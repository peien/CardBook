//
//  KHHDataNew+SignForPlan.h
//  CardBook
//
//  Created by CJK on 13-1-21.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew.h"
#import "KHHDataSignPlanDelegate.h"
#import "InterPlan.h"
#import "KHHNetClinetAPIAgent+SignPlan.h"
#import "Card.h"

typedef enum {
    KHHVisitScheduleSyncTypeAdd = 1,
    KHHVisitScheduleSyncTypeUpdate,
    KHHVisitScheduleSyncTypeDelete,
    KHHVisitScheduleSyncTypeSync,
}   KHHVisitScheduleSyncType;

@interface KHHDataNew (SignForPlan)<KHHNetAgentSignPlanDelegate>
- (void)doSign;
- (void)doAddPlan:(InterPlan *)iPlan delegate:(id<KHHDataSignPlanDelegate>) delegate;
- (void)doSyncPlan:(KHHVisitScheduleSyncType)syncType;

#pragma mark - for ui
- (NSInteger)countOfUnfinishedSchedulesOnCard:(Card *)aCard day:(NSString *)aDay;
#pragma mark - 我拜访别人的纪录
- (NSArray *)allSchedules;
- (NSArray *)executingSchedules;
- (NSArray *)overdueSchedules;
- (NSArray *)finishedSchedules;
- (NSArray *)schedulesOnCard:(Card *)aCard day:(NSString *)aDay;// 结果是从day开始一天内的所有schedule。
- (NSArray *)schedulesOnCard:(Card *)aCard date:(NSDate *)aDate;// 结果是从day开始一天内的所有
@end
