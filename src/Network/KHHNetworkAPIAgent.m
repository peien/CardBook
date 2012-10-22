//
//  KHHNetworkAPIAgent.m
//  CardBook
//
//  Created by 孙铭 on 8/22/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgent.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import "NSString+MD5.h"
#import "NSString+Networking.h"

@implementation KHHNetworkAPIAgent
/**
 登录成功后，一定要调用这个设置authentication。
 */
- (BOOL)authenticateWithFakeID:(NSString *)fakeID
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
    
    // 组合query url
    NSDictionary *queryDict = @{ @"method" : query };
    NSString *path = [NSString stringWithFormat:@"%@?%@",
                      pathRoot,
                      [self queryStringWithDictionary:queryDict]];
    
    // 创建请求
    KHHHTTPClient *httpClient = [KHHHTTPClient sharedClient];
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
    NSInteger code = KHHNetworkStatusCodeUnresolvableData;
    if (result) {
        if (state) {
            code = state.integerValue;
        } else {
            code = KHHNetworkStatusCodeUnknownError;
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
 KHHNetworkStatusCodeSucceeded 返回 action＋Succeeded
 其他返回action＋Failed
 */
NSString *NameWithActionAndCode(NSString *action, KHHNetworkStatusCode code) {
    NSString *suffix = (KHHNetworkStatusCodeSucceeded == code)?@"Succeeded":@"Failed";
    NSString *name = [NSString stringWithFormat:@"%@%@", action, suffix];
    ALog(@"[II] Notification name = %@", name);
    return name;
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
    KHHNetworkStatusCode code = [dict[kInfoKeyErrorCode] integerValue];
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
    dict[kInfoKeyError] = error.localizedDescription;
    // 把extra也一并返回
    if (extra) {
        dict[kInfoKeyExtra] = extra;
    }
    [self postASAPNotificationName:name
                              info:dict];
}
@end
