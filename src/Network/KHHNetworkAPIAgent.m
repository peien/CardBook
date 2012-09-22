//
//  KHHNetworkAPIAgent.m
//  CardBook
//
//  Created by 孙铭 on 8/22/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgent.h"
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
// 简便模式
- (void)postAction:(NSString *)action
             query:(NSString *)query
        parameters:(NSDictionary *)parameters {
    //
    [self postAction:action
            pathRoot:@"rest"
               query:query
          parameters:parameters];
}
// 带pathRoot的模式
- (void)postAction:(NSString *)action
          pathRoot:(NSString *)pathRoot
             query:(NSString *)query
        parameters:(NSDictionary *)parameters {
    // 调完全体
    [self postAction:action
               extra:nil
            pathRoot:pathRoot
               query:query
          parameters:parameters];
}
// 带条件的模式
- (void)postAction:(NSString *)action
             extra:(NSDictionary *)extra
             query:(NSString *)query
        parameters:(NSDictionary *)parameters {
    // 调完全体
    [self postAction:action
               extra:extra
            pathRoot:@"rest"
               query:query
          parameters:parameters];
}

// 完全体
- (void)postAction:(NSString *)action
             extra:(NSDictionary *)extra
          pathRoot:(NSString *)pathRoot
             query:(NSString *)query
        parameters:(NSDictionary *)parameters{
    
    NSMutableString *path = [NSMutableString stringWithString:pathRoot];
    NSDictionary *queries = @{ @"method" : query };
    [path appendFormat:@"?%@",[self queryStringWithDictionary:queries]];
    
    [[KHHHTTPClient sharedClient] postPath:path
                                parameters:parameters
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       // HTTP request 成功
                                       NSMutableDictionary *jsonData = [self resultDictionaryFromResponse:responseObject];
                                       NSMutableDictionary *dict = [jsonData objectForKey:JSONDataKeyJSONData];
                                       NSNumber *state = [dict valueForKey:JSONDataKeyState];
                                       NSInteger code = KHHNetworkStatusCodeUnresolvableData;
                                       if (dict) {
                                           if (state) {
                                               code = state.integerValue;
                                               [dict removeObjectForKey:JSONDataKeyState];
                                               [dict removeObjectForKey:JSONDataKeyNote];
                                           } else {
                                               code = KHHNetworkStatusCodeUnknownError;
                                           }
                                       } else {
                                           // 确保返回的dict不是nil
                                           dict = [NSMutableDictionary dictionaryWithCapacity:2];
                                       }
                                       // 把code返回
                                       dict[kInfoKeyErrorCode] = [NSNumber numberWithInteger:code];
                                       // 把extra也一并返回
                                       if (extra) {
                                           dict[kInfoKeyExtra] = extra;
                                       }
                                       
                                       SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", action, @"ResultCode:info:"]);
                                       if ([self respondsToSelector:selector]) {
                                           NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
                                           [inv setTarget:self];
                                           [inv setSelector:selector];
                                           [inv setArgument:&code atIndex:2];
                                           [inv setArgument:&dict atIndex:3];
                                           [inv invoke];
                                       } else {
                                           ALog(@"[II] 缺少处理返回结果的方法 %@%@", action, @"ResultCode:info:");
                                           ALog(@"[II] 进入默认模式:");
                                           NSString *name = (KHHNetworkStatusCodeSucceeded == code)?
                                                            [NSString stringWithFormat:@"%@Succeeded", action]
                                                            : [NSString stringWithFormat:@"%@Failed", action];
                                           ALog(@"[II] 发送 %@ 消息。", name);
                                           [self postNotification:name info:dict];
                                       }
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
                                       [self postNotification:name info:dict];
                                   }];
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
    DLog(@"[II] result = %@", result);
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
- (NSMutableDictionary *)resultDictionaryFromResponse:(NSData *)responseData {
    DLog(@"[II] response data = %@", responseData);
    NSString *base64 = [[NSString alloc] initWithBytes:[responseData bytes]
                                                length:[responseData length]
                                              encoding:NSASCIIStringEncoding];
    DLog(@"[II] base64 string = %@", base64);
    NSString *json = [base64 base64DecodedString];
    DLog(@"[II] json Decoded from base64 = %@", json);
    NSMutableDictionary *result = [json JSONValue];
    DLog(@"[II] result class = %@, value = %@", [result class], result);
    return result;
}
@end
