//
//  KHHNotifications.h
//
//  Created by 孙铭 on 9/12/12.
//

#ifndef KHHNotifications_h
#define KHHNotifications_h

//static NSString * const <#Name#> = @"<#String#>";
// Startup
static NSString * const KHHUIShowStartup = @"showStartup";
// MainUI
static NSString * const KHHUIShowMainUI = @"showMainUI";
// Intro
static NSString * const KHHUIShowIntro = @"ShowIntro";
static NSString * const KHHUISkipIntro = @"SkipIntro";
// Login
// 注意设置userInfo: 包含的keys @"user" @"password"
static NSString * const KHHUIStartLogin = @"StartLogin";
static NSString * const KHHUIStartAutoLogin = @"StartAutoLogin";
static NSString * const KHHUILoginAuto = @"LoginAuto";
static NSString * const KHHUILoginManually = @"LoginManually";
static NSString * const KHHUIAutoLoginFailed = @"AutoLoginFailed";
// 注册
// 注意设置userInfo: 包含的keys @"user" @"password"
static NSString * const KHHUISignUpAction = @"SignUpAction";
static NSString * const KHHUIStartSignUp = @"StartSignUp";
static NSString * const KHHUIStartResetPassword = @"StartResetPassword";
static NSString * const KHHUIResetPasswordAction = @"ResetPasswordAction";
// Sync
static NSString * const KHHNotificationStartSyncAfterLogin = @"startSyncAfterLogin";
static NSString * const KHHNotificationSyncAfterLoginSucceeded = @"SyncAfterLoginSucceeded";
static NSString * const KHHNotificationSyncAfterLoginFailed = @"SyncAfterLoginFailed";

//登录
static NSString * const KHHNetworkLoginSucceeded = @"loginSucceeded";
static NSString * const KHHNetworkLoginFailed = @"loginFailed";
//注册
static NSString * const KHHNetworkCreateAccountSucceeded = @"createAccountSucceeded";
static NSString * const KHHNotificationCreateAccountFailed = @"createAccountFailed";
//改密码
static NSString * const KHHNotificationChangePasswordSucceeded = @"changePasswordSucceeded";
static NSString * const KHHNotificationChangePasswordFailed = @"changePasswordFailed";
//重置密码
static NSString * const KHHNotificationResetPasswordSucceeded = @"resetPasswordSucceeded";
static NSString * const KHHNotificationResetPasswordFailed = @"resetPasswordFailed";
//markAutoReceive
static NSString * const KHHNotificationMarkAutoReceiveSucceeded = @"markAutoReceiveSucceeded";
static NSString * const KHHNotificationMarkAutoReceiveFailed = @"markAutoReceiveFailed";
#endif
