//
//  KHHCalendarViewController.m
//  CardBook
//
//  Created by 王国辉 on 12-8-22.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "KHHCalendarViewController.h"
#import "CKCalendarView.h"
#import "KHHAllVisitedSchedusVC.h"
#import "KHHVisitCalendarCell.h"
#import "KHHVisitCalendarView.h"
#import "KHHVisitRecoardVC.h"
#import "KHHShowHideTabBar.h"
#import "KHHAppDelegate.h"
#import "KHHClasses.h"
//#import "KHHData+UI.h"
//#import "KHHData.h"
#import "KHHFilterPopup.h"
#import "KHHDataNew+Card.h"

//title 右侧按钮供选择的类型
#define InitDataTypeArray   dataTypeArray = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(KHHMessageCheckIn, nil),NSLocalizedString(KHHMessageDataCollect, nil), nil]

@interface KHHCalendarViewController ()<CKCalendarDelegate, KHHFilterPopupDelegate>
{
    //类型选择名称
    NSArray *dataTypeArray;
    //类型
    KHHCalendarViewDataType dataType;
    //currentIndex
    int currentIndex;
}
@property (strong, nonatomic) NSDate *dateSelect;
@property (strong, nonatomic) CKCalendarView       *calView;
@property (strong, nonatomic) NSArray              *schedus;
@property (strong, nonatomic) KHHVisitCalendarView *visitView;
@end

@implementation KHHCalendarViewController
@synthesize theTable = _theTable;
@synthesize dateSelect;
@synthesize calView;
@synthesize card;
@synthesize schedus;
@synthesize visitView;
@synthesize isneedReloadeVisitTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"沟通拜访纪录", nil);
        //进入程序时，默认是数组第一个
        InitDataTypeArray;
        currentIndex = 0;
        [self.rightBtn setTitle:[dataTypeArray objectAtIndex:currentIndex] forState:UIControlStateNormal];
        CGRect frame = self.rightBtn.frame;
        frame.size.width += 15;
        self.rightBtn.frame = frame;
        //设置左对齐
        self.rightBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        //只设置上面一句没有用
        self.rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //设置上面一句后文字紧贴左边，下面一句是让左边空出点距离
        self.rightBtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
        dataType = KHHCalendarViewDataTypeCheckIn;
        UIEdgeInsets inset = UIEdgeInsetsMake(0, 10, 0, 25);
        [self.rightBtn setBackgroundImage:[[UIImage imageNamed:@"title_btn_with_drop"] resizableImageWithCapInsets:inset] forState:UIControlStateNormal];
    }
    
    return self;
}
- (void)rightBarButtonClick:(id)sender{
    [[KHHFilterPopup shareUtil] showPopUp:dataTypeArray index:currentIndex Title:@"选择类型" delegate:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startSunday card:self.card];
    self.calView = calendar;
    calendar.delegate = self;
    calendar.frame = CGRectMake(35, 28, 245, 160);
    //calendar.frame = CGRectMake(60, 28, 200, 208);
    [self.view addSubview:calendar];
    visitView = [[[NSBundle mainBundle] loadNibNamed:@"KHHVisitCalendarView" owner:self options:nil] objectAtIndex:0];
    visitView.backgroundColor = [UIColor purpleColor];
    visitView.isFromCalVC = YES;
    visitView.calBtn.hidden = YES;
    visitView.viewCtrl = self;
    //默认显示今天的
    NSDateFormatter *formt = [[NSDateFormatter alloc] init];
    [formt setDateFormat:@"yyyy-MM-dd"];
    NSString *dateS = [formt stringFromDate:[NSDate date]];
    visitView.selectedDate = [formt dateFromString:dateS];
    visitView.card = self.card;
    [visitView showTodayScheuds];
    CGRect rect = visitView.frame;
    CGRect rectTable = visitView.theTable.frame;
    rectTable.origin.y = 0;
    rectTable.size.height = 122;
    rect.origin.y = 300;
    rect.size.height = 200;
    visitView.frame = rect;
    visitView.theTable.frame = rectTable;
    [self.view addSubview:self.visitView];
    [self.view insertSubview:self.addBtn atIndex:100];
    [self.view insertSubview:self.allBtn atIndex:100];
    //日历默认选择当天
    [self.calView setSelectedDate:[formt dateFromString:dateS]];
    
    //iphone5 适配
    [KHHViewAdapterUtil checkIsNeedAddHeightForIphone5:visitView];
    [KHHViewAdapterUtil checkIsNeedMoveDownForIphone5:_addBtn];
    [KHHViewAdapterUtil checkIsNeedMoveDownForIphone5:_allBtn];
}
- (void)viewWillAppear:(BOOL)animated{
    [KHHShowHideTabBar hideTabbar];
    if (self.isneedReloadeVisitTable) {
        if ([self.card isKindOfClass:[ReceivedCard class]]) {
            self.card = [[KHHDataNew sharedData]receivedCardByID:self.card.id];
        }else if ([self.card isKindOfClass:[PrivateCard class]]){
            self.card = [[KHHDataNew sharedData] privateCardByID:self.card.id];
        }
        self.visitView.card = self.card;
        //如果某条拜访计划的日期发生变化后，要定位到相应的日期
        if (self.changedDate) {
            [self.calView setSelectedDate:self.changedDate];
            NSDateFormatter *formt = [[NSDateFormatter alloc] init];
            [formt setDateFormat:@"yyyy-MM-dd"];
            NSString *dateS = [formt stringFromDate:self.changedDate];
            visitView.selectedDate = [formt dateFromString:dateS];
            self.changedDate = nil;
        }
        
        [self.visitView reloadTheTable:dataType];
    }
}
- (void)viewDidAppear:(BOOL)animated{
  //  [self.calView layoutSubviews];

}
- (void)viewWillDisappear:(BOOL)animated{
   
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _theTable = nil;
    self.addBtn = nil;
    self.dateSelect = nil;
    self.calView = nil;
    self.card = nil;
    self.schedus = nil;
    self.visitView = nil;
}

