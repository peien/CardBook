//
//  KHHDataNew+VisitSchedule.m
//  CardBook
//
//  Created by 王定方 on 13-1-15.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew+VisitSchedule.h"
#import "NSObject+SM.h"
#import "Card.h"

@implementation KHHDataNew (VisitSchedule)

#pragma mark - 从本地取满足条件的拜访计划
- (NSArray *)allSchedules {
    NSPredicate *predicate = nil;
    //    predicate = [NSPredicate predicateWithFormat:@"company.id <> %@", myComID];
    
    NSSortDescriptor *sortDes = [NSSortDescriptor sortDescriptorWithKey:@"isFinished"
                                                              ascending:YES];
    NSSortDescriptor *timeSort = [NSSortDescriptor sortDescriptorWithKey:@"plannedDate"
                                                               ascending:NO];
    NSArray *result = [Schedule objectArrayByPredicate:predicate
                                       sortDescriptors:@[sortDes,timeSort]];
    return result;
}

//正在执行
- (NSArray *)executingSchedules
{
    NSPredicate *predicate = nil;
    predicate = [NSPredicate predicateWithFormat:@"isFinished = no AND plannedDate >= %@", [NSDate new]];
    
    NSSortDescriptor *timeSort = [NSSortDescriptor sortDescriptorWithKey:@"plannedDate"
                                                               ascending:NO];
    NSArray *result = [Schedule objectArrayByPredicate:predicate
                                       sortDescriptors:@[timeSort]];
    return result;
}

//过期的拜访记录
- (NSArray *)overdueSchedules
{
    NSPredicate *predicate = nil;
    predicate = [NSPredicate predicateWithFormat:@"isFinished = no AND plannedDate < %@", [NSDate new]];
    
    NSSortDescriptor *timeSort = [NSSortDescriptor sortDescriptorWithKey:@"plannedDate"
                                                               ascending:NO];
    NSArray *result = [Schedule objectArrayByPredicate:predicate
                                       sortDescriptors:@[timeSort]];
    return result;
}

//完成的
- (NSArray *)finishedSchedules
{
    NSPredicate *predicate = nil;
    predicate = [NSPredicate predicateWithFormat:@"isFinished <> no"];
    
    NSSortDescriptor *sortDes = [NSSortDescriptor sortDescriptorWithKey:@"isFinished"
                                                              ascending:YES];
    NSSortDescriptor *timeSort = [NSSortDescriptor sortDescriptorWithKey:@"plannedDate"
                                                               ascending:NO];
    NSArray *result = [Schedule objectArrayByPredicate:predicate
                                       sortDescriptors:@[sortDes,timeSort]];
    return result;
}

- (NSArray *)schedulesOnCard:(Card *)aCard day:(NSString *)aDay {
    NSDate *date = DateFromKHHDateString([aDay stringByAppendingString:@" 00:00:00"]);
    return [self schedulesOnCard:aCard date:date];
}
- (NSArray *)schedulesOnCard:(Card *)aCard date:(NSDate *)aDate {
    NSDate *start = aDate;
    NSTimeInterval oneDay = 60 * 60 * 24;
    NSDate *end = [start dateByAddingTimeInterval:oneDay];
    NSPredicate *predicate;
    if (aCard) {
        predicate = [NSPredicate predicateWithFormat:@"plannedDate >= %@ && plannedDate < %@ && SOME targets.id == %@", start, end, aCard.id];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"plannedDate >= %@ && plannedDate < %@", start, end];
    }
    NSSortDescriptor *sortDes = [NSSortDescriptor sortDescriptorWithKey:@"id"
                                                              ascending:NO];
    NSArray *result = [Schedule objectArrayByPredicate:predicate
                                       sortDescriptors:@[sortDes]];
    return result;
}
- (NSInteger)countOfUnfinishedSchedulesOnCard:(Card *)aCard day:(NSString *)aDay; {
    NSDate *start = DateFromKHHDateString([aDay stringByAppendingString:@" 00:00:00"]);
    return [self countOfUnfinishedSchedulesOnCard:aCard date:start];
}
- (NSInteger)countOfUnfinishedSchedulesOnCard:(Card *)aCard date:(NSDate *)aDate {
    NSArray *list = [self schedulesOnCard:aCard date:aDate];
    if (0 == list.count) {
        return -1;
    }
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:list.count];
    for (Schedule *schdl in list) {
        if(schdl.isFinishedValue) continue;
        [result addObject:schdl];
    }
    return result.count;
}

