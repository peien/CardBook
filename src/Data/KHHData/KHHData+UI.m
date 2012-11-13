//
//  KHHData+UI.m
//  CardBook
//
//  Created by 孙铭 on 12-9-19.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHData+UI.h"
//#import "KHHClasses.h"
#import "KHHTypes.h"
#import "KHHDefaults.h"
#import "NSManagedObject+KHH.h"
//#import "ContactCard.h"

@implementation KHHData (UI_Card)
// 交换名片后取最新一张名片
- (void)pullLatestReceivedCard {
    [self.agent latestReceivedCard];
}
/*!
 MyCard: 我的名片
 */
// 所有 我自己的名片 MyCard 的数组
- (NSArray *)allMyCards {
    NSArray *array;
    array = [MyCard objectArrayByPredicate:nil
                           sortDescriptors:@[[Card nameSortDescriptor],[Card companyCardSortDescriptor]]];
    return array;
}
- (MyCard *)myCardByID:(NSNumber *)cardID {
    MyCard *aCard;
    aCard = [MyCard objectByID:cardID createIfNone:NO];
    return aCard;
}
- (void)modifyMyCardWithInterCard:(InterCard *)iCard {
    if (![self.agent updateCard:iCard
                         ofType:KHHCardModelTypeMyCard])
    {
        // 参数有误，未发送请求。
        DLog(@"[II] modifyCardOfType:withInterCard: 参数有误，未发送请求。");
    }
}

/*!
 PrivateCard: 我自己创建的联系人, 即 PrivateCard 私有联系人
 */
- (NSArray *)allPrivateCards {
    NSArray *array;
    array = [PrivateCard objectArrayByPredicate:nil
                                sortDescriptors:@[[Card nameSortDescriptor]]];
    return array;
}
- (PrivateCard *)privateCardByID:(NSNumber *)cardID {
    PrivateCard *aCard = [PrivateCard objectByID:cardID
                                    createIfNone:NO];
    return aCard;
}
- (void)createPrivateCardWithInterCard:(InterCard *)iCard {
    if (![self.agent createCard:iCard
                         ofType:KHHCardModelTypePrivateCard])
    {
        // 参数有误，未发送请求。
        DLog(@"[II] createCardOfType:withInterCard: 参数有误，未发送请求。");
    }
}
- (void)modifyPrivateCardWithInterCard:(InterCard *)iCard {
    if (![self.agent updateCard:iCard
                         ofType:KHHCardModelTypePrivateCard])
    {
        // 参数有误，未发送请求。
        DLog(@"[II] modifyCardOfType:withInterCard: 参数有误，未发送请求。");
    }
}
- (void)deletePrivateCardByID:(NSNumber *)cardID {
    if (![self.agent deleteCardByID:cardID
                             ofType:KHHCardModelTypePrivateCard])
    {
        // 参数有误，未发送请求。
        DLog(@"[II] deleteCardByID:withInterCard: 参数有误，未发送请求。");
    }
}

/*!
 ReceivedCard: 收到的联系人, 即通常所说的“联系人”
 */
- (NSArray *)allReceivedCards {
    NSArray *array;
//    array = [ReceivedCard objectArrayByPredicate:nil
//                                 sortDescriptors:@[[Card nameSortDescriptor]]];
    array = [ReceivedCard objectArrayByPredicate:nil
                                 sortDescriptors:@[[Card newCardSortDescriptor],[Card nameSortDescriptor]]];
    return array;
}
- (ReceivedCard *)receivedCardByID:(NSNumber *)cardID {
    ReceivedCard *aCard = [ReceivedCard objectByID:cardID
                                      createIfNone:NO];
    return aCard;
}
- (void)deleteReceivedCard:(ReceivedCard *)receivedCard; {
    NSArray *cardList = @[receivedCard];
    [self.agent deleteReceivedCards:cardList];
}
- (void)markIsRead:(ReceivedCard *)aCard {
    [self.agent markReadReceivedCard:aCard];
}

