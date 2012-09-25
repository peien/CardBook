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
- (void)allDataAfterDate:(NSString *)lastDate extra:(NSDictionary *)extra {
    NSDictionary *parameters = @{
    @"lastUpdTime" : [lastDate length] > 0? lastDate: @""
    };
    [self postAction:@"allDataAfterDate"
               extra:extra
               query:@"userPasswordService.syncAllInfo"
          parameters:parameters];
}
- (void)allDataAfterDateResultCode:(KHHNetworkStatusCode)code
                              info:(NSMutableDictionary *)dict {
    NSString *notiName = (KHHNetworkStatusCodeSucceeded == code)?
    KHHNetworkAllDataAfterDateSucceeded
    : KHHNetworkAllDataAfterDateFailed;
    
    DLog(@"[II] dict keys = %@", [dict allKeys]);
    // 把返回的数据转成本地数据
    if (KHHNetworkStatusCodeSucceeded == code) {
        // MyCard List
        NSArray *mCardList = dict[JSONDataKeyMyCard];
        dict[kInfoKeyMyCardList] = mCardList;
        [dict removeObjectForKey:JSONDataKeyMyCard];
        // PrivateCard List
        NSArray *pCardList = dict[JSONDataKeyMyPrivateCard];
        dict[kInfoKeyPrivateCardList] = pCardList;
        [dict removeObjectForKey:JSONDataKeyMyPrivateCard];
        // Template List
        NSArray *tList = dict[JSONDataKeyTemplateList];
        dict[kInfoKeyTemplateList] = tList;
        [dict removeObjectForKey:JSONDataKeyTemplateList];
        // 运营商推广连接
        NSArray *ICPList = dict[JSONDataKeyLinkList];
        dict[kInfoKeyICPPromotionLinkList] = ICPList;
        [dict removeObjectForKey:JSONDataKeyLinkList];
        // 公司推广连接
        NSArray *comProList = dict[JSONDataKeyCompanyLinkList];
        dict[kInfoKeyCompanyPromotionLinkList] = comProList;
        [dict removeObjectForKey:JSONDataKeyCompanyLinkList];
        // Sync Time
        NSString *syncTime = dict[JSONDataKeySynTime];
        dict[kInfoKeySyncTime] = syncTime;
        [dict removeObjectForKey:JSONDataKeySynTime];
    }
    
    [self postASAPNotificationName:notiName info:dict];
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
