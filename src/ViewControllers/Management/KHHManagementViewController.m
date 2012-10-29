//
//  KHHManagementViewController.m
//  CardBook
//
//  Created by 孙铭 on 8/7/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHManagementViewController.h"
#import "KHHMyDetailController.h"
#import "KHHCalendarViewController.h"
#import "LocationInfoVC.h"
#import "EmployeesManageVC.h"
#import "KHHRadarViewController.h"
#import "KHHFunnelViewController.h"
#import "KHHVisitCalendarVC.h"
#import "KHHShowHideTabBar.h"
#import "KHHData+UI.h"
#import "Card.h"

@interface KHHManagementViewController ()
@property (strong, nonatomic) KHHData *dataCtrl;
@property (strong, nonatomic) Card    *myCard;
@end

@implementation KHHManagementViewController
@synthesize entranceView = _entranceView;
@synthesize isBoss = _isBoss;
@synthesize dataCtrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"员工管理";
        _isBoss = YES;
        self.dataCtrl = [KHHData sharedData];
        self.myCard = [[self.dataCtrl allMyCards] lastObject];
        if (_isBoss) {
           _entranceView = [[[NSBundle mainBundle] loadNibNamed:@"KHHBossEntrance" owner:self options:nil] objectAtIndex:0]; 
        }else
            _entranceView = [[[NSBundle mainBundle] loadNibNamed:@"KHHStaffEntrance" owner:self options:nil] objectAtIndex:0];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _entranceView.center = self.view.center;
    [self.view addSubview:_entranceView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [KHHShowHideTabBar showTabbar];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[KHHShowHideTabBar hideTabbar];
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.dataCtrl = nil;
}

- (IBAction)radarBtnClick:(id)sender{
    
    [self showAlert];
//    KHHRadarViewController *radarVC = [[KHHRadarViewController alloc] initWithNibName:nil bundle:nil];
//    [self.navigationController pushViewController:radarVC animated:YES];

}
- (IBAction)funnelBtnClick:(id)sender{
    [self showAlert];
//    KHHFunnelViewController *funnelVC = [[KHHFunnelViewController alloc] initWithNibName:nil bundle:nil];
//    [self.navigationController pushViewController:funnelVC animated:YES];

}
- (IBAction)calendarBtnClick:(id)sender{
    KHHCalendarViewController *calVC = [[KHHCalendarViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:calVC animated:YES];

}
- (IBAction)manageEmployeesBtnClick:(id)sender{
    [self showAlert];
//    EmployeesManageVC *employManVC = [[EmployeesManageVC alloc] initWithNibName:nil bundle:nil];
//    [self.navigationController pushViewController:employManVC animated:YES];

}
- (IBAction)locationBtnClick:(id)sender{
    LocationInfoVC *locaVC = [[LocationInfoVC alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:locaVC animated:YES];
}
- (IBAction)personBtnClick:(id)sender
{
    KHHMyDetailController *myDetailVC = [[KHHMyDetailController alloc] initWithNibName:nil bundle:nil];
    myDetailVC.card = self.myCard;
    [self.navigationController pushViewController:myDetailVC animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)showAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"功能暂时未开放" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

@end
