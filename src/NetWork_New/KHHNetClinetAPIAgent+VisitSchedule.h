//
//  KHHNetClinetAPIAgent+VisitSchedule.h
//  CardBook
//
//  Created by 王定方 on 13-1-11.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent.h"
#import "KHHNetAgentVisitScheduleDelegates.h"
#import "OSchedule.h"

@interface KHHNetClinetAPIAgent (VisitSchedule)
/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=252
 * url visitPlan/sync/{timestamp}
 * 方法  get
 */
-(void)syncVisitScheduleWithDate:(NSString *) lastDate delegate:(id<KHHNetAgentVisitScheduleDelegates>) delegate;

/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=253
 * url visitPlan
 * 方法  post
 */
-(void)addVisitSchedule:(OSchedule *) oSchedule cardID:(long) cardID delegate:(id<KHHNetAgentVisitScheduleDelegates>) delegate;

/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=254
 * url visitPlan
 * 方法  put
 */
-(void)updateVisitSchedule:(OSchedule *) oSchedule delegate:(id<KHHNetAgentVisitScheduleDelegates>) delegate;

/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=255
 * url visitPlan/{id}
 * 方法   delete
 */
-(void)deleteVisitScheduleByID:(long) scheduleID delegate:(id<KHHNetAgentVisitScheduleDelegates>) delegate;

/*
 * 更新拜访计划图片
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=295
 * url visitPlan/{visitPlan_id}
 * 方法  put
 */
//- (void)uploadImage:(NSArray *)imgs forVisitSchedule:(long) scheduleID delegate:(id<KHHNetAgentVisitScheduleDelegates>) delegate;
- (void)uploadImage:(UIImage *)img forVisitSchedule:(long) scheduleID delegate:(id<KHHNetAgentVisitScheduleDelegates>) delegate;

/*
 * 删除拜访计划图片
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=296
 * url visitPlan/{visitPlan_id}/{visitPlanAttachment_ids}
 * visitPlanAttachment_ids 为多个时 拼装格式：图片id,多个使用“,”分割（英文逗号分割），如1,2,3
 * 方法   delete
 */
- (void)deleteImageByIDs:(NSString *) imageIDs fromVisitSchedule:(long) scheduleID delegate:(id<KHHNetAgentVisitScheduleDelegates>) delegate;
@end
