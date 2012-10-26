//
//  AppStartController.m
//  CardBook
//
//  Created by Sun Ming on 12-10-24.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "AppStartController.h"
#import "UIViewController+SM.h"
#import "KHHKeys.h"
#import "KHHNotifications.h"
#import "IntroViewController.h"
#import "LaunchImageViewController.h"
#import "AppLoginController.h"
#import "LoginActionViewController.h"
#import "LoginViewController.h"
#import "BTestViewController.h"

#define titleCreateAccountSucceeded NSLocalizedString(@"用户注册成功", nil)
#define titleSyncFailed             NSLocalizedString(@"同步数据出错", nil)
#define textNotAllDataAvailable     NSLocalizedString(@"部分数据可能暂时无法使用。", nil)
#define textWillAutoLogin           NSLocalizedString(@"将自动登录...", nil)

static const NSTimeInterval AppStart_TransitionDuration = 0.3f;
static const UIViewAnimationOptions AppStart_AnimationOptions =UIViewAnimationOptionTransitionCrossDissolve;

#pragma mark - Utils
@interface AppStartController (Utils)
- (void)transitionToViewController:(UIViewController *)toViewController
                           options:(UIViewAnimationOptions)options;
@end
#pragma mark - 动作
@interface AppStartController (Actions)
- (void)createAccount;// 注册
- (void)login;
- (void)loginAuto;
- (void)resetPassword:(NSNotification *)noti;
- (void)sync;
@end
#pragma mark - 界面
@interface AppStartController (ShowViews)
- (void)showActionView;
- (void)showIntroView;
- (void)showLaunchImage;
- (void)showLoginView;
- (void)showTestView;
@end

