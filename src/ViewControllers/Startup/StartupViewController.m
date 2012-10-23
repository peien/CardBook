//
//  StartupViewController.m
//  eCard
//
//  Created by Ming Sun on 12-6-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "StartupViewController.h"
#import "LaunchImageViewController.h"
#import "IntroViewController.h"
#import "LoginViewController.h"
#import "LoginActionViewController.h"
#import "RegViewController.h"
#import "ResetPasswordViewController.h"
#import "AgreementViewController.h"
#import "KHHDefaults.h"
#import "KHHNetworkAPI.h"
#import "KHHNotifications.h"
#import "UIViewController+SM.h"

#define textLoginFailed NSLocalizedString(@"登录失败", nil)
#define textSignUpFailed NSLocalizedString(@"注册失败", nil)
#define textResetPasswordFailed NSLocalizedString(@"重置密码失败", nil)
#define textResetPasswordSucceeded NSLocalizedString(@"重置密码成功", nil)
#define textResetPasswordSucceededMessage NSLocalizedString(@"新密码将通过短信发送给您，请查收！", nil)

@interface StartupViewController () <UIAlertViewDelegate>
@property (nonatomic, strong) LaunchImageViewController *launchVC;
@property (nonatomic, strong) IntroViewController *introVC;
@property (nonatomic, strong) UINavigationController *navVC;
@property (nonatomic, strong) LoginActionViewController *actionVC;
@property (nonatomic, strong) KHHDefaults *defaults;
@end

@implementation StartupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _launchVC = [[LaunchImageViewController alloc] initWithNibName:nil bundle:nil];
        _introVC = [[IntroViewController alloc] initWithNibName:nil bundle:nil];
        _navVC = [[UINavigationController alloc]
                  initWithRootViewController:[[LoginViewController alloc] 
                                               initWithNibName:@"LoginViewController2" 
                                               bundle:nil]];
        _actionVC = [[LoginActionViewController alloc] initWithNibName:nil bundle:nil];
        _defaults = [KHHDefaults sharedDefaults];
        
        //注册需要捕获的消息
        //Intro
        [self observeNotificationName:KHHUIShowIntro selector:@"handleShowIntro:"];
        [self observeNotificationName:KHHUISkipIntro selector:@"handleSkipIntro:"];

        //Login
        [self observeNotificationName:KHHUIStartLogin selector:@"handleStartLogin:"];
        [self observeNotificationName:KHHUIStartAutoLogin selector:@"handleStartAutoLogin:"];
        [self observeNotificationName:KHHNetworkLoginFailed selector:@"handleLoginFailed:"];
        [self observeNotificationName:KHHNetworkLoginMenually selector:@"handleLoginMenually:"];
        
        //注册
        [self observeNotificationName:KHHUIStartSignUp selector:@"handleStartSignUp:"];
        [self observeNotificationName:KHHNetworkCreateAccountFailed selector:@"handleSignUpFailed:"];
        
        //Reset password
        [self observeNotificationName:KHHUIStartResetPassword selector:@"handleStartResetPassword:"];
        [self observeNotificationName:KHHNetworkResetPasswordSucceeded selector:@"handleResetPasswordSucceeded:"];
        [self observeNotificationName:KHHNetworkResetPasswordFailed selector:@"handleResetPasswordFailed:"];
    }
    return self;
}//initWithNibName:bundle:

- (void)dealloc {
    [self stopObservingAllNotifications];
    self.launchVC = nil;
    self.introVC = nil;
    self.navVC = nil;
    self.actionVC = nil;
    self.defaults = nil;
}//dealloc

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    DLog(@"[II] viewDidLoad...");
    
    // UINavigationController 默认顶部有20px的空白
    self.navVC.navigationBarHidden = YES;
    self.navVC.view.frame = self.view.bounds;
    [self.navVC setNavigationBarHidden:NO animated:YES];
    
    // 先显示LaunchImage
    [self showLaunchImage:UIViewAnimationOptionTransitionNone];
    NSString *notification = nil;

    if (self.defaults.firstLaunch) {
        // 首次启动
        // 显示引导界面
        notification = KHHUIShowIntro;
    } else {
        // 不是首次启动
        // 尝试自动登录
        notification = KHHUIStartAutoLogin;
    }
    
    DLog(@"[II] 发送消息: %@", notification);
    [self postASAPNotificationName:notification];
}//viewDidLoad

