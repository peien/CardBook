//
//  KHHNotifications.h
//
//  Created by 孙铭 on 9/12/12.
//

#ifndef KHHNotifications_h
#define KHHNotifications_h

#import "NSObject+SM.h"

#pragma mark - UI Notifications
static NSString * const KHHUIShowStartup     = @"UIshowStartup";
static NSString * const nAppShowMainView     = @"nAppShowMainView";
static NSString * const nAppShowPreviousView = @"nAppShowPreviousView";
// Intro
static NSString * const nAppSkipIntro    = @"nAppSkipIntro";
// Logout
static NSString * const KHHAppLogout     = @"AppLogout";

//MARK: - 帐户操作
// Login
// 注意设置userInfo: 包含的keys @"user" @"password"
static NSString * const nAppLogMeIn   = @"nAppLogMeIn";
static NSString * const nAppLoggingIn = @"nAppLoggingIn";

// 注册
// 注意设置userInfo: 包含的keys @"user" @"password"
static NSString * const nAppShowCreateAccount = @"nAppShowCreateAccount";
static NSString * const nAppCreateThisAccount = @"nAppCreateThisAccount";
static NSString * const nAppCreatingAccount   = @"nAppCreatingAccount";

// 重设密码
static NSString * const nAppResetMyPassword   = @"nAppResetMyPassword";
static NSString * const nAppResettingPassword = @"nAppResettingPassword";

//MARK: - 同步
// Sync
static NSString * const nAppSyncing           = @"nAppSyncing";
static NSString * const nDataSyncAllSucceeded = @"nDataSyncAllSucceeded";
static NSString * const nDataSyncAllFailed    = @"nDataSyncAllFailed";

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
// 取最后／最新一个ReceivedCard
static NSString * const KHHUIPullLatestReceivedCardSucceeded  = @"UIPullLatestReceivedCardSucceeded";
static NSString * const KHHUIPullLatestReceivedCardFailed     = @"UIPullLatestReceivedCardFailed";
// 标记为已读
static NSString * const KHHUIMarkCardIsReadSucceeded = @"UIMarkCardIsReadSucceeded";
static NSString * const KHHUIMarkCardIsReadFailed    = @"UIMarkCardIsReadFailed";

//MARK: - 分组
// 创建
static NSString * const KHHUICreateGroupSucceeded = @"UICreateGroupSucceeded";
static NSString * const KHHUICreateGroupFailed    = @"UICreateGroupFailed";
// 修改
static NSString * const KHHUIUpdateGroupSucceeded = @"UIUpdateGroupSucceeded";
static NSString * const KHHUIUpdateGroupFailed    = @"UIUpdateGroupFailed";
// 删除
static NSString * const KHHUIDeleteGroupSucceeded = @"UIDeleteGroupSucceeded";
static NSString * const KHHUIDeleteGroupFailed    = @"UIDeleteGroupFailed";
// 添加组员／删除组员
static NSString * const KHHUIMoveCardsSucceeded = @"UIMoveCardsSucceeded";
static NSString * const KHHUIMoveCardsFailed    = @"UIMoveCardsFailed";

//MARK: - 客户评估
static NSString * const KHHUISaveEvaluationSucceeded = @"UISaveEvaluationSucceeded";
static NSString * const KHHUISaveEvaluationFailed    = @"UISaveEvaluationFailed";

//MARK: - 拜访计划
static NSString * const KHHUICreateVisitScheduleSucceeded = @"UICreateVisitScheduleSucceeded";
static NSString * const KHHUICreateVisitScheduleFailed    = @"UICreateVisitScheduleFailed";
static NSString * const KHHUIUpdateVisitScheduleSucceeded = @"UIUpdateVisitScheduleSucceeded";
static NSString * const KHHUIUpdateVisitScheduleFailed    = @"UIUpdateVisitScheduleFailed";
static NSString * const KHHUIDeleteVisitScheduleSucceeded = @"UIDeleteVisitScheduleSucceeded";
static NSString * const KHHUIDeleteVisitScheduleFailed    = @"UIDeleteVisitScheduleFailed";
static NSString * const KHHUIUploadImageForVisitScheduleSucceeded  = @"UIUploadImageForVisitScheduleSucceeded";
static NSString * const KHHUIUploadImageForVisitScheduleFailed   = @"UIUploadImageForVisitScheduleFailed";
static NSString * const KHHUIDeleteImageFromVisitScheduleSucceeded = @"UIDeleteImageFromVisitScheduleSucceeded";
static NSString * const KHHUIDeleteImageFromVisitScheduleFailed  = @"UIDeleteImageFromVisitScheduleFailed";

