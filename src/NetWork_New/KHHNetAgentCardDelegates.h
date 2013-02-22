//
//  KHHNetAgentCardDelegates.h
//  CardBook
//
//  Created by CJK on 13-1-12.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef CardBook_KHHNetAgentCardDelegates_h
#define CardBook_KHHNetAgentCardDelegates_h

#pragma mark - for data
@protocol KHHNetAgentCardDelegate<NSObject>
@optional
//名片查询---同步(私有联系人与我的名片);
- (void)syncCardSuccess:(NSDictionary *) dict;
- (void)syncCardFailed:(NSDictionary *) dict;

//联系人查询---同步(私有联系人与我的名片);
- (void)syncCustomerCardSuccess:(NSDictionary *) dict;
- (void)syncCustomerCardFailed:(NSDictionary *) dict;


//名片新增
- (void)addCardSuccess;
- (void)addCardSuccess:(NSDictionary *) dict;
- (void)addCardFailed:(NSDictionary *) dict;

//名片删除
- (void)deleteCardSuccess;
- (void)deleteCardFailed:(NSDictionary *)dict;

//名片编辑
- (void)updateCardSuccess;
- (void)updateCardFailed:(NSDictionary *)dict;

//设置联系人新名片标记
- (void)updateCardNewCardStateSuccess;
- (void)updateCardNewCardStateFailed:(NSDictionary *)dict;

//获取最后一个联系人名片
- (void)getLatestCustomerCardSuccess:(NSDictionary *)dict;
- (void)getLatestCustomerCardFailed:(NSDictionary *)dict;

- (void)markIsReadSuccess:(NSDictionary *)dict;
- (void)markIsReadFailed:(NSDictionary *)dict;

@end

#endif
