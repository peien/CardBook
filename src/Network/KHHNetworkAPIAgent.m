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
#import "NSObject+Notification.h"

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
/**
 发请求的统一方法
 */
- (void)postAction:(NSString *)action
             query:(NSString *)query
        parameters:(NSDictionary *)parameters {
    [self postAction:action
            pathRoot:@"rest"
               query:query
          parameters:parameters];
}
- (void)postAction:(NSString *)action
          pathRoot:(NSString *)pathRoot
             query:(NSString *)query
        parameters:(NSDictionary *)parameters {
    NSMutableString *path = [NSMutableString stringWithString:pathRoot];
    NSDictionary *queries = @{ @"method" : query };
    [path appendFormat:@"?%@",[self queryStringWithDictionary:queries]];
    
    [[KHHHTTPClient sharedClient] postPath:path
                                parameters:parameters
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                       // HTTP request 成功
                                       NSDictionary *jsonData = [self resultDictionaryFromResponse:responseObject];
                                       NSDictionary *dict = [jsonData objectForKey:kJSONDataKeyJSONData];
                                       NSInteger code = KHHNetworkStatusCodeUnknownError;
                                       if (dict) {
                                           code = [[dict valueForKey:kJSONDataKeyState] integerValue];
                                       }
                                       
                                       SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@%@",
                                                                           action, @"SuccessWithCode:json:"]);
                                       if ([self respondsToSelector:selector]) {
                                           NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
                                           [inv setTarget:self];
                                           [inv setSelector:selector];
                                           [inv setArgument:&code atIndex:2];
                                           [inv setArgument:&dict atIndex:3];
                                           [inv invoke];
                                       } else {
                                           ALog(@"[II] 缺少处理返回结果的方法 %@%@", action, @"SuccessWithCode:json:");
                                           ALog(@"[II] 进入默认模式:");
                                           NSString *name = (KHHNetworkStatusCodeSucceeded == code)?
                                                            [NSString stringWithFormat:@"%@Succeeded", action]
                                                            : [NSString stringWithFormat:@"%@Failed", action];
                                           
                                           NSMutableDictionary *info = [NSMutableDictionary dictionaryWithDictionary:dict];
                                           [info setValue:[NSNumber numberWithInteger:code] forKey:kInfoKeyErrorCode];
                                           ALog(@"[II] 发送 %@ 消息。", name);
                                           [self postNotification:name
                                                             info:info];
                                       }
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       // HTTP request 失败
                                       DLog(@"[II] action = %@\n operation = %@\n error = %@", action, operation, error);
                                       NSString *name = [NSString stringWithFormat:@"%@Failed", action];
                                       NSDictionary *info = @{
                                                    kInfoKeyErrorCode : @(error.code),
                                                    kInfoKeyError : error.localizedDescription
                                       };
                                       [self postNotification:name
                                                         info:info];
                                   }];
}
- (NSDictionary *)resultDictionaryFromResponse:(id)responseObject {
//    DLog(@"[II] response class = %@\n data = %@", [responseObject class], responseObject);
    NSString *base64 = [NSString stringWithUTF8String:[[NSData dataWithData:responseObject] bytes]];
//    DLog(@"[II] base64 string = %@", base64);
    NSString *json = [base64 base64DecodedString];
//    DLog(@"[II] json Decoded from base64 = %@", json);
    NSDictionary *result = [json JSONValue];
    DLog(@"[II] result = %@", result);
    return result;
}
@end
