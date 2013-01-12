//
//  KHHNetClinetAPIAgent+Template.m
//  CardBook
//
//  Created by 王定方 on 13-1-10.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent+Template.h"

@implementation KHHNetClinetAPIAgent (Template)
/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=234
 * 模板增量接口
 * 方法 get
 */
- (void)syncTemplatesAfterDate:(NSString *)lastDate delegate:(id<KHHNetAgentTemplateDelegates>) delegate
{
    //网络状态
    if (![self networkStateIsValid]) {
        if ([delegate respondsToSelector:@selector(syncTemplateFailed:)]) {
            NSDictionary * dict = [self networkUnableFailedResponseDictionary];
            [delegate syncTemplateFailed:dict];
        }
        
        return;
    }
    
    //lastDate为空时表示拿全部数据，这里就没有无效参数判断
    NSString *pathFormat = @"temlate/sync/%@";
    NSString *path = [NSString stringWithFormat:pathFormat,lastDate ? lastDate : @""];
    
    //成功block
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        // 把返回的数据转成本地数据
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
        //成功失败标记
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        dict[kInfoKeyErrorCode] = @(code);
        if (KHHErrorCodeSucceeded == code) {
            // count
            dict[kInfoKeyCount] = responseDict[JSONDataKeyCount];
            
            // synTime -> syncTime
            NSString *syncTime = responseDict[JSONDataKeySynTime];
            dict[kInfoKeySyncTime] = syncTime? syncTime: @"";
            
            // templatelist -> templatelist
            NSArray *oldList = responseDict[JSONDataKeyTemplateList];
            dict[kInfoKeyTemplateList] = oldList;
            
            //同步成功,返回数据到data层保存数据
            if ([delegate respondsToSelector:@selector(syncTemplateSuccess:)]) {
                [delegate syncTemplateSuccess:dict];
            }
        }else {
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //同步失败
            if ([delegate respondsToSelector:@selector(syncTemplateFailed:)]) {
                [delegate syncTemplateFailed:dict];
            }
        }
    };
    
    //其它失败的block
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"syncTemplateFailed:"];
    
    //发送请求
    [self getPath:path parameters:nil success:success failure:failed];
}
@end
