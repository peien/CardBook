//
//  KHHDataNew+SyncContact.h
//  CardBook
//
//  Created by CJK on 13-2-1.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew.h"
#import "KHHDataSyncContactDelegate.h"
#import "KHHNetClinetAPIAgent+SyncContact.h"
#import "KHHDataTemplateDelegate.h"

typedef enum
{
    contactSyncTypeDelete,
    contactSyncTypeJust,
    
}contactSyncType;

@interface KHHDataNew (SyncContact)<KHHNetAgentSyncContactDelegate,KHHDataTemplateDelegate>

- (void)doSyncContact:(contactSyncType)contactSyncType delegate:(id<KHHDataSyncContactDelegate>) delegate;

- (void)doTouchCardForPushMsg:(NSString *)cardId delegate:(id<KHHDataSyncContactDelegate>) delegate;


- (void)doDeleteContact:(NSString *)contactId delegate:(id<KHHDataSyncContactDelegate>) delegate;

- (void)doSyncMycard:(id<KHHDataSyncContactDelegate>) delegate;

@end
