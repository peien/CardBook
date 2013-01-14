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

@interface KHHNetClinetAPIAgent (Card)

//名片查询---同步;
- (void)syncCard:(NSString *)lastDate delegate:(id<KHHNetAgentCardDelegate>) delegate;

//名片新增
- (void)addCard:(InterCard *)iCard delegate:(id<KHHNetAgentCardDelegate>) delegate;
- (void)addCard:(InterCard *)iCard logoImage:(UIImage *) logoImage cardLinks:(NSArray *) cardLinks delegate:(id<KHHNetAgentCardDelegate>) delegate;


//名片编辑
- (void)updateCard:(InterCard *)iCard delegate:(id<KHHNetAgentCardDelegate>) delegate;
- (void)updateCard:(InterCard *)iCard logoImage:(UIImage *) logoImage cardLinks:(NSArray *) cardLinks delegate:(id<KHHNetAgentCardDelegate>) delegate;

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
@end
