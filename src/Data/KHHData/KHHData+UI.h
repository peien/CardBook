//
//  KHHData+UI.h
//  CardBook
//
//  Created by 孙铭 on 12-9-19.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHData.h"
#import "KHHClasses.h"
#import "InterCard.h"


@interface KHHData (UI)

@end

@interface KHHData (UI_Card)
/*!
 交换名片后取最新一张名片
 */
- (void)pullLatestReceivedCard;

#pragma mark - MyCard: 我的名片
- (NSArray *)allMyCards; // 所有 我自己的名片 MyCard 的数组
- (MyCard *)myCardByID:(NSNumber *)cardID; // 根据ID查询
- (void)modifyMyCardWithInterCard:(InterCard *)iCard;

#pragma mark - PrivateCard: 我自己创建的联系人, 即 PrivateCard 私有联系人
- (NSArray *)allPrivateCards; // 所有 自己创建的联系人 PrivateCard 的数组
- (PrivateCard *)privateCardByID:(NSNumber *)cardID; // 根据ID查询
- (void)createPrivateCardWithInterCard:(InterCard *)iCard;
- (void)modifyPrivateCardWithInterCard:(InterCard *)iCard;
- (void)deletePrivateCardByID:(NSNumber *)cardID;

#pragma mark - ReceivedCard: 收到的联系人, 即通常所说的“联系人”
- (NSArray *)allReceivedCards; // 所有 收到的联系人 ReceivedCard 的数组
- (ReceivedCard *)receivedCardByID:(NSNumber *)cardID; // 根据ID查询
- (void)deleteReceivedCard:(ReceivedCard *)receivedCard;
@end

@interface KHHApp (UI_Group)
- (NSArray *)allTopLevelGroups;// 所有 顶级分组（即父分组 id 为 0）
@end

@interface KHHData (UI_Template)

@end

@interface KHHData (UI_Utils)

@end
