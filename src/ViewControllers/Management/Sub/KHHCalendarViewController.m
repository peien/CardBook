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
@interface KHHCalendarViewController ()<CKCalendarDelegate,UITableViewDataSource,UITableViewDelegate,KHHVisitCalendarCellDelegate>

@end

@implementation KHHCalendarViewController
@synthesize theTable = _theTable;

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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date
{
    DLog(@"date click!");
    KHHVisitRecoardVC *visitRVC = [[KHHVisitRecoardVC alloc] initWithNibName:nil bundle:nil];
    visitRVC.style = KVisitRecoardVCStyleNewBuild;
    visitRVC.isNeedWarn = YES;
    [self.navigationController pushViewController:visitRVC animated:YES];
}
- (void)calendarChangeFrame:(CKCalendarView *)calendar
{
//    int height = (int)calendar.frame.size.height;
//    if (height == 272) {
//        CGRect rect = _theTable.frame;
//        rect.size.height = 120;
//        rect.origin.y = 302;
//        _theTable.frame = rect;
//        
//    }else if (height == 238){
//        CGRect rect = _theTable.frame;
//        rect.size.height = 150;
//        rect.origin.y = 270;
//        _theTable.frame = rect;
//      
//    }

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
    //有没有图片
    visitVC.style = KVisitRecoardVCStyleShowInfo;
    visitVC.isHaveImage = YES;
    [self.navigationController pushViewController:visitVC animated:YES];


}
- (IBAction)plusBtnClick:(id)sender
{
    DLog(@"plusBtnClick");
    KHHVisitRecoardVC *visitRVC = [[KHHVisitRecoardVC alloc] initWithNibName:nil bundle:nil];
    visitRVC.style = KVisitRecoardVCStyleNewBuild;
    visitRVC.isNeedWarn = YES;
    [self.navigationController pushViewController:visitRVC animated:YES];

}
- (void)KHHVisitCalendarCellBtnClick:(NSInteger)tag
{
    if (tag == 222) {
        //铃铛；
        
    }else if (tag == 223){
        //完成；
        KHHVisitRecoardVC *finishVC = [[KHHVisitRecoardVC alloc] initWithNibName:nil bundle:nil];
        finishVC.isNeedWarn = NO;
        finishVC.isFinishTask = YES;
        finishVC.style = KVisitRecoardVCStyleShowInfo;
        [self.navigationController pushViewController:finishVC animated:YES];
    
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
