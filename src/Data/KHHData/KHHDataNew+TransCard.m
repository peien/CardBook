//
//  KHHDataNew+TransCard.m
//  CardBook
//
//  Created by CJK on 13-1-31.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew+TransCard.h"
#import "ContactCard.h"
@implementation KHHDataNew (TransCard)

#pragma mark - rebateCard
- (void)doRebateCard:(NSString *)receiverId cardId:(NSString *)cardId cardType:(KHHCardModelType)cardType delegate:(id<KHHDataTransCardDelegate>)delegate
{
    self.delegate = delegate;
    
    [self.agent rebateCard:receiverId cardId:cardId cardType:cardType delegate:self];
    
    
}

- (void)rebateCardSuccess:(NSDictionary *)dict
{
    [self.delegate rebateCardForUISuccess];
}


- (void)rebateCardFailed:(NSDictionary *)dict
{
    [self.delegate rebateCardForUIFailed:dict];
}

#pragma mark - sendToPhone

- (void)doSendByPhone:(NSArray *)receiverMobiles cardId:(NSString *)cardId delegate:(id<KHHDataTransCardDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent sendByPhone:receiverMobiles cardId:cardId delegate:self];
}

- (void)sendByPhoneSuccess:(NSDictionary *)dict
{
    [self.delegate sendByPhoneForUISuccess];
}


- (void)sendByPhoneFailed:(NSDictionary *)dict
{
    [self.delegate sendByPhoneForUIFailed:dict];
}

#pragma mark - exchange

- (void)doExchange:(InterShake *)iShake delegate:(id<KHHDataTransCardDelegate>)delegate
{
    self.delegate = delegate;
    [self.agent exchange:iShake delegate:self];
    
}

- (void)exchangeFailed:(NSDictionary *)dict
{
    [self.delegate exchangeForUIFailed:dict];
}

- (void)exchangeSuccess:(NSDictionary *)dict
{
    [self.delegate exchangeForUISuccess];
}

#pragma mark - exchange doReceive
- (void)doReceiveForExchange:(id<KHHDataTransCardDelegate>)delegate
{
    self.delegate = delegate;
    [self.agent receiveLastCostomer:self];
}

- (void)receiveLastCostomerSuccess:(NSDictionary *)dict
{
    NSMutableDictionary *dictPro = [[NSMutableDictionary alloc]initWithCapacity:1];
    dictPro[@"receivedCard"] = [ContactCard processIObject:[InterCard interCardWithReceivedCardJSON:dict[@"cardBookVo"][@"card"]]];
    [self saveContext];
    [self.delegate receiveLastCostomerForUISuccess:dictPro];
}

- (void)receiveLastCostomerFailed:(NSDictionary *)dict
{
    [self.delegate receiveLastCostomerForUIFailed:dict];
}

@end
