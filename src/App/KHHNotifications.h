//
//  KHHNotifications.h
//
//  Created by 孙铭 on 9/12/12.
//

#ifndef KHHNotifications_h
#define KHHNotifications_h

#pragma mark - Notifications for UI
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
//MARK: - 帐户操作
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
//MARK: - 同步
// Sync
static NSString * const KHHUIStartSyncAll = @"UIStartSyncAll";
static NSString * const KHHUISyncAllSucceeded = @"UISyncAllSucceeded";
static NSString * const KHHUISyncAllFailed = @"UISyncAllFailed";
//MARK: - 名片
// createCard
static NSString * const KHHUICreateCardSucceeded = @"UICreateCardSucceeded";
static NSString * const KHHUICreateCardFailed    = @"UICreateCardFailed";
// modifyCard
static NSString * const KHHUIModifyCardSucceeded = @"UIModifyCardSucceeded";
static NSString * const KHHUIModifyCardFailed    = @"UIModifyCardFailed";
// deleteCard
static NSString * const KHHUIDeleteCardSucceeded = @"UIDeleteCardSucceeded";
static NSString * const KHHUIDeleteCardFailed    = @"UIDeleteCardFailed";

#pragma mark - Notifications for Network
/*!
 Notifications for Network
 */
//MARK: - 帐户操作
// 登录
static NSString * const KHHNetworkLoginSucceeded = @"loginSucceeded";
static NSString * const KHHNetworkLoginFailed = @"loginFailed";
static NSString * const KHHNetworkLoginMenually = @"loginMenually";
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
//MARK: - 名片
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
//MARK: - 分组
// Create group
static NSString * const KHHNetworkCreateGroupSucceeded = @"createGroupSucceeded";
static NSString * const KHHNetworkCreateGroupFailed    = @"createGroupFailed";
// Update group
static NSString * const KHHNetworkUpdateGroupSucceeded = @"updateGroupSucceeded";
static NSString * const KHHNetworkUpdateGroupFailed    = @"updateGroupFailed";
// Delete group
static NSString * const KHHNetworkDeleteGroupSucceeded = @"deleteGroupSucceeded";
static NSString * const KHHNetworkDeleteGroupFailed    = @"deleteGroupFailed";
// card IDs in group
static NSString * const KHHNetworkCardIDsWithinGroupSucceeded = @"cardIDsWithinGroupSucceeded";
static NSString * const KHHNetworkCardIDsWithinGroupFailed    = @"cardIDsWithinGroupFailed";
// Move cards from ... to ...
static NSString * const KHHNetworkMoveCardsSucceeded = @"moveCardsSucceeded";
static NSString * const KHHNetworkMoveCardsFailed    = @"moveCardsFailed";
//MARK: - 名片交换
//交换
static NSString * const KHHNetworkExchangeCardSucceeded = @"ExchangeCardSucceeded";
static NSString * const KHHNetworkExchangeCardFailed = @"ExchangeCardFailed";
//发送
static NSString * const KHHNetworkSendCardToPhoneSucceeded = @"SendCardToPhoneSucceeded";
static NSString * const KHHNetworkSendCardToPhoneFailed = @"SendCardToPhoneFailed";
static NSString * const KHHNetworkSendCardToUserSucceeded = @"SendCardToUserSucceeded";
static NSString * const KHHNetworkSendCardToUserFailed = @"SendCardToUserFailed";
//MARK: - 拜访计划
static NSString * const KHHNetworkVisitSchedulesAfterDateSucceeded = @"visitSchedulesAfterDateSucceeded";
static NSString * const KHHNetworkVisitSchedulesAfterDateFailed = @"visitSchedulesAfterDateFailed";
//MARK: - 客户评估
static NSString * const KHHNetworkCustomerEvaluationListAfterDateSucceeded = @"customerEvaluationListAfterDateSucceeded";
static NSString * const KHHNetworkCustomerEvaluationListAfterDateFailed = @"customerEvaluationListAfterDateFailed";
//MARK: - 企业管理相关
// listDepartments
static NSString * const KHHNetworkListDepartmentsSucceeded = @"listDepartmentsSucceeded";
static NSString * const KHHNetworkListDepartmentsFailed    = @"listDepartmentsFailed";

#endif
