//
//  KHHNetworkAPIAgent+Account.m
//  CardBook
//
//  Created by 孙铭 on 8/29/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgent+Account.h"
#import "Encryptor.h"
#import "NSString+SM.h"
#import "NSNumber+SM.h"

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
        KHHNetworkStatusCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        if (KHHNetworkStatusCodeSucceeded == code) {
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
 @return: account或password为nil/@""返回NO。
 http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=172
 */
- (BOOL)createAccount:(NSString *)account
             password:(NSString *)password {
    if (0 == account.length || 0 == password.length) {
        return NO;
    }
    NSString *action = @"createAccount";
    NSString *pathRoot = @"registerOrLogin";
    NSString *query = @"accountService.registerAccount";
    NSString *encPass = [Encryptor encryptBase64String:password
                                             keyString:KHHHttpEncryptorKey];
    NSDictionary *parameters = @{
    @"accountNo" : account,
    @"userPassword" : encPass
    };
    
    // 处理返回数据的block
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *op, id response) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:response];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:8];
        // 把 responseDict 的数据转成本地可用的数据
        KHHNetworkStatusCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        if (KHHNetworkStatusCodeSucceeded == code) {
            // 注册成功
            // AuthorizationID
            NSNumber *oldAuthID = responseDict[JSONDataKeyID]; // string
            NSNumber *authorizationID = [NSNumber numberFromObject:oldAuthID zeroIfUnresolvable:YES];
            dict[kInfoKeyAuthorizationID] = authorizationID;
#warning TODO
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
- (BOOL)resetPasswordWithMobileNumber:(NSString *)mobile {
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
