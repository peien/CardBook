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

#pragma mark - do plan
- (void)doAddPlan:(InterPlan *)iPlan delegate:(id<KHHDataSignPlanDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent addPlan:iPlan delegate:self];
}

- (void)addPlanSuccess:(NSDictionary *)dict
{
    [self doSyncPlan:KHHVisitScheduleSyncTypeAdd];
   
}

- (void)addPlanFailed:(NSDictionary *)dict
{
    [self.delegate addPlanForUIFailed:dict];
}

- (void)doSyncPlan:(KHHVisitScheduleSyncType)syncType
{
    self.syncType = syncType;
    SyncMark *syncMark = [SyncMark syncMarkByKey:kSyncMarkKeySyncPlanLastTime];
    
    [self.agent syncPlan:syncMark.value delegate:self];
}

- (void)syncPlanSuccess:(NSDictionary *)dict
{
    NSArray *list = dict[kInfoKeyObjectList];
    [Schedule processIObjectList:list];
    // 2.Timestamp
    [SyncMark UpdateKey:kSyncMarkKeySyncPlanLastTime
                  value:[self interval:dict[kInfoKeySyncTime]]];
    // 3.保存
    [self saveContext];
    
    if (self.syncType == KHHVisitScheduleSyncTypeAdd) {
         [self.delegate addPlanForUISuccess];
    }
}

- (void)syncPlanFailed:(NSDictionary *)dict
{
    if (self.syncType == KHHVisitScheduleSyncTypeAdd) {
        [self.delegate addPlanForUIFailed:dict];
    }
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
