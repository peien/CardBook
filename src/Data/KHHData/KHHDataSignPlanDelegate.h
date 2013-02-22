//
//  KHHDataSignPlanDelegate.h
//  CardBook
//
//  Created by CJK on 13-1-23.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef CardBook_KHHDataSignPlanDelegate_h
#define CardBook_KHHDataSignPlanDelegate_h
@protocol KHHDataSignPlanDelegate <NSObject>
@optional
//同步拜访计划
-(void) syncPlanForUISuccess;
-(void) syncPlanForUIFailed:(NSDictionary *) dict;
//新增拜访计划
-(void) addPlanForUISuccess;
-(void) addPlanForUIFailed:(NSDictionary *) dict;
//更新拜访计划
-(void) updatePlanForUISuccess;
-(void) updatePlanForUIFailed:(NSDictionary *) dict;
//删除拜访计划
-(void) deletePlanForUISuccess;
-(void) deletePlanForUIFailed:(NSDictionary *) dict;

- (void)deletePlanImgForUISuccess;
- (void)deletePlanImgForUIFailed:(NSDictionary *) dict;

- (void)addPlanImgForUISuccess;
- (void)addPlanImgForUIFailed:(NSDictionary *) dict;

@end

#endif
