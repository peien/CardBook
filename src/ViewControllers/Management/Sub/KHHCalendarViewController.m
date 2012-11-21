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
#import "KHHData+UI.h"
#import "KHHData.h"

@interface KHHCalendarViewController ()<CKCalendarDelegate>
@property (strong, nonatomic) NSDate *dateSelect;
@property (strong, nonatomic) CKCalendarView       *calView;
@property (strong, nonatomic) NSArray              *schedus;
@property (strong, nonatomic) KHHVisitCalendarView *visitView;
@end

@implementation KHHCalendarViewController
@synthesize theTable = _theTable;
@synthesize addBtn;
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
        [self.rightBtn setTitle:NSLocalizedString(@"显示所有", nil) forState:UIControlStateNormal];
    }
    return self;
}
- (void)rightBarButtonClick:(id)sender{
    KHHAllVisitedSchedusVC *schedusVC = [[KHHAllVisitedSchedusVC alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:schedusVC animated:YES];
    
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
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [KHHShowHideTabBar hideTabbar];
    if (self.isneedReloadeVisitTable) {
        if ([self.card isKindOfClass:[ReceivedCard class]]) {
            self.card = [[KHHData sharedData]receivedCardByID:self.card.id];
        }else if ([self.card isKindOfClass:[PrivateCard class]]){
            self.card = [[KHHData sharedData] privateCardByID:self.card.id];
        }
         self.visitView.card = self.card;
        [self.visitView reloadTheTable];
    }
        //[self.visitView reloadTheTable];
}
- (void)viewDidAppear:(BOOL)animated{
    [self.calView layoutSubviews];

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
    [self.visitView reloadTheTable];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
