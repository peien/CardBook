//
//  KHHNotifications.h
//
//  Created by 孙铭 on 9/12/12.
//

#ifndef KHHNotifications_h
#define KHHNotifications_h

/*!
 Notifications for UI
 */
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
static NSString * const KHHUIStartSyncAll = @"UIStartSyncAll";
static NSString * const KHHUISyncAllSucceeded = @"UISyncAllSucceeded";
static NSString * const KHHUISyncAllFailed = @"UISyncAllFailed";
// createCard
static NSString * const KHHUICreateCardSucceeded = @"UICreateCardSucceeded";
static NSString * const KHHUICreateCardFailed    = @"UICreateCardFailed";
// modifyCard
static NSString * const KHHUIModifyCardSucceeded = @"UIModifyCardSucceeded";
static NSString * const KHHUIModifyCardFailed    = @"UIModifyCardFailed";
// deleteCard
static NSString * const KHHUIDeleteCardSucceeded = @"UIDeleteCardSucceeded";
static NSString * const KHHUIDeleteCardFailed    = @"UIDeleteCardFailed";

/*!
 Notifications for Network
 */
// 登录
static NSString * const KHHNetworkLoginSucceeded = @"loginSucceeded";
static NSString * const KHHNetworkLoginFailed = @"loginFailed";
// 注册
static NSString * const KHHNetworkCreateAccountSucceeded = @"createAccountSucceeded";
static NSString * const KHHNetworkCreateAccountFailed = @"createAccountFailed";
// 改密码
static NSString * const KHHNetworkChangePasswordSucceeded = @"changePasswordSucceeded";
static NSString * const KHHNetworkChangePasswordFailed = @"changePasswordFailed";
// 重置密码
static NSString * const KHHNetworkResetPasswordSucceeded = @"resetPasswordSucceeded";
static NSString * const KHHNetworkResetPasswordFailed = @"resetPasswordFailed";
// markAutoReceive
static NSString * const KHHNetworkMarkAutoReceiveSucceeded = @"markAutoReceiveSucceeded";
static NSString * const KHHNetworkMarkAutoReceiveFailed = @"markAutoReceiveFailed";
// createCard
static NSString * const KHHNetworkCreateCardSucceeded = @"createCardSucceeded";
static NSString * const KHHNetworkCreateCardFailed    = @"createCardFailed";
// updateCard
static NSString * const KHHNetworkUpdateCardSucceeded = @"updateCardSucceeded";
static NSString * const KHHNetworkUpdateCardFailed    = @"updateCardFailed";
// deleteCard
static NSString * const KHHNetworkDeleteCardSucceeded = @"deleteCardSucceeded";
static NSString * const KHHNetworkDeleteCardFailed    = @"deleteCardFailed";
// deleteReceivedCards
static NSString * const KHHNetworkDeleteReceivedCardsSucceeded = @"deleteReceivedCardsSucceeded";
static NSString * const KHHNetworkDeleteReceivedCardsFailed    = @"deleteReceivedCardsFailed";
// latestReceivedCard
static NSString * const KHHNetworkLatestReceivedCardSucceeded = @"latestReceivedCardSucceeded";
static NSString * const KHHNetworkLatestReceivedCardFailed    = @"latestReceivedCardFailed";
// receivedCardCountAfterDateLastCard
static NSString * const KHHNetworkReceivedCardCountAfterDateLastCardSucceeded = @"receivedCardCountAfterDateLastCardSucceeded";
static NSString * const KHHNetworkReceivedCardCountAfterDateLastCardFailed = @"receivedCardCountAfterDateLastCardFailed";
// receivedCardsAfterDateLastCardExpectedCount
static NSString * const KHHNetworkReceivedCardsAfterDateLastCardExpectedCountSucceeded = @"receivedCardsAfterDateLastCardExpectedCountSucceeded";
static NSString * const KHHNetworkReceivedCardsAfterDateLastCardExpectedCountFailed = @"receivedCardsAfterDateLastCardExpectedCountFailed";
// markReadReceivedCard
static NSString * const KHHNetworkMarkReadReceivedCardSucceeded = @"markReadReceivedCardSucceeded";
static NSString * const KHHNetworkMarkReadReceivedCardFailed    = @"markReadReceivedCardFailed";
// privateCardsAfterDate
static NSString * const KHHNetworkPrivateCardsAfterDateSucceeded = @"privateCardsAfterDateSucceeded";
static NSString * const KHHNetworkPrivateCardsAfterDateFailed    = @"privateCardsAfterDateFailed";

#endif
