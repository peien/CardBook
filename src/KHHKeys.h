//
//  KHHKeys.h
//  CardBook
//
//  Created by 孙铭 on 9/7/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#ifndef KHHKeys_h
#define KHHKeys_h

// 暂时空着的占位符号
static NSString * const KHHPlaceholderForEmptyString = @"";

#pragma mark - kAttributeKey* : Object attributes keys
/*!
 kAttributeKey* : Object attributes keys
 */
static NSString * const kAttributeKeyAutoReceive = @"autoReceive";
static NSString * const kAttributeKeyAliWangWang = @"aliWangWang";
static NSString * const kAttributeKeyBusinessScope = @"businessScope";
static NSString * const kAttributeKeyCompanyEmail = @"companyEmail";
static NSString * const kAttributeKeyCompanyList = @"companyList";
static NSString * const kAttributeKeyCustomerServiceTel = @"customerServiceTel";
static NSString * const kAttributeKeyDepartment = @"department";
static NSString * const kAttributeKeyEmail = @"email";
static NSString * const kAttributeKeyFactoryAddress = @"factoryAddress";
static NSString * const kAttributeKeyFax = @"fax";
static NSString * const kAttributeKeyID = @"id";
static NSString * const kAttributeKeyIsRead = @"isRead";
static NSString * const kAttributeKeyMemo = @"memo";
static NSString * const kAttributeKeyMicroblog = @"microblog";
static NSString * const kAttributeKeyMobilePhone = @"mobilePhone";
static NSString * const kAttributeKeyMoreInfo = @"moreInfo";
static NSString * const kAttributeKeyMSN = @"msn";
static NSString * const kAttributeKeyName = @"name";
static NSString * const kAttributeKeyPassword = @"password";
static NSString * const kAttributeKeyQQ = @"qq";
static NSString * const kAttributeKeyRemarks = @"remarks";
static NSString * const kAttributeKeyTelephone = @"telephone";
static NSString * const kAttributeKeyTitle = @"title";
static NSString * const kAttributeKeyUserID = @"userID";
static NSString * const kAttributeKeyVersion = @"version";
static NSString * const kAttributeKeyWeb = @"web";

/*!
 kAttributeKeyPath* : Object attributes key paths
 */
static NSString * const kAttributeKeyPathAddressCity = @"address.city";
static NSString * const kAttributeKeyPathAddressCountry = @"address.country";
static NSString * const kAttributeKeyPathAddressOther = @"address.other";
static NSString * const kAttributeKeyPathAddressProvince = @"address.province";
static NSString * const kAttributeKeyPathAddressZip = @"address.zip";
static NSString * const kAttributeKeyPathBankAccountBranch = @"bankAccount.branch";
static NSString * const kAttributeKeyPathBankAccountNumber = @"bankAccount.number";
static NSString * const kAttributeKeyPathCompanyEmail = @"company.email";
static NSString * const kAttributeKeyPathCompanyID = @"company.id";
static NSString * const kAttributeKeyPathCompanyLogoURL = @"company.logo.url";
static NSString * const kAttributeKeyPathCompanyName = @"company.name";
static NSString * const kAttributeKeyPathLogoURL = @"logo.url";
static NSString * const kAttributeKeyPathParentID = @"parent.id";
static NSString * const kAttributeKeyPathTemplateID = @"template.id";

#pragma mark - JSONDataKey* : result dictionary key path 
/*!
 JSONDataKey* : result dictionary key path
 */
