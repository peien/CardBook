//
//  KHHNetClinetAPIAgent+Login.m
//  CardBook
//
//  Created by CJK on 13-1-14.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent+Login.h"
#import "KHHUser.h"

@implementation KHHNetClinetAPIAgent (Login)

- (void)login:(NSString *)username password:(NSString *)password delegate:(id<KHHNetAgentLoginDelegate>)delegate
{
    if (0 == [username length] || 0 == [password length]) {
        return;
    }
    if (![self networkStateIsValid:delegate selector:@"loginFailed:"]) {
        return;
    }
       
    //url
    NSString *path = @"login";
    
    //服务器有返回值
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        DLog(@"[II] response = %@", responseDict);
        // 把返回的数据转成本地数据
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
        // errorCode
        dict[kInfoKeyErrorCode] = @(code);
        if (KHHErrorCodeSucceeded == code) {
            [[KHHUser shareInstance]fromJsonData:dict];
                [delegate loginSuccess:dict];
            
        }else {
            //错误信息
           
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //同步失败，返回失败信息
            if ([delegate respondsToSelector:@selector(loginFailed:)]) {
                [delegate loginFailed:dict];
            }
        }
    };
    
    //其他错误返回
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"loginFailed:"];
    
    //调接口
    [self postPath:path parameters:nil success:success failure:failed];
  
}

@end