//MARK: - 消息
// allMessages
static NSString * const nUISyncMessagesSucceeded   = @"UISyncMessagesSucceeded";
static NSString * const nUISyncMessagesFailed      = @"UISyncMessagesFailed";
// deleteMessages
static NSString * const nUIDeleteMessagesSucceeded = @"UIDeleteMessagesSucceeded";
static NSString * const nUIDeleteMessagesFailed    = @"UIDeleteMessagesFailed";

//MARK: -回赠名片
static NSString * const KHHUIReplyCardSucceeded     = @"UIReplyCardSucceeded";
static NSString * const KHHUIReplyCardFailed        = @"UIReplyCardFailed";

//MARK: -名片点击到全屏预览的callback actionName
static NSString * const KHHUICanclePreViewActionName = @"UICancleFullScreenPreView";

#pragma mark - Misc
//MARK: - 位置
/*!
 KHHLocationUpdateSucceeded userInfo keys
 kInfoKeyPlacemark         : CLPlacemark,
 kInfoKeyLocationLatitude  : NSNumber,
 kInfoKeyLocationLongitude : NSNumber,
 */
static NSString * const KHHLocationUpdateSucceeded = @"KHHLocationUpdateSucceeded";
/*!
 KHHLocationUpdateFailed userInfo keys
 kInfoKeyError : NSError,
 */
static NSString * const KHHLocationUpdateFailed    = @"KHHLocationUpdateFailed";

#pragma mark - Network Notifications
//MARK: - 帐户操作
// 登录
static NSString * const nNetworkLoginSucceeded = @"loginSucceeded";
static NSString * const nNetworkLoginFailed    = @"loginFailed";
// 注册
static NSString * const nNetworkCreateAccountSucceeded = @"createAccountSucceeded";
static NSString * const nNetworkCreateAccountFailed    = @"createAccountFailed";
// 改密码
static NSString * const KHHNetworkChangePasswordSucceeded = @"changePasswordSucceeded";
static NSString * const KHHNetworkChangePasswordFailed    = @"changePasswordFailed";
// 重置密码
static NSString * const nNetworkResetPasswordSucceeded = @"resetPasswordSucceeded";
static NSString * const nNetworkResetPasswordFailed    = @"resetPasswordFailed";
// markAutoReceive
static NSString * const KHHNetworkMarkAutoReceiveSucceeded = @"markAutoReceiveSucceeded";
static NSString * const KHHNetworkMarkAutoReceiveFailed    = @"markAutoReceiveFailed";

//MARK: - 同步数据
// allDataAfterDate
static NSString * const KHHNetworkAllDataAfterDateSucceeded = @"allDataAfterDateSucceeded";
static NSString * const KHHNetworkAllDataAfterDateFailed    = @"allDataAfterDateFailed";
// allDataAfterDate
static NSString * const KHHNetworkLogoURLWithCompanyNameSucceeded = @"logoURLWithCompanyNameSucceeded";
static NSString * const KHHNetworkLogoURLWithCompanyNameFailed    = @"logoURLWithCompanyNameFailed";

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
static NSString * const KHHNetworkReceivedCardCountAfterDateLastCardFailed    = @"receivedCardCountAfterDateLastCardFailed";
// receivedCardsAfterDateLastCardExpectedCount
static NSString * const KHHNetworkReceivedCardsAfterDateLastCardExpectedCountSucceeded = @"receivedCardsAfterDateLastCardExpectedCountSucceeded";
static NSString * const KHHNetworkReceivedCardsAfterDateLastCardExpectedCountFailed    = @"receivedCardsAfterDateLastCardExpectedCountFailed";
// markReadReceivedCard
static NSString * const KHHNetworkMarkReadReceivedCardSucceeded = @"markReadReceivedCardSucceeded";
static NSString * const KHHNetworkMarkReadReceivedCardFailed    = @"markReadReceivedCardFailed";
// privateCardsAfterDate
static NSString * const KHHNetworkPrivateCardsAfterDateSucceeded = @"privateCardsAfterDateSucceeded";
static NSString * const KHHNetworkPrivateCardsAfterDateFailed    = @"privateCardsAfterDateFailed";

//MARK: - 模板
static NSString * const KHHNetworkTemplatesAfterDateSucceeded = @"templatesAfterDateSucceeded";
static NSString * const KHHNetworkTemplatesAfterDateFailed    = @"templatesAfterDateFailed";

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
static NSString * const KHHNetworkCardIDsInGroupSucceeded = @"cardIDsInGroupSucceeded";
static NSString * const KHHNetworkCardIDsInGroupFailed    = @"cardIDsInGroupFailed";
static NSString * const KHHNetworkCardIDsInAllGroupSucceeded = @"NetworkCardIDsInAllGroupSucceeded";
static NSString * const KHHNetworkCardIDsInAllGroupFailed    = @"NetworkCardIDsInAllGroupFailed";
// Move cards from ... to ...
static NSString * const KHHNetworkMoveCardsSucceeded = @"moveCardsSucceeded";
static NSString * const KHHNetworkMoveCardsFailed    = @"moveCardsFailed";
// Child groups
static NSString * const KHHNetworkChildGroupsOfGroupIDSucceeded = @"NetworkChildGroupsOfGroupIDSucceeded";
static NSString * const KHHNetworkChildGroupsOfGroupIDFailed    = @"NetworkChildGroupsOfGroupIDFailed";

