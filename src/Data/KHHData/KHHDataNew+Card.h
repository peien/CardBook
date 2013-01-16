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
@interface KHHDataNew (Card) <KHHNetAgentCardDelegate>
#pragma mark - 名片查询---同步;
- (void)syncCard:(NSString *)lastDate delegate:(id<KHHDataCardDelegate>) delegate;

#pragma mark - 名片新增
- (void)addCard:(InterCard *)iCard delegate:(id<KHHDataCardDelegate>) delegate;
- (void)addCard:(InterCard *)iCard logoImage:(UIImage *) logoImage cardLinks:(NSArray *) cardLinks delegate:(id<KHHDataCardDelegate>) delegate;


#pragma mark - 名片编辑
- (void)updateCard:(InterCard *)iCard delegate:(id<KHHDataCardDelegate>) delegate;
- (void)updateCard:(InterCard *)iCard logoImage:(UIImage *) logoImage cardLinks:(NSArray *) cardLinks delegate:(id<KHHDataCardDelegate>) delegate;


#pragma mark - 名片删除
- (void)deleteCard:(Card *)card delegate:(id<KHHDataCardDelegate>) delegate;


#pragma mark - 设置联系人的状态为已查看
- (void)updateCardReadState:(Card *)card myUserID:(long) userID delegate:(id<KHHDataCardDelegate>) delegate;
@end
