//
//  KHHNetClinetAPIAgent+Exchange.m
//  CardBook
//
//  Created by 王定方 on 13-1-10.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent+Exchange.h"

@implementation KHHNetClinetAPIAgent (Exchange)
/**
 * 发送名片到手机 sendCardService.sendCard
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=235
 * 方法 put
 * 多介手机号时用";"隔开
 */
- (void)sendCard:(long) cardID version:(int) version toPhones:(NSString *) phoneNumbers delegate:(id<KHHNetAgentExchangeDelegates>) delegate
{
    //网络状态
    if (![self networkStateIsValid]) {
        if ([delegate respondsToSelector:@selector(sendCardToMobileFailed:)]) {
            NSDictionary * dict = [self networkUnableFailedResponseDictionary];
            [delegate sendCardToMobileFailed:dict];
        }
        
        return;
    }
    
    //检查参数
    if (cardID <= 0 || version < 0 || 0 == phoneNumbers.length) {
        if ([delegate respondsToSelector:@selector(sendCardToMobileFailed:)]) {
            NSDictionary * dict = [self parametersNotMeetRequirementFailedResponseDictionary];
            [delegate sendCardToMobileFailed:dict];
        }
        
        return;
    }
    
    //请求url的格式
    NSString *pathFormat = @"card/mobile/%ld/%d";
    NSString *path = [NSString stringWithFormat:pathFormat, cardID, version];
    
    //成功block
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        // 把返回的数据转成本地数据
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        //成功失败标记
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        if (KHHErrorCodeSucceeded == code) {
            //同步成功,返回数据到data层保存数据
            if ([delegate respondsToSelector:@selector(sendCardToMobileSuccess:)]) {
                [delegate sendCardToMobileSuccess];
            }
        }else {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
            //失败code号
            dict[kInfoKeyErrorCode] = @(code);    
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //同步失败
            if ([delegate respondsToSelector:@selector(sendCardToMobileFailed:)]) {
                [delegate sendCardToMobileFailed:dict];
            }
        }
    };
    
    //其它失败的block
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"sendCardToMobileFailed:"];
    
    //发送请求
    [self putPath:path parameters:nil success:success failure:failed];
}
@end
