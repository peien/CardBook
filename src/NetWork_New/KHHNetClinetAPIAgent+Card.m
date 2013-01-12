//
//  KHHNetClinetAPIAgent+Card.m
//  CardBook
//
//  Created by CJK on 13-1-12.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent+Card.h"
#import "Card.h"

@implementation KHHNetClinetAPIAgent (Card)

#pragma mark - 名片查询---同步;
- (void)syncCard:(NSString *)lastDate delegate:(id<KHHNetAgentCardDelegate>) delegate
{
    
    if (![self networkStateIsValid]) {
        if ([delegate respondsToSelector:@selector(syncVisitScheduleFailed:)]) {
            NSDictionary * dict = [self networkUnableFailedResponseDictionary];
            [delegate syncCardFailed:dict];
        }
        return;
    }
    //url format
    NSString *path = @"visitPlan/sync";
    if (path.length > 0) {
        //以前同步过
        path = [NSString stringWithFormat:@"%@/%@", path, lastDate];
    }
    
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *op, id response) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:response];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
        
        // 把返回的数据转成本地数据
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        // errorCode
        dict[kInfoKeyErrorCode] = @(code);
        if (KHHErrorCodeSucceeded == code) {
            // count
            dict[kInfoKeyCount] = responseDict[JSONDataKeyCount];
            
            // synTime -> syncTime
            NSString *syncTime = responseDict[JSONDataKeySynTime];
            dict[kInfoKeySyncTime] = syncTime? syncTime: @"";
            
            // planList -> visitScheduleList
            NSArray *planList = responseDict[JSONDataKeyPlanList];
            NSMutableArray *newList = [NSMutableArray arrayWithCapacity:planList.count];
            for (id obj in planList) {
                Card *iSchedule = [[[Card alloc] init] updateWithJSON:obj];
                DLog(@"[II] iSchedule = %@", iSchedule);
                [newList addObject:iSchedule];
            }
            dict[kInfoKeyObjectList] = newList;
            
            //同步成功,把解析后的数据传出，上层去保存数据
            if ([delegate respondsToSelector:@selector(syncVisitScheduleSuccess:)]) {
                [delegate syncCardSuccess:dict];
            }
        }else {
            //错误码
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //同步失败，返回错误信息
            if ([delegate respondsToSelector:@selector(syncVisitScheduleFailed:)]) {
                [delegate syncCardFailed:dict];
            }
        }
    };
    
    //其它失败的block
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"syncVisitScheduleFailed:"];
    
    //发送请求
    [self getPath:path parameters:nil success:success failure:failed];
    
}

#pragma mark - 名片新增
- (void)addCard:(Card *)card delegate:(id<KHHNetAgentCardDelegate>) delegate
{

}

#pragma mark - 名片删除
- (void)deleteCard:(Card *)card delegate:(id<KHHNetAgentCardDelegate>) delegate
{

}

#pragma mark - 名片编辑
- (void)updateCard:(Card *)card delegate:(id<KHHNetAgentCardDelegate>) delegate
{
    
}

@end
