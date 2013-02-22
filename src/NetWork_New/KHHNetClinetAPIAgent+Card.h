//
//  KHHNetClinetAPIAgent+Card.h
//  CardBook
//
//  Created by CJK on 13-1-12.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent.h"
#import "KHHNetAgentCardDelegates.h"
#import "Card.h"
#import "ReceivedCard.h"

@interface KHHNetClinetAPIAgent (Card)

#warning 同步接口服务还没写好，文档也没定义好，这里只写了函数空壳
//名片查询---同步(我的名片私有联系人);
- (void)syncCard:(NSString *)lastDate delegate:(id<KHHNetAgentCardDelegate>) delegate;

//联系人查询---同步;
- (void)syncCustomerCard:(NSString *) startPage pageSize:(NSString *) pageSize lastDate:(NSString *)lastDate delegate:(id<KHHNetAgentCardDelegate>) delegate;
//#end warning==================================

//名片新增
- (void)addCard:(InterCard *)iCard delegate:(id<KHHNetAgentCardDelegate>) delegate;
- (void)addCard:(InterCard *)iCard logoImage:(UIImage *) logoImage cardLinks:(NSArray *) cardLinks delegate:(id<KHHNetAgentCardDelegate>) delegate;


//名片编辑
- (void)updateCard:(InterCard *)iCard delegate:(id<KHHNetAgentCardDelegate>) delegate;
- (void)updateCard:(InterCard *)iCard logoImage:(UIImage *) logoImage cardLinks:(NSArray *) cardLinks delegate:(id<KHHNetAgentCardDelegate>) delegate;

//名片发送
- (void)sendCard:(Card *)myReplyCard toPhones:(NSArray *)newMobiles delegate:(id<KHHNetAgentCardDelegate>) delegate;
/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=259
 * 名片删除
 * url card/{cardid}
 * 方法 delete
 */
- (void)deleteCard:(Card *)card delegate:(id<KHHNetAgentCardDelegate>) delegate;

/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=262
 * 设置联系人的状态为已查看
 * url customer/{myUser_id}/{customerUser_id}/{customercard_id}/customoercard_version}
 * 方法 put
 */
- (void)updateCardReadState:(Card *)card myUserID:(long) userID delegate:(id<KHHNetAgentCardDelegate>) delegate;

/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=282
 * 按照认识时间排序的最后一个联系人
 * url customer/last
 * 方法 put
 */
- (void)latestCustomerCard:(id<KHHNetAgentCardDelegate>) delegate;

- (void)markIsRead:(ReceivedCard *)aCard delegate:(id<KHHNetAgentCardDelegate>)delegate;
@end
