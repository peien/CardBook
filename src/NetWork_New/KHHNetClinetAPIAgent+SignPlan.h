//
//  KHHNetClinetAPIAgent+SignPlan.h
//  CardBook
//
//  Created by CJK on 13-1-23.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent.h"
#import "KHHNetAgentSignPlanDelegate.h"
#import "InterPlan.h"

@interface KHHNetClinetAPIAgent (SignPlan)
- (void)addPlan:(InterPlan *) iPlan delegate:(id<KHHNetAgentSignPlanDelegate>) delegate;
- (void)syncPlan:(NSString *)lastDate delegate:(id<KHHNetAgentSignPlanDelegate>) delegate;
@end
