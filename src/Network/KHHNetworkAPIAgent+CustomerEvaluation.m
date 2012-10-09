//
//  KHHNetworkAPIAgent+CustomerEvaluation.m
//  CardBook
//
//  Created by Sun Ming on 12-10-9.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHNetworkAPIAgent+CustomerEvaluation.h"

@implementation KHHNetworkAPIAgent (CustomerEvaluation)
/**
 客户评估信息增量接口 customerAppraiseService.synCustomerAppraise
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=209
 */
- (void)customerEvaluationListAfterDate:(NSString *)lastDate
                                  extra:(NSDictionary *)extra {
    NSString *action = @"customerEvaluationListAfterDate";
    NSDictionary *parameters = @{
    @"lastUpdTime" : [lastDate length] > 0? lastDate: @""
    };
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *op, id response) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:response];
        DLog(@"[II] response keys = %@", [responseDict allKeys]);
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:8];
        
        // 把返回的数据转成本地数据
        KHHNetworkStatusCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        if (KHHNetworkStatusCodeSucceeded == code) {
            // count
            dict[kInfoKeyCount] = responseDict[JSONDataKeyCount];
            
            // synTime -> syncTime
            NSString *syncTime = responseDict[JSONDataKeySynTime];
            dict[kInfoKeySyncTime] = syncTime? syncTime: @"";
            
            // customerAppraise -> customerEvaluationList
//            NSArray *oldList = responseDict[JSONDataKeyPlanList];
//            dict[kInfoKeyVisitScheduleList] = oldList;
        }
        
        // errorCode 和 extra
        dict[kInfoKeyErrorCode] = @(code);
        dict[kInfoKeyExtra] = extra;
        // 把处理完的数据发出去。
        [self postASAPNotificationName:NameWithActionAndCode(action, code)
                                  info:dict];
    };
    [self postAction:action
               query:@"customerAppraiseService.synCustomerAppraise"
          parameters:parameters
             success:success
               extra:extra];
}
@end
