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
#import "KHHDefaults.h"
#import "KHHCalendarViewController.h"
#import "KHHHomeViewController.h"
#import "KHHExchangeViewController.h"
#import "LocationInfoVC.h"
#import "MBProgressHUD.h"
#import "KHHAppDelegate.h"
#import "KHHRadarViewController.h"
#import "KHHFunnelViewController.h"
#import "KHHMessageViewController.h"
#import "KHHShowHideTabBar.h"

#import "Card.h"
#import "DetailInfoViewController.h"
#import "KHHLocalNotificationUtil.h"
#import "KHHOrganizationViewController.h"
#import "IntroViewController.h"
#import "KHHPlanViewController.h"
#import "KHHWhereUtil.h"
#import "KHHBMapLocationController.h"
#import "KHHDataNew+Card.h"
#import "KHHDataNew+Message.h"
#import "KHHDataNew+Template.h"
#import "KHHNewMessageViewController.h"


#define TEXT_NEW_MESSAGE_COMMING NSLocalizedString(@"您有新消息到了,可到消息界面查看新消息。",nil)
#define TEXT_NEW_CONTACT_COMMING NSLocalizedString(@"您有新名片到了，点击确认去查看联系人...",nil)

//定时同步消息时间(秒)
static int const KHH_SYNC_MESSAGE_TIME = 3 * 60;//alert类型:1.新消息 2.新联系人

@interface KHHManagementViewController ()

@property (strong, nonatomic) Card           *myCard;
@property (strong, nonatomic) KHHAppDelegate *app;
@property (strong, nonatomic) UIImageView    *messageImageView;
@property (strong, nonatomic) UILabel        *numLab2;
@property (strong, nonatomic) NSTimer        *syncMessageTimer;
@property (assign, nonatomic) BOOL           isSingleContact;
@property (strong, nonatomic) NSArray        *messageContactList;

@end

@implementation KHHManagementViewController
{
    IntroViewController *introVC;
    
    MBProgressHUD *_hud;
}
@synthesize guide = _guide;
@synthesize signButton = _signButton;
@synthesize entranceView = _entranceView;

@synthesize app;
@synthesize messageImageView;
@synthesize numLab2;
@synthesize syncMessageTimer;
@synthesize isSingleContact = _isSingleContact;
@synthesize messageContactList = _messageContactList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization CFBundleName
        //        self.title = NSLocalizedString(@"蜂巢访销", nil);
        self.title = KHH_APP_NAME;
       // self.dataCtrl = [KHHData sharedData];
        _entranceView = [[[NSBundle mainBundle] loadNibNamed:@"KHHBossEntrance" owner:self options:nil] objectAtIndex:0];
        
        [self.leftBtn setTitle:NSLocalizedString(@"消息", nil) forState:UIControlStateNormal];
        [self.rightBtn setTitle:NSLocalizedString(@"同步", nil) forState:UIControlStateNormal];
        
    }
    return self;
}

//同步
- (void)rightBarButtonClick:(id)sender{
    //弹出同步提示框
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"同步数据"
                                                    message:KhhMessageSyncDataWithServer
                                                   delegate:self
                                          cancelButtonTitle:@"确认"
                                          otherButtonTitles:@"取消", nil];
    alert.tag = KHHAlertSync;
    [alert show];
}
//消息
- (void)leftBarButtonClick:(id)sender{
    [self gotoMessageListViewController];
}

//去消息列表
-(void) gotoMessageListViewController
{
    KHHNewMessageViewController *messageVC = [[KHHNewMessageViewController alloc] initWithNibName:nil bundle:nil];
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
    
    if ([[KHHDataNew sharedData] countOfUnreadMessages] > 0) {
        self.messageImageView.hidden = NO;
        numLab2.text = [NSString stringWithFormat:@"%d",[[KHHDataNew sharedData] countOfUnreadMessages]];
    }else if([[KHHDataNew sharedData] countOfUnreadMessages] == 0){
        self.messageImageView.hidden = YES;
    }
}

