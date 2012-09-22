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
    [self postAction:@"login"
            pathRoot:@"registerOrLogin"
               query:@"accountService.login"
          parameters:parameters];
    return YES;
}
- (void)loginResultCode:(KHHNetworkStatusCode)code
                   info:(NSDictionary *)jsonDict {
    
    NSString *name = (KHHNetworkStatusCodeSucceeded == code)?
                        KHHNotificationLoginSucceeded
                        : KHHNotificationLoginFailed;
    // 把返回的json dictionary转换成本地数据类型。
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:8];
    if (KHHNetworkStatusCodeSucceeded == code) {
        // 登录成功
        id obj = nil;
        NSNumber *number = nil;
        NSString *string = nil;
        // AuthorizationID number
        obj = [jsonDict valueForKeyPath:JSONDataKeyID]; // string
        number = [NSNumber numberFromObject:obj zeroIfUnresolvable:YES];
        [dict setObject:number forKey:kInfoKeyAuthorizationID];
        // AutoReceive number
        obj = [jsonDict valueForKeyPath:JSONDataKeyIsAutoReceive]; // string
        number = (nil == obj || obj == [NSNull null])? [NSNumber numberWithBool:YES]
                : [NSNumber numberFromObject:obj zeroIfUnresolvable:YES];
        [dict setObject:number forKey:kInfoKeyAutoReceive];
        // CompanyID number
        obj = [jsonDict valueForKeyPath:JSONDataKeyCompanyId];
        number = [NSNumber numberFromObject:obj zeroIfUnresolvable:YES];
        [dict setObject:number forKey:kInfoKeyCompanyID];
        // DepartmentID number
        obj = [jsonDict valueForKeyPath:JSONDataKeyOrgId];
        number = [NSNumber numberFromObject:obj zeroIfUnresolvable:YES];
        [dict setObject:number forKey:kInfoKeyDepartmentID];
        // Permission string
        obj = [jsonDict valueForKeyPath:JSONDataKeyPermissionName];
        string = [NSString stringFromObject:obj];
        [dict setObject:string forKey:kInfoKeyPermission];
    } else {
        // 登录失败
    }
    [dict setObject:@(code) forKey:kInfoKeyErrorCode];
    [self postNotification:name
                      info:dict];
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
        [self postAction:@"createAccount"
                pathRoot:@"registerOrLogin"
                   query:@"accountService.registerAccount"
              parameters:parameters];
        return YES;
    }
    return NO;
}
- (void)createAccountResultCode:(KHHNetworkStatusCode)code
                           info:(NSDictionary *)jsonDict {
    NSString *name = (KHHNetworkStatusCodeSucceeded == code)?
                        KHHNotificationCreateAccountSucceeded
                        : KHHNotificationCreateAccountFailed;
    
    // 把返回的json dictionary转换成本地数据类型。
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:8];
    if (KHHNetworkStatusCodeSucceeded == code) {
        // 注册成功
        id obj = nil;
        NSNumber *number = nil;
//        NSString *string = nil;
        // AuthorizationID
        obj = [jsonDict valueForKeyPath:JSONDataKeyID]; // string
        number = [NSNumber numberFromObject:obj zeroIfUnresolvable:YES];
        [dict setObject:number forKey:kInfoKeyAuthorizationID];
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
    } else {
        // 注册失败
    }
    [dict setObject:@(code) forKey:kInfoKeyErrorCode];
    [self postNotification:name
                      info:dict];
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
          parameters:parameters];
    return YES;
}
//- (void)changePasswordResultCode:(KHHNetworkStatusCode)code
//                                 json:(NSDictionary *)jsonDict {
//    NSString *name = (KHHNetworkStatusCodeSucceeded == code)?
//    KHHNotificationChangePasswordSucceeded
//    : KHHNotificationChangePasswordFailed;
//    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:jsonDict];
//    [dict setObject:[NSNumber numberWithInteger:code] forKey:kInfoKeyErrorCode];
//    
//    [self postNotification:name info:dict];
//}

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
          parameters:parameters];
    return YES;
}
//- (void)resetPasswordResultCode:(KHHNetworkStatusCode)code
//                                json:(NSDictionary *)jsonDict {
//    NSString *name = (KHHNetworkStatusCodeSucceeded == code)?
//    KHHNotificationResetPasswordSucceeded
//    : KHHNotificationResetPasswordFailed;
//    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:jsonDict];
//    [dict setObject:[NSNumber numberWithInteger:code] forKey:kInfoKeyErrorCode];
//    
//    [self postNotification:name info:dict];
//}

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
          parameters:parameters];
}
//- (void)markAutoReceiveResultCode:(KHHNetworkStatusCode)code
//                                  json:(NSDictionary *)jsonDict {
//    NSString *name = (KHHNetworkStatusCodeSucceeded == code)?
//    KHHNotificationMarkAutoReceiveSucceeded
//    : KHHNotificationMarkAutoReceiveFailed;
//    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:jsonDict];
//    [dict setObject:[NSNumber numberWithInteger:code] forKey:kInfoKeyErrorCode];
//    
//    [self postNotification:name info:dict];
//}
@end
