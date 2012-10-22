//
//  KHHNetworkAPIAgent+VisitSchedule.m
//  CardBook
//
//  Created by 孙铭 on 8/29/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgent+VisitSchedule.h"
#import "Schedule.h"
#pragma mark - Schedule参数整理函数
BOOL ScheduleHasRequiredAttributes(Schedule *visitSchedule,
                                   KHHScheduleAttributeType attributes) {
    NSString *ID = [[visitSchedule valueForKey:kAttributeKeyID] stringValue];
    if ((attributes & KHHScheduleAttributeID) && ID.length == 0) {
        return NO;
    }
    return YES;
}
NSMutableDictionary * ParametersFromSchedule(Schedule *visitSchedule,
                                             KHHScheduleAttributeType attributes) {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    NSString *ID = [[visitSchedule valueForKey:kAttributeKeyID] stringValue];
    if ((attributes & KHHScheduleAttributeID)) {
        [result setObject:(ID.length > 0? ID: @"") forKey:kAttributeKeyID];
    }
    return result;
}
@implementation KHHNetworkAPIAgent (VisitSchedule)
/**
 新建拜访计划 kinghhVisitCustomPlanService.create
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=156
 */
- (BOOL)createVisitSchedule:(Schedule *)visitSchedule {
    
}

/**
 修改拜访计划 kinghhVisitCustomPlanService.update
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=158
 */
- (BOOL)updateVisitSchedule:(Schedule *)visitSchedule {
    
}

/**
 删除拜访计划 kinghhVisitCustomPlanService.delete
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=159
 */
- (BOOL)deleteVisitSchedule:(Schedule *)visitSchedule {
    
}

/**
 拜访计划增量 kinghhVisitCustomPlanService.incList
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=155
 */
- (void)visitSchedulesAfterDate:(NSString *)lastDate
                          queue:(NSArray *)queue {
    NSString *action = @"visitSchedulesAfterDate";
    NSDictionary *extra = @{ kExtraKeySyncQueue : (queue?queue:[NSArray array]) };
    
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *op, id response) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:response];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
        
        // 把返回的数据转成本地数据
        KHHNetworkStatusCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        if (KHHNetworkStatusCodeSucceeded == code) {
            // count
            dict[kInfoKeyCount] = responseDict[JSONDataKeyCount];
            
            // synTime -> syncTime
            NSString *syncTime = responseDict[JSONDataKeySynTime];
            dict[kInfoKeySyncTime] = syncTime? syncTime: @"";
            
            // planList -> visitScheduleList
            NSArray *planList = responseDict[JSONDataKeyPlanList];
            NSMutableArray *newList = [NSMutableArray arrayWithCapacity:planList.count];
            for (id obj in planList) {
                DLog(@"[II] obj keys = %@, obj = %@", [obj allKeys], obj);
                ISchedule *iSchedule = [[[ISchedule alloc] init] updateWithJSON:obj];
                DLog(@"[II] iSchedule = %@", iSchedule);
                [newList addObject:iSchedule];
            }
            dict[kInfoKeyObjectList] = newList;
        }
        
        // errorCode 和 extra
        dict[kInfoKeyErrorCode] = @(code);
        dict[kInfoKeyExtra] = extra;
        // 把处理完的数据发出去。
        [self postASAPNotificationName:NameWithActionAndCode(action, code)
                                  info:dict];
    };
    
    NSDictionary *parameters = @{
    @"lastUpdTime" : [lastDate length] > 0? lastDate: @""
    };
    [self postAction:action
               query:@"kinghhVisitCustomPlanService.incList"
          parameters:parameters
             success:success
               extra:extra];
}
/**
 上传拜访图片 kinghhVisitCustomPlanService.uploadImg
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=161
 */
- (BOOL)uploadImage:(NSString *)imgPath
   forVisitSchedule:(Schedule *)visitSchedule {
    if (!ScheduleHasRequiredAttributes(visitSchedule, KHHScheduleAttributeID)) {
        return NO;
    }
    NSString *standardizedPath = [imgPath stringByStandardizingPath];
    UIImage *img = [UIImage imageWithContentsOfFile:standardizedPath];
    if (nil == img) {
        return NO;
    }
    NSMutableDictionary *parameters = ParametersFromSchedule(visitSchedule, KHHScheduleAttributeID);
    [parameters setObject:img
                   forKey:@"imgs"];
    [self postAction:@"uploadImageForVisitSchedule"
               query:@"kinghhVisitCustomPlanService.uploadImg"
          parameters:parameters
             success:nil];
    return YES;
}
/**
 删除拜访图片 kinghhVisitCustomPlanService.delImg
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=160
 */
//- (BOOL)deleteImage:(NSString *)imgID
//  fromVisitSchedule:(Schedule *)visitSchedule {
//
//}
@end
