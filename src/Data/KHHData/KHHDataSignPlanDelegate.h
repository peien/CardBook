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
-(void) syncVisitScheduleForUISuccess;
-(void) syncVisitScheduleForUIFailed:(NSDictionary *) dict;
//新增拜访计划
-(void) addPlanForUISuccess;
-(void) addPlanForUIFailed:(NSDictionary *) dict;
//更新拜访计划
-(void) updateVisitScheduleForUISuccess;
-(void) updateVisitScheduleForUIFailed:(NSDictionary *) dict;
//删除拜访计划
-(void) deleteVisitScheduleForUISuccess;
-(void) deleteVisitScheduleForUIFailed:(NSDictionary *) dict;
@end

#endif
