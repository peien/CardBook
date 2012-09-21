//
//  KHHNotifications.h
//
//  Created by 孙铭 on 9/12/12.
//

#ifndef KHHNotifications_h
#define KHHNotifications_h

//static NSString * const <#Name#> = @"<#String#>";
// Startup
static NSString * const KHHNotificationShowStartup = @"showStartup";
// MainUI
static NSString * const KHHNotificationShowMainUI = @"showMainUI";
// Intro
static NSString * const ECardNotificationShowIntro = @"ShowIntro";
static NSString * const ECardNotificationSkipIntro = @"SkipIntro";
// Login
static NSString * const ECardNotificationStartLogin = @"StartLogin";
static NSString * const ECardNotificationStartAutoLogin = @"StartAutoLogin";
static NSString * const ECardNotificationLoginAuto = @"LoginAuto";
static NSString * const ECardNotificationLoginManually = @"LoginManually";
static NSString * const ECardNotificationAutoLoginFailed = @"AutoLoginFailed";
// 注册
static NSString * const ECardNotificationSignUpAction = @"SignUpAction";
static NSString * const ECardNotificationStartSignUp = @"StartSignUp";
static NSString * const ECardNotificationStartResetPassword = @"StartResetPassword";
static NSString * const ECardNotificationResetPasswordAction = @"ResetPasswordAction";
// Sync
static NSString * const KHHNotificationStartSyncAfterLogin = @"startSyncAfterLogin";
static NSString * const KHHNotificationSyncAfterLoginSucceeded = @"SyncAfterLoginSucceeded";
static NSString * const KHHNotificationSyncAfterLoginFailed = @"SyncAfterLoginFailed";
#endif
