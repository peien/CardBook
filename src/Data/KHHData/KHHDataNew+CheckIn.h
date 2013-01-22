//
//  KHHDataNew+CheckIn.h
//  CardBook
//
//  Created by 王定方 on 13-1-15.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew.h"
#import "KHHDataCheckInDelegate.h"
#import "KHHNetClinetAPIAgent+CheckIn.h"
@interface KHHDataNew (CheckIn) <KHHNetAgentCheckInDelegates>
#pragma mark - 员工签到
- (void)doCheckIn:(ICheckIn *)iCheckIn delegate:(id<KHHDataCheckInDelegate>) delegate;

#pragma mark - 增量获取员工签到记录
- (void)syncMySelfCheckInRecordWithCardID:(long) cardID delegate:(id<KHHDataCheckInDelegate>) delegate;

#pragma mark - 增量获取员工签到记录
- (void)syncSubordinateCheckInRecordWithPage:(NSString *) startPage pageSize:(NSString *) pageSize cardID:(long) cardID delegate:(id<KHHDataCheckInDelegate>) delegate;
@end
