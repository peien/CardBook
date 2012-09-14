//
//  KHHNetworkAPIAgent+Misc.h
//  CardBook
//
//  Created by 孙铭 on 8/29/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgent.h"
/*!
 Notification names
 */
// allDataAfterDate
static NSString * const KHHNotificationAllDataAfterDateSucceeded = @"allDataAfterDateSucceeded";
static NSString * const KHHNotificationAllDataAfterDateFailed    = @"allDataAfterDateFailed";
// allDataAfterDate
static NSString * const KHHNotificationLogoURLWithCompanyNameSucceeded = @"logoURLWithCompanyNameSucceeded";
static NSString * const KHHNotificationLogoURLWithCompanyNameFailed    = @"logoURLWithCompanyNameFailed";

@interface KHHNetworkAPIAgent (Misc)
/**
 增量同步所有数据 userPasswordService.syncAllInfo
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=183
 */
- (void)allDataAfterDate:(NSString *)lastDate;
/**
 公司logo kinghhCompanyService.getCompanyMessage
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=193
 */
- (BOOL)logoURLWithCompanyName:(NSString *)companyName;
@end
