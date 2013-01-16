//
//  KHHNetClinetAPIAgent+CheckIn.h
//  CardBook
//
//  Created by 王定方 on 13-1-13.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent.h"
#import "KHHNetAgentCheckInDelegates.h"
@class ICheckIn;
@interface KHHNetClinetAPIAgent (CheckIn)
/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=276
 * 员工签到
 * url checkIn
 * 方法 post
 */
- (void)checkIn:(ICheckIn *)iCheckIn delegate:(id<KHHNetAgentCheckInDelegates>) delegate;

/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=278
 * 增量获取员工签到记录
 * url checkIn/{cardId}/{lastUpdateDateStr}
 * 方法 get
 */
- (void)syncMySelfCheckInRecordWithDate:(NSString *) lastDate cardID:(long) cardID delegate:(id<KHHNetAgentCheckInDelegates>) delegate;

/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=279
 * 增量获取员工签到记录
 * url checkIn/history/{cardId}/{startPage}/{ pageSize}/{lastUpdateDateStr}
 * 方法 get
 */
- (void)syncSubordinateCheckInRecordWithPage:(NSString *) startPage pageSize:(NSString *) pageSize cardID:(long) cardID lastDate:(NSString *) lastDate delegate:(id<KHHNetAgentCheckInDelegates>) delegate;
@end