- (void)handleDataSyncAllSucceeded:(NSNotification *)noti{
    [self stopObservingStartSynAllData];
    DLog(@"handleDataSyncAllSucceeded! ====== noti is %@",noti.userInfo);
}
- (void)handleDataSyncAllFailed:(NSNotification *)noti{
    [self stopObservingStartSynAllData];
    DLog(@"handleDataSyncAllFailed! ====== noti is %@",noti.userInfo);
    //设置消息
    NSString *message = nil;
    if ([[noti.userInfo objectForKey:@"errorCode"]intValue] == KHHErrorCodeConnectionOffline){
        message = KHHMessageNetworkEorror;
    }
    
    //提示没有收到新名片
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:KHHMessageSyncAllFailed
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:KHHMessageSure
                                          otherButtonTitles:nil, nil];
    [alert show];
}
- (void)stopObservingStartSynAllData{
    
    [self stopObservingNotificationName:nDataSyncAllSucceeded];
    [self stopObservingNotificationName:nDataSyncAllFailed];
    app = (KHHAppDelegate *)[UIApplication sharedApplication].delegate;
    [MBProgressHUD hideHUDForView:app.window animated:YES];
}

- (void)doInitWithUser
{
    [self showMessageNums];
    self.myCard = [[[KHHDataNew sharedData] allMyCards] objectAtIndex:0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //判断是否是iphone5,把图标位置改一下
    [KHHViewAdapterUtil checkIsNeedMoveDownForIphone5:_guide];
    
    //判断数据是否完整
     {
        //提示用户数据没有同步下来，先同步一下数据
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:KhhMessageDataErrorTitle
//                                                        message:KhhMessageDataError
//                                                       delegate:self
//                                              cancelButtonTitle:KHHMessageSure
//                                              otherButtonTitles:KHHMessageCancle, nil];
//        alert.tag = KHHAlertSync;
//        [alert show];
    }
    
    // Do any additional setup after loading the view from its nib.
    _entranceView.center = self.view.center;
    
    [self.view addSubview:_entranceView];
    //根据nib里的tag获取view
    self.signButton = (UIButton *)[_entranceView viewWithTag:1001];
    if (self.signButton) {
        //获取公司id
        NSNumber *companyID = [[KHHDefaults sharedDefaults] currentCompanyID];
        if (!companyID || companyID.longValue <= 0 ) {
            self.signButton.hidden = YES;
        }else {
            self.signButton.hidden = NO;
        }
         self.signButton.hidden = NO;
    }
    //启动定时同步消息timer
   // [self syncMessage];
    //立马同步一次消息
  //  [self handleSyncMessage];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [KHHShowHideTabBar showTabbar];
   // [self showMessageNums];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[KHHShowHideTabBar hideTabbar];
    
}
- (void)viewDidUnload
{
    //关闭timer同步接收广播
    [self stopObservingNotificationName:nUISyncMessagesSucceeded];
    [self stopObservingNotificationName:nUISyncMessagesFailed];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
   // self.dataCtrl = nil;
    self.myCard = nil;
    self.app = nil;
    self.messageImageView = nil;
    self.numLab2 = nil;
    [self.syncMessageTimer invalidate];
}

#pragma mark - show reviewGuide
- (void)reviewGuide:(id) sender {
    DLog(@"review guide pages!");
    if (!introVC) {
        introVC = [[IntroViewController alloc] initWithNibName:nil bundle:nil];
        introVC.view.alpha = 0.0;
    }
    UIViewController *contPro = self.parentViewController.parentViewController;
    [contPro addChildViewController:introVC];
    [contPro.view addSubview:introVC.view];
    [UIView animateWithDuration: 0.5
                     animations:^{
                         introVC.view.alpha = 1.0;
                        
                     }
                     completion:^(BOOL finished) {
                         
                     }];
  //  [self.navigationController pushViewController:introVC animated:YES];
}

- (IBAction)radarBtnClick:(id)sender{
    
    KHHRadarViewController *radarVC = [[KHHRadarViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:radarVC animated:YES];
    
}
- (IBAction)funnelBtnClick:(id)sender{
    
    KHHFunnelViewController *funnelVC = [[KHHFunnelViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:funnelVC animated:YES];
    
}

//公司组织架构
- (IBAction)organizationBtnClick:(id)sender{
    KHHOrganizationViewController *orgVC = [[KHHOrganizationViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:orgVC animated:YES];
}
//分组
- (IBAction)manageEmployeesBtnClick:(id)sender{
    KHHHomeViewController *homeVC = [[KHHHomeViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:homeVC animated:YES];
}

#pragma mark - local0

- (IBAction)locationBtnClick:(id)sender{
    [[KHHFilterPopup shareUtil]showPopUp:[NSArray arrayWithObjects:NSLocalizedString(KHHMessageCreatePlan, nil),
                                          NSLocalizedString(KHHMessageDataCollect, nil),
                                          NSLocalizedString(KHHMessageCheckIn, nil),
                                          NSLocalizedString(KHHMessageViewCalendar, nil), nil]
                                   index:0
                                   Title:@"选择类型" delegate:self];
}

#pragma mark - local1

- (void)selectInAlert:(id)obj
{
    //如果选中返回的空，默认进入新建
    if (!obj) {
        //具休界面
        return;
    }
    
    NSDictionary *dic = obj;
    int index =[[dic objectForKey:@"index"] integerValue];
    NSMutableDictionary *dicPro;
    NSString *titlePro;
    switch (index) {
        case 0:
        {
            dicPro = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"plan" ofType:@"plist"]];
            
            titlePro = @"新建计划";
            
            break;
        }
        case 1:
        {
            dicPro = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"collection" ofType:@"plist"]];
            
            titlePro = @"数据采集";
            
            break;
        }
        case 2:
        {
            dicPro = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"attendance" ofType:@"plist"]];
            titlePro = @"考勤";
            
            break;
        }
        case 3:
        {
            //          dicPro = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"attendance" ofType:@"plist"]];
            KHHCalendarViewController *calVC = [[KHHCalendarViewController alloc] initWithNibName:nil bundle:nil];
            calVC.card = self.myCard;
            [self.navigationController pushViewController:calVC animated:YES];
            return;
            break;
            
        }
        default:
        {
            
            break;
        }
    }
    
    KHHPlanViewController *viewPro = [[KHHPlanViewController alloc]init];
    viewPro.paramDic = dicPro;
    viewPro.title = titlePro;
    [self.navigationController pushViewController:viewPro animated:YES];
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

