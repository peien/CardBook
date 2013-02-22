//
//  KHHNetClinetAPIAgent+TransCard.h
//  CardBook
//
//  Created by CJK on 13-1-31.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent.h"
#import "KHHNetAgentTransCardDelegate.h"
#import "InterShake.h"


@interface KHHNetClinetAPIAgent (TransCard)

- (void)rebateCard:(NSString *)receiverId cardId:(NSString *)cardId cardType:(KHHCardModelType)cardType delegate:(id<KHHNetAgentTransCardDelegate>) delegate;

- (void)sendByPhone:(NSArray *)receiverMobiles cardId:(NSString *)cardId delegate:(id<KHHNetAgentTransCardDelegate>) delegate;

- (void)exchange:(InterShake *)iShake delegate:(id<KHHNetAgentTransCardDelegate>)delegate;
- (void)receiveLastCostomer:(id<KHHNetAgentTransCardDelegate>) delegate;

@end
