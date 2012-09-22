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

@implementation KHHData (Card)

/*!
 MyCard: 我的名片
 */
// 所有 我自己的名片 MyCard 的数组
- (NSArray *)allMyCards {
    NSArray *result = [self allCardsOfType:KHHCardModelTypeMyCard];
    return result;
}
- (MyCard *)myCardByID:(NSNumber *)cardID {
    MyCard *result = [self cardOfType:KHHCardModelTypeMyCard byID:cardID];
    return result;
}
- (void)createMyCardWithDictionary:(NSDictionary *)dict {
    [self createCardOfType:KHHCardModelTypeMyCard withDictionary:dict];
}
- (void)modifyMyCardWithDictionary:(NSDictionary *)dict {
    [self modifyCardOfType:KHHCardModelTypeMyCard withDictionary:dict];
}
- (void)deleteMyCardByID:(NSNumber *)cardID {
    [self deleteCardOfType:KHHCardModelTypeMyCard byID:cardID];
}

/*!
 PrivateCard: 我自己创建的联系人, 即 PrivateCard 私有联系人
 */
- (NSArray *)allPrivateCards {
    NSArray *result = [self allCardsOfType:KHHCardModelTypePrivateCard];
    return result;
}
- (PrivateCard *)privateCardByID:(NSNumber *)cardID {
    PrivateCard *result = [self cardOfType:KHHCardModelTypePrivateCard byID:cardID];
    return result;
}
- (void)createPrivateCardWithDictionary:(NSDictionary *)dict {
    [self createCardOfType:KHHCardModelTypePrivateCard withDictionary:dict];
}
- (void)modifyPrivateCardWithDictionary:(NSDictionary *)dict {
    [self modifyCardOfType:KHHCardModelTypePrivateCard withDictionary:dict];
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
    ReceivedCard *result = [self cardOfType:KHHCardModelTypeReceivedCard byID:cardID];
    return result;
}
- (void)createReceivedCardWithDictionary:(NSDictionary *)dict {
    [self createCardOfType:KHHCardModelTypeReceivedCard withDictionary:dict];
}
- (void)modifyReceivedCardWithDictionary:(NSDictionary *)dict {
    [self modifyCardOfType:KHHCardModelTypeReceivedCard withDictionary:dict];
}
- (void)deleteReceivedCardByID:(NSNumber *)cardID {
    [self deleteCardOfType:KHHCardModelTypeReceivedCard byID:cardID];
}

@end