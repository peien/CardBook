//
//  KHHNetworkAPIAgent+Misc.m
//  CardBook
//
//  Created by 孙铭 on 8/29/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgent+Misc.h"

@implementation KHHNetworkAPIAgent (Misc)
/**
 增量同步所有数据 userPasswordService.syncAllInfo
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=183
 */
- (void)allDataAfterDate:(NSString *)lastDate {
    NSDictionary *parameters = @{
    @"lastUpdTime" : [lastDate length] > 0? lastDate: @""
    };
    [self postAction:@"allDataAfterDate"
               query:@"userPasswordService.syncAllInfo"
          parameters:parameters];
}
/**
 公司logo kinghhCompanyService.getCompanyMessage
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=193
 */
- (BOOL)logoURLWithCompanyName:(NSString *)companyName {
    if (0 == companyName.length) {
        // companyName为nil或@“”
        return NO;
    }
    NSDictionary *parameters = @{ @"companyName" : companyName };
    [self postAction:@"logoURLWithCompanyName"
               query:@"kinghhCompanyService.getCompanyMessage"
          parameters:parameters];
    return YES;
}
@end
