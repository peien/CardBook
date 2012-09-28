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
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *op, id response) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:response];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:responseDict.count];
        KHHNetworkStatusCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        // 把返回的数据转成本地数据
        if (KHHNetworkStatusCodeSucceeded == code) {
            // MyCard List
            NSArray *oldMyCardList = responseDict[JSONDataKeyMyCard];
            NSMutableArray *myCardList = [NSMutableArray arrayWithCapacity:oldMyCardList.count];
            for (NSDictionary *oldCard in oldMyCardList) {
                InterCard *card = [InterCard interCardWithMyCardJSON:oldCard];
                [myCardList addObject:card];
            }
            dict[kInfoKeyMyCardList] = myCardList;
            
            // PrivateCard List
            NSArray *oldPrivateCardList = responseDict[JSONDataKeyMyPrivateCard];
            NSMutableArray *privateCardList = [NSMutableArray arrayWithCapacity:oldPrivateCardList.count];
            for (NSDictionary *oldCard in oldPrivateCardList) {
                InterCard *card = [InterCard interCardWithPrivateCardJSON:oldCard];
                [privateCardList addObject:card];
            }
            dict[kInfoKeyPrivateCardList] = privateCardList;
            
            // Template List
            NSArray *templateList = responseDict[JSONDataKeyTemplateList];
            dict[kInfoKeyTemplateList] = templateList;
            
            // 运营商推广连接
            NSArray *ICPList = responseDict[JSONDataKeyLinkList];
            dict[kInfoKeyICPPromotionLinkList] = ICPList;
            
            // 公司推广连接
            NSArray *comProList = responseDict[JSONDataKeyCompanyLinkList];
            dict[kInfoKeyCompanyPromotionLinkList] = comProList;
            
            // Sync Time
            NSString *syncTime = responseDict[JSONDataKeySynTime];
            dict[kInfoKeySyncTime] = syncTime;
        }
        
        dict[kInfoKeyErrorCode] = @(code);
        dict[kInfoKeyExtra] = extra;
        
        NSString *noti = (KHHNetworkStatusCodeSucceeded == code)?
        KHHNetworkAllDataAfterDateSucceeded
        : KHHNetworkAllDataAfterDateFailed;
        [self postASAPNotificationName:noti info:dict];
    };
    [self postAction:@"allDataAfterDate"
               query:@"userPasswordService.syncAllInfo"
          parameters:parameters
             success:success
               extra:extra];
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
          parameters:parameters
             success:nil];
    return YES;
}
@end
