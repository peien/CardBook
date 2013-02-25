//
//  KHHVisitCalendarView.m
//  CardBook
//
//  Created by 王国辉 on 12-8-24.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "KHHVisitCalendarView.h"
#import "KHHVisitCalendarCell.h"
#import "KHHCalendarViewController.h"
#import "KHHAllVisitedSchedusVC.h"
#import "KHHVisitRecoardVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DetailInfoViewController.h"
//#import "KHHData+UI.h"
//#import "KHHData.h"
#import "NSString+SM.h"
#import "KHHBMapViewController.h"
#import "KHHDataNew+VisitSchedule.h"
#import "KHHPlanViewController.h"
#import "KHHDataNew+Card.h"

@interface KHHVisitCalendarView()
{
    //标记是否初始化过了,只有第一次init时才做iphone5的适配
    BOOL isInitialized;
    
    //列表的数据类型
    KHHCalendarViewDataType dataType;
}
@end

@implementation KHHVisitCalendarView
@synthesize theTable = _theTable;
@synthesize footView = _footView;
@synthesize imgArr = _imgArr;
@synthesize viewCtrl = _viewCtrl;
@synthesize card;
@synthesize dataArray;
@synthesize isDetailVC;
@synthesize visitType;
@synthesize isFromCalVC;
@synthesize isFromHomeVC;
@synthesize selectedDate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */



