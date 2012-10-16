//
//  KHHData+UI.m
//  CardBook
//
//  Created by 孙铭 on 12-9-19.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHData+UI.h"
#import "KHHClasses.h"
#import "KHHTypes.h"
#import "KHHData+CRUD.h"
#import "KHHDefaults.h"

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
- (void)deleteReceivedCard:(ReceivedCard *)receivedCard; {
    NSArray *cardList = @[receivedCard];
    [self.agent deleteReceivedCards:cardList];
}

/*!
 交换名片后取最新一张名片
 */
- (void)pullLatestReceivedCard {
    [self.agent latestReceivedCard];
}
@end
@implementation KHHData (UI_Group)
// 所有 顶级分组（即父分组 id 为 0）
- (NSArray *)allTopLevelGroups {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent.id = %@", @(0)];
    NSArray *result = [self fetchEntityName:[Group entityName]
                                  predicate:predicate
                            sortDescriptors:nil];
    return result;
}
// 内部固定分组
// 所有（联系人与自建联系人的总和，过滤掉同事）
- (NSArray *)cardsOfAll {
    NSNumber *myComID = [KHHDefaults sharedDefaults].currentCompanyID;
    NSPredicate *predicate = nil;
    if (myComID.integerValue) {
        // 自己属于某公司
        // 用公司ID过滤掉同事
        predicate = [NSPredicate predicateWithFormat:@"company.id <> %@", myComID];
    }
    NSArray *fetched = [self fetchEntityName:[Card entityName]
                                  predicate:predicate
                            sortDescriptors:nil];
    // 过滤掉意外情况
    NSMutableArray *result = FilterUnexpectedCardsFromArray(fetched);
    return result;
}
// new（即isRead为no，过滤掉同事）
- (NSArray *)cardsOfNew {
    NSNumber *myComID = [KHHDefaults sharedDefaults].currentCompanyID;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isRead <> YES"];
    if (myComID.integerValue) {
        // 自己属于某公司
        predicate = [NSPredicate predicateWithFormat:@"(isRead <> YES) && (company.id <> %@)", myComID];
    }
    NSArray *fetched = [self fetchEntityName:[ReceivedCard entityName]
                                  predicate:predicate
                            sortDescriptors:nil];
    // 过滤掉意外情况
    NSMutableArray *result = FilterUnexpectedCardsFromArray(fetched);
    return result;
}
// 同事（companyid与自己相同）
- (NSArray *)cardsOfColleague {
    NSNumber *myComID = [KHHDefaults sharedDefaults].currentCompanyID;
    NSMutableArray *result = [NSMutableArray array];
    if (myComID.integerValue) {
        // 自己属于某公司
        NSPredicate *predicate =  [NSPredicate predicateWithFormat:@"company.id == %@", myComID];
        NSArray *fetched = [self fetchEntityName:[Card entityName]
                             predicate:predicate
                       sortDescriptors:nil];
        // 过滤掉意外情况
        result = FilterUnexpectedCardsFromArray(fetched);
    }
    return result;
}
// 拜访 (先把所有的拜访记录的客户ID,再从联系人与自建联系人中查询id在拜访列表中的数据):
- (NSArray *)cardsOfVisited {
#warning TODO
    return [NSArray array];
}
// 重点 (客户评估在3星以上的，先从5星查5星有数据就返回此星下的客户，没数据就查4星，以此类推，下面语句只是5星的，其它星值只是把5换成其它星值)
- (NSArray *)cardsOfVIP {
#warning TODO
    return [NSArray array];
}
// 未分组（不在其它分组的，过滤掉同事）
- (NSArray *)cardsOfUngrouped {
    NSNumber *myComID = [KHHDefaults sharedDefaults].currentCompanyID;
    NSPredicate *predicate = nil;
    if (myComID.integerValue) {
        // 自己属于某公司
        predicate = [NSPredicate predicateWithFormat:@"company.id <> %@", myComID];
    }
    NSArray *fetched = [self fetchEntityName:[Card entityName]
                                  predicate:predicate
                            sortDescriptors:nil];
    NSMutableArray *filtered = [NSMutableArray arrayWithCapacity:fetched.count];
    for (Card *card in fetched) {
        if (card.groups.count < 1) {
            [filtered addObject:card];
        }
    }
    // 过滤掉意外情况
    NSMutableArray *result = FilterUnexpectedCardsFromArray(filtered);
    return result;
}
// 过滤掉意外的名片：比如cardid＝＝0
NSMutableArray *FilterUnexpectedCardsFromArray(NSArray *oldArray) {
    NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:oldArray.count];
    for (Card *card in oldArray) {
        if (card.idValue && (![card isKindOfClass:[MyCard class]])) {
            [newArray addObject:card];
        }
    }
    return newArray;
}

// 分组增删改
- (void)createGroup:(IGroup *)iGroup
         withMyCard:(MyCard *)myCard {
    NSString *myCardID = myCard.id.stringValue;
    [self.agent createGroup:iGroup
                 userCardID:myCardID];
}
- (void)updateGroup:(IGroup *)iGroup {
    [self.agent updateGroup:iGroup];
    
}
- (void)deleteGroup:(Group *)group {
    [self.agent deleteGroup:group];
}
@end