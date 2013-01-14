//
//  KHHNetAgentPrivateDelegates.h
//  CardBook
//
//  Created by CJK on 13-1-12.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef CardBook_KHHNetAgentPrivateDelegates_h
#define CardBook_KHHNetAgentPrivateDelegates_h
@protocol KHHNetAgentPrivateCardDelegates <NSObject>
@optional
//同步私有名片
- (void)syncPrivateCardSuccess:(NSDictionary *) dict;
-(void)syncPrivateCardFailed:(NSDictionary *) dict;
//新增拜访计划
- (void)addPrivateCardSuccess:(NSDictionary *) dict;
- (void)addPrivateCardFailed:(NSDictionary *) dict;
//更新拜访计划
- (void)updatePrivateCardSuccess;
- (void)updatePrivateCardFailed:(NSDictionary *) dict;
//删除拜访计划
- (void)deletePrivateCardSuccess;
- (void)deletePrivateCardFailed:(NSDictionary *) dict;
@end


#endif
