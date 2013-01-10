//
//  NetClient+Account.m
//  CardBook
//
//  Created by 王定方 on 13-1-9.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "NetClient+Account.h"
#import "Encryptor.h"
#import "NSString+SM.h"
#import "NSNumber+SM.h"
#import "KHHKeys.h"
#import "KHHTypes.h"

@implementation NetClient (Account)
/*
 * 用户登录
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=230
 * 方法 post
 */
- (BOOL) login:(NSString *)user password:(NSString *)password delegate:(id<KHHNetClientAccountDelegates>) delegate
{
    if (0 == [user length] || 0 == [password length]) {
        return NO;
    }
    
    NSString *path = @"login";
    NSString *encPass = [Encryptor encryptBase64String:password
                                             keyString:KHHHttpEncryptorKey];
    NSDictionary *parameters = @{
        @"username" : user,
        @"password" : encPass
    };
    
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *op, id response) {
        //解析json
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:response];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:8];
        // 把 responseDict 的数据转成本地可用的数据
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        //error code
        dict[kInfoKeyErrorCode] = @(code);
        if (KHHErrorCodeSucceeded == code) {
            // 登录成功 把要保存的保存到某个地方
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
            //companyName
            obj = [responseDict valueForKeyPath:JSONDataKeyCompanyName];
            NSString *companyName = [NSString stringFromObject:obj];
            dict[kInfoKeyCompanyName] = companyName;
            
            // DepartmentID number
            obj = [responseDict valueForKeyPath:JSONDataKeyOrgId];
            NSNumber *departmentID = [NSNumber numberFromObject:obj zeroIfUnresolvable:YES];
            dict[kInfoKeyDepartmentID] = departmentID;
            // Permission string
            obj = [responseDict valueForKeyPath:JSONDataKeyPermissionName];
            NSString *permission = [NSString stringFromObject:obj];
            dict[kInfoKeyPermission] = permission;
            
            //session id
            obj = [responseDict valueForKeyPath:JSONDataKeySessionID];
            NSString *sessionID = [NSString stringFromObject:obj];
            dict[kInfoKeySessionID] = sessionID;
            
            //登录成功
            if ([delegate respondsToSelector:@selector(loginSuccess:)]) {
                [delegate loginSuccess:dict];
            }
        }else{
            //不为0时表示失败，返回失败信息
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            if ([delegate respondsToSelector:@selector(loginFailed:)]) {
                [delegate loginFailed:dict];
            }
        }
    };
    
    //请求失败
//    KHHFailureBlock failed = ^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSDictionary *dict = [self defaultFailedResponseDictionary:error];
//        //登录失败
//        if ([delegate respondsToSelector:@selector(loginFailed:)]) {
//            [delegate loginSuccess:dict];
//        }
//    };
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"loginFailed:"];
    //发送网络请求
    [self postPath:path parameters:parameters success:success failure:failed];
    return YES;
}

/*
 * 用户注册
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=231
 * 方法 post
 */
- (void)createAccount:(NSDictionary *)accountDict delegate:(id<KHHNetClientAccountDelegates>) delegate
{
    NSString *path     = @"register";
    NSString *user     = accountDict[kAccountKeyUser];
    NSString *password = accountDict[kAccountKeyPassword];
    NSString *userName = accountDict[kAccountKeyName];
    if (0 == user.length || 0 == password.length || 0 == userName.length) {
        //无效参数
        if ([delegate respondsToSelector:@selector(createAccountFailed:)]) {
            NSDictionary *dict = [self parametersNotMeetRequirementFailedResponseDictionary];
            [delegate createAccountFailed:dict];
        }
        return;
    }
    
    //密码加密
    NSString *encPass = [Encryptor encryptBase64String:password
                                             keyString:KHHHttpEncryptorKey];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:@{
                                       @"username" : user,
                                       @"password" : encPass,
                                       @"trueName" : userName
                                       }];
    
    //公司名
    NSString *company = accountDict[kAccountKeyCompany];
    if (company.length) parameters[@"companyName"] = company;
    
    // 处理返回数据的block
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *op, id response) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:response];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
        // 把 responseDict 的数据转成本地可用的数据
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        //成功失败标记
        dict[kInfoKeyErrorCode] = @(code);
        if (KHHErrorCodeSucceeded == code) {
            // 注册成功
            // AuthorizationID
            NSNumber *authorizationID = [NSNumber numberFromObject:responseDict[JSONDataKeyID]
                                                zeroIfUnresolvable:YES];
            dict[kInfoKeyAuthorizationID] = authorizationID;
            
            //联网操作成功
            if ([delegate respondsToSelector:@selector(createAccountSuccess:)]) {
                [delegate createAccountSuccess:dict];
            }
        }else {
            //操作失败
            //错误信息
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            if ([delegate respondsToSelector:@selector(createAccountFailed:)]) {
                [delegate createAccountFailed:dict];
            }
        }
        
    };
    
    //请求失败
