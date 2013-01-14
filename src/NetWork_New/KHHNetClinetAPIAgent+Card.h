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
- (void)addCard:(Card *)card delegate:(id<KHHNetAgentCardDelegate>) delegate;

//名片删除
- (void)deleteCard:(Card *)card delegate:(id<KHHNetAgentCardDelegate>) delegate;

//名片编辑
- (void)updateCard:(Card *)card delegate:(id<KHHNetAgentCardDelegate>) delegate;

@end
