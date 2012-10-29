//
//  KHHCalendarViewController.m
//  CardBook
//
//  Created by 王国辉 on 12-8-22.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "KHHCalendarViewController.h"
#import "CKCalendarView.h"
#import "KHHVisitCalendarCell.h"
#import "KHHVisitRecoardVC.h"
#import "KHHShowHideTabBar.h"
#import "KHHAppDelegate.h"

@interface KHHCalendarViewController ()<CKCalendarDelegate,UITableViewDataSource,UITableViewDelegate,KHHVisitCalendarCellDelegate>
@property (strong, nonatomic) NSDate *dateSelect;
@end

@implementation KHHCalendarViewController
@synthesize theTable = _theTable;
@synthesize addBtn;
@synthesize dateSelect;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"沟通拜访纪录", nil);
        self.navigationItem.rightBarButtonItem = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startSunday];
    calendar.delegate = self;
    calendar.frame = CGRectMake(35, 28, 245, 160);
    //calendar.frame = CGRectMake(60, 28, 200, 208);
    [self.view addSubview:calendar];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [KHHShowHideTabBar hideTabbar];

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
}
- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date
{
    NSDate *selectedNewDate = [date dateByAddingTimeInterval:24*60*60];//用与判断添加按钮是否隐藏
    self.dateSelect = date;//用于拜访界面的日期显示
    DLog(@"date click ====== selectedNewDate is %@!",selectedNewDate);
    
    NSDate *now = [NSDate date];
    DLog(@"NOW IS %@",now);
    double timerIntervNow = [now timeIntervalSince1970];
    double timerIntervSelected = [selectedNewDate timeIntervalSince1970];
    
    if (timerIntervSelected - timerIntervNow > 0) {
        DLog(@"将来");
        self.addBtn.hidden = NO;
    }else if (timerIntervSelected - timerIntervNow < 0){
        DLog(@"过去");
        self.addBtn.hidden = YES;
    }else if (timerIntervSelected - timerIntervNow == 0){
        DLog(@"")
    }
}
- (void)calendarChangeFrame:(CKCalendarView *)calendar
{

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KHHVisitRecoardVC *visitVC = [[KHHVisitRecoardVC alloc] initWithNibName:nil bundle:nil];
    visitVC.style = KVisitRecoardVCStyleShowInfo;
    visitVC.isHaveImage = YES;
    [self.navigationController pushViewController:visitVC animated:YES];


}
- (IBAction)plusBtnClick:(id)sender
{
    DLog(@"plusBtnClick");
    KHHVisitRecoardVC *visitRVC = [[KHHVisitRecoardVC alloc] initWithNibName:nil bundle:nil];
    visitRVC.style = KVisitRecoardVCStyleNewBuild;
    visitRVC.isFromCalVC = YES;
    visitRVC.selectedDateFromCal = self.dateSelect;
    visitRVC.isNeedWarn = YES;
    [self.navigationController pushViewController:visitRVC animated:YES];

}
- (void)KHHVisitCalendarCellBtnClick:(UIButton *)btn
{
    if (btn.tag == 222) {
        //铃铛；
        
    }else if (btn.tag == 223){
        //完成；
        KHHVisitRecoardVC *finishVC = [[KHHVisitRecoardVC alloc] initWithNibName:nil bundle:nil];
        finishVC.isNeedWarn = NO;
        finishVC.isFinishTask = YES;
        finishVC.style = KVisitRecoardVCStyleShowInfo;
        [self.navigationController pushViewController:finishVC animated:YES];
    
    }
}
//显示地图
- (void)showLocaButtonClick:(id)sender{

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
