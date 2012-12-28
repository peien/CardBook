//
//  KHHNetworkAPIAgent.m
//  CardBook
//
//  Created by 孙铭 on 8/22/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgent.h"
#import "KHHTypes.h"
#import "KHHStatusCodes.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import "NSString+MD5.h"
#import "NSString+Networking.h"


@implementation KHHNetworkAPIAgent
/**
 登录成功后，一定要调用这个设置authentication。
 */
- (BOOL)authenticateWithUser:(NSString *)fakeID
                      password:(NSString *)password {
    if (0 == [fakeID length] || 0 == [password length]) {
        return NO;
    }
    [[KHHHTTPClient sharedClient] setAuthorizationHeaderWithUsername:fakeID
                                                            password:password];
    return YES;
}
#pragma mark - 发请求
- (void)postAction:(NSString *)action
             query:(NSString *)query
        parameters:(NSDictionary *)parameters {
    [self postAction:action
               query:query
          parameters:parameters
             success:nil];
}
// 发请求，默认 pathRoot 为 @"rest"，extra 为 nil；
- (void)postAction:(NSString *)action
             query:(NSString *)query
        parameters:(NSDictionary *)parameters
           success:(KHHSuccessBlock)success {
    [self postAction:action
               query:query
          parameters:parameters
             success:success
               extra:nil];
}
// 发请求，默认pathRoot为@"rest"
- (void)postAction:(NSString *)action
             query:(NSString *)query
        parameters:(NSDictionary *)parameters
           success:(KHHSuccessBlock)success
             extra:(NSDictionary *)extra {
    [self postAction:action
            pathRoot:@"rest"
               query:query
          parameters:parameters
             success:success
             failure:nil
               extra:extra];
}
// 发请求
- (void)postAction:(NSString *)action
          pathRoot:(NSString *)pathRoot
             query:(NSString *)query
        parameters:(NSDictionary *)parameters
           success:(KHHSuccessBlock)success
           failure:(KHHFailureBlock)failure
             extra:(NSDictionary *)extra {
    [self postAction:action
            pathRoot:pathRoot
               query:query
          parameters:parameters
    constructingBody:nil
             success:success
             failure:failure
               extra:extra];
}
- (void)postAction:(NSString *)action
             query:(NSString *)query
        parameters:(NSDictionary *)parameters
  constructingBody:(KHHConstructionBlock)construction
           success:(KHHSuccessBlock)success {
    [self postAction:action
            pathRoot:@"rest"
               query:query
          parameters:parameters
    constructingBody:construction
             success:success
             failure:nil
               extra:nil];
}
- (void)postAction:(NSString *)action
          pathRoot:(NSString *)pathRoot
             query:(NSString *)query
        parameters:(NSDictionary *)parameters
  constructingBody:(KHHConstructionBlock)construction
           success:(KHHSuccessBlock)success
           failure:(KHHFailureBlock)failure
             extra:(NSDictionary *)extra {
    // 创建请求
    KHHHTTPClient *httpClient = [KHHHTTPClient sharedClient];
        
    // 处理成功的请求
    KHHSuccessBlock successBlock = success? success:
    ^(AFHTTPRequestOperation *operation, id responseObject) {
        [self defaultSuccessProcessWithAction:action
                                        extra:extra
                                 responseData:responseObject];
    };
    // 处理失败的请求
    KHHFailureBlock failureBlock = failure? failure:
    ^(AFHTTPRequestOperation *operation, NSError *error) {
        [self defaultFailureProcessWithAction:action
                                        extra:extra
                                        error:error];
    };
    
    //网络不可用的时候直接返回错误信息
    AFNetworkReachabilityStatus state = [httpClient networkReachabilityStatus];
    if (AFNetworkReachabilityStatusNotReachable == state || AFNetworkReachabilityStatusUnknown == state) {
        NSError *failed = [[NSError alloc] initWithDomain:@"网络不可用,不能进行操作!" code:KHHErrorCodeConnectionOffline userInfo:nil];
        failureBlock(nil,failed);
        return;
    }

    
    // 组合query url
    NSDictionary *queryDict = @{ @"method" : query };
    NSString *path = [NSString stringWithFormat:@"%@?%@",
                      pathRoot,
                      [self queryStringWithDictionary:queryDict]];
    DLog(@"path%@",path);
    
    NSURLRequest *request = [httpClient
                             multipartFormRequestWithMethod:@"POST"
                             path:path
                             parameters:parameters
                             constructingBodyWithBlock:construction];
    AFHTTPRequestOperation *reqOperation = [httpClient
                                            HTTPRequestOperationWithRequest:request
                                            success:successBlock
                                            failure:failureBlock];
    // 实际发送请求
    [httpClient enqueueHTTPRequestOperation:reqOperation];
}
#pragma mark - Utils
- (NSString *)queryStringWithDictionary:(NSDictionary *)aDictionary {
    
    NSMutableDictionary *queryDict = [NSMutableDictionary dictionaryWithDictionary:aDictionary];
    
    // timestamp
    NSString *timestamp = [[[NSNumber numberWithDouble:(1000.0 * [[NSDate date] timeIntervalSince1970])]
                            stringValue] stringByDeletingPathExtension];//毫秒
    [queryDict setObject:timestamp forKey:@"timestamp"];
    
    // format
    [queryDict setObject:KHHJSONFormat forKey:@"format"];
    
    // sign
    NSString *signature = [self signatureWithDictionary:queryDict];
    [queryDict setObject:signature forKey:@"sign"];
    
    //
    NSString *result = [@"" stringByAppendingQueryParameters:queryDict];
    DLog(@"[II] query = %@", result);
    return result;
}
- (NSString *)signatureWithDictionary:(NSDictionary *)aDictionary {
    NSArray *keys=[[aDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSMutableString *result = [NSMutableString stringWithString:KHHHttpSignatureKey];
    for (NSString *key in keys) {
        [result appendString:key];
        [result appendString:[aDictionary objectForKey:key]];
    }
    [result appendString:KHHHttpSignatureKey];
    return [result MD5];
}
- (NSMutableDictionary *)JSONDictionaryWithResponse:(NSData *)responseData {
    ALog(@"[II] responseData -> JSON dictionary");
    NSString *base64 = [[NSString alloc] initWithBytes:[responseData bytes]
                                                length:[responseData length]
                                              encoding:NSASCIIStringEncoding];
    NSData *decodedData = [NSData dataWithBase64EncodedString:base64];
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:decodedData
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil];
    NSMutableDictionary *result = dict[JSONDataKeyJSONData];
    NSNumber *state = result[JSONDataKeyState];
    NSInteger code = KHHErrorCodeUnresolvableData;
    if (result) {
        if (state) {
            code = state.integerValue;
        } else {
            code = KHHErrorCodeUnknownError;
        }
    } else {
        // 确保返回的 result 不是nil
        result = [NSMutableDictionary dictionaryWithCapacity:2];
    }
    // 根据状态，插入errorCode
    result[kInfoKeyErrorCode] = [NSNumber numberWithInteger:code];
    DLog(@"[II] result class = %@, value = %@", [result class], result);
    return result;
}
/*!
 根据 Action 和 Status Code 生成 Notification Name。
 KHHErrorCodeSucceeded 返回 action＋Succeeded
 其他返回action＋Failed
 */
NSString *NameWithActionAndCode(NSString *action, KHHErrorCode code) {
    NSString *suffix = (KHHErrorCodeSucceeded == code)?@"Succeeded":@"Failed";
    if ([action isEqualToString:kActionNetworkSendCardToPhone]
        && 1 == code) {
        suffix = @"Succeeded";
    }
    NSString *name = [NSString stringWithFormat:@"%@%@", action, suffix];
    ALog(@"[II] Notification name = %@", name);
    return name;
}
/*!
 根据 Action 和 Status Code 生成 提示消息。
 */
NSString *MessageWithActionAndCode(KHHErrorCode code, NSString *errorMessage) {
    NSString *message = @"";
    switch (code) {
        case KHHErrorCodeSucceeded: {
            message = NSLocalizedString(@"成功。", nil);
            break;
        }
        case KHHErrorCodeFailed: {
            message = NSLocalizedString(@"请检查您输入的数据。", nil);
            break;
        }
        case KHHErrorCodeDataServerError: {
            message = NSLocalizedString(@"服务器出错，请稍后再试。", nil);
            break;
        }
        case KHHErrorCodeAlreadyCreated: {
            message = NSLocalizedString(@"该手机号已被注册，请检查。若确实输入正确，请联络客服。", nil);
            break;
        }
        case KHHErrorCodeAccountExpired: {
            message = NSLocalizedString(@"该帐户已过期，请重新激活。", nil);
            break;
        }
        case KHHErrorCodeExceedRetryLimit: {
            message = NSLocalizedString(@"操作过于频繁，请一小时后再试。", nil);
            break;
        }
        case KHHErrorCodeCompanyAlreadyExist: {
            message = NSLocalizedString(@"该公司名已被注册，请检查公司名是否正确。若确实输入正确，请联络客服。", nil);
            break;
        }
        case KHHErrorCodeDuplication: {
            message = NSLocalizedString(@"请勿重复注册。", nil);
            break;
        }
        case KHHErrorCodeOldPasswordWrong: {
            message = NSLocalizedString(@"旧密码错误，请重新输入。", nil);
            break;
        }
        case KHHErrorCodeLatitudeOrLongitudeWrong: {
            message = NSLocalizedString(@"经纬度数据有误，请重试。", nil);
            break;
        }
        case KHHErrorCodeNoneCounterpartCard: {
            message = NSLocalizedString(@"未发现正在与您交换的名片。", nil);
            break;
        }
        case KHHErrorCodeSomethingWrong: {
            message = NSLocalizedString(@"身份验证出错。请登出，再登入。", nil);
            break;
        }
        case KHHErrorCodeUnresolvableData: {
            message = NSLocalizedString(@"网络传回的数据无法识别，请检查您的网络设置，然后重试。", nil);
            break;
        }
        case KHHErrorCodeConnectionOffline: {
            message = NSLocalizedString(@"网络断了，请检查网络设置。", nil);
            break;
        }
        case KHHErrorCode404: {
            message = NSLocalizedString(@"服务器出错，请稍后再试。", nil);
            break;
        }
        case KHHErrorCodeLocalDataOperationFailed: {
            message = NSLocalizedString(@"本地数据库出错。若多次出现此错误，请删除本应用然后重新安装。", nil);
            break;
        }
        case KHHErrorCodeBusy: {
            message = NSLocalizedString(@"前一个操作尚未完成，请稍后再试。", nil);
            break;
        }
        case KHHErrorCodeParametersNotMeetRequirement: {
            message = NSLocalizedString(@"输入的数据不符合要求。", nil);
            break;
        }
        default: {
            message = errorMessage.length? errorMessage: @"发生未知错误，请稍后再试。";
            break;
        }
    }
    return message;
}
/*!
 根据 Action 发 notification，提醒参数错误。
 返回action＋Failed。
 */
void WarnParametersNotMeetRequirement(NSString *action) {
    KHHErrorCode errCode = KHHErrorCodeParametersNotMeetRequirement;
    NSString *errMessage = NSLocalizedString(@"参数不满足要求！", nil);
    NSNotificationCenter *dc = [NSNotificationCenter defaultCenter];
    [dc postASAPNotificationName:NameWithActionAndCode(action, errCode)
                            info:@{ kInfoKeyErrorMessage : errMessage, kInfoKeyErrorCode : @(errCode) }];
}

/*!
 默认的成功处理流程
 */
- (void)defaultSuccessProcessWithAction:(NSString *)action
                                  extra:(id)extra
                           responseData:(id)responseData {
    ALog(@"[II] 缺少处理 %@ 返回结果的 successBlock！", action);
    ALog(@"[II] 进入默认模式:");
    // 把返回的 NSData 转成 NSDictionary
    NSMutableDictionary *dict = [self JSONDictionaryWithResponse:responseData];
    KHHErrorCode code = [dict[kInfoKeyErrorCode] integerValue];
    // 把extra也一并返回
    if (extra) {
        dict[kInfoKeyExtra] = extra;
    }
    NSString *name = NameWithActionAndCode(action, code);
    ALog(@"[II] 发送 %@ 消息。", name);
    [self postNowNotificationName:name
                             info:dict];
}
/*!
 默认的失败处理流程
 */
- (void)defaultFailureProcessWithAction:(NSString *)action
                                  extra:(id)extra
                                  error:(NSError *)error {
    DLog(@"[II] action = %@\n error = %@", action, error);
    NSString *name = [NSString stringWithFormat:@"%@Failed", action];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
    dict[kInfoKeyAction] = action;
    dict[kInfoKeyErrorCode] = @(error.code);
    dict[kInfoKeyErrorMessage] = error.localizedDescription;
    // 把extra也一并返回
    if (extra) {
        dict[kInfoKeyExtra] = extra;
    }
    [self postASAPNotificationName:name
                              info:dict];
}
@end
