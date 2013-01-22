//
//  KHHDataNew+CheckIn.m
//  CardBook
//
//  Created by 王定方 on 13-1-15.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew+CheckIn.h"
#import "ICheckInForNetwork.h"
@implementation KHHDataNew (CheckIn)
#pragma mark - 员工签到
- (void)doCheckIn:(ICheckIn *)iCheckIn delegate:(id<KHHDataCheckInDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent checkIn:iCheckIn delegate:self];
}

#pragma mark - 增量获取员工签到记录
- (void)syncMySelfCheckInRecordWithCardID:(long) cardID delegate:(id<KHHDataCheckInDelegate>) delegate
{
    self.delegate = delegate;
    SyncMark *syncMark = [SyncMark syncMarkByKey:kSyncMarkKeySyncCheckInRecordsLastTime];
    [self.agent syncMySelfCheckInRecordWithDate:syncMark.value cardID:cardID delegate:self];
}

#pragma mark - 增量获取员工签到记录
- (void)syncSubordinateCheckInRecordWithPage:(NSString *) startPage pageSize:(NSString *) pageSize cardID:(long) cardID delegate:(id<KHHDataCheckInDelegate>) delegate
{
    //因为看下级记录是不保存在数据库中，每次都去拿，所以时间戳传空
    self.delegate = delegate;
    [self.agent syncSubordinateCheckInRecordWithPage:startPage pageSize:pageSize cardID:cardID lastDate:nil delegate:self];
}

#pragma mark - KHHNetAgentCheckInDelegates
//员工签到
- (void)checkInSuccess
{
    DLog(@"checkInSuccess")
    if([self.delegate respondsToSelector:@selector(checkInForUISuccess)])
    {
        [self.delegate checkInForUISuccess];
    }
}
- (void)checkInFailed:(NSDictionary *) dict
{
    DLog(@"checkInFailed")
    if([self.delegate respondsToSelector:@selector(checkInForUIFailed:)])
    {
        [self.delegate checkInForUIFailed:dict];
    }
}

//增量获取签到记录（登录用户自己的签到记录）
- (void)syncMySelfCheckInRecordSuccess:(NSDictionary *) dict
{
    DLog(@"syncMySelfCheckInRecordSuccess! dict = %@", dict);
    //把数据保存在本地
    NSArray *checkInRecord = dict[kInfoKeyObjectList];
    for (ICheckInForNetwork *record in checkInRecord) {
#warning 插入签到表中，表现在没有创建
    }
    if([self.delegate respondsToSelector:@selector(syncMySelfCheckInRecordForUISuccess)])
    {
        [self.delegate syncMySelfCheckInRecordForUISuccess];
    }
}
- (void)syncMySelfCheckInRecordFailed:(NSDictionary *) dict
{
    DLog(@"checkInFailed")
    if([self.delegate respondsToSelector:@selector(syncMySelfCheckInRecordForUIFailed:)])
    {
        [self.delegate syncMySelfCheckInRecordForUIFailed:dict];
    }
}

//分页获取签到记录（上级看下级）
- (void)syncSubordinateCheckInRecordSuccess:(NSDictionary *) dict
{
    //因为数据不保存，把解析好的数据直接返回给界面
    DLog(@"syncSubordinateCheckInRecordSuccess")
    if([self.delegate respondsToSelector:@selector(syncSubordinateCheckInRecordForUISuccess:)])
    {
        [self.delegate syncSubordinateCheckInRecordForUISuccess:dict];
    }
}
- (void)syncSubordinateCheckInRecordFailed:(NSDictionary *) dict
{
    DLog(@"syncSubordinateCheckInRecordFailed")
    if([self.delegate respondsToSelector:@selector(syncSubordinateCheckInRecordForUIFailed:)])
    {
        [self.delegate syncSubordinateCheckInRecordForUIFailed:dict];
    }
}
@end