//后台同步消息
//每隔半小时去同步一次消息
//有新联系人时要提示用户alert，有新消息时要push出来
-(void) syncMessage
{
    //注册广播接收器
    //注册同步消息
    [self observeNotificationName:nUISyncMessagesSucceeded selector:@"handleSyncMessagesSucceeded:"];
    [self observeNotificationName:nUISyncMessagesFailed selector:@"handlenUISyncMessagesFailed:"];
    //设置后台handle
    // [self setupBackgroundHandler];
}

//解析数据
//程序在后台运行的时候notify出来，程序在运行时alert
- (void)handleSyncMessagesSucceeded:(NSNotification *)noti{
    //消息解析成功，看看解析结果中有没有联系人，有联系人就弹出预览框，有新消息就push消息（现在没有push就alert出来）
    DLog(@"timer sync handleSyncMessagesSucceeded ! noti is ======%@",noti.userInfo);
    // DLog(@"%@",noti.userInfo);
    NSArray *messgaeList = noti.userInfo[kInfoKeyObjectList];
    //清空变量
    self.messageContactList = nil;
    self.isSingleContact = NO;
    self.messageContactList = noti.userInfo[kInfoKeyReceivedCard];
    
    UIApplication *application = [UIApplication sharedApplication];
    if([application applicationState] == UIApplicationStateBackground)
    {
        //在后台运行时notify出来
        if (messgaeList && messgaeList.count > 0) {
            //显示有新消息到了
            //          NSString *alertBody = TEXT_NEW_MESSAGE_COMMING;
            //添加跳转页面
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NSLocalizedString(@"KHHMessageViewController", nil) forKey:kLocalNotification_Target_Name];
            //            [KHHLocalNotificationUtil addLocalNotifiCation:[NSDate dateWithTimeIntervalSinceNow:10] alertBody:alertBody userinfo:userInfo];
        }
        
        if (self.messageContactList && self.messageContactList.count > 0) {
            //提示有新联系人到了(一个人时就直接提示名称，点击可以去详细界面，多个人时提示有新联系人)
            NSString *alertBody = nil;
            if (self.messageContactList.count == 1) {
                Card *card = [self.messageContactList objectAtIndex:0];
                alertBody = card.name;
            }else {
                alertBody = TEXT_NEW_CONTACT_COMMING;
            }
            //添加跳转页面
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:NSLocalizedString(@"KHHHomeViewController", nil) forKey:kLocalNotification_Target_Name];
            [KHHLocalNotificationUtil addLocalNotifiCation:[NSDate dateWithTimeIntervalSinceNow:15] alertBody:alertBody userinfo:userInfo];
        }
    }else if([application applicationState] == UIApplicationStateActive)
    {
        //        if (messgaeList && messgaeList.count > 0) {
        //            //显示有新消息到了
        //            NSArray *viewControllers = self.navigationController.viewControllers;
        //            UITableViewController *parent = [viewControllers lastObject];
        //            //当前页不是消息界面时要弹出新消息到了的框
        //            if (parent && ![parent isKindOfClass:[KHHMessageViewController class]]) {
        //                //showalert
        //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新消息"
        //                                                                message:TEXT_NEW_MESSAGE_COMMING
        //                                                               delegate:self
        //                                                      cancelButtonTitle:@"确认"
        //                                                      otherButtonTitles:@"取消", nil];
        //                alert.tag = KHHAlertMessage;
        //                [alert show];
        //            }
        //        }
        
        if (self.messageContactList && self.messageContactList.count > 0) {
            //提示有新联系人到了(一个人时就直接提示名称，点击可以去详细界面，多个人时提示有新联系人)
            [self showNewCardInfo];
        }
    }
}

