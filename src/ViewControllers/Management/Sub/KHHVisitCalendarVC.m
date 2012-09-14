//
//  KHHVisitCalendarVC.m
//  CardBook
//
//  Created by 王国辉 on 12-8-23.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "KHHVisitCalendarVC.h"
#import "KHHVisitCalendarCell.h"
#import "KHHDelVisitCalendarVC.h"
#import "KHHCalendarViewController.h"
#import "KHHFinishVisitVC.h"
#import "KHHVisitCalendarView.h"
#import "KHHShowHideTabBar.h"

@interface KHHVisitCalendarVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation KHHVisitCalendarVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"拜访日历", nil);
        [self.rightBtn setTitle:@"删除" forState:UIControlStateNormal];
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
- (void)rightBarClick:(id)sender
{
    KHHDelVisitCalendarVC *delVisitVC = [[KHHDelVisitCalendarVC alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:delVisitVC animated:YES];
  
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    KHHVisitCalendarView *visitCalendar = [[[NSBundle mainBundle] loadNibNamed:@"KHHVisitCalendarView" owner:self options:nil] objectAtIndex:0];
    visitCalendar.viewCtrl = self;
    [self.view addSubview:visitCalendar];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [KHHShowHideTabBar hideTabbar];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

}
#pragma mark -
#pragma KHHVisitCalendarViewDelegate
//- (void) visitCalendarViewBtnClick:(NSInteger)tag
//{
//    if (tag == 111) {
//        DLog(@"添加");
//        NewVisitRecordVC *newVisVC = [[NewVisitRecordVC alloc] initWithNibName:@"NewVisitRecordVC" bundle:nil];
//        newVisVC.style = KNewVisitRecordVCStyleVisitRecord;
//        [self.navigationController pushViewController:newVisVC animated:YES];
//        
//    }else if (tag == 222){
//        DLog(@"日历");
//        KHHCalendarViewController *calendarVC = [[KHHCalendarViewController alloc] initWithNibName:nil bundle:nil];
//        [self.navigationController pushViewController:calendarVC animated:YES];
//
//        
//    }
//
//}
//- (void)visitCalendarViewCellClick:(KHHVisitCalendarCell *)cell
//{
//    DLog(@"visitCalendarViewCellClick");
//    
//    if (cell.finishBtn.hidden) {
//        NewVisitRecordVC *newVisVC = [[NewVisitRecordVC alloc] initWithNibName:@"NewVisitRecordVC" bundle:nil];
//        newVisVC.style = KNewVisitRecordVCStyleEditLog;
//        [self.navigationController pushViewController:newVisVC animated:YES];
//    }else{
//        KHHFinishVisitVC *finVC = [[KHHFinishVisitVC alloc] initWithNibName:@"KHHFinishVisitVC" bundle:nil];
//        finVC.isShowUpdateBtn = NO;
//        finVC.isFinishVisit = YES;
//        [self.navigationController pushViewController:finVC animated:YES];
//    }
//
//}
//
//- (void)visitCalendarViewCellBtnClick:(NSInteger)tag
//{
//    if (tag == 222) {
//        //铃铛提示
//    }else if (tag == 223){
//        //完成
//        KHHFinishVisitVC *finishVC = [[KHHFinishVisitVC alloc] initWithNibName:nil bundle:nil];
//        finishVC.isShowUpdateBtn = YES;
//        finishVC.isFinishVisit = YES;
//        [self.navigationController pushViewController:finishVC animated:YES];
//        
//    }
//
//}
//- (void)testALL{}
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 11;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 130;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellID = @"cellID";
//    KHHVisitCalendarCell *cell = nil;
//    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//    if (cell == nil) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"KHHVisitCalendarCell" owner:self options:nil] objectAtIndex:0];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.delegate = self;
//    }
//    if (indexPath.row%2 == 0) {
//        cell.finishBtn.hidden = YES;
//    }
//    return cell;
//
//}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    KHHVisitCalendarCell *cell = (KHHVisitCalendarCell *)[tableView cellForRowAtIndexPath:indexPath];
//    if (cell.finishBtn.hidden) {
//        NewVisitRecordVC *newVisVC = [[NewVisitRecordVC alloc] initWithNibName:@"NewVisitRecordVC" bundle:nil];
//        newVisVC.style = KNewVisitRecordVCStyleEditLog;
//        [self.navigationController pushViewController:newVisVC animated:YES];
//    }else{
//        KHHFinishVisitVC *finVC = [[KHHFinishVisitVC alloc] initWithNibName:@"KHHFinishVisitVC" bundle:nil];
//        finVC.isShowUpdateBtn = NO;
//        finVC.isFinishVisit = YES;
//        [self.navigationController pushViewController:finVC animated:YES];
//    }
//
//    // 根据单元格是否是完成或没完成
//}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