static NSString * const JSONDataKeyAddress = @"address";
static NSString * const JSONDataKeyBankNO = @"bankNO";
static NSString * const JSONDataKeyBusinessScope = @"businessScope";
static NSString * const JSONDataKeyCardId = @"cardId";
static NSString * const JSONDataKeyCardBookList = @"cardBookList";
static NSString * const JSONDataKeyCardBookVO = @"cardBookVo";
static NSString * const JSONDataKeyCardLinkList = @"cardLinkList";
static NSString * const JSONDataKeyCardTypeId = @"cardTypeId"; // 对应 roleType
static NSString * const JSONDataKeyCity = @"city";
static NSString * const JSONDataKeyCol1 = @"col1";
static NSString * const JSONDataKeyCol2 = @"col2";
static NSString * const JSONDataKeyCol3 = @"col3";
static NSString * const JSONDataKeyCol4 = @"col4";
static NSString * const JSONDataKeyCol5 = @"col5";
static NSString * const JSONDataKeyCompanyId = @"companyId";
static NSString * const JSONDataKeyCompanyLinkList = @"companyLinkList";
static NSString * const JSONDataKeyCompanyName = @"companyName";
static NSString * const JSONDataKeyCount = @"count";
static NSString * const JSONDataKeyCountry = @"country";
static NSString * const JSONDataKeyDescription = @"description";
static NSString * const JSONDataKeyDetails = @"details";
static NSString * const JSONDataKeyEmail = @"email";
static NSString * const JSONDataKeyFax = @"fax";
static NSString * const JSONDataKeyFuctionIds = @"fuctionIds";
static NSString * const JSONDataKeyGmtCreateTime = @"gmtCreateTime";
static NSString * const JSONDataKeyGmtModTime = @"gmtModTime";
static NSString * const JSONDataKeyID = @"id";
static NSString * const JSONDataKeyImageUrl = @"imageUrl";
static NSString * const JSONDataKeyIsAutoReceive = @"isAutoReceive";
static NSString * const JSONDataKeyIsDelete = @"isDelete";
static NSString * const JSONDataKeyItem = @"item";
static NSString * const JSONDataKeyJSONData = @"jsonData";
static NSString * const JSONDataKeyJobTitle = @"jobTitle";
static NSString * const JSONDataKeyLastCardbookId = @"lastCardbookId";
static NSString * const JSONDataKeyLinkList = @"linkList";
static NSString * const JSONDataKeyLogoImage = @"logoImage";
static NSString * const JSONDataKeyMemo = @"memo";
static NSString * const JSONDataKeyMicroBlog = @"microBlog";
static NSString * const JSONDataKeyMobilePhone = @"mobilephone";
static NSString * const JSONDataKeyMoreInfo = @"moreInfo";
static NSString * const JSONDataKeyMSN = @"msn";
static NSString * const JSONDataKeyMyCard = @"myCard";
static NSString * const JSONDataKeyMyPrivateCard = @"myPrivateCard";//NSArray
static NSString * const JSONDataKeyName = @"name";
static NSString * const JSONDataKeyNote = @"note";
static NSString * const JSONDataKeyOpenBank = @"openBank";
static NSString * const JSONDataKeyOrgId = @"orgId";
static NSString * const JSONDataKeyPermissionName = @"permissionName";
static NSString * const JSONDataKeyPlanList = @"planList";
static NSString * const JSONDataKeyProvince = @"province";
static NSString * const JSONDataKeyQQ = @"qq";
static NSString * const JSONDataKeyState = @"state";
static NSString * const JSONDataKeyStyle = @"style";
static NSString * const JSONDataKeySynTime = @"synTime";
static NSString * const JSONDataKeyTelephone = @"telephone";
static NSString * const JSONDataKeyTemplateId = @"templateId";
static NSString * const JSONDataKeyTemplateList = @"templatelist";
static NSString * const JSONDataKeyTemplateStyle = @"templateStyle";
static NSString * const JSONDataKeyTemplateType = @"templateType";
static NSString * const JSONDataKeyUserId = @"userId";
static NSString * const JSONDataKeyVersion = @"version";
static NSString * const JSONDataKeyWangWang = @"wangwang";
static NSString * const JSONDataKeyWeb = @"web";
static NSString * const JSONDataKeyZipcode = @"zipcode";

#pragma mark - kInfoKey* : Info dictionary key
/*!
 kInfoKey* : Info dictionary key
 */
