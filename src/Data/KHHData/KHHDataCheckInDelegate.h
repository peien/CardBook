//
//  KHHDataCheckInDelegate.h
//  CardBook
//
//  Created by 王定方 on 13-1-15.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef CardBook_KHHDataCheckInDelegate_h
#define CardBook_KHHDataCheckInDelegate_h
@protocol KHHDataCheckInDelegate <NSObject>
@optional
//员工签到
- (void)checkInForUISuccess;
- (void)checkInForUIFailed:(NSDictionary *) dict;

//增量获取签到记录（登录用户自己的签到记录）
- (void)syncMySelfCheckInRecordForUISuccess;
- (void)syncMySelfCheckInRecordForUIFailed:(NSDictionary *) dict;

//分页获取签到记录（上级看下级）
- (void)syncSubordinateCheckInRecordForUISuccess:(NSDictionary *) dict;
- (void)syncSubordinateCheckInRecordForUIFailed:(NSDictionary *) dict;
@end


#endif
