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

//名片查询---同步;
- (void)syncCardForUISuccess;
- (void)syncCardForUIFailed:(NSDictionary *) dict;


//名片新增
- (void)addCardForUISuccess;
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
@end



#endif