//    KHHFailureBlock failed = ^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSDictionary *dict = [self defaultFailedResponseDictionary:error];
//        //登录失败
//        if ([delegate respondsToSelector:@selector(createAccountFailed:)]) {
//            [delegate createAccountFailed:dict];
//        }
//    };
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"createAccountFailed:"];
    //网络请求
    [self postPath:path parameters:parameters success:success failure:failed];
}

/*
 * 用户修改密码
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=232
 * 方法 put
 * 参数 passwd/{oldPassword}/{newPassword}
 */
- (BOOL)changePassword:(NSString *)oldPassword toNewPassword:(NSString *)newPassword delegate:(id<KHHNetClientAccountDelegates>) delegate
{
    if (0 == [oldPassword length] || 0 == [newPassword length]) {
        //无效参数
        if ([delegate respondsToSelector:@selector(changePasswordFailed:)]) {
            NSDictionary *dict = [self parametersNotMeetRequirementFailedResponseDictionary];
            [delegate changePasswordFailed:dict];
        }
        return NO;
    }
    
    //密码加密
    NSString *encOld = [Encryptor encryptBase64String:oldPassword
                                            keyString:KHHHttpEncryptorKey];
    NSString *encNew = [Encryptor encryptBase64String:newPassword
                                            keyString:KHHHttpEncryptorKey];
    //url拼装格式
    NSString *urlFormat = @"passwd/%@/%@";
    NSString *path = [NSString stringWithFormat:urlFormat,encOld,encNew];
    // 处理返回数据的block
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *op, id response) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:response];
        // 把 responseDict 的数据转成本地可用的数据
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        if (KHHErrorCodeSucceeded == code) {
            //操作成功
            if ([delegate respondsToSelector:@selector(changePasswordSuccess)]) {
                [delegate changePasswordSuccess];
            }
        }else {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
            //改密码失败标记
            dict[kInfoKeyErrorCode] = @(code);
            //错误代码
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //操作失败
            if ([delegate respondsToSelector:@selector(changePasswordFailed:)]) {
                [delegate changePasswordFailed:dict];
            }
        }
        
    };
    
    //其它操作失败block
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"changePasswordFailed:"];
    
    //联网操作
    [self putPath:path parameters:nil success:success failure:failed];
    return YES;
}

/*
 * 用户重置密码
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=233
 * 方法 get
 */
- (BOOL)resetPassword:(NSString *)mobile delegate:(id<KHHNetClientAccountDelegates>) delegate
{
    if (0 == mobile.length) {
        // mobile为nil或@""
        //无效参数
        if ([delegate respondsToSelector:@selector(resetPasswordFailed:)]) {
            NSDictionary *dict = [self parametersNotMeetRequirementFailedResponseDictionary];
            [delegate resetPasswordFailed:dict];
        }
        return NO;
    }
    
    //重置密码的url格式
    NSString *pathFormat = @"passwd/reset/%@";
    NSString *path = [NSString stringWithFormat:pathFormat, mobile];
    // 处理返回数据的block
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *op, id response) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:response];
        // 把 responseDict 的数据转成本地可用的数据
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        if (KHHErrorCodeSucceeded == code) {
            // 重置成功
            if ([delegate respondsToSelector:@selector(resetPasswordSuccess)]) {
                [delegate resetPasswordSuccess];
            }
        }else {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];    
            //失败标记
            dict[kInfoKeyErrorCode] = @(code);
            //错误代码
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //操作失败
            if ([delegate respondsToSelector:@selector(resetPasswordFailed:)]) {
                [delegate resetPasswordFailed:dict];
            }
        }
    };
    
    //其它操作失败block
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"resetPasswordFailed:"];
    
    [self getPath:path parameters:nil success:success failure:failed];
    return YES;
}
@end
