//
//  KHHNetClinetAPIAgent+Register.m
//  CardBook
//
//  Created by CJK on 13-1-15.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent+Register.h"
#import "KHHUser.h"

@implementation KHHNetClinetAPIAgent (Register)
    

- (void)regist:(NSString *)phone username:(NSString *)username  password:(NSString *)password companyName:(NSString *)companyName  delegate:(id<KHHNetAgentRegisterDelegate>)delegate
{
    if (0 == [username length] || 0 == [password length]) {
        return;
    }
    if (![self networkStateIsValid:delegate selector:@"registerFailed:"]) {
        return;
    }
    
    //url
    NSString *path = @"register";
    
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
            [[KHHUser shareInstance] fromJsonData:dict];
            [delegate registerSuccess:dict];
            
        }else {
            //错误信息
            
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //同步失败，返回失败信息
            if ([delegate respondsToSelector:@selector(registerFailed:)]) {
                [delegate registerFailed:dict];
            }
        }
    };
    
    //其他错误返回
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"registerFailed:"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithCapacity:4];
    dic[@"username"] = phone;
    dic[@"password"] = password;
    dic[@"trueName"] = username;
    if (companyName) {
        dic[@"companyName"] = companyName;
    }
        
    //调接口
    [self postPath:path parameters:dic success:success failure:failed];

}

@end
