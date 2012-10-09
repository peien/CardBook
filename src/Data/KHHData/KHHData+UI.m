//
//  KHHData+UI.m
//  CardBook
//
//  Created by 孙铭 on 12-9-19.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHData+UI.h"

@implementation KHHData (UI)

@end

@implementation KHHData (UI_Card)

/*!
 MyCard: 我的名片
 */
// 所有 我自己的名片 MyCard 的数组
- (NSArray *)allMyCards {
    NSArray *result = [self allCardsOfType:KHHCardModelTypeMyCard];
    return result;
}
- (MyCard *)myCardByID:(NSNumber *)cardID {
    id result = [self cardOfType:KHHCardModelTypeMyCard byID:cardID];
    return result;
}
- (void)modifyMyCardWithInterCard:(InterCard *)iCard {
    [self modifyCardOfType:KHHCardModelTypeMyCard withInterCard:iCard];
}

/*!
 PrivateCard: 我自己创建的联系人, 即 PrivateCard 私有联系人
 */
- (NSArray *)allPrivateCards {
    NSArray *result = [self allCardsOfType:KHHCardModelTypePrivateCard];
    return result;
}
- (PrivateCard *)privateCardByID:(NSNumber *)cardID {
    id result = [self cardOfType:KHHCardModelTypePrivateCard byID:cardID];
    return result;
}
- (void)createPrivateCardWithInterCard:(InterCard *)iCard {
    [self createCardOfType:KHHCardModelTypePrivateCard withInterCard:iCard];
}
- (void)modifyPrivateCardWithInterCard:(InterCard *)iCard {
    [self modifyCardOfType:KHHCardModelTypePrivateCard withInterCard:iCard];
}
- (void)deletePrivateCardByID:(NSNumber *)cardID {
    [self deleteCardOfType:KHHCardModelTypePrivateCard byID:cardID];
}

/*!
 ReceivedCard: 收到的联系人, 即通常所说的“联系人”
 */
- (NSArray *)allReceivedCards {
    NSArray *result = [self allCardsOfType:KHHCardModelTypeReceivedCard];
    return result;
}
- (ReceivedCard *)receivedCardByID:(NSNumber *)cardID {
    id result = [self cardOfType:KHHCardModelTypeReceivedCard byID:cardID];
    return result;
}
- (void)deleteReceivedCardByID:(NSNumber *)cardID {
    NSArray *IDList = @[cardID];
    [self.agent deleteReceivedCards:IDList];
}

@end
@implementation KHHData (UI_VisitSchedule)

@end