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
- (void)addPlan:(InterPlan *)iPlan delegate:(id<KHHNetAgentSignPlanDelegate>) delegate;
- (void)updatePlan:(InterPlan *)iPlan delegate:(id<KHHNetAgentSignPlanDelegate>) delegate;
- (void)syncPlan:(NSString *)lastDate delegate:(id<KHHNetAgentSignPlanDelegate>) delegate;

- (void)deleteImg:(NSString *)planId attachmentId:(NSString *)attachmentId delegate:(id<KHHNetAgentSignPlanDelegate>) delegate;

- (void)addImg:(NSString *)planId image:(UIImage *)image delegate:(id<KHHNetAgentSignPlanDelegate>) delegate;

@end
