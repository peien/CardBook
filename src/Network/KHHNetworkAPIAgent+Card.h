//
//  KHHNetworkAPIAgent+Card.h
//  CardBook
//
//  Created by 孙铭 on 8/29/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgent.h"
#import "MyCard.h"
#import "CreatedCard.h"
#import "ReceivedCard.h"
/*!
 Notification names
 */
// createCard
static NSString * const KHHNotificationCreateCardSucceeded = @"createCardSucceeded";
static NSString * const KHHNotificationCreateCardFailed    = @"createCardFailed";
// updateCard
static NSString * const KHHNotificationUpdateCardSucceeded = @"updateCardSucceeded";
static NSString * const KHHNotificationUpdateCardFailed    = @"updateCardFailed";
// deleteCard
static NSString * const KHHNotificationDeleteCardSucceeded = @"deleteCardSucceeded";
static NSString * const KHHNotificationDeleteCardFailed    = @"deleteCardFailed";
// deleteReceivedCards
static NSString * const KHHNotificationDeleteReceivedCardsSucceeded = @"deleteReceivedCardsSucceeded";
static NSString * const KHHNotificationDeleteReceivedCardsFailed    = @"deleteReceivedCardsFailed";
// latestReceivedCard
static NSString * const KHHNotificationLatestReceivedCardSucceeded = @"latestReceivedCardSucceeded";
static NSString * const KHHNotificationLatestReceivedCardFailed    = @"latestReceivedCardFailed";
// receivedCardCountAfterDateLastCard
static NSString * const KHHNotificationReceivedCardCountAfterDateLastCardSucceeded
                    = @"receivedCardCountAfterDateLastCardSucceeded";
static NSString * const KHHNotificationReceivedCardCountAfterDateLastCardFailed
                    = @"receivedCardCountAfterDateLastCardFailed";
// receivedCardsAfterDateLastCardExpectedCount
static NSString * const KHHNotificationReceivedCardsAfterDateLastCardExpectedCountSucceeded
                    = @"receivedCardsAfterDateLastCardExpectedCountSucceeded";
static NSString * const KHHNotificationReceivedCardsAfterDateLastCardExpectedCountFailed
                    = @"receivedCardsAfterDateLastCardExpectedCountFailed";
// markReadReceivedCard
static NSString * const KHHNotificationMarkReadReceivedCardSucceeded = @"markReadReceivedCardSucceeded";
static NSString * const KHHNotificationMarkReadReceivedCardFailed    = @"markReadReceivedCardFailed";
// createdCardsAfterDate
static NSString * const KHHNotificationCreatedCardsAfterDateSucceeded = @"createdCardsAfterDateSucceeded";
static NSString * const KHHNotificationCreatedCardsAfterDateFailed    = @"createdCardsAfterDateFailed";

typedef enum {
    KHHCardAttributeNone       = 0UL,
    KHHCardAttributeID         = 1UL << 0,
    KHHCardAttributeVersion    = 1UL << 1,
    KHHCardAttributeName       = 1UL << 2,
    KHHCardAttributeUserID     = 1UL << 3,
    KHHCardAttributeTemplateID = 1UL << 4,
//    KHHCardAttribute           = ,
    KHHCardAttributeAll        = ~KHHCardAttributeNone,
} KHHCardAttributes;

/*!
 @fuctiongroup Card参数整理函数
 */
BOOL CardHasRequiredAttributes(Card *card, KHHCardAttributes attributes);
NSMutableDictionary * ParametersToCreateOrUpdateCard(Card *card);

@interface KHHNetworkAPIAgent (MyCard)
/**
 新增名片 kinghhCardService.create
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=202
 */
- (BOOL)createCard:(MyCard *)card;
/**
 修改名片 kinghhCardService.update
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=203
 */
- (BOOL)updateCard:(MyCard *)card;
/**
 删除名片 kinghhCardService.delete
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=204
 */
- (BOOL)deleteCard:(MyCard *)card;
@end

#pragma mark - ReceivedCard 联系人，即收到的他人名片
@interface KHHNetworkAPIAgent (ReceivedCard)
/**
 删除联系人 relationGroupService.deleteCardBook
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=192
 */
- (BOOL)deleteReceivedCards:(NSArray *)cards;

/**
 我的联系人中最后一个名片 exchangeCardService.getReceiverCardBookLast
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=196
 */
- (void)latestReceivedCard;

/**
 我的联系人增量总个数 exchangeCardService.getReceiverCardBookSynCount
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=195
 */
- (BOOL)receivedCardCountAfterDate:(NSString *)lastDate
                          lastCard:(ReceivedCard *)lastCard;

/**
 我的联系人增量 exchangeCardService.getReceiverCardBookSyn
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=182
 */
- (BOOL)receivedCardsAfterDate:(NSString *)lastDate
                      lastCard:(ReceivedCard *)lastCard
                 expectedCount:(NSString *)count;

/**
 设置联系人的状态为已查看 sendCardService.updateReadState
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=208
 */
- (BOOL)markReadReceivedCard:(ReceivedCard *)card;
@end

#pragma mark - CreatedCard 私有名片，即自建的他人名片
@interface KHHNetworkAPIAgent (CreatedCard)
/**
 增 kinghhPrivateCardService.create
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=179
 */
//- (BOOL)createCreatedCard:(CreatedCard *)card;
/**
 改 kinghhPrivateCardService.update
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=180
 */
//- (BOOL)updateCreatedCard:(CreatedCard *)card;
/**
 删除 kinghhPrivateCardService.delete
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=181
 */
//- (BOOL)deleteCreatedCard:(CreatedCard *)card;
/**
 增量查 kinghhPrivateCardService.synCard
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=178
 */
- (void)createdCardsAfterDate:(NSString *)lastDate;
@end
