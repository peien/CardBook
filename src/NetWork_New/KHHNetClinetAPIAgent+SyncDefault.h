//
//  KHHNetClinetAPIAgent+SyncDefault.h
//  CardBook
//
//  Created by CJK on 13-1-30.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent.h"
#import "KHHNetAgentSyncDefaultDelegate.h"

@interface KHHNetClinetAPIAgent (SyncDefault)

- (void)syncDefault:(NSString *)lastDate delegate:(id<KHHNetAgentSyncDefaultDelegate>) delegate;

@end
