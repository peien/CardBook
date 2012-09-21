//
//  KHHVisitCalendarVC.m
//  CardBook
//
//  Created by 王国辉 on 12-8-23.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "KHHVisitCalendarVC.h"
#import "KHHDelVisitCalendarVC.h"
#import "KHHCalendarViewController.h"
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