@implementation AppStartController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self observeNotificationName:nAppStartLogMeIn
                             selector:@"login"];
        [self observeNotificationName:nAppStartResetMyPassword
                             selector:@"resetPassword:"];
        [self observeNotificationName:nAppStartSkipIntro
                             selector:@"showLoginView"];
        [self observeNotificationName:nDataSyncAllSucceeded
                             selector:@"handleSyncSucceeded:"];
        [self observeNotificationName:nDataSyncAllFailed
                             selector:@"handleSyncFailed:"];
        [self observeNotificationName:nNetworkLoginSucceeded
                             selector:@"handleNetworkLoginSucceeded:"];
        [self observeNotificationName:nNetworkLoginFailed
                             selector:@"handleNetworkLoginFailed:"];
    }
    return self;
}
- (void)dealloc {
    [self stopObservingAllNotifications];
}//dealloc
#pragma mark - 从这里开始
- (void)viewDidLoad
{
    [super viewDidLoad];
    DLog(@"[II] viewDidLoad...");
    
    // 先显示 Launch Image。
    [self showLaunchImage];
    
    // 判断是否是首次启动。首次启动显示引导页。
    if ([self.defaults isFirstLaunch]) {
        [self showIntroView];
        return;
    }
    
    // 不是首次启动
    // 如果满足条件则自动登录，否则手动登录。
    if ([self.defaults isAutoLogin]   // 是否允许自动登录
        && [self.defaults isLoggedIn] // 是否已登录
        && self.defaults.currentUser.length
        && self.defaults.currentPassword.length) {
        // 自动登录
        [self loginAuto];
    } else {
        // 手动登录
        [self showLoginView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

#pragma mark - 动作
@implementation AppStartController (Actions)
- (void)createAccount {
    DLog(@"[II] 开始注册！");
    [self.defaults setLoggedIn:NO];
    
    // 切换到 ActionView
    [self showActionView];
    
    //发送正在注册消息
    [self postASAPNotificationName:nAppStartCreatingAccount];
    
    // 调接口
    NSString *user = self.defaults.currentUser;
    NSString *password = self.defaults.currentPassword;
    [self.agent createAccount:user
                     password:password];
}
- (void)login {
    DLog(@"[II] 开始登录！");
    [self.defaults setLoggedIn:NO];
    
    // 切换到 ActionView
    [self showActionView];
    
    // 发“正在登录”消息
    [self postASAPNotificationName:nAppStartLoggingIn];
    
    // 调接口
    NSString *user = self.defaults.currentUser;
    NSString *password = self.defaults.currentPassword;
    [self.agent login:user
             password:password];
}
- (void)loginAuto {
    DLog(@"[II] 开始自动登录！");
    
    // 无网络直接进
    if (NO) {
#warning TODO
        [self postASAPNotificationName:nAppStartShowMainView];
    }
    // 有网络则登录
    else {
        [self login];
    }
}
- (void)resetPassword:(NSNotification *)noti {
    DLog(@"[II] 开始重置密码！");
    // 切换到 ActionView
    [self showActionView];
    
    // 发送正在重置消息
    [self postASAPNotificationName:nAppStartResettingPassword];
    
    // 调接口
    DLog(@"[II] 调用重置密码接口！");
    NSString *user = noti.userInfo[kInfoKeyUser];
    [self.agent resetPassword:user];
}
- (void)sync {
    DLog(@"[II] 开始同步！");
    [self postASAPNotificationName:nAppStartSyncing];
    // 开始同步数据
    [self.data removeContext];
    [self.data startSyncAllData];
}

#pragma mark - Handlers
- (void)handleNetworkCreateAccountSucceeded:(NSNotification *)noti {
    // 注册成功
    DLog(@"[II] 注册成功，保存用户数据。");
    // 保存用户数据: id,mobile,password
    [self.defaults saveLoginOrRegisterResult:noti.userInfo];
    // 自动登录
    [self alertWithTitle:titleCreateAccountSucceeded
                 message:textWillAutoLogin];
}
- (void)handleNetworkLoginSucceeded:(NSNotification *)noti {
    // 登陆成功
    // 保存用户数据: id,mobile,password,isAutoReceive
    [self.defaults saveLoginOrRegisterResult:noti.userInfo];
    [self.defaults setLoggedIn:YES];
    // http鉴权
    [self.agent authenticateWithUser:self.defaults.currentAuthorizationID.stringValue
                            password:self.defaults.currentPassword];
    // 开始同步
    [self sync];
}
- (void)handleNetworkLoginFailed:(NSNotification *)noti {
    DLog(@"[II] 登录失败！");
    [self.defaults setLoggedIn:NO];
#warning TODO
}
- (void)handleNetworkResetPasswordSucceeded:(NSNotification *)noti
{
    DLog(@"[II] 重置密码成功！");
    [self.defaults setLoggedIn:NO];
#warning TODO
}

- (void)handleSyncSucceeded:(NSNotification *)noti {
    // 进主界面。
    [self postNowNotificationName:nAppStartShowMainView];
}
- (void)handleSyncFailed:(NSNotification *)noti {
    [self alertWithTitle:titleSyncFailed
                 message:textNotAllDataAvailable];
    // 进主界面。
    [self postNowNotificationName:nAppStartShowMainView];
}
@end

#pragma mark - 界面
@implementation AppStartController (ShowViews)
- (void)showTestView {
    UIViewController *toVC = [[BTestViewController alloc]
                              initWithNibName:nil
                              bundle:nil];
    [self transitionToViewController:toVC
                             options:AppStart_AnimationOptions];
}
- (void)showActionView {
//    if ([self.childViewControllers.lastObject
//         isKindOfClass:[LoginActionViewController class]]) {
//        return;
//    }
    UIViewController *toVC = [[LoginActionViewController alloc]
                              initWithNibName:nil
                              bundle:nil];
    [self transitionToViewController:toVC
                             options:AppStart_AnimationOptions];
}
- (void)showIntroView {
    UIViewController *toVC = [[IntroViewController alloc]
                              initWithNibName:nil
                              bundle:nil];
    [self transitionToViewController:toVC
                             options:AppStart_AnimationOptions];
}
- (void)showLaunchImage {
    UIViewController *toVC = [[LaunchImageViewController alloc]
                              initWithNibName:nil
                              bundle:nil];
    [self transitionToViewController:toVC
                             options:AppStart_AnimationOptions];
}
- (void)showLoginView {
    
    UIViewController *toVC = [[UINavigationController alloc]
                              initWithRootViewController:[[AppLoginController alloc]
                                                          initWithNibName:nil
                                                          bundle:nil]];
    [self transitionToViewController:toVC
                             options:AppStart_AnimationOptions];
}

@end

@implementation AppStartController (Utils)
- (void)transitionToViewController:(UIViewController *)toViewController
                           options:(UIViewAnimationOptions)options {
    DLog(@"[II] 切换前：\n \
         child controllers = %@\n \
         subviews = %@", self.childViewControllers, self.view.subviews);
    
    if (self.childViewControllers.count) {
        UIViewController *fromVC = self.childViewControllers.lastObject;
        [self addChildViewController:toViewController];
        [self transitionFromViewController:fromVC
                          toViewController:toViewController
                                  duration:AppStart_TransitionDuration
                                   options:options
                                animations:nil
                                completion:^(BOOL finished) {
                                }];
        [fromVC.view removeFromSuperview];
        [fromVC removeFromParentViewController];
    } else {
        [self addChildViewController:toViewController];
        [self.view addSubview:toViewController.view];
    }
    
    DLog(@"[II] 切换后：\n \
         child controllers = %@\n \
         subviews = %@", self.childViewControllers, self.view.subviews);
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:titleCreateAccountSucceeded]) {
        //注册成功, 自动登录
        [self login];
    }
}
@end