//日期选择后，要判断是要显示何种类型的数据
- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date
{
    NSDate *selectedNewDate = [date dateByAddingTimeInterval:8*60*60];//用与判断添加按钮是否隐藏
    self.dateSelect = selectedNewDate;//用于拜访界面的日期显示
    DLog(@"date click ====== selectedNewDate is %@!",selectedNewDate);
    NSDate *now = [NSDate date];
    DLog(@"NOW IS %@",now);
    double timerIntervNow = [now timeIntervalSince1970];
     NSDate *selectedDateBtn = [date dateByAddingTimeInterval:24*60*60];
    double timerIntervSelected = [selectedDateBtn timeIntervalSince1970];
    
    if (timerIntervSelected - timerIntervNow > 0) {
        DLog(@"将来");
        self.addBtn.hidden = NO;
    }else if (timerIntervSelected - timerIntervNow < 0){
        DLog(@"过去");
        self.addBtn.hidden = YES;
    }else if (timerIntervSelected - timerIntervNow == 0){
        DLog(@"");
    }
    self.visitView.selectedDate = self.dateSelect;
    self.visitView.card = self.card;
    [self.visitView reloadTheTable:dataType];
}
- (void)calendarChangeFrame:(CKCalendarView *)calendar
{

}
- (IBAction)plusBtnClick:(id)sender{
    
    KHHVisitRecoardVC *visitVC = [[KHHVisitRecoardVC alloc] initWithNibName:nil bundle:nil];
    visitVC.visitInfoCard = self.card;
    visitVC.selectedDateFromCal = self.dateSelect;
    visitVC.isFromCalVC = YES;
    visitVC.isNeedWarn = YES;
    self.isneedReloadeVisitTable = YES;
    [self.navigationController pushViewController:visitVC animated:YES];
//    KHHTempVisitedVC *visitVC = [[KHHTempVisitedVC alloc] initWithNibName:nil bundle:nil];
//    visitVC.visitInfoCard = self.card;
//    visitVC.selectedDateFromCal = self.dateSelect;
//    visitVC.isFromCalVC = YES;
//    visitVC.isNeedWarn = YES;
//    visitVC.style = KVisitRecoardVCStyleNewBuild1;
//    self.isneedReloadeVisitTable = YES;
//    [self.navigationController pushViewController:visitVC animated:YES];
}

- (IBAction)allBtnClick:(id)sender {
    //显示所有
    KHHAllVisitedSchedusVC *schedusVC = [[KHHAllVisitedSchedusVC alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:schedusVC animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma KHHFilterPopupDelegate
- (void)selectInAlert:(id)obj
{
    if (!obj) {
        return;
    }
    
    NSDictionary *dic = (NSDictionary *) obj;
    if ([[dic objectForKey:@"selectItem"] isEqualToString:NSLocalizedString(KHHMessageCheckIn, nil)]) {
        dataType = KHHCalendarViewDataTypeCheckIn;
        [self.rightBtn setTitle:NSLocalizedString(KHHMessageCheckIn, nil) forState:UIControlStateNormal];
    }else if([[dic objectForKey:@"selectItem"] isEqualToString:NSLocalizedString(KHHMessageDataCollect, nil)]){
        dataType = KHHCalendarViewDataTypeCollect;
        [self.rightBtn setTitle:NSLocalizedString(KHHMessageDataCollect, nil) forState:UIControlStateNormal];    
    }
    
    currentIndex = [[NSNumber numberFromString:[dic objectForKey:@"index"]] intValue];
    
    //刷新数据
    [self.visitView reloadTheTable:dataType];
}

@end
