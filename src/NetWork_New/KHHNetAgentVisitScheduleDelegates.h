//
//  KHHNetAgentVisitScheduleDelegates.h
//  CardBook
//
//  Created by 王定方 on 13-1-11.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef KHH_NetAgent_VisitSchedule_Delegates
#define KHH_NetAgent_VisitSchedule_Delegates
@protocol KHHNetAgentVisitScheduleDelegates <NSObject>
@optional
//同步拜访计划
-(void) syncVisitScheduleSuccess:(NSDictionary *) dict;
-(void) syncVisitScheduleFailed:(NSDictionary *) dict;
//新增拜访计划
-(void) addVisitScheduleSuccess:(NSDictionary *) dict;
-(void) addVisitScheduleFailed:(NSDictionary *) dict;
//更新拜访计划
-(void) updateVisitScheduleSuccess;
-(void) updateVisitScheduleFailed:(NSDictionary *) dict;
//删除拜访计划
-(void) deleteVisitScheduleSuccess;
-(void) deleteVisitScheduleFailed:(NSDictionary *) dict;
//上传拜访计划图片
-(void) uploadVisitScheduleImageSuccess;
-(void) uploadVisitScheduleImageFailed:(NSDictionary *) dict;
//删除拜访计划图片
-(void) deleteVisitScheduleImageSuccess;
-(void) deleteVisitScheduleImageFailed:(NSDictionary *) dict;
@end
#endif