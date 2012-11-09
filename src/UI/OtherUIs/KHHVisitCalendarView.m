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
#import "KHHFinishVisitVC.h"
#import "KHHVisitRecoardVC.h"
#import "KHHFullFrameController.h"
#import "MapController.h"
#import "UIImageView+WebCache.h"
#import "DetailInfoViewController.h"
#import "KHHData+UI.h"
#import "KHHData.h"
#import "NSString+SM.h"


@implementation KHHVisitCalendarView
@synthesize theTable = _theTable;
@synthesize footView = _footView;
@synthesize imgArr = _imgArr;
@synthesize viewCtrl = _viewCtrl;
@synthesize card;
@synthesize dataArray;
@synthesize isDetailVC;
@synthesize isAllVisitedSch;
@synthesize isFromCalVC;
@synthesize isFromHomeVC;
@synthesize selectedDate;
@synthesize calBtn;
@synthesize mapAddress;

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
    NSSortDescriptor *descFini = [NSSortDescriptor sortDescriptorWithKey:@"isFinished" ascending:YES];
    NSSortDescriptor *descDate = [NSSortDescriptor sortDescriptorWithKey:@"plannedDate" ascending:NO];
    if (self.isAllVisitedSch) {
        KHHData *data = [KHHData sharedData];
        self.dataArray  = [data allSchedules];
    }else if(self.isFromHomeVC){
        NSSet *set = self.card.schedules;
        self.dataArray = [[set allObjects] sortedArrayUsingDescriptors:@[descFini,descDate]];
    }else if (self.isFromCalVC){
        if ([self.card isKindOfClass:[MyCard class]]) {
            self.card = nil;
        }
        self.dataArray = [[[KHHData sharedData] schedulesOnCard:self.card date:self.selectedDate] sortedArrayUsingDescriptors:@[descFini,descDate]];
    }
}
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Schedule *sched = [self.dataArray objectAtIndex:indexPath.row];
    if ([sched.images allObjects].count > 0) {
        return 140;
    }else{
        return 80;
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
        for (int i = 0; i < [sched.images allObjects].count; i++) {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFullFrame:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            Image *img = [[sched.images allObjects] objectAtIndex:i];
            if (i == 0) {
                [cell.imgviewIco1 addGestureRecognizer:tap];
                [cell.imgviewIco1 setImageWithURL:[NSURL URLWithString:img.url] placeholderImage:[UIImage imageNamed:@"logopic.png"]];
            }else if (i == 1){
                [cell.imgviewIco2 addGestureRecognizer:tap];
                [cell.imgviewIco2 setImageWithURL:[NSURL URLWithString:img.url] placeholderImage:[UIImage imageNamed:@"logopic.png"]];
            }else if (i == 2){
                [cell.imgviewIco3 addGestureRecognizer:tap];
                [cell.imgviewIco3 setImageWithURL:[NSURL URLWithString:img.url] placeholderImage:[UIImage imageNamed:@"logopic.png"]];
            }else if (i == 3){
                [cell.imgviewIco4 addGestureRecognizer:tap];
                [cell.imgviewIco4 setImageWithURL:[NSURL URLWithString:img.url] placeholderImage:[UIImage imageNamed:@"logopic.png"]];
            }
        }
    }
    //拜访日期
    if (sched.plannedDate != nil) {
        NSDateFormatter *form = [[NSDateFormatter alloc] init];
        [form setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *date = [form stringFromDate:sched.plannedDate];
        cell.dateLab.text = date;
    }
    //拜访对象
    if (sched.targets!= nil ) {
        NSMutableString *names = [[NSMutableString alloc] init];
        NSArray *objects = [sched.targets allObjects];
        for (int i = 0; i < objects.count; i++) {
            Card *cardObj = [objects objectAtIndex:i];
            NSString *name = [NSString stringByFilterNilFromString:cardObj.name];
            if (name.length) {
                [names appendString:[NSString stringWithFormat:@" %@",name]];
            }
        }
        cell.objValueLab.text = names;
    }
    //地址
    if (sched.address.other.length > 0) {
        NSString *p = [NSString stringByFilterNilFromString:sched.address.province];
        NSString *c = [NSString stringByFilterNilFromString:sched.address.city];
        NSString *o = [NSString stringByFilterNilFromString:sched.address.other];
        cell.locValueLab.text = [NSString stringWithFormat:@"%@%@%@",p,c,o];
        self.mapAddress = cell.locValueLab.text;
    }
    //备注
    if (sched.content.length > 0) {
        cell.noteValueLab.text = sched.content;
    }
    //是否完成
    if ([sched.isFinished isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        cell.finishBtn.hidden = YES;
    }else{
        cell.finishBtn.hidden = NO;
    }
    if (sched.minutesToRemindValue > 0) {
        cell.Btn.hidden = NO;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        //完成
        KHHVisitCalendarCell *cell = (KHHVisitCalendarCell *)[[btn superview] superview];
        NSIndexPath *index = [_theTable indexPathForCell:cell];
        KHHVisitRecoardVC *finishVC = [[KHHVisitRecoardVC alloc] initWithNibName:nil bundle:nil];
        finishVC.isNeedWarn = NO;
        finishVC.isFinishTask = YES;
        finishVC.schedu = [self.dataArray objectAtIndex:index.row];
        finishVC.style = KVisitRecoardVCStyleShowInfo;
        [self.viewCtrl.navigationController pushViewController:finishVC animated:YES];
    }
}
- (void)showLocaButtonClick:(id)sender{
    DLog(@"showMap");
    MapController *mapVC = [[MapController alloc] initWithNibName:nil bundle:nil];
    mapVC.companyAddr = self.mapAddress;
    [self.viewCtrl.navigationController pushViewController:mapVC animated:YES];
    
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
- (void)tapFullFrame:(UITapGestureRecognizer *)sender
{
    self.imgview = (UIImageView *)[sender view];
    KHHFullFrameController *fullVC = [[KHHFullFrameController alloc] initWithNibName:nil bundle:nil];
    fullVC.image = self.imgview.image;
    [self.viewCtrl.navigationController pushViewController:fullVC animated:YES];
    
}
- (void)reloadTheTable{
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
    self.dataArray = [[KHHData sharedData] schedulesOnCard:self.card day:dateS];
}
@end
