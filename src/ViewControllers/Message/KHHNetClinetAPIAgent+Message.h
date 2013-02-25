//
//  KHHNetClinetAPIAgent+Message.h
//  CardBook
//
//  Created by CJK on 12-12-27.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent.h"
#import "KHHNetAgentMessageDelegate.h"
#import "Reachability.h"

@interface KHHNetClinetAPIAgent (Message)
- (void)doDeleteInEdit:(id<KHHNetAgentMessageDelegate>)delegate messages:(NSArray *)messages;

- (void)reseaveMessage:(id<KHHNetAgentMessageDelegate>) delegate;

- (void)deleteMessage:(NSString *)messageId delegate:(id<KHHNetAgentMessageDelegate>) delegate;

@end
