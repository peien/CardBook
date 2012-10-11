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
- (void)clearAuthorizationHeader {
    [[KHHHTTPClient sharedClient] clearAuthorizationHeader];
}
#pragma mark - 发请求
// 发请求，默认 pathRoot 为 @"rest"，extra 为 nil；
- (void)postAction:(NSString *)action
             query:(NSString *)query
        parameters:(NSDictionary *)parameters
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success {
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
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             extra:(NSDictionary *)extra {
    [self postAction:action
            pathRoot:@"rest"
               query:query
          parameters:parameters
             success:success
               extra:extra];
}
// 发请求
- (void)postAction:(NSString *)action
          pathRoot:(NSString *)pathRoot
             query:(NSString *)query
        parameters:(NSDictionary *)parameters
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             extra:(NSDictionary *)extra {
    // 组织 path
    NSMutableString *path = [NSMutableString stringWithString:pathRoot];
    NSDictionary *queries = @{ @"method" : query };
    [path appendFormat:@"?%@",[self queryStringWithDictionary:queries]];
    //
    KHHSuccessBlock successBlock;
    if (success) {
        successBlock = success;
    } else {
        successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
            ALog(@"[II] 缺少处理 %@ 返回结果的 successBlock！", action);
            ALog(@"[II] 进入默认模式:");
            // HTTP request 成功
            // 把返回的 NSData 转成 NSDictionary
            NSMutableDictionary *dict = [self JSONDictionaryWithResponse:responseObject];
            KHHNetworkStatusCode code = [dict[kInfoKeyErrorCode] integerValue];
            // 把extra也一并返回
            if (extra) {
                dict[kInfoKeyExtra] = extra;
            }
            NSString *name = NameWithActionAndCode(action, code);
            ALog(@"[II] 发送 %@ 消息。", name);
            [self postNowNotificationName:name info:dict];
        };
    }
    KHHFailureBlock failureBlock = ^(AFHTTPRequestOperation *operation, NSError *error) {
        // HTTP request 失败
        DLog(@"[II] action = %@\n operation = %@\n error = %@", action, operation, error);
        NSString *name = [NSString stringWithFormat:@"%@Failed", action];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
        dict[kInfoKeyErrorCode] = @(error.code);
        dict[kInfoKeyError] = error.localizedDescription;
        // 把extra也一并返回
        if (extra) {
            dict[kInfoKeyExtra] = extra;
        }
        [self postASAPNotificationName:name info:dict];
    };
    [[KHHHTTPClient sharedClient] postPath:path
                                parameters:parameters
                                   success:successBlock
                                   failure:failureBlock];
}
- (void)postAction:(NSString *)action
           request:(NSURLRequest *)request
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             extra:(NSDictionary *)extra {
    KHHHTTPClient *httpClient = [KHHHTTPClient sharedClient];
    KHHSuccessBlock successBlock;
    if (success) {
        successBlock = success;
    } else {
        successBlock = ^(AFHTTPRequestOperation *operation, id responseObject) {
            ALog(@"[II] 缺少处理 %@ 返回结果的 successBlock！", action);
            ALog(@"[II] 进入默认模式:");
            // HTTP request 成功
            // 把返回的 NSData 转成 NSDictionary
            NSMutableDictionary *dict = [self JSONDictionaryWithResponse:responseObject];
            KHHNetworkStatusCode code = [dict[kInfoKeyErrorCode] integerValue];
            // 把extra也一并返回
            if (extra) {
                dict[kInfoKeyExtra] = extra;
            }
            NSString *name = NameWithActionAndCode(action, code);
            ALog(@"[II] 发送 %@ 消息。", name);
            [self postNowNotificationName:name info:dict];
        };
    }
    KHHFailureBlock failureBlock = ^(AFHTTPRequestOperation *operation, NSError *error) {
        // HTTP request 失败
        DLog(@"[II] action = %@\n operation = %@\n error = %@", action, operation, error);
        NSString *name = [NSString stringWithFormat:@"%@Failed", action];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
        dict[kInfoKeyErrorCode] = @(error.code);
        dict[kInfoKeyError] = error.localizedDescription;
        // 把extra也一并返回
        if (extra) {
            dict[kInfoKeyExtra] = extra;
        }
        [self postASAPNotificationName:name info:dict];
    };
    AFHTTPRequestOperation *req = [httpClient HTTPRequestOperationWithRequest:request
                                                                      success:successBlock
                                                                      failure:failureBlock];
    [httpClient enqueueHTTPRequestOperation:req];
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
@end
