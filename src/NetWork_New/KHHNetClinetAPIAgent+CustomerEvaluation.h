//
//  KHHNetClinetAPIAgent+CustomerEvaluation.h
//  CardBook
//
//  Created by 王定方 on 13-1-12.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent.h"
#import "KHHNetAgentCustomerEvaluationDelegates.h"
#import "ICustomerEvaluation.h"
@class Card;
@class MyCard;

@interface KHHNetClinetAPIAgent (CustomerEvaluation)
/**
 * 客户评估信息增量接口
 * url CustomerRelations/{syncTime}
 * 方法 get
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=263
 */
- (void)syncCustomerEvaluationWithDate:(NSString *)lastDate delegate:(id<KHHNetAgentCustomerEvaluationDelegates>) delegate;
/*!
 客户评估信息新增
 http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=264
 url customerRelations
 方法 post
 参数：
 customerAppraise.id 	 Long 	 否 	 id（andriod客户端没有这张表不使用）
 customerAppraise.cardId 	 Long 	 否 	 当前用户对应名片ID
 customerAppraise.version 	 int 	 否 	 当前用户对应名片版本号
 customerAppraise.customCardId 	 Long 	 是 	 客户名片ID
 customerAppraise.customType 	 String 	 是 客户类型（决定客户手机的类型）linkman---名片ID|me---私有名片ID）
 customerAppraise.customPosition 	 String 	 否 	 客户所在位置
 customerAppraise.relateDepth 	 String 	 否 	 关系深度
 customerAppraise.customCost String 否 	 客户价值
 knowTimeTemp 	 String 	 否 	 认识时间
 customerAppraise.knowAddress 	 String 	 否 	 认识地址
 customerAppraise.col1 	 String 	 否 	 备注1
 customerAppraise.col2 	 String 	 否 	 备注2
 */
- (void)addCustomerEvaluation:(ICustomerEvaluation *)icv aboutCustomer:(Card *)aCard withMyCard:(MyCard *)myCard  delegate:(id<KHHNetAgentCustomerEvaluationDelegates>) delegate;


/*!
 客户评估信息修改
 http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=265
 url customerRelations
 方法 put
 参数：
 customerAppraise.id 	 Long 	 否 	 id（andriod客户端没有这张表不使用）
 customerAppraise.cardId 	 Long 	 否 	 当前用户对应名片ID
 customerAppraise.version 	 int 	 否 	 当前用户对应名片版本号
 customerAppraise.customCardId 	 Long 	 是 	 客户名片ID
 customerAppraise.customType 	 String 	 是 客户类型（决定客户手机的类型）linkman---名片ID|me---私有名片ID）
 customerAppraise.customPosition 	 String 	 否 	 客户所在位置
 customerAppraise.relateDepth 	 String 	 否 	 关系深度
 customerAppraise.customCost String 否 	 客户价值
 knowTimeTemp 	 String 	 否 	 认识时间
 customerAppraise.knowAddress 	 String 	 否 	 认识地址
 customerAppraise.col1 	 String 	 否 	 备注1
 customerAppraise.col2 	 String 	 否 	 备注2
 */
- (void)updateCustomerEvaluation:(ICustomerEvaluation *)icv aboutCustomer:(Card *)aCard withMyCard:(MyCard *)myCard  delegate:(id<KHHNetAgentCustomerEvaluationDelegates>) delegate;

/*
 * 客户评估删除
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=266
 * url CustomerRelations/{id}
 * 方法 delete
 */
-(void)deleteCustomerEvaluationByID:(long) CEID delegate:(id<KHHNetAgentCustomerEvaluationDelegates>) delegate;

/*
 * 查询单个客户评估信息
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=274
 * 方法 get
 * utl customerRelations/{user_id}/{customerUser_id}
 */
-(void)syncSingleCustomerEvaluationWithID:(long)cutomerUserID myUserID:(long) myUserID delegate:(id<KHHNetAgentCustomerEvaluationDelegates>)delegate;
@end