//MARK: - 名片交换
//交换
static NSString * const KHHNetworkExchangeCardSucceeded = @"exchangeCardSucceeded";
static NSString * const KHHNetworkExchangeCardFailed    = @"exchangeCardFailed";
//发送（回赠名片）
static NSString * const nNetworkSendCardToPhoneSucceeded = @"NetworkSendCardToPhoneSucceeded";
static NSString * const nNetworkSendCardToPhoneFailed    = @"NetworkSendCardToPhoneFailed";
static NSString * const KHHNetworkSendCardToUserSucceeded = @"sendCardToUserSucceeded";
static NSString * const KHHNetworkSendCardToUserFailed    = @"sendCardToUserFailed";

//MARK: - 拜访计划
static NSString * const KHHNetworkVisitSchedulesAfterDateSucceeded = @"visitSchedulesAfterDateSucceeded";
static NSString * const KHHNetworkVisitSchedulesAfterDateFailed    = @"visitSchedulesAfterDateFailed";
static NSString * const KHHNetworkCreateVisitScheduleSucceeded = @"NetworkCreateVisitScheduleSucceeded";
static NSString * const KHHNetworkCreateVisitScheduleFailed    = @"NetworkCreateVisitScheduleFailed";
static NSString * const KHHNetworkUpdateVisitScheduleSucceeded = @"NetworkUpdateVisitScheduleSucceeded";
static NSString * const KHHNetworkUpdateVisitScheduleFailed    = @"NetworkUpdateVisitScheduleFailed";
static NSString * const KHHNetworkDeleteVisitScheduleSucceeded = @"NetworkDeleteVisitScheduleSucceeded";
static NSString * const KHHNetworkDeleteVisitScheduleFailed    = @"NetworkDeleteVisitScheduleFailed";
static NSString * const KHHNetworkUploadImageForVisitScheduleSucceeded = @"NetworkUploadImageForVisitScheduleSucceeded";
static NSString * const KHHNetworkUploadImageForVisitScheduleFailed    = @"NetworkUploadImageForVisitScheduleFailed";
static NSString * const KHHNetworkDeleteImageFromVisitScheduleSucceeded = @"NetworkDeleteImageFromVisitScheduleSucceeded";
static NSString * const KHHNetworkDeleteImageFromVisitScheduleFailed    = @"NetworkDeleteImageFromVisitScheduleFailed";

//MARK: - 客户评估
static NSString * const KHHNetworkCustomerEvaluationListAfterDateSucceeded = @"customerEvaluationListAfterDateSucceeded";
static NSString * const KHHNetworkCustomerEvaluationListAfterDateFailed    = @"customerEvaluationListAfterDateFailed";
static NSString * const KHHNetworkCreateOrUpdateEvaluationSucceeded = @"NetworkCreateOrUpdateEvaluationSucceeded";
static NSString * const KHHNetworkCreateOrUpdateEvaluationFailed    = @"NetworkCreateOrUpdateEvaluationFailed";

//MARK: - 企业管理相关
// listDepartments
static NSString * const KHHNetworkListDepartmentsSucceeded = @"listDepartmentsSucceeded";
static NSString * const KHHNetworkListDepartmentsFailed    = @"listDepartmentsFailed";
// CheckIn
static NSString * const KHHNetworkCheckInSucceeded = @"checkInSucceeded";
static NSString * const KHHNetworkCheckInFailed    = @"checkInFailed";

//MARK: - 消息
// allMessages
static NSString * const nNetworkAllMessagesSucceeded = @"NetworkAllMessagesSucceeded";
static NSString * const nNetworkAllMessagesFailed    = @"NetworkAllMessagesFailed";
// deleteMessages
static NSString * const nNetworkDeleteMessagesSucceeded = @"NetworkDeleteMessagesSucceeded";
static NSString * const nNetworkDeleteMessagesFailed    = @"NetworkDeleteMessagesFailed";
// promotionMessagesWithType
static NSString * const KHHNetworkPromotionMessagesWithTypeSucceeded = @"promotionMessagesWithTypeSucceeded";
static NSString * const KHHNetworkPromotionMessagesWithTypeFailed    = @"promotionMessagesWithTypeFailed";


#endif