- (void)viewDidUnload
{
    [super viewDidUnload];
}//viewDidUnload

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}//shouldAutorotateToInterfaceOrientation:

#pragma mark - Handle notifications
- (void)handleShowIntro:(NSNotification *)notification
{
    //Show Intro
    [self showIntro:UIViewAnimationOptionTransitionCrossDissolve];
}
- (void)handleSkipIntro:(NSNotification *)notification
{
    //跳过Intro以后先尝试自动登录
    DLog(@"[II] 跳过Intro以后先尝试自动登录...");
//    [self handleStartLogin:notification];
    [self postASAPNotificationName:KHHUIStartAutoLogin];
}
- (void)handleStartAutoLogin:(NSNotification *)notification {
    //自动登录
    //转到LoginAction界面
    [self showLoginAction:UIViewAnimationOptionTransitionCrossDissolve];
    //准备发送消息
    NSString *name = KHHUILoginAuto;
    DLog(@"[II] 发送消息: %@", name);
    [self postASAPNotificationName:name];
}
- (void)handleStartLogin:(NSNotification *)notification
{
    NSString *notificationName = nil;
    NSDictionary *infoDict = nil;
    if (notification.userInfo) {
        //手动登录
//        [KHHDefaults setBool:NO forKey:kKHHDefaultsKeyHaveSignedIn];
        self.defaults.loggedIn = NO;
        //转到LoginAction界面
        [self showLoginAction:UIViewAnimationOptionTransitionFlipFromRight];
        //准备发送消息
        notificationName = KHHUILoginManually;
        infoDict = notification.userInfo;
    } else {
        //自动登录
        //转到LoginAction界面
        [self showLoginAction:UIViewAnimationOptionTransitionCrossDissolve];
        //准备发送消息
        notificationName = KHHUILoginAuto;
    }
    NSLog(@"\n%@: handleStartLogin: 发送消息: %@", self, notificationName);
    [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
                                                        object:self
                                                      userInfo:infoDict];
}
- (void)handleLoginFailed:(NSNotification *)notification
{
    self.defaults.loggedIn = NO; // 设置标记避免自动重复登录
    
    NSDictionary *info = notification.userInfo;
    NSString *message = nil;
//    AccountAgentErrorCode errCode = [[infoDict objectForKey:kAccountAgentUserInfoKeyErrorCode] integerValue];
//    if (AccountAgentErrorCodeErrorInfo == errCode) {
//        message = [infoDict objectForKey:kAccountAgentUserInfoKeyInfo]; 
//    } else {
//        message = [KHHAccountAgent stringFromErrorCode:errCode];
//    }
//    
//    BOOL isAuto = [[infoDict objectForKey:kAccountAgentUserInfoKeyAutoLogin] boolValue];
    BOOL isAuto = NO;
    if (isAuto) {
        //自动登录失败
        //返回Login界面
        [self showLoginView:UIViewAnimationOptionTransitionCrossDissolve];
    } else {
        //手动登录失败
        //显示警告信息
        [self alertWithTitle:textLoginFailed message:message];
    }
    NSLog(@"\n%@: 登录失败: %@", self, message);
    NSLog(@"\n%@: _navVC.view.subviews: %@", self, _navVC.view.subviews); 
}

- (void)handleLoginMenually:(NSNotification *)notification
{
    self.defaults.loggedIn = NO; // 设置标记避免自动重复登录
    
    //自动登录失败
    //返回Login界面
    [self showLoginView:UIViewAnimationOptionTransitionCrossDissolve];
}

