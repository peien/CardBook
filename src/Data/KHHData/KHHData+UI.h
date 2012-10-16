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

@interface KHHData (UI_Group)
// 所有 顶级用户自定义分组（即父分组 id 为 0）
- (NSArray *)allTopLevelGroups;// 结果为Group组成的数组

// 内部固定分组
// 所有（联系人与自建联系人的总和，过滤掉同事）
- (NSArray *)cardsOfAll;
// new（即isRead为no，过滤掉同事）
- (NSArray *)cardsOfNew;
// 同事（companyid与自己相同）
- (NSArray *)cardsOfColleague;
// 拜访 (先把所有的拜访记录的客户ID,再从联系人与自建联系人中查询id在拜访列表中的数据):
- (NSArray *)cardsOfVisited;
// 重点 (客户评估在3星以上的，先从5星查5星有数据就返回此星下的客户，没数据就查4星，以此类推，下面语句只是5星的，其它星值只是把5换成其它星值)
- (NSArray *)cardsOfVIP;
// 未分组（不在其它分组的，过滤掉同事）
- (NSArray *)cardsOfUngrouped;
// 手机（就是手机上的通讯录）????

@end

@interface KHHData (UI_Template)

@end

@interface KHHData (UI_Utils)

@end
