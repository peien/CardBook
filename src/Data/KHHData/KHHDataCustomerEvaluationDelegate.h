//
//  KHHDataCustomerEvaluationDelegate.h
//  CardBook
//
//  Created by 王定方 on 13-1-15.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef CardBook_KHHDataCustomerEvaluationDelegate_h
#define CardBook_KHHDataCustomerEvaluationDelegate_h
@protocol KHHDataCustomerEvaluationDelegate <NSObject>
@optional
//同步客户评估
-(void)syncCustomerEvaluationForUISuccess;
-(void)syncCustomerEvaluationForUIFailed:(NSDictionary *) dict;
//新增客户评估
-(void)addCustomerEvaluationForUISuccess;
-(void)addCustomerEvaluationForUIFailed:(NSDictionary *) dict;
//更新客户评估
-(void)updateCustomerEvaluationForUISuccess;
-(void)updateCustomerEvaluationForUIFailed:(NSDictionary *) dict;
//删除客户评估
-(void)deleteCustomerEvaluationForUISuccess;
-(void)deleteCustomerEvaluationForUIFailed:(NSDictionary *) dict;
//同步单个联系人的客户评估信息
-(void)syncSingleCustomerEvaluationForUISuccess;
-(void)syncSingleCustomerEvaluationForUIFailed:(NSDictionary *) dict;
@end


#endif