//同步失败
- (void)handlenUISyncMessagesFailed:(NSNotification *)noti{
    //消息解析失败，不做事情，只是显示本地最新的消息个数
    DLog(@"timer sync handlenUISyncMessagesFailed! noti is ======%@",noti.userInfo);
    [self showMessageNums];
}

//同步消息
-(void) handleSyncMessage
{
    [NSThread detachNewThreadSelector:@selector(syncMessageWithServer) toTarget:self withObject:nil];
    //    [self performSelectorInBackground:@selector(syncMessageWithServer) withObject:nil];
}

-(void) syncMessageWithServer
{
    DLog(@"sync time: %@",[NSDate new]);
  //  [[KHHData sharedData]syncMessages];
}

- (void)showNewCardInfo{
    if (!self.messageContactList || self.messageContactList.count <= 0) {
        return;
    }
    
    NSString *message;
    NSString *btnText;
    if (self.messageContactList.count == 1) {
        Card *card = [self.messageContactList objectAtIndex:0];
        message = card.name;
        self.isSingleContact = YES;
        btnText = @"查看详情";
    }else {
        message = TEXT_NEW_CONTACT_COMMING;
        btnText = @"查看详情";
        self.isSingleContact = NO;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"收到新到名片"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"确认"
                                          otherButtonTitles:@"取消", nil];
    alert.tag = KHHAlertContact;
    [alert show];
}

//收到新的名片，跳转到详细界面


#pragma backgroud running
//手机支持多线程时就启动后台运行那套方案，不支持后台运行时就用timer
//后台运行时，不管程序有没有在活动状态都能执行同步函数，timer只能在程序active的状态下运行
- (void)setupBackgroundHandler
{
    if([self UIUDeviceIsBackgroundSupported])
    {
        if(
           [[UIApplication sharedApplication] setKeepAliveTimeout:600 handler: ^
            {
                //同步消息
                [self syncMessageWithServer];
            }
            ]
           )
        {
            DLog(@"Set Background handler successed!");
        }else
        {//failed
            DLog(@"Set Background handler failed!");
        }
    }else
    {
        DLog(@"This Deviece is not Background supported.");
        if (!self.syncMessageTimer) {
            self.syncMessageTimer = [NSTimer scheduledTimerWithTimeInterval:KHH_SYNC_MESSAGE_TIME target:self selector:@selector(handleSyncMessage) userInfo:nil repeats:YES];
        }
    }
}

-(BOOL) UIUDeviceIsBackgroundSupported {
    UIDevice* device = [UIDevice currentDevice];
    BOOL backgroundSupported = NO;
    if ([device respondsToSelector:@selector(isMultitaskingSupported)])
        backgroundSupported = device.multitaskingSupported;
    return backgroundSupported;
}

#pragma mark - delegateMsgForMain

- (void)reseaveDone:(Boolean)haveNewMsg

{
    if (haveNewMsg) {
        //显示有新消息到了
        NSArray *viewControllers = self.navigationController.viewControllers;
        UITableViewController *parent = [viewControllers lastObject];
        //当前页不是消息界面时要弹出新消息到了的框
        if (parent && ![parent isKindOfClass:[KHHMessageViewController class]]) {
            //showalert
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新消息"
                                                            message:TEXT_NEW_MESSAGE_COMMING
                                                           delegate:self
                                                  cancelButtonTitle:@"确认"
                                                  otherButtonTitles:@"取消", nil];
            alert.tag = KHHAlertMessage;
            [alert show];
        }
    }
    
}

- (void)reseaveFail

{
    
}

