//
//  KHHDataNew+SignForPlan.m
//  CardBook
//
//  Created by CJK on 13-1-21.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew+SignForPlan.h"
#import "Schedule.h"
#import "NSObject+SM.h"


@implementation KHHDataNew (SignForPlan)

#pragma mark - do sign
- (void)doSign
{}

#pragma mark - do add plan
- (void)doAddPlan:(InterPlan *)iPlan delegate:(id<KHHDataSignPlanDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent addPlan:iPlan delegate:self];
}

- (void)addPlanSuccess:(NSDictionary *)dict
{
    [self doSyncPlan:KHHPlanSyncTypeAdd];
   
}

- (void)addPlanFailed:(NSDictionary *)dict
{
    [self.delegate addPlanForUIFailed:dict];
}

- (void)doSyncPlan:(KHHPlanSyncType)syncType
{
    self.syncType = syncType;
    SyncMark *syncMark = [SyncMark syncMarkByKey:kSyncMarkKeySyncPlanLastTime];
    
    [self.agent syncPlan:syncMark.value delegate:self];
}

#pragma mark - do update plan
- (void)doUpdatePlan:(InterPlan *)iPlan delegate:(id<KHHDataSignPlanDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent updatePlan:iPlan delegate:self];
}

- (void)updatePlanSuccess
{
    [self doSyncPlan:KHHPlanSyncTypeUpdate];
    
}

- (void)updatePlanFailed:(NSDictionary *)dict
{
    [self.delegate updatePlanForUIFailed:dict];
}


#pragma mark - sync

- (void)syncPlanSuccess:(NSDictionary *)dict
{
    NSArray *list = dict[kInfoKeyObjectList];
    [Schedule processIObjectList:list];
    // 2.Timestamp
    [SyncMark UpdateKey:kSyncMarkKeySyncPlanLastTime
                  value:[NSString stringWithFormat:@"%@",dict[kInfoKeySyncTime]]];
    // 3.保存
    [self saveContext];
    
    if (self.syncType == KHHPlanSyncTypeAdd) {
         [self.delegate addPlanForUISuccess];
    }
    if (self.syncType == KHHPlanSyncTypeUpdate) {
        [self.delegate updatePlanForUISuccess];
    }
    if (self.syncType == KHHPlanSyncTypeDeleteImg) {
        [self.delegate deletePlanImgForUISuccess];
    }
    if (self.syncType == KHHPlanSyncTypeAddImg) {
        [self.delegate addPlanImgForUISuccess];
    }
    if (self.syncType == KHHPlanSyncTypeSync) {
        [self.delegate syncPlanForUISuccess];
    }
}

- (void)syncPlanFailed:(NSDictionary *)dict
{
    if (self.syncType == KHHPlanSyncTypeAdd) {
        [self.delegate addPlanForUIFailed:dict];
    }
    
    if (self.syncType == KHHPlanSyncTypeSync) {
        [self.delegate syncPlanForUIFailed:dict];
    }
}

#pragma mark - do img
- (void)doDeleteImg:(NSString *)planId attachmentId:(NSString *)attachmentId delegate:(id<KHHDataSignPlanDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent deleteImg:planId attachmentId:attachmentId delegate:self];
}

- (void)deletePlanImgSuccess
{
    [self doSyncPlan:KHHPlanSyncTypeDeleteImg];
}

- (void)deletePlanImgFailed:(NSDictionary *)dict
{
    [self.delegate deletePlanImgForUIFailed:dict];
}

- (void)doAddImg:(NSString *)planId image:(UIImage *)image  delegate:(id<KHHDataSignPlanDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent addImg:planId image:image delegate:self];
}

- (void)addPlanImgSuccess
{
    [self doSyncPlan:KHHPlanSyncTypeAddImg];
    
}

- (void)addPlanImgFailed:(NSDictionary *)dict
{
    [self.delegate addPlanForUIFailed:dict];
}

#pragma mark - sync in managePage

- (void)syncPlan:(id<KHHDataSignPlanDelegate>)delegate
{
    self.delegate = delegate;
    [self doSyncPlan:KHHPlanSyncTypeSync];
}

#pragma mark - do Collect
- (void)doCollect
{}


#pragma mark - for ui

- (NSInteger)countOfUnfinishedSchedulesOnCard:(Card *)aCard day:(NSString *)aDay{
    NSDate *start = DateFromKHHDateString([aDay stringByAppendingString:@" 00:00:00"]);
    return [self countOfUnfinishedSchedulesOnCard:aCard date:start];
}
- (NSInteger)countOfUnfinishedSchedulesOnCard:(Card *)aCard date:(NSDate *)aDate {
    NSArray *list = [self schedulesOnCard:aCard date:aDate];
    if (0 == list.count) {
        return -1;
    }
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:list.count];
    for (Schedule *schdl in list) {
        if(schdl.isFinishedValue) continue;
        [result addObject:schdl];
    }
    return result.count;
}

- (NSArray *)schedulesOnCard:(Card *)aCard date:(NSDate *)aDate {
    NSDate *start = aDate;
    NSTimeInterval oneDay = 60 * 60 * 24;
    NSDate *end = [start dateByAddingTimeInterval:oneDay];
    NSPredicate *predicate;
    
    if (aCard) {
        predicate = [NSPredicate predicateWithFormat:@"plannedDate >= %@ && plannedDate < %@ && SOME targets.id == %@", start, end, aCard.id];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"plannedDate >= %@ && plannedDate < %@", start, end];
    }
    NSSortDescriptor *sortDes = [NSSortDescriptor sortDescriptorWithKey:@"id"
                                                              ascending:NO];
    NSArray *result = [Schedule objectArrayByPredicate:predicate
                                       sortDescriptors:@[sortDes]];
    return result;
}
@end
