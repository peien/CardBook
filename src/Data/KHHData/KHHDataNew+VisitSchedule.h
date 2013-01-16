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
@property (assign, nonatomic) KHHVisitScheduleSyncType syncType;

#pragma mark - 同步拜访计划
-(void)syncVisitSchedule:(id<KHHDataVisitScheduleDelegate>) delegate;

#pragma mark - 添加拜访计划
-(void)addVisitSchedule:(OSchedule *) oSchedule cardID:(long) cardID delegate:(id<KHHDataVisitScheduleDelegate>) delegate;

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
