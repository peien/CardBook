//
//  KHHDataNew+TransCard.h
//  CardBook
//
//  Created by CJK on 13-1-31.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew.h"
#import "KHHNetClinetAPIAgent+TransCard.h"


#import "KHHDataTransCardDelegate.h"

@interface KHHDataNew (TransCard)<KHHNetAgentTransCardDelegate>

- (void)doRebateCard:(NSString *)receiverId cardId:(NSString *)cardId cardType:(KHHCardModelType)cardType delegate:(id<KHHDataTransCardDelegate>) delegate;

- (void)doSendByPhone:(NSArray *)receiverMobiles cardId:(NSString *)cardId delegate:(id<KHHDataTransCardDelegate>) delegate;


#pragma mark - exchange steped

- (void)doExchange:(InterShake *)iShake delegate:(id<KHHDataTransCardDelegate>)delegate;

- (void)doReceiveForExchange:(id<KHHDataTransCardDelegate>)delegate;

@end
