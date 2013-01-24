//
//  KHHDataNew+VisitSchedule.h
//  CardBook
//
//  Created by 王定方 on 13-1-15.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew.h"
#import "KHHDataVisitScheduleDelegate.h"
#import "KHHNetClinetAPIAgent+VisitSchedule.h"
//同步类型
typedef enum {
    KHHVisitScheduleSyncTypeAdd = 1,
    KHHVisitScheduleSyncTypeUpdate,
    KHHVisitScheduleSyncTypeDelete,
    KHHVisitScheduleSyncTypeSync,
}   KHHVisitScheduleSyncType;

@interface KHHDataNew (VisitSchedule) <KHHNetAgentVisitScheduleDelegates>

#pragma mark - 从本地取满足条件的拜访计划
- (NSArray *)allSchedules;
- (NSArray *)executingSchedules;
- (NSArray *)overdueSchedules;
- (NSArray *)finishedSchedules;
- (NSArray *)schedulesOnCard:(Card *)aCard day:(NSString *)aDay;// 结果是从day开始一天内的所有schedule。
- (NSArray *)schedulesOnCard:(Card *)aCard date:(NSDate *)aDate;// 结果是从day开始一天内的所有schedule。

// -1表示没有shcedule，0表示都完成了，大于0的数表示未完成的具体数量。
- (NSInteger)countOfUnfinishedSchedulesOnCard:(Card *)aCard day:(NSString *)aDay;
// -1表示没有shcedule，0表示都完成了，大于0的数表示未完成的具体数量。
- (NSInteger)countOfUnfinishedSchedulesOnCard:(Card *)aCard date:(NSDate *)aDate;

#pragma mark - 同步拜访计划
-(void)syncVisitSchedule:(id<KHHDataVisitScheduleDelegate>) delegate;

#pragma mark - 添加拜访计划
-(void)addVisitSchedule:(OSchedule *) oSchedule delegate:(id<KHHDataVisitScheduleDelegate>) delegate;

#pragma mark - 更新拜访计划
//-(void)updateVisitSchedule:(OSchedule *) oSchedule delegate:(id<KHHDataVisitScheduleDelegate>) delegate;
-(void)updateVisitSchedule:(OSchedule *) oSchedule needUploadImage:(NSArray *)imgs needDeleteImageIDs:(NSString *) imageIDs delegate:(id<KHHDataVisitScheduleDelegate>) delegate;

#pragma mark - 删除拜访计划
-(void)deleteVisitScheduleByID:(long) scheduleID delegate:(id<KHHDataVisitScheduleDelegate>) delegate;

//#pragma mark - 更新拜访计划图片
//- (void)uploadImage:(UIImage *)img forVisitSchedule:(long) scheduleID delegate:(id<KHHDataVisitScheduleDelegate>) delegate;
//
//#pragma mark - 删除拜访计划图片
//- (void)deleteImageByIDs:(NSString *) imageIDs fromVisitSchedule:(long) scheduleID delegate:(id<KHHDataVisitScheduleDelegate>) delegate;

@end
