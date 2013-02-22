//
//  KHHNetAgentSignPlanDelegate.h
//  CardBook
//
//  Created by CJK on 13-1-23.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef CardBook_KHHNetAgentSignPlanDelegate_h
#define CardBook_KHHNetAgentSignPlanDelegate_h
@protocol KHHNetAgentSignPlanDelegate <NSObject>
@optional
//同步拜访计划
-(void) syncPlanSuccess:(NSDictionary *) dict;
-(void) syncPlanFailed:(NSDictionary *) dict;
//新增拜访计划
-(void) addPlanSuccess:(NSDictionary *) dict;
-(void) addPlanFailed:(NSDictionary *) dict;
//更新拜访计划
-(void) updatePlanSuccess;
-(void) updatePlanFailed:(NSDictionary *) dict;
//删除拜访计划
-(void) deletePlanSuccess;
-(void) deletePlanFailed:(NSDictionary *) dict;
//上传拜访计划图片
-(void) addPlanImgSuccess;
-(void) addPlanImgFailed:(NSDictionary *) dict;
//删除拜访计划图片
-(void) deletePlanImgSuccess;
-(void) deletePlanImgFailed:(NSDictionary *) dict;



@end
#endif
