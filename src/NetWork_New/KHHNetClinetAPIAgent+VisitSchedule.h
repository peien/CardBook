//
//  KHHNetClinetAPIAgent+VisitSchedule.h
//  CardBook
//
//  Created by 王定方 on 13-1-11.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent.h"
#import "KHHNetAgentVisitScheduleDelegates.h"
#import "ISchedule.h"

@interface KHHNetClinetAPIAgent (VisitSchedule)
/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=252
 * url visitPlan/sync/{timestamp}
 * 方法  get
 */
-(void) syncVisitScheduleWithDate:(NSString *) lastDate delegate:(id<KHHNetAgentVisitScheduleDelegates>) delegate;

/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=253
 * url visitPlan
 * 方法  post
 */
-(void) addVisitSchedule:(ISchedule *) schedule cardID:(long) cardID delegate:(id<KHHNetAgentVisitScheduleDelegates>) delegate;

/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=254
 * url visitPlan
 * 方法  put
 */
-(void) updateVisitSchedule:(ISchedule *) schedule delegate:(id<KHHNetAgentVisitScheduleDelegates>) delegate;

/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=255
 * url visitPlan/{id}
 * 方法   delete
 */
-(void) deleteVisitScheduleByID:(long) scheduleID delegate:(id<KHHNetAgentVisitScheduleDelegates>) delegate;
@end
