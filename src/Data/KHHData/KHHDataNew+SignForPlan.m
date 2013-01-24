//
//  KHHDataNew+SignForPlan.m
//  CardBook
//
//  Created by CJK on 13-1-21.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew+SignForPlan.h"
#import "Schedule.h"

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


@end
