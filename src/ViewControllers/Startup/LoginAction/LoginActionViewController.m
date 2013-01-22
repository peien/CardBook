//
//  LoginActionViewController.m
//  eCard
//
//  Created by Ming Sun on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginActionViewController.h"
#import "KHHDataAPI.h"
#import "KHHDefaults.h"
#import "KHHMacros.h"
#import "KHHNetworkAPI.h"
#import "KHHNotifications.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIViewController+SM.h"
#import "KHHViewAdapterUtil.h"
#import "KHHUser.h"
#import "AppLoginController.h"


//#define textStartAutoLogin NSLocalizedString(@"正在自动登录...", nil)
#define textCreatingAccount   NSLocalizedString(@"正在注册帐户...", nil)
#define textLoggingIn         NSLocalizedString(@"正在登录...", nil)
#define textOfflineLogin NSLocalizedString(@"网络不可用,正在进行离线...", nil)
#define textCheckNetwork NSLocalizedString(@"正在检测网络...", nil)
#define textResettingPassword NSLocalizedString(@"正在重置密码...", nil)
//#define textStartLogin NSLocalizedString(@"正在登录...", nil)
//#define textLoginSucceeded NSLocalizedString(@"登录成功", nil)
#define textStartPostLoginSync NSLocalizedString(@"正在同步数据...", nil)
//#define textPostLoginSyncSucceeded NSLocalizedString(@"同步完成", nil)
//#define textStartSignUp NSLocalizedString(@"正在注册...", nil)
//#define textSignUpSucceeded NSLocalizedString(@"注册成功", nil)
//#define textStartResetPassword NSLocalizedString(@"正在重置密码...", nil)
//#define textResetPasswordSucceeded NSLocalizedString(@"重置密码成功", nil)
//#define alertTitleSyncFailed NSLocalizedString(@"同步数据出错", nil)
//#define textNotAllDataAvailable NSLocalizedString(@"部分数据可能暂时无法使用。", nil)

@interface LoginActionViewController ()<KHHFilterPopupDelegate>
@property (nonatomic, strong) KHHData *data;
@property (nonatomic, strong) KHHDefaults *defaults;
@property (nonatomic, strong) KHHNetworkAPIAgent *agent;
@end

@implementation LoginActionViewController
{
    NSArray *_arrCompnis;
}

#pragma mark - init && dealloc
- (void)dealloc
{
    [self stopObservingAllNotifications];
    self.data = nil;
    self.defaults = nil;
    self.agent = nil;
}//dealloc
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _data = [KHHData sharedData];
        _defaults = [KHHDefaults sharedDefaults];
        _agent = [[KHHNetworkAPIAgent alloc] init];
        //需要捕获的消息
        //Login
//        [self observeNotificationName:nAppLoggingIn
//                             selector:@"handleLoggingIn:"];
//        //Sign up
//        [self observeNotificationName:nAppCreatingAccount
//                             selector:@"handleCreatingAccount:"];
//        //Reset password
//        [self observeNotificationName:nAppResettingPassword
//                             selector:@"handleResettingPassword:"];
//        //offline login
//        [self observeNotificationName:nAppOfflineLoggingIn
//                             selector:@"handleOfflineLoggingIn:"];
//        //check network
//        [self observeNotificationName:nAppCheckNetwork
//                             selector:@"handleCheckNetwork:"];
//        //同步数据
//        [self observeNotificationName:nAppSyncing
//                             selector:@"handleSyncingWithServer:"];
    }
    return self;
}

#pragma mark - UIViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    DLog(@"[II] viewDidLoad...");
    self.companyImageView.image = [UIImage imageNamed:KHHLogoFileName];
    self.bgImageView.image = [UIImage imageNamed:@"LoginImage_normal.jpg"];
    self.companyImageView.image = [UIImage imageNamed:@"startnew_logo.png"];
    //iphone5的适配
    [KHHViewAdapterUtil checkIsNeedAddHeightForIphone5:self.bgImageView];
}

- (void)changeToTitle:(NSString *)title
{
    self.actionLabel.text = title;
}

- (void)showAlert:(NSArray *)arrCompnis
{
    self.actionLabel.text = @"选择公司...";
    _arrCompnis = arrCompnis;
    NSMutableArray *arrStrPro = [[NSMutableArray alloc]initWithCapacity:5];
    for (NSDictionary *dicPro in arrCompnis) {
        [arrStrPro addObject:dicPro[@"name"]];
    }
    
    [[KHHFilterPopup shareUtil]showPopUp:arrStrPro index:0 Title:@"选择公司" delegate:self];
    
}

- (void)selectInAlert:(id)obj
{
        
    [[KHHDataNew sharedData]doLoginStep2:[KHHUser shareInstance].username password:[KHHUser shareInstance].password sessionId:[KHHUser shareInstance].sessionId companyId:_arrCompnis[[((NSDictionary *)obj)[@"index"] integerValue]] delegate:(id<KHHDataAccountDelegate>)((UINavigationController *)self.parentViewController.childViewControllers[2]).viewControllers[0]];
}

#pragma mark - Notification Handlers
- (void)handleCreatingAccount:(NSNotification *)noti {
    // 显示正在注册
    self.actionLabel.text = textCreatingAccount;
}
- (void)handleLoggingIn:(NSNotification *)noti {
    // 显示正在登录
    self.actionLabel.text = textLoggingIn;
}
- (void)handleResettingPassword:(NSNotification *)noti {
    // 显示正在重置密码
    self.actionLabel.text = textResettingPassword;
}
- (void)handleOfflineLoggingIn:(NSNotification *)noti {
    // 显示正在进行离线登录
    self.actionLabel.text = textOfflineLogin;
}
- (void)handleCheckNetwork:(NSNotification *)noti {
    // 显示正在check网络
    self.actionLabel.text = textCheckNetwork;
}
- (void)handleSyncingWithServer:(NSNotification *)noti {
    // 显示正在同步数据
    self.actionLabel.text = textStartPostLoginSync;
}
#pragma mark - Utilities



@end