#pragma mark - alert delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    if (!alertView || !alertView.tag) {
        return;
    }
    
    KHHAlertType type = alertView.tag;
    
    switch (type) {
        case KHHAlertContact:
        {
            if (buttonIndex == 0) {
                if (!self.messageContactList || self.messageContactList.count <= 0) {
                    return;
                }
                
                if (self.isSingleContact) {
                    //通过cardid，获取到ReceiveCard的card
                    InterCard *intercard = [self.messageContactList objectAtIndex:0];
                    ReceivedCard *card = [ReceivedCard objectByID:intercard.id  createIfNone:NO];
                    DLog(@"messgaeContact card id=%@",card.id);
                    if (card) {
                        DetailInfoViewController *detail = [[DetailInfoViewController alloc] initWithNibName:nil bundle:nil];
                        card.isReadValue = YES;
                        detail.card = card;
                        [self.navigationController pushViewController:detail animated:YES];
                    }
                }else {
                    [self manageEmployeesBtnClick:nil];
                }
            }
        }
            break;
        case KHHAlertMessage:
        {
            if (buttonIndex == 0) {
                [self gotoMessageListViewController];
            }
            break;
        }
        case KHHAlertSync:{
            if (buttonIndex == 0) {
                [self synBtnClick];
            }
        }
        default:
            break;
    }
}

#pragma mark - net syn & delegate
- (void)synBtnClick
{
    NSLog(@"start syn");
    //    [self observeNotificationName:nDataSyncAllSucceeded selector:@"handleDataSyncAllSucceeded:"];
    //    [self observeNotificationName:nDataSyncAllFailed selector:@"handleDataSyncAllFailed:"];
    app = (KHHAppDelegate *)[UIApplication sharedApplication].delegate;
    //    [MBProgressHUD showHUDAddedTo:app.window animated:YES];
    _hud = [MBProgressHUD showHUDAddedTo:app.window animated:YES];
    _hud.labelText = @"同步联系人...";
    // [[KHHData sharedData] startSyncAllData];
    [[KHHDataNew sharedData] doSyncContact:contactSyncTypeJust delegate:self];
}

- (void)syncContactForUISuccess
{
    [self step2SyncTemplate];
    
    
}

- (void)syncContactForUIFailed:(NSDictionary *)dict
{
    [MBProgressHUD hideHUDForView:app.window animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"同步联系人失败" message:dict[kInfoKeyErrorMessage] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

#pragma mark - step2

- (void)step2SyncTemplate
{
    _hud.labelText = @"同步模板...";
    [[KHHDataNew sharedData]doSyncTemplates:self];
    
}

- (void)syncTemplateForUISuccess
{  
    [self step3SyncGroup];
}

- (void)syncTemplateForUIFailed:(NSDictionary *)dict
{
    [MBProgressHUD hideHUDForView:app.window animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"同步模板失败" message:dict[kInfoKeyErrorMessage] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

#pragma mark - step3

- (void)step3SyncGroup
{
    _hud.labelText = @"同步分组...";
    [[KHHDataNew sharedData]doSyncGroup:self];
}

- (void)syncGroupForUISuccess
{
    [self step4SyncPrivateCard];
}

#pragma mark - step4

- (void)step4SyncPrivateCard
{
    _hud.labelText = @"同步私有名片...";
    [[KHHDataNew sharedData] syncCard:self];
}

- (void)syncCardForUISuccess
{
   [self step5SyncPlan];
}

- (void)syncCardForUIFailed:(NSDictionary *)dict
{
    [MBProgressHUD hideHUDForView:app.window animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"同步私有名片失败" message:dict[kInfoKeyErrorMessage] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}


#pragma mark - step5

- (void)step5SyncPlan
{
    _hud.labelText = @"同步拜访计划...";
    [[KHHDataNew sharedData] syncPlan:self];
}

- (void)syncPlanForUISuccess
{
    [self step6SyncCustomer];
}

- (void)syncPlanForUIFailed:(NSDictionary *)dict
{
    [MBProgressHUD hideHUDForView:app.window animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"同步拜访计划失败" message:dict[kInfoKeyErrorMessage] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}

#pragma mark - step6

- (void)step6SyncCustomer
{
    _hud.labelText = @"同步客户评估...";
    [[KHHDataNew sharedData] doSyncCustomer:self];
}

- (void)syncCustomerForUISuccess
{    
    [self step7SyncMessgae];
    [MBProgressHUD hideHUDForView:app.window animated:YES];
}

- (void)syncCustomerForUIFailed:(NSDictionary *)dict
{
    [MBProgressHUD hideHUDForView:app.window animated:YES];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"同步客户评估失败" message:dict[kInfoKeyErrorMessage] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}


#pragma mark - step5

- (void)step7SyncMessgae
{
    if (_hud) {
        _hud.labelText = @"收消息...";
    }    
    [[KHHDataNew sharedData] reseaveMsg:self];
}

@end