@end
@implementation KHHData (UI_Group)
// 过滤掉意外的名片：比如cardid＝＝0
NSMutableArray *FilterUnexpectedCardsFromArray(NSArray *oldArray) {
    NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:oldArray.count];
    for (Card *card in oldArray) {
        if (card.idValue && card.isFullValue) {
            [newArray addObject:card];
        }
    }
    return newArray;
}
// 所有 顶级分组（即父分组 id 为 0）
- (NSArray *)allTopLevelGroups {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent.id = %@", @(0)];
    NSArray *array = [Group objectArrayByPredicate:predicate
                                   sortDescriptors:@[[Group nameSortDescriptor]]];
    return array;
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
    NSArray *fetched;
    fetched = [ContactCard objectArrayByPredicate:predicate
                                  sortDescriptors:@[[Card nameSortDescriptor]]];
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
    NSArray *fetched;
    fetched = [ReceivedCard objectArrayByPredicate:predicate
                                   sortDescriptors:@[[Card nameSortDescriptor]]];
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
        NSArray *fetched;
        fetched = [ContactCard objectArrayByPredicate:predicate
                                      sortDescriptors:@[[Card nameSortDescriptor]]];
        // 过滤掉意外情况
        result = FilterUnexpectedCardsFromArray(fetched);
    }
    return result;
}
// 拜访 (先把所有的拜访记录的客户ID,再从联系人与自建联系人中查询id在拜访列表中的数据):
- (NSArray *)cardsOfVisited {
    NSArray *oldArray = [self cardsOfAll];
    NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:oldArray.count];
    for (Card *card in oldArray) {
        if (card.schedules.count) {
            [newArray addObject:card];
        }
    }
    return newArray;
}
// 重点 (客户评估在3星以上的，先从5星查5星有数据就返回此星下的客户，没数据就查4星，以此类推。)
- (NSArray *)cardsOfVIP {
    NSMutableArray *result;
    NSArray *fetched;
    NSPredicate *predicate =  [NSPredicate predicateWithFormat:@"evaluation.value >= 3.0"];
    fetched = [ContactCard objectArrayByPredicate:predicate
                                  sortDescriptors:@[[Card nameSortDescriptor]]];
    // 过滤掉意外情况
    result = FilterUnexpectedCardsFromArray(fetched);
    return result;
}
// 未分组（不在其它分组的，过滤掉同事）
- (NSArray *)cardsOfUngrouped {
    NSNumber *myComID = [KHHDefaults sharedDefaults].currentCompanyID;
    NSPredicate *predicate = nil;
    if (myComID.integerValue) {
        // 自己属于某公司
        predicate = [NSPredicate predicateWithFormat:@"company.id <> %@", myComID];
    }
    NSArray *fetched;
    fetched = [ContactCard objectArrayByPredicate:predicate
                                  sortDescriptors:@[[Card nameSortDescriptor]]];
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
// 分组增删改
- (void)createGroup:(IGroup *)iGroup
         withMyCard:(MyCard *)myCard {
    NSString *myCardID = myCard.id.stringValue;
    if (![self.agent createGroup:iGroup
                      userCardID:myCardID]) {
        ALog(@"[EE] ERROR!!参数错误！");
    }
}
- (void)updateGroup:(IGroup *)iGroup {
    if (![self.agent updateGroup:iGroup]) {
        ALog(@"[EE] ERROR!!参数错误！");
    }
}
- (void)deleteGroup:(Group *)group {
    if (![self.agent deleteGroup:group]) {
        ALog(@"[EE] ERROR!!参数错误！");
    }
}
- (void)moveCards:(NSArray *)cards
        fromGroup:(Group *)fromGroup
          toGroup:(Group *)toGroup {
    if (![self.agent moveCards:cards
                     fromGroup:fromGroup
                       toGroup:toGroup]) {
        ALog(@"[EE] ERROR!!参数错误！");
    }
}
@end

@implementation KHHData (UI_CustomerEvaluation)
- (void)saveEvaluation:(ICustomerEvaluation *)icv //
         aboutCustomer:(Card *)aCard              // 客户的名片
            withMyCard:(MyCard *)myCard {
    [self.agent createOrUpdateEvaluation:icv
                           aboutCustomer:aCard
                              withMyCard:myCard];
}
@end

@implementation KHHData (UI_Schedule)

- (void)createSchedule:(OSchedule *)oSchedule
            withMyCard:(MyCard *)myCard {
    [self.agent createVisitSchedule:oSchedule
                         withMyCard:myCard];
}
- (void)updateSchedule:(OSchedule *)oSchedule {
    [self.agent updateVisitSchedule:oSchedule];
}
- (void)deleteSchedule:(Schedule *)schedule {
    [self.agent deleteVisitSchedule:schedule];
}
- (void)uploadImage:(UIImage *)image forSchedule:(Schedule *)schedule {
    [self.agent uploadImage:image
           forVisitSchedule:schedule];
}
- (void)deleteImage:(Image *)image  fromSchedule:(Schedule *)schedule {
    [self.agent deleteImage:image
          fromVisitSchedule:schedule];
}
#pragma mark - 我拜访别人的纪录
- (NSArray *)allSchedules {
    NSPredicate *predicate = nil;
//    predicate = [NSPredicate predicateWithFormat:@"company.id <> %@", myComID];

    NSSortDescriptor *sortDes = [NSSortDescriptor sortDescriptorWithKey:@"id"
                                                              ascending:NO];
    NSArray *result = [Schedule objectArrayByPredicate:predicate
                                       sortDescriptors:@[sortDes]];
    return result;
}
- (NSArray *)schedulesOnCard:(Card *)aCard day:(NSString *)aDay {
    NSDate *date = DateFromKHHDateString([aDay stringByAppendingString:@" 00:00:00"]);
    return [self schedulesOnCard:aCard date:date];
}
- (NSArray *)schedulesOnCard:(Card *)aCard date:(NSDate *)aDate {
    NSDate *start = aDate;
    NSTimeInterval oneDay = 60 * 60 * 24;
    NSDate *end = [start dateByAddingTimeInterval:oneDay];
    NSPredicate *predicate;
    if (aCard) {
        predicate = [NSPredicate predicateWithFormat:@"plannedDate >= %@ && plannedDate < %@ && SOME targets.id == %@", start, end, aCard.id];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"plannedDate >= %@ && plannedDate < %@", start, end];
    }
    NSSortDescriptor *sortDes = [NSSortDescriptor sortDescriptorWithKey:@"id"
                                                              ascending:NO];
    NSArray *result = [Schedule objectArrayByPredicate:predicate
                                       sortDescriptors:@[sortDes]];
    return result;
}
- (NSInteger)countOfUnfinishedSchedulesOnCard:(Card *)aCard day:(NSString *)aDay; {
    NSDate *start = DateFromKHHDateString([aDay stringByAppendingString:@" 00:00:00"]);
    return [self countOfUnfinishedSchedulesOnCard:aCard date:start];
}
- (NSInteger)countOfUnfinishedSchedulesOnCard:(Card *)aCard date:(NSDate *)aDate {
    NSArray *list = [self schedulesOnCard:aCard date:aDate];
    if (0 == list.count) {
        return -1;
    }
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:list.count];
    for (Schedule *schdl in list) {
        if(schdl.isFinishedValue) continue;
        [result addObject:schdl];
    }
    return result.count;
}
@end

