//
//  KHHNetClinetAPIAgent+SyncContact.h
//  CardBook
//
//  Created by CJK on 13-2-1.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent.h"
#import "KHHNetAgentSyncContactDelegate.h"

@interface KHHNetClinetAPIAgent (SyncContact)

- (void)syncContact:(NSString *)lastDate lastCardId:(NSString *)lastCardId delegate:(id<KHHNetAgentSyncContactDelegate>) delegate;

- (void)touchCardForPushMsg:(NSString *)cardId delegate:(id<KHHNetAgentSyncContactDelegate>) delegate;

- (void)deleteContact:(NSString *)contactId delegate:(id<KHHNetAgentSyncContactDelegate>) delegate;

- (void)syncMycard:(id<KHHNetAgentSyncContactDelegate>) delegate;


@end
