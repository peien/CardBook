//
//  KHHNetAgentCheckInDelegates.h
//  CardBook
//
//  Created by 王定方 on 13-1-13.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef KHH_NetAgent_CheckIn_Delegates
#define KHH_NetAgent_CheckIn_Delegates
@protocol KHHNetAgentCheckInDelegates <NSObject>
@optional
//员工签到
- (void)checkInSuccess;
- (void)checkInFailed:(NSDictionary *) dict;

//增量获取签到记录（登录用户自己的签到记录）
- (void)syncMySelfCheckInRecordSuccess:(NSDictionary *) dict;
- (void)syncMySelfCheckInRecordFailed:(NSDictionary *) dict;

//分页获取签到记录（上级看下级）
- (void)syncSubordinateCheckInRecordSuccess:(NSDictionary *) dict;
- (void)syncSubordinateCheckInRecordFailed:(NSDictionary *) dict;
@end
#endif