- (void)handleStartSignUp:(NSNotification *)notification
{
    //转到LoginAction界面
    [self showLoginAction:UIViewAnimationOptionTransitionFlipFromRight];
    //发送注册动作消息
    NSString *name = KHHUISignUpAction;
    DLog(@"[II] 发送消息: %@", name);
    [self postASAPNotificationName:name info:notification.userInfo];
}
- (void)handleSignUpFailed:(NSNotification *)notification
{
    NSDictionary *info = notification.userInfo;
    NSString *message = nil;
//    AccountAgentErrorCode errCode = [[infoDict objectForKey:kAccountAgentUserInfoKeyErrorCode] integerValue];
//    if (AccountAgentErrorCodeErrorInfo == errCode) {
//        message = [infoDict objectForKey:kAccountAgentUserInfoKeyInfo]; 
//    } else {
//        message = [KHHAccountAgent stringFromErrorCode:errCode];
//    }
    //显示警告信息
    [self alertWithTitle:textSignUpFailed message:message];
}
- (void)handleStartResetPassword:(NSNotification *)notification
{
    //转到LoginAction界面
    [self showLoginAction:UIViewAnimationOptionTransitionFlipFromRight];
    //发送重置密码消息
    NSString *name = KHHUIResetPasswordAction;
    DLog(@"[II] 发送消息: %@", name);
    [self postASAPNotificationName:name info:notification.userInfo];
}
- (void)handleResetPasswordSucceeded:(NSNotification *)notification
{
    NSString *message = textResetPasswordSucceededMessage;
    //显示警告信息
    [self alertWithTitle:textResetPasswordSucceeded message:message];
}
- (void)handleResetPasswordFailed:(NSNotification *)notification
{
    NSDictionary *info = notification.userInfo;
    NSString *message = nil;
//    AccountAgentErrorCode errCode = [[infoDict objectForKey:kAccountAgentUserInfoKeyErrorCode] integerValue];
//    if (AccountAgentErrorCodeErrorInfo == errCode) {
//        message = [infoDict objectForKey:kAccountAgentUserInfoKeyInfo]; 
//    } else {
//        message = [KHHAccountAgent stringFromErrorCode:errCode];
//    }
    //显示警告信息
    [self alertWithTitle:textResetPasswordFailed message:message];
}

#pragma mark - Actions
- (void)showLaunchImage:(UIViewAnimationOptions)options
{
    [self transitionToViewController:self.launchVC 
                             options:options];
}
- (void)showIntro:(UIViewAnimationOptions)options
{
    [self transitionToViewController:self.introVC 
                             options:options];
}
- (void)showLoginView:(UIViewAnimationOptions)options
{
    [self transitionToViewController:self.navVC 
                             options:options];
//    self.navVC.navigationBarHidden = YES;
}
- (void)showLoginAction:(UIViewAnimationOptions)options
{
    [self transitionToViewController:self.actionVC 
                             options:options];
}

#pragma mark - Utilities
- (void)transitionToViewController:(UIViewController *)toVC
                           options:(UIViewAnimationOptions)options
{
    NSArray *subviews = self.view.subviews;
    DLog(@"[II] 切换界面之前 subviews＝%@", self.view.subviews);
    if (subviews.count) {
        UIView *fromView = [subviews objectAtIndex:0];
        [UIView transitionFromView:fromView
                            toView:toVC.view 
                          duration:0.5
                           options:options 
                        completion:^(BOOL finished){
                        }];
    } else {
        [self.view addSubview:toVC.view];
    }
    DLog(@"[II] 切换界面之后 subviews＝%@", self.view.subviews);
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString *title = alertView.title;
    if ([title isEqualToString:textLoginFailed]) {
        //登录失败
//        [self showLoginView:UIViewAnimationOptionTransitionFlipFromLeft];
    } else if ([title isEqualToString:textSignUpFailed]) {
        //登录失败
//        [self showLoginView:UIViewAnimationOptionTransitionFlipFromLeft];
    } else if ([title isEqualToString:textResetPasswordSucceeded]) {
//        [self showLoginView:UIViewAnimationOptionTransitionFlipFromLeft];
    } else if ([title isEqualToString:textResetPasswordFailed]) {
//        [self showLoginView:UIViewAnimationOptionTransitionFlipFromLeft];
    }
    // 现在统一返回Login界面
    [self showLoginView:UIViewAnimationOptionTransitionFlipFromLeft];
}
@end
