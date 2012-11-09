//
//  KHHManagementViewController.m
//  CardBook
//
//  Created by 孙铭 on 8/7/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHManagementViewController.h"
#import "KHHMyDetailController.h"
#import "MoreViewController.h"
#import "KHHCalendarViewController.h"
#import "KHHHomeViewController.h"
#import "KHHExchangeViewController.h"
#import "LocationInfoVC.h"
#import "EmployeesManageVC.h"
#import "MBProgressHUD.h"
#import "KHHAppDelegate.h"
#import "KHHRadarViewController.h"
#import "KHHFunnelViewController.h"
#import "KHHVisitCalendarVC.h"
#import "KHHMessageViewController.h"
#import "KHHShowHideTabBar.h"
#import "KHHData+UI.h"
#import "Card.h"

@interface KHHManagementViewController ()
@property (strong, nonatomic) KHHData        *dataCtrl;
@property (strong, nonatomic) Card           *myCard;
@property (strong, nonatomic) KHHAppDelegate *app;
@property (strong, nonatomic) UIImageView    *messageImageView;
@property (strong, nonatomic) UILabel        *numLab2;
@end

@implementation KHHManagementViewController
@synthesize entranceView = _entranceView;
@synthesize isBoss = _isBoss;
@synthesize dataCtrl;
@synthesize app;
@synthesize messageImageView;
@synthesize numLab2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"名片宝", nil);
        _isBoss = YES;
        self.dataCtrl = [KHHData sharedData];
        self.myCard = [[self.dataCtrl allMyCards] lastObject];
        if (_isBoss) {
           _entranceView = [[[NSBundle mainBundle] loadNibNamed:@"KHHBossEntrance" owner:self options:nil] objectAtIndex:0]; 
        }else
            _entranceView = [[[NSBundle mainBundle] loadNibNamed:@"KHHStaffEntrance" owner:self options:nil] objectAtIndex:0];
        
        [self.leftBtn setTitle:NSLocalizedString(@"消息", nil) forState:UIControlStateNormal];
        [self.rightBtn setTitle:NSLocalizedString(@"同步", nil) forState:UIControlStateNormal];
        [self showMessageNums];
    }
    return self;
}

//同步
- (void)rightBarButtonClick:(id)sender{
    [self synBtnClick];
}
//消息
- (void)leftBarButtonClick:(id)sender{
    KHHMessageViewController *messageVC = [[KHHMessageViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:messageVC animated:YES];
}
//显示消息个数
- (void)showMessageNums{
    
    if (self.messageImageView == nil) {
        self.messageImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"message_bg.png"]stretchableImageWithLeftCapWidth:0 topCapHeight:0]];
        self.messageImageView.frame = CGRectMake(43, -5, 28, 28);
        //self.messageImageView.backgroundColor = [UIColor grayColor];
        numLab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 28, 28)];
        numLab2.backgroundColor = [UIColor clearColor];
        numLab2.font = [UIFont systemFontOfSize:10];
        numLab2.textColor = [UIColor whiteColor];
        numLab2.textAlignment = UITextAlignmentCenter;
        [self.messageImageView addSubview:numLab2];
        [self.leftBtn addSubview:self.messageImageView];
    }
    
    if ([[KHHData sharedData] countOfUnreadMessages] > 0) {
        self.messageImageView.hidden = NO;
        numLab2.text = [NSString stringWithFormat:@"%d",[[KHHData sharedData] countOfUnreadMessages]];
    }else if([[KHHData sharedData] countOfUnreadMessages] == 0){
        self.messageImageView.hidden = YES;
    }
}
- (void)synBtnClick
{
    NSLog(@"start syn");
    [self observeNotificationName:nDataSyncAllSucceeded selector:@"handleDataSyncAllSucceeded:"];
    [self observeNotificationName:nDataSyncAllFailed selector:@"handleDataSyncAllFailed:"];
    app = (KHHAppDelegate *)[UIApplication sharedApplication].delegate;
    [MBProgressHUD showHUDAddedTo:app.window animated:YES];
    [[KHHData sharedData] startSyncAllData];
}
- (void)handleDataSyncAllSucceeded:(NSNotification *)noti{
    [self stopObservingStartSynAllData];
    DLog(@"handleDataSyncAllSucceeded! ====== noti is %@",noti.userInfo);
}
- (void)handleDataSyncAllFailed:(NSNotification *)noti{
    [self stopObservingStartSynAllData];
    DLog(@"handleDataSyncAllFailed! ====== noti is %@",noti.userInfo);
}
- (void)stopObservingStartSynAllData{
    
    [self stopObservingNotificationName:nDataSyncAllSucceeded];
    [self stopObservingNotificationName:nDataSyncAllFailed];
    app = (KHHAppDelegate *)[UIApplication sharedApplication].delegate;
    [MBProgressHUD hideHUDForView:app.window animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _entranceView.center = self.view.center;
    [self.view addSubview:_entranceView];
    //////////////////////////////////////////////////////////////// test!
//    NSArray *receiveNewCardArr = [self.dataCtrl allReceivedCards];
//    for (ReceivedCard *card in receiveNewCardArr) {
//        DLog(@"receiveNewCardArr.isRead is ====== %@",card.isRead);
//    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [KHHShowHideTabBar showTabbar];
    [self showMessageNums];
    
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
    self.myCard = nil;
    self.app = nil;
    self.messageImageView = nil;
    self.numLab2 = nil;
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
    //calVC.card = self.myCard;
    [self.navigationController pushViewController:calVC animated:YES];

}
//分组
- (IBAction)manageEmployeesBtnClick:(id)sender{
    KHHHomeViewController *homeVC = [[KHHHomeViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:homeVC animated:YES];
    

}
//签到
- (IBAction)locationBtnClick:(id)sender{
    LocationInfoVC *locaVC = [[LocationInfoVC alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:locaVC animated:YES];
}
//交换
- (IBAction)personBtnClick:(id)sender
{
    KHHExchangeViewController *exchangeVC = [[KHHExchangeViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:exchangeVC animated:YES];
    
}
//更多
- (IBAction)moreBtnClick:(id)sender{
    MoreViewController *moreVC = [[MoreViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:moreVC animated:YES];
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
