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
 @warning: 此处不对user和password进行有效性检查。
 http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=173
 */
- (BOOL)login:(NSString *)user
     password:(NSString *)password {
    if (0 == [user length] || 0 == [password length]) {
        return NO;
    }
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
        
        NSString *noti = (KHHNetworkStatusCodeSucceeded == code)?
        KHHNetworkLoginSucceeded
        : KHHNetworkLoginFailed;
        [self postASAPNotificationName:noti info:dict];

    };
    [self postAction:@"login"
            pathRoot:@"registerOrLogin"
               query:@"accountService.login"
          parameters:parameters
             success:success
               extra:nil];
    return YES;
}

/**
 用户注册: 对应"accountService.registerAccount"
 @warning: 此处不对account和password进行有效性检查。
 http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=172
 */
- (BOOL)createAccount:(NSString *)account
             password:(NSString *)password {
    if (account.length > 0 && password.length > 0) {
        NSString *encPass = [Encryptor encryptBase64String:password
                                                 keyString:KHHHttpEncryptorKey];
        NSDictionary *parameters = @{
        @"accountNo" : account,
        @"userPassword" : encPass
        };
        
        // 返回数据的处理block
        KHHSuccessBlock success = ^(AFHTTPRequestOperation *op, id response) {
            NSDictionary *responseDict = [self JSONDictionaryWithResponse:response];
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:8];
            // 把 responseDict 的数据转成本地可用的数据
            KHHNetworkStatusCode code = [responseDict[kInfoKeyErrorCode] integerValue];
            if (KHHNetworkStatusCodeSucceeded == code) {
                // 注册成功
                id obj = nil;
                // AuthorizationID
                obj = [responseDict valueForKeyPath:JSONDataKeyID]; // string
                NSNumber *authorizationID = [NSNumber numberFromObject:obj zeroIfUnresolvable:YES];
                dict[kInfoKeyAuthorizationID] = authorizationID;
                //        // 补齐数据结构
                //        // AutoReceive
                //        obj = [jsonDict valueForKeyPath:JSONDataKeyIsAutoReceive]; // string
                //        number = (nil == obj || obj == [NSNull null] || [@"yes" isEqualToString:obj])?[NSNumber numberWithBool:YES]:[NSNumber numberWithBool:NO];
                //        [dict setObject:number forKey:kInfoKeyAutoReceive];
                //        // CompanyID
                //        obj = [jsonDict valueForKeyPath:JSONDataKeyCompanyId];
                //        number = (nil == obj || obj == [NSNull null])?[NSNumber numberWithInteger:0]:obj;
                //        [dict setObject:number forKey:kInfoKeyCompanyID];
                //        // DepartmentID
                //        obj = [jsonDict valueForKeyPath:JSONDataKeyOrgId];
                //        number = (nil == obj || obj == [NSNull null])?[NSNumber numberWithInteger:0]:obj;
                //        [dict setObject:number forKey:kInfoKeyDepartmentID];
                //        // Permission
                //        obj = [jsonDict valueForKeyPath:JSONDataKeyPermissionName];
                //        string = (nil == obj || obj == [NSNull null])?@"":obj;
                //        [dict setObject:string forKey:kInfoKeyPermission];
            } 
            
            dict[kInfoKeyErrorCode] = @(code);
            
            NSString *noti = (KHHNetworkStatusCodeSucceeded == code)?
            KHHNetworkCreateAccountSucceeded
            : KHHNotificationCreateAccountFailed;
            [self postASAPNotificationName:noti info:dict];
        };
        [self postAction:@"createAccount"
                pathRoot:@"registerOrLogin"
                   query:@"accountService.registerAccount"
              parameters:parameters
                 success:success
                   extra:nil];
        return YES;
    }
    return NO;
}
/**
 修改密码: 对应"userPasswordService.updatePwd"
 @warning: 此处不对oldPassword和newPassword进行有效性检查。
 http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=176
 */
- (BOOL)changePassword:(NSString *)oldPassword
         toNewPassword:(NSString *)newPassword {
    if (0 == [oldPassword length] || 0 == [newPassword length]) {
        //oldPassword或newPassword为nil／@“”
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
 @warning: 此处不对mobile进行有效性检查。
 http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=175
 */
- (BOOL)resetPasswordWithMobileNumber:(NSString *)mobile {
    if (0 == mobile.length) {
        // mobile为nil或@“”
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
