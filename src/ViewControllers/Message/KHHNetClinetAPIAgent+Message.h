//
//  KHHNetClinetAPIAgent+Message.h
//  CardBook
//
//  Created by CJK on 12-12-27.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent.h"
#import "MsgDelegates.h"
#import "Reachability.h"

@interface KHHNetClinetAPIAgent (Message)
- (void)doDeleteInEdit:(id<delegateMsgForRead>)delegate messages:(NSArray *)messages;
- (void)doDelete:(id<delegateMsgForRead>) delegate messages:(NSArray *)messages;
- (void)doReseaveMessage:(id<delegateMsgForMain>) delegate;

@end