@implementation KHHData (UI_Template)

- (NSArray *)allPublicTemplates {
    NSNumber *domainType = @(KHHTemplateDomainTypePublic);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"domainType == %@", domainType];
    NSArray *fetched;
    fetched = [CardTemplate objectArrayByPredicate:predicate
                                   sortDescriptors:nil];
    NSArray *result = fetched;
    return result;
}

@end

@implementation KHHData (UI_Message)

-(void)syncMessages {
    [self.agent allMessages];
}
- (NSArray *)allMessages {
    NSSortDescriptor *sortDes = [NSSortDescriptor sortDescriptorWithKey:@"time"
                                                              ascending:NO];
    NSArray *result = [KHHMessage objectArrayByPredicate:nil
                                         sortDescriptors:@[sortDes]];
    return result;
}
- (NSUInteger)countOfUnreadMessages {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isRead == %@", @(NO)];
    NSArray *fetched = [KHHMessage objectArrayByPredicate:predicate
                                          sortDescriptors:nil];
    return fetched.count;
}
- (void)deleteMessages:(NSArray *)msgList {
//    [self.agent deleteMessages:msgList];
    for (KHHMessage *msg in msgList) {
        [self.context deleteObject:msg];
    }
    [self saveContext];
}

@end

@implementation KHHData(UI_Reply)
// 回赠名片，是收到名片就调真正回赠接口，是自建联系人就掉发送到手机接口
- (void)replyCard:(Card *) receiverCard myDefaultReplyCard:(Card *) myReplyCard {
    if (!receiverCard || !myReplyCard) {
        return;
    }
    
    DLog(@"reply card, the receiver mobilePhone = %@", receiverCard.mobilePhone);
    //判断是不是收到的联系人
    if ([receiverCard isKindOfClass: [ReceivedCard class]]) {
        [self.agent sendCard:myReplyCard toUser:[[NSString alloc] initWithFormat:@"%@",receiverCard.userID]];
    }else if ([receiverCard isKindOfClass: [PrivateCard class]]) {
        //取用户的手机号
        NSArray *mobiles = [receiverCard.mobilePhone componentsSeparatedByString:@"|"];
        if (!mobiles || mobiles.count <= 0) {
            //发送失败的广播
            return;
        }
        NSMutableArray *newMobiles = [[NSMutableArray alloc] initWithCapacity:0];
        [newMobiles addObject:[mobiles objectAtIndex:0]];
        
        DLog(@"reply card, the receiver mobilePhone at index 0 = %@", mobiles);
        [self.agent sendCard:myReplyCard toPhones:newMobiles];
    }
}

@end