- (void)initViewData{
    //    NSSortDescriptor *descFini = [NSSortDescriptor sortDescriptorWithKey:@"isFinished" ascending:YES];
    //判断是否要做一iphone5的适配
    //    if (!isInitialized) {
    //        //适配一下iphone5
    //        [KHHViewAdapterUtil checkIsNeedMoveDownForIphone5:_footView];
    //        [KHHViewAdapterUtil checkIsNeedMoveDownForIphone5:_addBtn];
    ////        [_addBtn addTarget:self action:@selector(visitCalendarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    ////        _addBtn.enabled = YES;
    //        [KHHViewAdapterUtil checkIsNeedMoveDownForIphone5:_calBtn];
    //        isInitialized = YES;
    //    }
#warning 查询(考勤、数据采集)的相应数据，根据dataType来查询,因服务器那边类型还未区分，所以客户端还无法做，这个要等网络接口实现后再改
    NSSortDescriptor *descDate = [NSSortDescriptor sortDescriptorWithKey:@"plannedDate" ascending:NO];
    if(self.isFromHomeVC){
        NSSet *set = self.card.schedules;
        self.dataArray = [[set allObjects] sortedArrayUsingDescriptors:@[descDate]];
    }else if (self.isFromCalVC){
        if ([self.card isKindOfClass:[MyCard class]]) {
            self.card = nil;
        }
        self.dataArray = [[[KHHDataNew sharedData] schedulesOnCard:self.card date:self.selectedDate] sortedArrayUsingDescriptors:@[descDate]];
    }else {
        //  KHHDataNew *data = [KHHDataNew sharedData];
        switch (self.visitType) {
            case KHHVisitPlanExecuting:
            {
                //正在执行（当前时间以后的）
                self.dataArray  = [[KHHDataNew sharedData] executingSchedules];
            }
                break;
            case KHHVisitPlanOverdue:
            {
                //过期(当前时间以前的并且没有finish的)
                self.dataArray  = [[KHHDataNew sharedData] overdueSchedules];
            }
                break;
            case KHHVisitPlanFinished:
            {
                //已完成(finish标记为yes)
                self.dataArray  = [[KHHDataNew sharedData] finishedSchedules];
            }
                break;
            case KHHVisitPlanAll:
            {
                //所有
                self.dataArray  = [[KHHDataNew sharedData] allSchedules];
            }
                break;
            default:
                break;
        }
    }
}
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
    
    Schedule *sched = [self.dataArray objectAtIndex:indexPath.row];
    if ([sched.images allObjects].count > 0) {
        return 140;
    }else{
        return 85;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    KHHVisitCalendarCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"KHHVisitCalendarCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    UIImage *imgBtn = [[UIImage imageNamed:@"tongbu_normal.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 8, 0, 8)];
    [cell.finishBtn setBackgroundImage:imgBtn forState:UIControlStateNormal];
    Schedule *sched = [self.dataArray objectAtIndex:indexPath.row];
    
    //是否有图片
    if ([sched.images allObjects].count > 0) {
        //显示有图的图标
        cell.photoBtn.hidden = NO;
    }
    //拜访日期
    if (sched.plannedDate != nil) {
        NSDateFormatter *form = [[NSDateFormatter alloc] init];
        [form setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *date = [form stringFromDate:sched.plannedDate];
        cell.dateLab.text = date;
    }
    //拜访对象 (customer里的存放的是用户手动输入的客户，可能不是联系人)
    if (sched.targets != nil || sched.customer) {
        NSMutableString *names = [[NSMutableString alloc] init];
        //先添加到用户手动输入的
        if (sched.customer) {
            [names appendString:sched.customer];
        }
        
        //循环添加联系人
        //        if (sched.targets) {
        //            NSArray *objects = [sched.targets allObjects];
        //            for (int i = 0; i < objects.count; i++) {
        //                Card *cardObj = [objects objectAtIndex:i];
        //                //用分号与前一个分开
        //                if (names.length > 0) {
        //                    [names appendString:KHH_SEMICOLON];
        //                }
        //
        //                //姓名
        //                NSString *name = [NSString stringByFilterNilFromString:cardObj.name];
        //                if (name.length) {
        //                    [names appendString:[NSString stringWithFormat:@"%@",name]];
        //                }else {
        //                    //名称为空时添加一个空格作为标识
        //                    [names appendString:@" "];
        //                }
        //
        //                //公司
        //                if (cardObj.company && cardObj.company.name && cardObj.company.name.length > 0) {
        //                    NSString *company = [NSString stringByFilterNilFromString:cardObj.company.name];
        //                    if (company.length) {
        //                        [names appendString:[NSString stringWithFormat:@"(%@)",company]];
        //                    }
        //                }
        //            }
        //        }
        //
        
        cell.objValueLab.text = names;
    }
    //地址
    if (sched.address.other.length > 0) {
        NSString *p = [NSString stringByFilterNilFromString:sched.address.province];
        NSString *c = [NSString stringByFilterNilFromString:sched.address.city];
        NSString *o = [NSString stringByFilterNilFromString:sched.address.other];
        //直辖市只取一个
        if (p && c && [p isEqualToString:c]) {
            cell.locValueLab.text = [NSString stringWithFormat:@"%@%@",p,o];
        }else {
            cell.locValueLab.text = [NSString stringWithFormat:@"%@%@%@",p,c,o];
        }
    }
    //备注
    if (sched.content.length > 0) {
        cell.noteValueLab.text = sched.content;
    }
    //是否完成
    BOOL isFinished = [sched.isFinished isEqualToNumber:[NSNumber numberWithBool:YES]];
    if (isFinished) {
        cell.finishBtn.hidden = YES;
    }else{
        cell.finishBtn.hidden = NO;
    }
    
    //铃铛显示与隐藏
    //显示条件(未完成的拜访计划、有提醒并且没有提醒过的)
    int remindVaule = sched.minutesToRemindValue;
    DLog(@"visit plant remindValue = %d",remindVaule);
    NSDate * remindTime = [sched.plannedDate dateByAddingTimeInterval:-remindVaule * 60];
    //这两个时间都没有考虑时区的，因为求差，只要两个时间都用同一时区就可以
    DLog(@"visit plant remindDate = %@",remindTime);
    NSTimeInterval interval = [remindTime timeIntervalSinceNow];
    DLog(@"visit plant now = %@, interval = %f",[NSDate new],interval);
    if (remindVaule > 0 && !isFinished && interval > 0.0f) {
        cell.Btn.hidden = NO;
    }
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isDetailVC) {
        
        Schedule *scheduPro = [self.dataArray objectAtIndex:indexPath.row];
        
        KHHPlanViewController *viewPro = [[KHHPlanViewController alloc]init];
        viewPro.paramDic = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"plan" ofType:@"plist"]];;
        viewPro.title = @"编辑详情";
        viewPro.uperSuccess = ^(){
            if ([self.card isKindOfClass:[ReceivedCard class]]) {
                self.card = [[KHHDataNew sharedData] receivedCardByID:self.card.id];
            }else if ([self.card isKindOfClass:[PrivateCard class]]){
                self.card = [[KHHDataNew sharedData] privateCardByID:self.card.id];
            }
            
            [self reloadTheTable:KHHCalendarViewDataTypeCheckIn];
        };
        
        
        // [viewPro setTargetStr:scheduPro.customer cardsArr:[scheduPro.targets allObjects]];
        [viewPro setSchedule:scheduPro type:plan];
        [self.viewCtrl.navigationController pushViewController:viewPro animated:YES];
        return;
    }
    
    KHHVisitRecoardVC *visitVC = [[KHHVisitRecoardVC alloc] initWithNibName:nil bundle:nil];
    //有没有图片
    visitVC.style = KVisitRecoardVCStyleShowInfo;
    Schedule *schedu = [self.dataArray objectAtIndex:indexPath.row];
    
    visitVC.schedu = schedu;
    
    if (!schedu.isFinishedValue) {
        visitVC.isNeedWarn = YES;
    }
    visitVC.isHaveImage = YES;
    if (self.isDetailVC) {
        DetailInfoViewController *detailVC = (DetailInfoViewController *)self.viewCtrl;
        detailVC.isReloadVisiteTable = YES;
    }
    if ([self.viewCtrl isKindOfClass:[KHHCalendarViewController class]]) {
        KHHCalendarViewController *calVC = (KHHCalendarViewController *)self.viewCtrl;
        calVC.isneedReloadeVisitTable = YES;
        visitVC.viewCtl = self.viewCtrl;
    }
    if ([self.viewCtrl isKindOfClass:[KHHAllVisitedSchedusVC class]]) {
        KHHAllVisitedSchedusVC *calVC = (KHHAllVisitedSchedusVC *)self.viewCtrl;
        calVC.isNeedReloadData = YES;
    }
    
    [self.viewCtrl.navigationController pushViewController:visitVC animated:YES];
}
#pragma mark -
- (void)KHHVisitCalendarCellBtnClick:(UIButton *)btn
{
    if (btn.tag == 222) {
        //铃铛提示
    }else if (btn.tag == 223){
        
        KHHVisitCalendarCell *cell = (KHHVisitCalendarCell *)[[btn superview] superview];
        NSIndexPath *indexPath = [_theTable indexPathForCell:cell];
        
        KHHPlanViewController *planPro = [[KHHPlanViewController alloc]init];
        planPro.paramDic = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"collection" ofType:@"plist"]];
        // [planPro set_dicTempTarget:self.card];
        [planPro setSchedule:[self.dataArray objectAtIndex:indexPath.row] type:collect];
        planPro.title = @"数据采集";
        planPro.uperSuccess = ^(){
            if ([self.card isKindOfClass:[ReceivedCard class]]) {
                self.card = [[KHHDataNew sharedData] receivedCardByID:self.card.id];
            }else if ([self.card isKindOfClass:[PrivateCard class]]){
                self.card = [[KHHDataNew sharedData] privateCardByID:self.card.id];
            }
            
            [self reloadTheTable:KHHCalendarViewDataTypeCheckIn];
        };

        //完成
        //        KHHVisitCalendarCell *cell = (KHHVisitCalendarCell *)[[btn superview] superview];
        //        NSIndexPath *index = [_theTable indexPathForCell:cell];
        //        KHHVisitRecoardVC *finishVC = [[KHHVisitRecoardVC alloc] initWithNibName:nil bundle:nil];
        //        finishVC.isNeedWarn = YES;
        //        finishVC.isFinishTask = YES;
        //        finishVC.schedu = [self.dataArray objectAtIndex:index.row];
        //        finishVC.style = KVisitRecoardVCStyleShowInfo;
        //        if ([self.viewCtrl isKindOfClass:[KHHCalendarViewController class]]) {
        //            KHHCalendarViewController *calVC = (KHHCalendarViewController *)self.viewCtrl;
        //            calVC.isneedReloadeVisitTable = YES;
        //            finishVC.viewCtl = self.viewCtrl;
        //        }
        [self.viewCtrl.navigationController pushViewController:planPro animated:YES];
    }
}
//地图
- (void)showLocaButtonClick:(id)sender{
    DLog(@"showMap");
    //    //默认的地图
    //    MapController *mapVC = [[MapController alloc] initWithNibName:nil bundle:nil];
    //    mapVC.companyName = @"";
    //    mapVC.companyAddr = self.mapAddress;
    //先获取点击的哪个cell的index
    //[[sender superview] superview] ---> KHHVisitCalendarCell
    if (sender) {
        //用百度地图定位
        KHHVisitCalendarCell *cell = (KHHVisitCalendarCell *)[[sender superview] superview];
        NSIndexPath *index = [_theTable indexPathForCell:cell];
        Schedule *sched = [self.dataArray objectAtIndex:index.row];
        if (sched) {
            KHHBMapViewController *mapVC = [[KHHBMapViewController alloc] initWithNibName:nil bundle:nil];
            mapVC.companyCity = sched.address.city;
            mapVC.companyDetailAddr = sched.address.other;
            mapVC.companyName = cell.objValueLab.text;
            mapVC.companyAllAddr = cell.locValueLab.text;
            [self.viewCtrl.navigationController pushViewController:mapVC animated:YES];
        }
    }
}
- (IBAction)VisitCalendarBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (self.isDetailVC) {
        DetailInfoViewController *detailVC = (DetailInfoViewController *)self.viewCtrl;
        detailVC.isReloadVisiteTable = YES;
    }
    if (btn.tag == 333) {
        KHHVisitRecoardVC *visitRVC = [[KHHVisitRecoardVC alloc] initWithNibName:nil bundle:nil];
        visitRVC.style = KVisitRecoardVCStyleNewBuild;
        visitRVC.isNeedWarn = YES;
        visitRVC.visitInfoCard = self.card;
        [self.viewCtrl.navigationController pushViewController:visitRVC animated:YES];
        
    }else if (btn.tag == 444){
        KHHCalendarViewController *calendarVC = [[KHHCalendarViewController alloc] initWithNibName:nil bundle:nil];
        calendarVC.card = self.card;
        [self.viewCtrl.navigationController pushViewController:calendarVC animated:YES];
    }
}

- (void)visitCalendarBtnClick
{
    KHHVisitRecoardVC *visitRVC = [[KHHVisitRecoardVC alloc] initWithNibName:nil bundle:nil];
    visitRVC.style = KVisitRecoardVCStyleNewBuild;
    visitRVC.isNeedWarn = YES;
    visitRVC.visitInfoCard = self.card;
    [self.viewCtrl.navigationController pushViewController:visitRVC animated:YES];
}

//刷新数据，不传数据类型时默认是数据采集
- (void)reloadTheTable{
    [self reloadTheTable:KHHCalendarViewDataTypeCollect];
}

//刷新数据
- (void)reloadTheTable:(KHHCalendarViewDataType) theDataType{
    dataType = theDataType;
    [self initViewData];
    [_theTable reloadData];
}
- (void)showTodayScheuds{
    NSDateFormatter *formt = [[NSDateFormatter alloc] init];
    [formt setDateFormat:@"yyyy-MM-dd"];
    NSString *dateS = [formt stringFromDate:[NSDate date]];
    if ([self.card isKindOfClass:[MyCard class]]) {
        self.card = nil;
    }
    self.dataArray = [[KHHDataNew sharedData] schedulesOnCard:self.card day:dateS];
}
@end
