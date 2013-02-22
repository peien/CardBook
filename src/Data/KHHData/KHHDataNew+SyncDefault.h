//
//  KHHDataNew+SyncDefault.h
//  CardBook
//
//  Created by CJK on 13-1-30.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew.h"
#import "KHHNetAgentSyncDefaultDelegate.h"
#import "KHHNetClinetAPIAgent+SyncDefault.h"

#import "KHHDataSyncDefaultDelegate.h"

@interface KHHDataNew (SyncDefault)<KHHNetAgentSyncDefaultDelegate>

- (void)doSyncDefault:(id<KHHDataSyncDefaultDelegate>) delegate;

@end
