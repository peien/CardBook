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
#import "UIImageView+WebCache.h"
#import "UIViewController+SM.h"

//#define textStartAutoLogin NSLocalizedString(@"正在自动登录...", nil)
#define textLoggingIn NSLocalizedString(@"正在登录...", nil)
//#define textStartLogin NSLocalizedString(@"正在登录...", nil)
//#define textLoginSucceeded NSLocalizedString(@"登录成功", nil)
//#define textStartPostLoginSync NSLocalizedString(@"正在同步数据...", nil)
//#define textPostLoginSyncSucceeded NSLocalizedString(@"同步完成", nil)
//#define textStartSignUp NSLocalizedString(@"正在注册...", nil)
//#define textSignUpSucceeded NSLocalizedString(@"注册成功", nil)
//#define textStartResetPassword NSLocalizedString(@"正在重置密码...", nil)
//#define textResetPasswordSucceeded NSLocalizedString(@"重置密码成功", nil)
//#define alertTitleSyncFailed NSLocalizedString(@"同步数据出错", nil)
//#define textNotAllDataAvailable NSLocalizedString(@"部分数据可能暂时无法使用。", nil)

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
        [self observeNotificationName:nAppStartLoggingIn
                             selector:@"handleLoggingIn:"];
        //Sign up
        [self observeNotificationName:nAppStartCreatingAccount
                             selector:@"handleCreatingAccount:"];
        //Reset password
        [self observeNotificationName:nAppStartResettingPassword
                             selector:@"handleResettingPassword:"];
    }
    return self;
}

#pragma mark - UIViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    DLog(@"[II] viewDidLoad...");
    self.companyImageView.image = [UIImage imageNamed:KHHLogoFileName];
    self.bgImageView.image = [UIImage imageNamed:@"LoginImage_bg.png"];
    
}

#pragma mark - Notification Handlers
- (void)handleLoggingIn:(NSNotification *)noti {
    // 显示正在登录
    self.actionLabel.text = textLoggingIn;
    [self showCompanyLogo];
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
