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
#import "MyCard.h"
#import "PrivateCard.h"

//同步类型
typedef enum {
    KHHCardSyncTypeAdd = 1,
    KHHCardSyncTypeUpdate,
    KHHCardSyncTypeDelete,
    KHHCardSyncTypeSyncCard, //同步我的名片及自建名片
    KHHCardSyncTypeSyncCustomerCard,//同步联系人
}   KHHCardSyncType;

@interface KHHDataNew (Card) <KHHNetAgentCardDelegate>
@property (assign, nonatomic) KHHCardSyncType syncType;
#pragma mark - 名片查询---同步;
- (void)syncCard:(id<KHHDataCardDelegate>) delegate;

#pragma mark - 联系人查询---同步;
- (void)syncCustomerCard:(NSString *) startPage pageSize:(NSString *) pageSize delegate:(id<KHHDataCardDelegate>) delegate;

#pragma mark - 名片新增(新增)
- (void)doAddCard:(InterCard *)iCard delegate:(id<KHHDataCardDelegate>) delegate;
- (void)addCard:(InterCard *)iCard logoImage:(UIImage *) logoImage cardLinks:(NSArray *) cardLinks delegate:(id<KHHDataCardDelegate>) delegate;


#pragma mark - 名片编辑
- (void)doUpdateCard:(InterCard *)iCard delegate:(id<KHHDataCardDelegate>) delegate;
- (void)updateCard:(InterCard *)iCard logoImage:(UIImage *) logoImage cardLinks:(NSArray *) cardLinks delegate:(id<KHHDataCardDelegate>) delegate;


#pragma mark - 名片删除
- (void)doDeleteCard:(Card *)card delegate:(id<KHHDataCardDelegate>) delegate;

#pragma mark - 名片交换


#pragma mark - 设置联系人的状态为已查看
- (void)updateCardReadState:(Card *)card myUserID:(long) userID delegate:(id<KHHDataCardDelegate>) delegate;


#pragma mark - data from manageContext
- (NSArray *)allMyCards;

- (MyCard *)myCardByID:(NSNumber *)cardID;

#pragma mark - for do later
- (void)doInsertMyCard;

@end
