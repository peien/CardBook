//
//  KHHNetworkAPIAgent+VisitSchedule.h
//  CardBook
//
//  Created by 孙铭 on 8/29/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgent.h"
#import "KHHTypes.h"
#import "Schedule.h"

BOOL ScheduleHasRequiredAttributes(Schedule *visitSchedule,
                                   KHHScheduleAttributeType attributes);
NSMutableDictionary * ParametersFromSchedule(Schedule *visitSchedule,
                                             KHHScheduleAttributeType attributes);
@interface KHHNetworkAPIAgent (VisitSchedule)
/**
 新建拜访计划 kinghhVisitCustomPlanService.create
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=156
 */
- (BOOL)createVisitSchedule:(Schedule *)visitSchedule;

/**
 修改拜访计划 kinghhVisitCustomPlanService.update
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=158
 */
- (BOOL)updateVisitSchedule:(Schedule *)visitSchedule;

/**
 删除拜访计划 kinghhVisitCustomPlanService.delete
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=159
 */
- (BOOL)deleteVisitSchedule:(Schedule *)visitSchedule;

/**
 拜访计划增量 kinghhVisitCustomPlanService.incList
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=155
 */
- (void)visitSchedulesAfterDate:(NSString *)lastDate;
/**
 上传拜访图片 kinghhVisitCustomPlanService.uploadImg
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=161
 */
- (BOOL)uploadImage:(NSString *)imgPath
   forVisitSchedule:(Schedule *)visitSchedule;
/**
 删除拜访图片 kinghhVisitCustomPlanService.delImg
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=160
 */
//- (BOOL)deleteImage:(NSString *)imgID
//  fromVisitSchedule:(Schedule *)visitSchedule;
@end
