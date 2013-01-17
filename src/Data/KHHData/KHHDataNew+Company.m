//
//  KHHDataNew+Company.m
//  CardBook
//
//  Created by 王定方 on 13-1-15.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew+Company.h"
#import "InterCard.h"
#import "ReceivedCard.h"
@implementation KHHDataNew (Company)
#pragma mark - 获取公司logo
- (void) getCompanyLogo:(id<KHHDataCompanyDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent getCompanyLogo:self];
}


#pragma mark - 获取公司部门
- (void) getCompanyDepartment:(id<KHHDataCompanyDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent getCompanyDepartment:self];
}

#pragma mark - 获取公司logo
- (void) getCompanyColleagueByDepartmentID:(long) departmentID startPage:(int) startPage pageSize:(int) pageSize delegate:(id<KHHDataCompanyDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent getCompanyColleagueByDepartmentID:departmentID startPage:startPage pageSize:pageSize delegate:self];
}

#pragma mark - KHHNetAgentCompanyDelegates
//获取公司logo
- (void)getCompanyLogoSuccess:(NSDictionary *) dict
{
    DLog(@"getCompanyLogoSuccess! dict = %@", dict);
    NSString *logoUrl = dict[kInfoKeyCompanyLogo];
    DLog(@"company logo url = %@", logoUrl);
#warning 保存公司logoUrl
    if ([self.delegate respondsToSelector:@selector(getCompanyLogoForUISuccess)])
    {
        [self.delegate getCompanyLogoForUISuccess];
    }
}
- (void)getCompanyLogoFailed:(NSDictionary *) dict
{
    DLog(@"getCompanyLogoFailed! dict = %@", dict);
    if ([self.delegate respondsToSelector:@selector(getCompanyLogoForUIFailed:)])
    {
        [self.delegate getCompanyLogoForUIFailed:dict];
    }
}

//获取公司同事根据部门
- (void)getColleagueByDepartmentSuccess:(NSDictionary *) dict
{
    DLog(@"getColleagueByDepartmentSuccess! dict = %@", dict);
#warning 同事目前各联系人分开了，可能数据库要变，如果不变那么下面的2，3就不能记录，再次同步时会有重复数据
    //保存数据
     //1.receivedCardList {
    NSArray *colleague = dict[kInfoKeyReceivedCardList];
    if (colleague.count) {
        [ReceivedCard processIObjectList:colleague];
    }
    // }
//    //2.syncTime
//    [SyncMark UpdateKey:kSyncMarkKeyReceviedCardLastTime
//                  value:dict[kInfoKeySyncTime]];
//    //3.lastID
//    [SyncMark UpdateKey:kSyncMarkKeyReceviedCardLastID
//                  value:dict[kInfoKeyLastID]];
    // 4.保存
    ALog(@"[II] 同步联系人 save context!");
    [self saveContext];
    if ([self.delegate respondsToSelector:@selector(getColleagueByDepartmentForUISuccess:)]) {
        //如果需求是不保存那数据就原术返回到界面
        [self.delegate getColleagueByDepartmentForUISuccess:dict];
    }
}
- (void)getColleagueByDepartmentFailed:(NSDictionary *) dict
{
    DLog(@"getColleagueByDepartmentFailed! dict = %@", dict);
    if ([self.delegate respondsToSelector:@selector(getCompanyDepartmentsForUIFailed:)])
    {
        [self.delegate getCompanyDepartmentsForUIFailed:dict];
    }
}

//获取公司部门列表
- (void)getCompanyDepartmentsSuccess:(NSDictionary *) dict
{
    DLog(@"getCompanyDepartmentsSuccess! dict = %@", dict);
    //需求是不保存在本地，把数据直接返回
    if ([self.delegate respondsToSelector:@selector(getCompanyDepartmentsForUISuccess:)]) {
        [self.delegate getCompanyDepartmentsForUISuccess:dict];
    }
    
}
- (void)getCompanyDepartmentsFailed:(NSDictionary *) dict
{
    DLog(@"getCompanyDepartmentsFailed! dict = %@", dict);
    if ([self.delegate respondsToSelector:@selector(getCompanyDepartmentsForUIFailed:)])
    {
        [self.delegate getCompanyDepartmentsForUIFailed:dict];
    }
}
@end