#pragma mark - 同步拜访计划
-(void)syncVisitSchedule:(id<KHHDataVisitScheduleDelegate>) delegate
{
    [self syncVisitSchedule:delegate syncType:KHHVisitScheduleSyncTypeSync];
}

-(void)syncVisitSchedule:(id<KHHDataVisitScheduleDelegate>) delegate syncType:(KHHVisitScheduleSyncType) syncType
{
    self.delegate = delegate;
    self.syncType = syncType;
    //获取上次同步时间
    SyncMark *syncMark = [SyncMark syncMarkByKey:kSyncMarkKeyVisitScheduleLastTime];
    [self.agent syncVisitScheduleWithDate:syncMark.value delegate:self];
}

#pragma mark - 添加拜访计划
-(void)addVisitSchedule:(OSchedule *) oSchedule cardID:(long) cardID delegate:(id<KHHDataVisitScheduleDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent addVisitSchedule:oSchedule cardID:cardID delegate:self];
}

#pragma mark - 更新拜访计划
-(void)updateVisitSchedule:(OSchedule *) oSchedule needUploadImage:(NSArray *)imgs needDeleteImageIDs:(NSString *) imageIDs delegate:(id<KHHDataVisitScheduleDelegate>) delegate
{
    self.delegate = delegate;
    self.hasFailed = NO;
    //删除老图片
    if (imageIDs.length > 0) {
        [self.agent deleteImageByIDs:imageIDs fromVisitSchedule:oSchedule.id.longValue delegate:self];
    }
    
    //上传新图片
    for (UIImage *img in imgs) {
        if (!self.hasFailed) {
            [self.agent uploadImage:img forVisitSchedule:oSchedule.id.longValue delegate:self];
        }else {
            break;
        }
    }
    
    //更新基本信息
    if (!self.hasFailed) {
        [self.agent updateVisitSchedule:oSchedule delegate:self];
    }
}

#pragma mark - 删除拜访计划
-(void)deleteVisitScheduleByID:(long) scheduleID delegate:(id<KHHDataVisitScheduleDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent deleteVisitScheduleByID:scheduleID delegate:self];
}

