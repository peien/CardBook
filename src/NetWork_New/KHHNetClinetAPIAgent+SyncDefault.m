//
//  KHHNetClinetAPIAgent+SyncDefault.m
//  CardBook
//
//  Created by CJK on 13-1-30.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent+SyncDefault.h"

@implementation KHHNetClinetAPIAgent (SyncDefault)

- (void)syncDefault:(NSString *)lastDate delegate:(id<KHHNetAgentSyncDefaultDelegate>) delegate
{
    if (![self networkStateIsValid:delegate selector:@"syncDefaultFailed:"]) {
        return;
    }
    
    NSString *path =@"syncAllInfo/yes";
    if (lastDate.length > 0) {
        path = [NSString stringWithFormat:@"%@/%@",path,lastDate];
    }
    
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        DLog(@"[II] response = %@", responseDict);
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
        // 把返回的数据转成本地数据
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        // errorCode
        dict[kInfoKeyErrorCode] = @(code);
        
        if (KHHErrorCodeSucceeded == code) {
            // count
           // dict[kInfoKeyCount] = responseDict[JSONDataKeyCount];
            
            // synTime -> syncTime
            NSString *syncTime = responseDict[@"syncTime"];
            dict[kInfoKeySyncTime] = syncTime? syncTime: @"";
            dict[@"myCard"] = responseDict[@"myCard"];
            dict[@"templatelist"] = responseDict[@"templatelist"];
            dict[@"linkList"] = responseDict[@"linkList"];
            dict[@"companyLinkList"] = responseDict[@"companyLinkList"];
            
            //dict[@"customerAppraise"] = responseDict[@"customerAppraise"];
            
            if ([delegate respondsToSelector:@selector(syncDefaultSuccess:)]) {
                [delegate syncDefaultSuccess:dict];
            }
        }else {
            //错误信息
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //添加失败，返回失败信息
            if ([delegate respondsToSelector:@selector(syncDefaultFailed:)]) {
                [delegate syncDefaultFailed:dict];
            }
        }
    };
    
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"syncDefaultFailed:"];
    
    [self getPath:path parameters:nil success:success failure:failed];

}

@end
