//
//  KHHDataVisitScheduleDelegate.h
//  CardBook
//
//  Created by 王定方 on 13-1-15.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef CardBook_KHHDataVisitScheduleDelegate_h
#define CardBook_KHHDataVisitScheduleDelegate_h
@protocol KHHDataVisitScheduleDelegate <NSObject>
@optional
//同步拜访计划
-(void) syncVisitScheduleForUISuccess;
-(void) syncVisitScheduleForUIFailed:(NSDictionary *) dict;
//新增拜访计划
-(void) addVisitScheduleForUISuccess;
-(void) addVisitScheduleForUIFailed:(NSDictionary *) dict;
//更新拜访计划
-(void) updateVisitScheduleForUISuccess;
-(void) updateVisitScheduleForUIFailed:(NSDictionary *) dict;
//删除拜访计划
-(void) deleteVisitScheduleForUISuccess;
-(void) deleteVisitScheduleForUIFailed:(NSDictionary *) dict;
@end


#endif