static NSString * const kInfoKeyAuthorizationID = @"authorizationID";//NSNumber
static NSString * const kInfoKeyAutoLogin = @"autoLogin";//NSNumber(BOOL)
static NSString * const kInfoKeyAutoReceive = @"autoReceive";//NSNumber(BOOL)
static NSString * const kInfoKeyCompanyID = @"companyID";//NSNumber
static NSString * const kInfoKeyCompanyPromotionLinkList = @"companyPromotionLinkList";//NSArray
static NSString * const kInfoKeyCount = @"count";//NSNumber
static NSString * const kInfoKeyExtra = @"extra";//NSDictionary
static NSString * const kInfoKeyDepartmentID = @"departmentID";//NSNumber
static NSString * const kInfoKeyError = @"error";
static NSString * const kInfoKeyErrorCode = @"errorCode";//NSNumber
static NSString * const kInfoKeyErrorMessage = @"errorMessage";//NSString
static NSString * const kInfoKeyICPPromotionLinkList = @"ICPPromotionLinkList";//NSArray
static NSString * const kInfoKeyID = @"id";
static NSString * const kInfoKeyInterCard = @"InterCard";
static NSString * const kInfoKeyLastID = @"lastID";//NSNumber
static NSString * const kInfoKeyMyCardList = @"myCardList";//NSArray
static NSString * const kInfoKeyPassword = @"password";//NSString
static NSString * const kInfoKeyPermission = @"permission";//NSString
static NSString * const kInfoKeyPrivateCardList = @"privateCardList";//NSArray
static NSString * const kInfoKeyReceivedCard = @"receivedCard"; // ReceivedCard
static NSString * const kInfoKeyReceivedCardList = @"receivedCardList";//NSArray
static NSString * const kInfoKeySyncTime = @"syncTime";//NSString
static NSString * const kInfoKeyTemplateList = @"templateList";//NSArray
static NSString * const kInfoKeyUser = @"user";//NSString
static NSString * const kInfoKeyUserID = @"userID";//NSNumber
static NSString * const kInfoKeyVisitScheduleList = @"visitScheduleList";

#pragma mark - kExtraKey* : "Extra" dictionary key
/*!
 kExtraKey* : "Extra" dictionary key
 */
static NSString * const kExtraKeyCardID = @"cardID";// Card ID, NSNumber
static NSString * const kExtraKeyCardModelType = @"cardModelType";// CardModelType , NSNumber
static NSString * const kExtraKeyChainedInvocation = @"chainedInvocation";//NSNumber(BOOL), 是否为链式调用
static NSString * const kExtraKeyInterCard = @"interCard";// InterCard

#pragma mark - kVisualCardItem* : 
/*!
 static NSString * const kVisualCardItemKey<#Name#> = @"<#String#>";
 */
static NSString * const kVisualCardItemKeyAddress = @"address";
static NSString * const kVisualCardItemKeyCompanyEmail = @"cpemail";
static NSString * const kVisualCardItemKeyCompanyName = @"company";
static NSString * const kVisualCardItemKeyCompanyLogo = @"companylogo";
static NSString * const kVisualCardItemKeyEmail = @"email";
static NSString * const kVisualCardItemKeyFax = @"fax";
static NSString * const kVisualCardItemKeyLogo = @"logo";
static NSString * const kVisualCardItemKeyMobilePhone = @"mobile";
static NSString * const kVisualCardItemKeyMSN = @"msn";
static NSString * const kVisualCardItemKeyName = @"name";
static NSString * const kVisualCardItemKeyQQ = @"qq";
static NSString * const kVisualCardItemKeyTelephone = @"telephone";
static NSString * const kVisualCardItemKeyTitle = @"title";

#pragma mark - kSyncMarkKey* : SyncMark keys
//static NSString * const kSyncMarkKey<#Name#> = @"<#String#>";
static NSString * const kSyncMarkKeyCustomerEvaluationLastTime = @"customerEvaluationLastTime";
static NSString * const kSyncMarkKeyReceviedCardLastID = @"receviedCardLastID";
static NSString * const kSyncMarkKeyReceviedCardLastTime = @"receviedCardLastTime";
static NSString * const kSyncMarkKeySyncAllLastTime = @"syncAllLastTime";
static NSString * const kSyncMarkKeyVisitScheduleLastTime = @"visitScheduleLastTime";

#endif