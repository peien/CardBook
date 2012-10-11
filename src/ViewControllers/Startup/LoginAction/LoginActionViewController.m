//
//  LoginActionViewController.m
//  eCard
//
//  Created by Ming Sun on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginActionViewController.h"
#import "KHHData.h"
#import "KHHDefaults.h"
#import "KHHNetworkAPIAgent+Account.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+SM.h"

#define textStartAutoLogin NSLocalizedString(@"正在自动登录...", nil)
#define textStartLogin NSLocalizedString(@"正在登录...", nil)
#define textWillAutoLogin NSLocalizedString(@"将自动登录...", nil)
#define textLoginSucceeded NSLocalizedString(@"登录成功", nil)
#define textStartPostLoginSync NSLocalizedString(@"正在同步数据...", nil)
#define textPostLoginSyncSucceeded NSLocalizedString(@"同步完成", nil)
#define textStartSignUp NSLocalizedString(@"正在注册...", nil)
#define textSignUpSucceeded NSLocalizedString(@"注册成功", nil)
#define alertTitleSignUpSucceeded NSLocalizedString(@"注册成功", nil)
#define textStartResetPassword NSLocalizedString(@"正在重置密码...", nil)
#define textResetPasswordSucceeded NSLocalizedString(@"重置密码成功", nil)
#define alertTitleSyncFailed NSLocalizedString(@"同步数据出错", nil)
#define textNotAllDataAvailable NSLocalizedString(@"部分数据可能暂时无法使用。", nil)

@interface LoginActionViewController ()
@property (nonatomic, strong) KHHData *data;
@property (nonatomic, strong) KHHDefaults *defaults;
@property (nonatomic, strong) KHHNetworkAPIAgent *agent;
@end

@implementation LoginActionViewController

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
        [self observeNotificationName:KHHUILoginManually
                         selector:@"handleLoginManually:"];
        [self observeNotificationName:KHHUILoginAuto
                         selector:@"handleLoginAuto:"];
        [self observeNotificationName:KHHNetworkLoginSucceeded
                         selector:@"handleLoginSucceeded:"];
        //Sign up
        [self observeNotificationName:KHHUISignUpAction
                         selector:@"handleSignUpAction:"];
        [self observeNotificationName:KHHNetworkCreateAccountSucceeded
                         selector:@"handleSignUpSucceeded:"];
        //Reset password
        [self observeNotificationName:KHHUIResetPasswordAction
                         selector:@"handleResetPasswordAction:"];
        [self observeNotificationName:KHHNetworkResetPasswordSucceeded
                         selector:@"handleResetPasswordSucceeded:"];
        //Sync
        [self observeNotificationName:KHHUIStartSyncAll
                         selector:@"handleStartSyncAfterLogin:"];
        [self observeNotificationName:KHHUISyncAllSucceeded
                         selector:@"handleSyncAfterLoginSucceeded:"];
        [self observeNotificationName:KHHUISyncAllFailed
                         selector:@"handleSyncAfterLoginFailed:"];
    }
    return self;
}

