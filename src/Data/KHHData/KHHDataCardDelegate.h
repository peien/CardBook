//
//  KHHDataCardDelegate.h
//  CardBook
//
//  Created by CJK on 13-1-12.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef CardBook_KHHDataCardDelegate_h
#define CardBook_KHHDataCardDelegate_h
@protocol KHHDataCardDelegate<NSObject>
@optional
//名片查询---同步;
- (void)syncCardForUISuccess;
- (void)syncCardForUIFailed:(NSDictionary *) dict;

//联系人查询---同步;
- (void)syncCustomerCardForUISuccess;
- (void)syncCustomerCardForUIFailed:(NSDictionary *) dict;

//名片新增
- (void)addCardForUISuccess;
- (void)addCardForUISuccess:(NSDictionary *) dict;
- (void)addCardForUIFailed:(NSDictionary *) dict;

//名片删除
- (void)deleteCardForUISuccess;
- (void)deleteCardForUIFailed:(NSDictionary *)dict;

//名片编辑
- (void)updateCardForUISuccess;
- (void)updateCardForUIFailed:(NSDictionary *)dict;

//设置联系人新名片标记
- (void)updateCardNewCardStateForUISuccess;
- (void)updateCardNewCardStateForUIFailed:(NSDictionary *)dict;

//获取最后一个联系人名片
- (void)getLatestCustomerCardForUISuccess:(NSDictionary *)dict;
- (void)getLatestCustomerCardForUIFailed:(NSDictionary *)dict;

//- (void)markIsReadForUISuccess;
//- (void)markIsReadForUIFailed;
@end



#endif
