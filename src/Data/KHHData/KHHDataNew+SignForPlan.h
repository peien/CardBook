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
@end
