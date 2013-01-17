//
//  KHHData+Card.h
//  CardBook
//
//  Created by CJK on 13-1-12.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew.h"
#import "KHHDataCardDelegate.h"
#import "KHHNetClinetAPIAgent+Card.h"
@class MyCard;
@class PrivateCard;
@class ReceivedCard;

//同步类型
typedef enum {
    KHHCardSyncTypeAdd = 1,
    KHHCardSyncTypeUpdate,
    KHHCardSyncTypeDelete,
    KHHCardSyncTypeSyncCard, //同步我的名片及自建名片
    KHHCardSyncTypeSyncCustomerCard,//同步联系人
    KHHCardSyncTypeSyncCustomerCardUpdateNewCardState,//同步联系人置新名片标记
}   KHHCardSyncType;

@interface KHHDataNew (Card) <KHHNetAgentCardDelegate>
#pragma mark - 名片查询---同步;
- (void)syncCard:(id<KHHDataCardDelegate>) delegate;

#pragma mark - 联系人查询---同步;
- (void)syncCustomerCard:(NSString *) startPage pageSize:(NSString *) pageSize delegate:(id<KHHDataCardDelegate>) delegate;

#pragma mark - 名片新增(新增自建联系人)
- (void)addCard:(InterCard *)iCard delegate:(id<KHHDataCardDelegate>) delegate;
- (void)addCard:(InterCard *)iCard logoImage:(UIImage *) logoImage cardLinks:(NSArray *) cardLinks delegate:(id<KHHDataCardDelegate>) delegate;


#pragma mark - 名片编辑(编辑自建联系人、个人用户或boss编辑自己的名片)
- (void)updateCard:(InterCard *)iCard delegate:(id<KHHDataCardDelegate>) delegate;
- (void)updateCard:(InterCard *)iCard logoImage:(UIImage *) logoImage cardLinks:(NSArray *) cardLinks delegate:(id<KHHDataCardDelegate>) delegate;


#pragma mark - 名片删除(删除自建联系人)
- (void)deleteCard:(Card *)card delegate:(id<KHHDataCardDelegate>) delegate;


#pragma mark - 设置联系人的状态为已查看
- (void)updateCardReadState:(Card *)card myUserID:(long) userID delegate:(id<KHHDataCardDelegate>) delegate;

#pragma mark - 获取本地所有名片(不包含同事)
-(NSArray*) allCards;

#pragma mark - 获取本地所有我的名片
-(NSArray*) allMyCards;

#pragma mark - 获取本地所有自建联系人名片
-(NSArray*) allPrivateCards;

#pragma mark - 获取本地联系人名片
-(NSArray*) allCustomerCards;

#pragma mark - 获取本地我的名片
- (MyCard *)myCardByID:(NSNumber *)cardID;// 根据ID查询

#pragma mark - 获取本地我的自建名片
- (PrivateCard *)privateCardByID:(NSNumber *)cardID;// 根据ID查询

#pragma mark - 获取本地我的联系人
- (ReceivedCard *)receivedCardByID:(NSNumber *)cardID;// 根据ID查询

#pragma mark - 获取本地最后一个联系人
- (void)latestCustomerCard:(id<KHHDataCardDelegate>) delegate;
@end