#pragma mark - UIViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    DLog(@"[II] viewDidLoad...");
    self.companyImageView.image = [UIImage imageNamed:KHHLogoFileName];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    DLog(@"[II] viewDidUnload...");
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    DLog(@"[II] viewDidAppear...");
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    DLog(@"[II] viewDidDisappear...");
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Notification Handlers
- (void)handleLoginManually:(NSNotification *)notification
{
    //开始登录
//    NSString *user = [notification.userInfo objectForKey:kAccountAgentUserInfoKeyUser];
    NSString *user = self.defaults.currentUser;
//    NSString *password = [notification.userInfo objectForKey:kAccountAgentUserInfoKeyPassword];
    NSString *password = self.defaults.currentPassword;
    DLog(@"[II] 调用登录接口！");
    [self.agent login:user
             password:password];
    //在界面上显示登录信息和Logo
    self.actionLabel.text = textStartLogin;
    if (self.defaults.currentCompanyID.integerValue) {
        [self showCompanyLogo];
    }
}
- (void)handleLoginAuto:(NSNotification *)notification
{
    BOOL autoLogin = self.defaults.autoLogin;
    BOOL loggedIn = self.defaults.loggedIn;
    NSString *user = self.defaults.currentUser;
    NSString *password = self.defaults.currentPassword;
    
    if(user.length && password.length && autoLogin && loggedIn){
        DLog(@"[II] 开始自动登录！");
        [self.agent login:user password:password];
        //在界面上显示登录信息和Logo
        self.actionLabel.text = textStartAutoLogin;
        [self showCompanyLogo];
    } else {
        NSString *notiName = KHHNetworkLoginMenually;
        NSString *info = NSLocalizedString(@"自动登录条件不满足! ", nil);
        NSDictionary *infoDict = @{
                kInfoKeyAutoLogin : @(YES),
                kInfoKeyErrorMessage : info
        };
        DLog(@"[II] 自动登录条件不满足! 发送消息 %@", notiName);
        [self postASAPNotificationName:notiName
                          info:infoDict];
    }
}
- (void)handleLoginSucceeded:(NSNotification *)notification
{
    // 登陆成功
    self.actionLabel.text = textLoginSucceeded;
    // 保存用户数据: id,mobile,password,isAutoReceive
    [self.defaults saveLoginOrRegisterResult:notification.userInfo];
    self.defaults.loggedIn = YES;
    // http鉴权
    [self.agent authenticateWithFakeID:self.defaults.currentAuthorizationID.stringValue
                              password:self.defaults.currentPassword];
    // 发送同步消息
    [self postASAPNotificationName:KHHUIStartSyncAll];
}
- (void)handleSignUpAction:(NSNotification *)notification
{
    NSString *user = [notification.userInfo objectForKey:kInfoKeyUser];
//    NSString *user = self.defaults.currentUser;
    NSString *password = [notification.userInfo objectForKey:kInfoKeyPassword];
//    NSString *password = self.defaults.currentPassword;
    DLog(@"[II] 调用注册接口!");
    [self.agent createAccount:user
                     password:password];
    self.actionLabel.text = textStartSignUp;
}
- (void)handleSignUpSucceeded:(NSNotification *)notification
{
    self.actionLabel.text = textSignUpSucceeded;
    DLog(@"[II] 注册成功，保存用户数据。");
    // 保存用户数据: id,mobile,password
//    NSDictionary *infoDict = notification.userInfo;
//    NSString *userID = [infoDict objectForKey:kAccountAgentUserInfoKeyUserID];
//    NSString *mobile = [infoDict objectForKey:kAccountAgentUserInfoKeyUser];
//    NSString *password = [infoDict objectForKey:kAccountAgentUserInfoKeyPassword];
    
    [self.defaults saveLoginOrRegisterResult:notification.userInfo];

    [self alertWithTitle:alertTitleSignUpSucceeded message:textWillAutoLogin];
}
- (void)handleResetPasswordAction:(NSNotification *)notification
{
    NSString *user = [notification.userInfo objectForKey:kInfoKeyUser];
    DLog(@"[II] 调用重置密码接口！");
    [self.agent resetPasswordWithMobileNumber:user];
    self.actionLabel.text = textStartResetPassword;
}
- (void)handleResetPasswordSucceeded:(NSNotification *)notification
{
    self.actionLabel.text = textResetPasswordSucceeded;
#ifdef DEBUG
    NSLog(@"\n%@: handleResetPasswordSucceeded:", self);
#endif
//    [KHHDefaults setBool:NO forKey:kKHHDefaultsKeyHaveSignedIn];
    self.defaults.loggedIn = NO;
}
- (void)handleStartSyncAfterLogin:(NSNotification *)notification
{
    self.actionLabel.text = textStartPostLoginSync;
    // 开始同步数据
    [self.data removeContext];
    [self.data startSyncAllData];
}
- (void)handleSyncAfterLoginSucceeded:(NSNotification *)noti {
    // 进主界面。
    [self postNowNotificationName:KHHUIShowMainUI];
}
- (void)handleSyncAfterLoginFailed:(NSNotification *)noti {
    [self alertWithTitle:alertTitleSyncFailed message:textNotAllDataAvailable];
    // 进主界面。
    [self postNowNotificationName:KHHUIShowMainUI];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:alertTitleSignUpSucceeded]) {
        //注册成功
        self.defaults.loggedIn = YES;
        //发送登录消息
        NSString *notiName = KHHUILoginAuto;
        DLog(@"[II] 发送消息 %@ ！", notiName);
        [self postASAPNotificationName:notiName];
    }
}

#pragma mark - Utilities
- (void)showCompanyLogo
{
#warning 这里根据需要来重写
//    NSURL *logoURL = self.defaults.companyLogo;
//    if (imgURL) {
//        [self.companyImageView setImageWithURL:imgURL
//                              placeholderImage:[UIImage imageNamed:KHHLogoFileName]];
//    } 
}
@end
