//
//  KHHNetAgentCustomerEvaluationDelegates.h
//  CardBook
//
//  Created by 王定方 on 13-1-12.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef KHH_NetAgent_CustomerEvaluation_Delegates
#define KHH_NetAgent_CustomerEvaluation_Delegates
@protocol KHHNetAgentCustomerEvaluationDelegates <NSObject>
@optional
//同步客户评估
-(void)syncCustomerEvaluationSuccess:(NSDictionary *) dict;
-(void)syncCustomerEvaluationFailed:(NSDictionary *) dict;
//新增客户评估
-(void)addCustomerEvaluationSuccess:(NSDictionary *) dict;
-(void)addCustomerEvaluationFailed:(NSDictionary *) dict;
//更新客户评估
-(void)updateCustomerEvaluationSuccess;
-(void)updateCustomerEvaluationFailed:(NSDictionary *) dict;
//删除客户评估
-(void)deleteCustomerEvaluationSuccess;
-(void)deleteCustomerEvaluationFailed:(NSDictionary *) dict;
//同步单个联系人的客户评估信息
-(void)syncSingleCustomerEvaluationSuccess:(NSDictionary *) dict;
-(void)syncSingleCustomerEvaluationFailed:(NSDictionary *) dict;
@end
#endif
