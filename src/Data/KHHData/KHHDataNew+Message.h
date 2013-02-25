//
//  KHHData+Message.h
//  CardBook
//
//  Created by CJK on 13-1-12.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew.h"
#import "MsgDelegates.h"
#import "KHHNetClinetAPIAgent+Message.h"
#import "KHHDataMessageDelegate.h"

@interface KHHDataNew (Message)<KHHNetAgentMessageDelegate>

- (NSUInteger)countOfUnreadMessages;

#pragma mark - reseaveMsg
- (void)reseaveMsg:(id<KHHDataMessageDelegate>)delegate;

#pragma mark - allMessage
- (NSArray *)allMessages;

#pragma mark - setRead
- (void)setRead:(NSString *)messageId delegate:(id<KHHDataMessageDelegate>)delegate;

#pragma mark - true delete 
- (void)doDeleteMessage:(NSString *)messageId delegate:(id<KHHDataMessageDelegate>)delegate;

@end
