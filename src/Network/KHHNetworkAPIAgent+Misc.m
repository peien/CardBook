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
                              info:(NSDictionary *)dict {
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionaryWithCapacity:dict.count];
    
    // 把返回的数据转成本地数据
    if (KHHNetworkStatusCodeSucceeded == code) {
        // MyCard List
        NSArray *oldMyCardList = dict[JSONDataKeyMyCard];
        NSMutableArray *myCardList = [NSMutableArray arrayWithCapacity:oldMyCardList.count];
        for (NSDictionary *oldCard in oldMyCardList) {
            InterCard *card = [InterCard interCardWithMyCardJSON:oldCard];
            [myCardList addObject:card];
        }
        resultDict[kInfoKeyMyCardList] = myCardList;
        
        // PrivateCard List
        NSArray *oldPrivateCardList = dict[JSONDataKeyMyPrivateCard];
        NSMutableArray *privateCardList = [NSMutableArray arrayWithCapacity:oldPrivateCardList.count];
        for (NSDictionary *oldCard in oldPrivateCardList) {
            InterCard *card = [InterCard interCardWithPrivateCardJSON:oldCard];
            [privateCardList addObject:card];
        }
        resultDict[kInfoKeyPrivateCardList] = privateCardList;
        
        // Template List
        NSArray *templateList = dict[JSONDataKeyTemplateList];
        resultDict[kInfoKeyTemplateList] = templateList;

        // 运营商推广连接
        NSArray *ICPList = dict[JSONDataKeyLinkList];
        resultDict[kInfoKeyICPPromotionLinkList] = ICPList;

        // 公司推广连接
        NSArray *comProList = dict[JSONDataKeyCompanyLinkList];
        resultDict[kInfoKeyCompanyPromotionLinkList] = comProList;

        // Sync Time
        NSString *syncTime = dict[JSONDataKeySynTime];
        resultDict[kInfoKeySyncTime] = syncTime;
    }
    
    NSString *notiName = (KHHNetworkStatusCodeSucceeded == code)?
    KHHNetworkAllDataAfterDateSucceeded
    : KHHNetworkAllDataAfterDateFailed;
    [self postASAPNotificationName:notiName info:resultDict];
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
