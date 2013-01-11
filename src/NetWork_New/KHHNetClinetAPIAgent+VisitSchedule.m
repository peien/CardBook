//
//  KHHNetClinetAPIAgent+VisitSchedule.m
//  CardBook
//
//  Created by 王定方 on 13-1-11.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent+VisitSchedule.h"

@implementation KHHNetClinetAPIAgent (VisitSchedule)
/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=252
 * url  visitPlan/sync 查询所有
 *      visitPlan/sync/{timestamp} 查询某个时间点后面的数据
 * 方法  get
 */
-(void) syncVisitScheduleWithDate:(NSString *) lastDate delegate:(id<KHHNetAgentVisitScheduleDelegates>) delegate
{
    //网络状态
    if (![self networkStateIsValid]) {
        if ([delegate respondsToSelector:@selector(syncVisitScheduleFailed:)]) {
            NSDictionary * dict = [self networkUnableFailedResponseDictionary];
            [delegate syncVisitScheduleFailed:dict];
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
                ISchedule *iSchedule = [[[ISchedule alloc] init] updateWithJSON:obj];
                DLog(@"[II] iSchedule = %@", iSchedule);
                [newList addObject:iSchedule];
            }
            dict[kInfoKeyObjectList] = newList;
            
            //同步成功,把解析后的数据传出，上层去保存数据
            if ([delegate respondsToSelector:@selector(syncVisitScheduleSuccess:)]) {
                [delegate syncVisitScheduleSuccess:dict];
            }
        }else {
            //错误码
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //同步失败，返回错误信息
            if ([delegate respondsToSelector:@selector(syncVisitScheduleFailed:)]) {
                [delegate syncVisitScheduleFailed:dict];
            }
        }
    };
        
    //其它失败的block
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"syncVisitScheduleFailed:"];
    
    //发送请求
    [self getPath:path parameters:nil success:success failure:failed];
}

/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=253
 * url visitPlan
 * 方法  post
 */
-(void) addVisitSchedule:(ISchedule *) schedule cardID:(long) cardID delegate:(id<KHHNetAgentVisitScheduleDelegates>) delegate
{
    
}

/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=254
 * url visitPlan
 * 方法  put
 */
-(void) updateVisitSchedule:(ISchedule *) schedule delegate:(id<KHHNetAgentVisitScheduleDelegates>) delegate
{
    
}

/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=255
 * url visitPlan/{id}
 * 方法   delete
 */
-(void) deleteVisitScheduleByID:(long) scheduleID delegate:(id<KHHNetAgentVisitScheduleDelegates>) delegate
{
    
}
@end
