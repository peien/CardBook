//
//  KHHData+UI.h
//  CardBook
//
//  Created by 孙铭 on 12-9-19.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHData.h"

@interface KHHData (UI)

@end

@interface KHHData (Card)
/*!
 MyCard: 我的名片
 */
- (NSArray *)allMyCards; // 所有 我自己的名片 MyCard 的数组
- (MyCard *)myCardByID:(NSNumber *)cardID; // 根据ID读取
- (void)createMyCardWithDictionary:(NSDictionary *)dict;
- (void)modifyMyCardWithDictionary:(NSDictionary *)dict;
- (void)deleteMyCardByID:(NSNumber *)cardID;

/*!
 PrivateCard: 我自己创建的联系人, 即 PrivateCard 私有联系人
 */
- (NSArray *)allPrivateCards; // 所有 自己创建的联系人 PrivateCard 的数组
- (PrivateCard *)privateCardByID:(NSNumber *)cardID; // 根据ID读取
- (void)createPrivateCardWithDictionary:(NSDictionary *)dict;
- (void)modifyPrivateCardWithDictionary:(NSDictionary *)dict;
- (void)deletePrivateCardByID:(NSNumber *)cardID;

/*!
 ReceivedCard: 收到的联系人, 即通常所说的“联系人”
 */
- (NSArray *)allReceivedCards; // 所有 收到的联系人 ReceivedCard 的数组
- (ReceivedCard *)receivedCardByID:(NSNumber *)cardID; // 根据ID读取
- (void)createReceivedCardWithDictionary:(NSDictionary *)dict;
- (void)modifyReceivedCardWithDictionary:(NSDictionary *)dict;
- (void)deleteReceivedCardByID:(NSNumber *)cardID;

@end