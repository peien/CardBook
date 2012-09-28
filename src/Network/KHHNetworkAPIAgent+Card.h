//
//  KHHNetworkAPIAgent+Card.h
//  CardBook
//
//  Created by 孙铭 on 8/29/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgent.h"
#import "InterCard.h"
#import "MyCard.h"
#import "PrivateCard.h"
#import "ReceivedCard.h"

/*!
 @fuctiongroup Card参数整理函数
 */
BOOL CardHasRequiredAttributes(InterCard *card, KHHCardAttributeType attributes);
NSMutableDictionary * ParametersToCreateOrUpdateCard(InterCard *card);

@interface KHHNetworkAPIAgent (Card)
/**
 新增我的名片 kinghhCardService.create
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=202
 新增私有名片 kinghhPrivateCardService.create
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=179
 */
- (BOOL)createCard:(InterCard *)iCard ofType:(KHHCardModelType)cardType;
/**
 修改我的名片 kinghhCardService.update
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=203
 修改私有名片 kinghhPrivateCardService.update
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=180
 */
- (BOOL)updateCard:(InterCard *)iCard ofType:(KHHCardModelType)cardType;
/**
 删除我的名片 kinghhCardService.delete
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=204
 删除私有名片 kinghhPrivateCardService.delete
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=181
 */
- (BOOL)deleteCardByID:(NSNumber *)cardID ofType:(KHHCardModelType)cardType;
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
- (void)receivedCardCountAfterDate:(NSString *)lastDate
                          lastCard:(NSString *)lastCard
                             extra:(NSDictionary *)extra;

/**
 我的联系人增量 exchangeCardService.getReceiverCardBookSyn
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=182
 */
- (void)receivedCardsAfterDate:(NSString *)lastDate
                      lastCard:(NSString *)lastCardID
                 expectedCount:(NSString *)count
                         extra:(NSDictionary *)extra;

/**
 设置联系人的状态为已查看 sendCardService.updateReadState
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=208
 */
- (BOOL)markReadReceivedCard:(ReceivedCard *)card;
@end

#pragma mark - PrivateCard 私有名片，即自建的他人名片
@interface KHHNetworkAPIAgent (PrivateCard)
/**
 增量查 kinghhPrivateCardService.synCard
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=178
 */
- (void)privateCardsAfterDate:(NSString *)lastDate;
@end
