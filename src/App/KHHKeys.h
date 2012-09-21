//
//  KHHKeys.h
//  CardBook
//
//  Created by 孙铭 on 9/7/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#ifndef KHHKeys_h
#define KHHKeys_h

/*!
 kAttributeKey: Object attributes keys
 */
static NSString * const kAttributeKeyAutoReceive = @"autoReceive";
static NSString * const kAttributeKeyAliWangWang = @"aliWangWang";
static NSString * const kAttributeKeyBusinessScope = @"businessScope";
static NSString * const kAttributeKeyCompanyList = @"companyList";
static NSString * const kAttributeKeyCustomerServiceTel = @"customerServiceTel";
static NSString * const kAttributeKeyDepartment = @"department";
static NSString * const kAttributeKeyEmail = @"email";
static NSString * const kAttributeKeyFactoryAddress = @"factoryAddress";
static NSString * const kAttributeKeyFax = @"fax";
static NSString * const kAttributeKeyID = @"id";
static NSString * const kAttributeKeyMicroblog = @"microblog";
static NSString * const kAttributeKeyMobilePhone = @"mobilePhone";
static NSString * const kAttributeKeyMoreInfo = @"moreInfo";
static NSString * const kAttributeKeyMSN = @"msn";
static NSString * const kAttributeKeyName = @"name";
static NSString * const kAttributeKeyOfficeEmail = @"officeEmail";
static NSString * const kAttributeKeyPassword = @"password";
static NSString * const kAttributeKeyQQ = @"qq";
static NSString * const kAttributeKeyRemarks = @"remarks";
static NSString * const kAttributeKeyTelephone = @"telephone";
static NSString * const kAttributeKeyTitle = @"title";
static NSString * const kAttributeKeyUserID = @"userID";
static NSString * const kAttributeKeyVersion = @"version";
static NSString * const kAttributeKeyWeb = @"web";

/*!
 kAttributeKeyPath: Object attributes key paths
 */
static NSString * const kAttributeKeyPathAddressCity = @"address.city";
static NSString * const kAttributeKeyPathAddressCountry = @"address.country";
static NSString * const kAttributeKeyPathAddressOther = @"address.other";
static NSString * const kAttributeKeyPathAddressProvince = @"address.province";
static NSString * const kAttributeKeyPathAddressZip = @"address.zip";
static NSString * const kAttributeKeyPathBankAccountBranch = @"bankAccount.branch";
static NSString * const kAttributeKeyPathBankAccountNumber = @"bankAccount.number";
static NSString * const kAttributeKeyPathCompanyID = @"company.id";
static NSString * const kAttributeKeyPathCompanyName = @"company.name";
static NSString * const kAttributeKeyPathLogoURL = @"logo.url";
static NSString * const kAttributeKeyPathParentID = @"parent.id";
static NSString * const kAttributeKeyPathTemplateID = @"template.id";

/*!
 JSONDataKey: result dictionary key path
 */
static NSString * const JSONDataKeyAddress = @"address";
static NSString * const JSONDataKeyBankNO = @"bankNO";
static NSString * const JSONDataKeyBusinessScope = @"businessScope";
static NSString * const JSONDataKeyCardId = @"cardId";
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
static NSString * const JSONDataKeyCountry = @"country";
static NSString * const JSONDataKeyEmail = @"email";
static NSString * const JSONDataKeyFax = @"fax";
static NSString * const JSONDataKeyFuctionIds = @"fuctionIds";
static NSString * const JSONDataKeyGmtCreateTime = @"gmtCreateTime";
static NSString * const JSONDataKeyGmtModTime = @"gmtModTime";
static NSString * const JSONDataKeyID = @"id";
static NSString * const JSONDataKeyIsAutoReceive = @"isAutoReceive";
static NSString * const JSONDataKeyIsDelete = @"isDelete";
static NSString * const JSONDataKeyJSONData = @"jsonData";
static NSString * const JSONDataKeyJobTitle = @"jobTitle";
static NSString * const JSONDataKeyLinkList = @"linkList";
static NSString * const JSONDataKeyLogoImage = @"logoImage";
static NSString * const JSONDataKeyMicroBlog = @"microBlog";
static NSString * const JSONDataKeyMobilePhone = @"mobilephone";
static NSString * const JSONDataKeyMoreInfo = @"moreInfo";
static NSString * const JSONDataKeyMSN = @"msn";
static NSString * const JSONDataKeyMyCard = @"myCard";
static NSString * const JSONDataKeyMyPrivateCard = @"myPrivateCard";//NSArray
static NSString * const JSONDataKeyNote = @"note";
static NSString * const JSONDataKeyOpenBank = @"openBank";
static NSString * const JSONDataKeyOrgId = @"orgId";
static NSString * const JSONDataKeyPermissionName = @"permissionName";
static NSString * const JSONDataKeyProvince = @"province";
static NSString * const JSONDataKeyQQ = @"qq";
static NSString * const JSONDataKeyState = @"state";
static NSString * const JSONDataKeySynTime = @"synTime";
static NSString * const JSONDataKeyTelephone = @"telephone";
static NSString * const JSONDataKeyTemplateId = @"templateId";
static NSString * const JSONDataKeyTemplateList = @"templatelist";
static NSString * const JSONDataKeyUserId = @"userId";
static NSString * const JSONDataKeyVersion = @"version";
static NSString * const JSONDataKeyWangWang = @"wangwang";
static NSString * const JSONDataKeyWeb = @"web";
static NSString * const JSONDataKeyZipcode = @"zipcode";

/*!
 Info dictionary key
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
static NSString * const kInfoKeyMyCardList = @"myCardList";//NSArray
static NSString * const kInfoKeyPassword = @"password";//NSString
static NSString * const kInfoKeyPermission = @"permission";//NSString
static NSString * const kInfoKeyPrivateCardList = @"privateCardList";//NSArray
static NSString * const kInfoKeySyncTime = @"syncTime";//NSString
static NSString * const kInfoKeyTemplateList = @"templateList";//NSArray
static NSString * const kInfoKeyUser = @"user";//NSString
static NSString * const kInfoKeyUserID = @"userID";//NSNumber

/*!
 "Extra" dictionary key
 */
static NSString * const kExtraKeyChainedInvocation = @"chainedInvocation";//NSNumber(BOOL), 是否为链式调用

#endif
