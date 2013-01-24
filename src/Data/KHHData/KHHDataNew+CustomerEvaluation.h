//
//  KHHDataNew+CustomerEvaluation.h
//  CardBook
//
//  Created by 王定方 on 13-1-15.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew.h"
#import "KHHDataCustomerEvaluationDelegate.h"
#import "KHHNetClinetAPIAgent+CustomerEvaluation.h"

//同步类型
typedef enum {
    KHHCustomerEvaluationSyncTypeAdd = 1,
    KHHCustomerEvaluationSyncTypeUpdate,
    KHHCustomerEvaluationSyncTypeDelete,
    KHHCustomerEvaluationSyncTypeSync,
}   KHHCustomerEvaluationSyncType;

@interface KHHDataNew (CustomerEvaluation) <KHHNetAgentCustomerEvaluationDelegates>
#pragma mark -  客户评估信息增量接口
- (void)syncCustomerEvaluation:(id<KHHDataCustomerEvaluationDelegate>) delegate;

#pragma mark - 客户评估信息新增
- (void)addCustomerEvaluation:(ICustomerEvaluation *)icv aboutCustomer:(Card *)aCard withMyCard:(MyCard *)myCard  delegate:(id<KHHDataCustomerEvaluationDelegate>) delegate;


#pragma mark - 客户评估信息修改
- (void)updateCustomerEvaluation:(ICustomerEvaluation *)icv aboutCustomer:(Card *)aCard withMyCard:(MyCard *)myCard  delegate:(id<KHHDataCustomerEvaluationDelegate>) delegate;

#pragma mark - 客户评估删除
-(void)deleteCustomerEvaluationByID:(long) CEID delegate:(id<KHHDataCustomerEvaluationDelegate>) delegate;

#pragma mark - 查询单个客户评估信息
-(void)syncSingleCustomerEvaluationWithID:(long)CustomerUserID myUserID:(long)myUserID delegate:(id<KHHDataCustomerEvaluationDelegate>)delegate;
@end
