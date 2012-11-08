//
//  KHHNetworkAPIAgent+Account.m
//  CardBook
//
//  Created by 孙铭 on 8/29/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPI.h"
#import "Encryptor.h"
#import "NSString+SM.h"
#import "NSNumber+SM.h"
#import "KHHKeys.h"
#import "KHHTypes.h"
#import "KHHNotifications.h"

@implementation KHHNetworkAPIAgent (Account)
/**
 用户登录: 对应"accountService.login"
 @return: user或password为nil/@""返回NO。
 http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=173
 */
- (BOOL)login:(NSString *)user
     password:(NSString *)password {
    if (0 == [user length] || 0 == [password length]) {
        return NO;
    }
    NSString *action = @"login";
    NSString *pathRoot = @"registerOrLogin";
    NSString *query = @"accountService.login";
    NSString *encPass = [Encryptor encryptBase64String:password
                                             keyString:KHHHttpEncryptorKey];
    NSDictionary *parameters = @{
    @"loginType" : @"MOBILE",
    @"accountNo" : user,
    @"userPassword" : encPass
    };
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *op, id response) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:response];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:8];
        // 把 responseDict 的数据转成本地可用的数据
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        if (KHHErrorCodeSucceeded == code) {
            // 登录成功
            id obj = nil;
            // AuthorizationID number
            obj = [responseDict valueForKeyPath:JSONDataKeyID]; // string
            NSNumber *authorizationID = [NSNumber numberFromObject:obj zeroIfUnresolvable:YES];
            dict[kInfoKeyAuthorizationID] = authorizationID;
            // AutoReceive number
            obj = [responseDict valueForKeyPath:JSONDataKeyIsAutoReceive]; // string
            NSNumber *autoReceive = [NSNumber numberFromObject:obj defaultValue:1 defaultIfUnresolvable:YES];
            dict[kInfoKeyAutoReceive] = autoReceive;
            // CompanyID number
            obj = [responseDict valueForKeyPath:JSONDataKeyCompanyId];
            NSNumber *companyID = [NSNumber numberFromObject:obj zeroIfUnresolvable:YES];
            dict[kInfoKeyCompanyID] = companyID;
            // DepartmentID number
            obj = [responseDict valueForKeyPath:JSONDataKeyOrgId];
            NSNumber *departmentID = [NSNumber numberFromObject:obj zeroIfUnresolvable:YES];
            dict[kInfoKeyDepartmentID] = departmentID;
            // Permission string
            obj = [responseDict valueForKeyPath:JSONDataKeyPermissionName];
            NSString *permission = [NSString stringFromObject:obj];
            dict[kInfoKeyPermission] = permission;
        }
        
        dict[kInfoKeyErrorCode] = @(code);
        
        [self postASAPNotificationName:NameWithActionAndCode(action, code)
                                  info:dict];

    };
    [self postAction:action
            pathRoot:pathRoot
               query:query
          parameters:parameters
             success:success
             failure:nil
               extra:nil];
    return YES;
}

/**
 用户注册: 对应"accountService.registerAccount"
 accountNo 	 String 	 是 	 账号（手机号）
 userPassword 	 String 	 是 	 密码
 userName 	 String 	 否 	 用户名
 companyName 	 String 	 否 公司名 传此参数表示注册的用户为公司董事长）
 inviteCode 	 String 	 否 	 公司邀请码
 http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=172
 */
- (void)createAccount:(NSDictionary *)accountDict {
    NSString *action   = @"createAccount";
    NSString *pathRoot = @"registerOrLogin";
    NSString *query    = @"accountService.registerAccountNew";
    NSString *user     = accountDict[kAccountKeyUser];
    NSString *password = accountDict[kAccountKeyPassword];
    if (0 == user.length || 0 == password.length) {
        WarnParametersNotMeetRequirement(action);
    }
    NSString *encPass = [Encryptor encryptBase64String:password
                                             keyString:KHHHttpEncryptorKey];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{
                                       @"accountNo" : user,
                                       @"userPassword" : encPass
                                       }];
    NSString *userName = accountDict[kAccountKeyName];
    if (userName.length) parameters[@"userName"] = userName;
    NSString *company = accountDict[kAccountKeyCompany];
    if (company.length) parameters[@"companyName"] = company;
    NSString *invitation = accountDict[kAccountKeyInvitationCode];
    if (invitation.length) parameters[@"inviteCode"] = invitation;
    
    // 处理返回数据的block
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *op, id response) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:response];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:8];
        // 把 responseDict 的数据转成本地可用的数据
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        if (KHHErrorCodeSucceeded == code) {
            // 注册成功
            // AuthorizationID
            NSNumber *authorizationID = [NSNumber numberFromObject:responseDict[JSONDataKeyID]
                                                zeroIfUnresolvable:YES];
            dict[kInfoKeyAuthorizationID] = authorizationID;
        }
        dict[kInfoKeyErrorCode] = @(code);
        
        [self postASAPNotificationName:NameWithActionAndCode(action, code)
                                  info:dict];
    };
    [self postAction:action
            pathRoot:pathRoot
               query:query
          parameters:parameters
             success:success
             failure:nil
               extra:nil];
}
/**
 修改密码: 对应"userPasswordService.updatePwd"
 @return: oldPassword或newPassword为nil/@""返回NO。
 http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=176
 */
- (BOOL)changePassword:(NSString *)oldPassword
         toNewPassword:(NSString *)newPassword {
    if (0 == [oldPassword length] || 0 == [newPassword length]) {
        //oldPassword或newPassword为nil/@""
        return NO;
    }
    NSString *encOld = [Encryptor encryptBase64String:oldPassword
                                            keyString:KHHHttpEncryptorKey];
    NSString *encNew = [Encryptor encryptBase64String:newPassword
                                            keyString:KHHHttpEncryptorKey];
    NSDictionary *parameters = @{
    @"oldPassword" : encOld,
    @"newPassword" : encNew
    };
    [self postAction:@"changePassword"
               query:@"userPasswordService.updatePwd"
          parameters:parameters
             success:nil];
    return YES;
}

/**
 重置密码: 对应"userPasswordService.resetPwd"
 @return: mobile为nil或@""返回NO。
 http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=175
 */
- (BOOL)resetPassword:(NSString *)mobile {
    if (0 == mobile.length) {
        // mobile为nil或@""
        return NO;
    }
    NSDictionary *parameters = @{
    @"mobile" : mobile
    };
    [self postAction:@"resetPassword"
            pathRoot:@"registerOrLogin"
               query:@"userPasswordService.resetPwd"
          parameters:parameters
             success:nil
             failure:nil
               extra:nil];
    return YES;
}

/**
 设置是否自动接收名片 userPasswordService.autoReceive
 http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=186
 */
- (void)markAutoReceive:(BOOL)autoReceive {
    NSDictionary *parameters = @{
    @"isAutoReceive" : autoReceive? @"yes": @"no"
    };
    [self postAction:@"markAutoReceive"
               query:@"userPasswordService.autoReceive"
          parameters:parameters
             success:nil];
}
@end