#pragma mark - KHHNetAgentVisitScheduleDelegates
//同步拜访计划
-(void) syncVisitScheduleSuccess:(NSDictionary *) dict
{
    DLog(@"syncVisitScheduleSuccess ! dict = %@", dict);
    //同步成功，把返回的拜访计划（插入、修改、删除）到本地数据库
    // 1.List
    NSArray *list = dict[kInfoKeyObjectList];
    [Schedule processIObjectList:list];
    // 2.Timestamp
    [SyncMark UpdateKey:kSyncMarkKeyVisitScheduleLastTime
                  value:dict[kInfoKeySyncTime]];
    // 3.保存
    [self saveContext];
    //告诉界面同步成功
    switch (self.syncType) {
        case KHHVisitScheduleSyncTypeAdd:
        {
            if ([self.delegate respondsToSelector:@selector(addVisitScheduleForUISuccess)]) {
                [self.delegate addVisitScheduleForUISuccess];
            }
        }
            break;
        case KHHVisitScheduleSyncTypeUpdate:
        {
            if ([self.delegate respondsToSelector:@selector(updateVisitScheduleForUISuccess)]) {
                [self.delegate updateVisitScheduleForUISuccess];
            }
        }
            break;
        case KHHVisitScheduleSyncTypeDelete:
        {
            if ([self.delegate respondsToSelector:@selector(deleteVisitScheduleForUISuccess)]) {
                [self.delegate deleteVisitScheduleForUISuccess];
            }
        }
            break;
        default:
            //默认就是同步
        {
            if ([self.delegate respondsToSelector:@selector(syncVisitScheduleForUISuccess)]) {
                [self.delegate syncVisitScheduleForUISuccess];
            }
        }
            break;
    }
    
}
-(void) syncVisitScheduleFailed:(NSDictionary *) dict
{
    DLog(@"syncVisitScheduleFailed ! dict = %@", dict);
    switch (self.syncType) {
        case KHHVisitScheduleSyncTypeAdd:
        {
            if ([self.delegate respondsToSelector:@selector(addVisitScheduleForUIFailed:)]) {
                [self.delegate addVisitScheduleForUIFailed: dict];
            }
        }
            break;
        case KHHVisitScheduleSyncTypeUpdate:
        {
            if ([self.delegate respondsToSelector:@selector(updateVisitScheduleForUIFailed:)]) {
                [self.delegate updateVisitScheduleForUIFailed: dict];
            }
        }
            break;
        case KHHVisitScheduleSyncTypeDelete:
        {
            if ([self.delegate respondsToSelector:@selector(deleteVisitScheduleForUIFailed:)]) {
                [self.delegate deleteVisitScheduleForUIFailed: dict];
            }
        }
            break;
        default:
            //默认就是同步
        {
            if ([self.delegate respondsToSelector:@selector(syncVisitScheduleForUIFailed:)]) {
                [self.delegate syncVisitScheduleForUIFailed: dict];
            }
        }
            break;
    }
    
}
//新增拜访计划
-(void) addVisitScheduleSuccess:(NSDictionary *) dict
{
    DLog(@"addVisitScheduleSuccess ! dict = %@", dict);
    //添加成功成功，把返回的拜访计划（插入）到本地数据库，建议与服务器进行一次同步
   // [self syncVisitSchedule:self.delegate syncType: KHHVisitScheduleSyncTypeAdd];
}
-(void) addVisitScheduleFailed:(NSDictionary *) dict
{
    DLog(@"addVisitScheduleFailed ! dict = %@", dict);
    if ([self.delegate respondsToSelector:@selector(addVisitScheduleForUIFailed:)]) {
        [self.delegate addVisitScheduleForUIFailed: dict];
    }
}
//更新拜访计划
-(void) updateVisitScheduleSuccess
{
    DLog(@"updateVisitScheduleSuccess !");
    //说明在完成当前请求前，已经有出错的了，所以这里对处理结果忽略掉
    if (self.hasFailed) {
        return;
    }
    
    //更新成功，把相应的数据更新到本地数据库，这里没参数返回是建议与服务器同步一次
    [self syncVisitSchedule:self.delegate syncType:KHHVisitScheduleSyncTypeUpdate];
}
-(void) updateVisitScheduleFailed:(NSDictionary *) dict
{
    DLog(@"updateVisitScheduleFailed ! dict = %@", dict);
    if (self.hasFailed) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(updateVisitScheduleForUIFailed:)]) {
        [self.delegate updateVisitScheduleForUIFailed: dict];
    }
}
//删除拜访计划
-(void) deleteVisitScheduleSuccess
{
    DLog(@"deleteVisitScheduleSuccess !");
    //删除成功，从本地数据库把相应的数据删除，这里没返回相应数据是建议立即与服务器做次同步
    [self syncVisitSchedule:self.delegate syncType:KHHVisitScheduleSyncTypeDelete];
}
-(void) deleteVisitScheduleFailed:(NSDictionary *) dict
{
    DLog(@"deleteVisitScheduleFailed ! dict = %@", dict);
    if ([self.delegate respondsToSelector:@selector(deleteVisitScheduleForUIFailed:)]) {
        [self.delegate deleteVisitScheduleForUIFailed: dict];
    }
}
//上传拜访计划图片
-(void) uploadVisitScheduleImageSuccess
{
    DLog(@"uploadVisitScheduleImageSuccess !");
}

-(void) uploadVisitScheduleImageFailed:(NSDictionary *) dict
{
    DLog(@"uploadVisitScheduleImageFailed ! dict = %@", dict);
    //在完成此操作前，没有操作失败的请求
    if (!self.hasFailed) {
        //标记有失败
        self.hasFailed = YES;
        //直接返回给界面
        [self updateVisitScheduleFailed:dict];
    }
}
//删除拜访计划图片
-(void) deleteVisitScheduleImageSuccess
{
    DLog(@"deleteVisitScheduleImageSuccess !");
}
-(void) deleteVisitScheduleImageFailed:(NSDictionary *) dict
{
    DLog(@"deleteVisitScheduleImageFailed ! dict = %@", dict);
    //在完成此操作前，没有操作失败的请求
    if (!self.hasFailed) {
        //标记有失败
        self.hasFailed = YES;
        //直接返回给界面
        [self updateVisitScheduleFailed:dict];
    }
}
@end
