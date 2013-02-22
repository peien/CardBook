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
    KHHPlanSyncTypeAdd = 1,
    KHHPlanSyncTypeUpdate,
    KHHPlanSyncTypeDelete,
    KHHPlanSyncTypeSync,
    KHHPlanSyncTypeAddImg,
    KHHPlanSyncTypeDeleteImg,
}   KHHPlanSyncType;

@interface KHHDataNew (SignForPlan)<KHHNetAgentSignPlanDelegate>

- (void)doAddPlan:(InterPlan *)iPlan delegate:(id<KHHDataSignPlanDelegate>) delegate;
- (void)doUpdatePlan:(InterPlan *)iPlan delegate:(id<KHHDataSignPlanDelegate>) delegate;
- (void)doSyncPlan:(KHHPlanSyncType)syncType;

- (void)doDeleteImg:(NSString *)planId attachmentId:(NSString *)attachmentId delegate:(id<KHHDataSignPlanDelegate>) delegate;
- (void)doAddImg:(NSString *)planId image:(UIImage *)image  delegate:(id<KHHDataSignPlanDelegate>) delegate;

#pragma mark - sync in managePage

- (void)syncPlan:(id<KHHDataSignPlanDelegate>)delegate;

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
