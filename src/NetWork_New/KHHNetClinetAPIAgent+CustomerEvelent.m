//
//  KHHNetClinetAPIAgent+CustomerEvelent.m
//  CardBook
//
//  Created by CJK on 13-1-24.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent+CustomerEvelent.h"
#import "ICustomerEvaluation.h"
#import "MyCard.h"

@implementation KHHNetClinetAPIAgent (CustomerEvelent)
- (void)customerEvaluationListAfterDate:(NSString *)lastDate
                                  extra:(NSDictionary *)extra {
    NSString *action = @"customerEvaluationListAfterDate";
    NSDictionary *parameters = @{
    @"lastUpdTime" : [lastDate length] > 0? lastDate: @""
    };
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *op, id response) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:response];
        DLog(@"[II] response keys = %@", [responseDict allKeys]);
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
        
        // 把返回的数据转成本地数据
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        if (KHHErrorCodeSucceeded == code) {
            // count
            dict[kInfoKeyCount] = responseDict[JSONDataKeyCount];
            
            // synTime -> syncTime
            NSString *syncTime = responseDict[JSONDataKeySynTime];
            dict[kInfoKeySyncTime] = syncTime? syncTime: @"";
            
            // customerAppraise -> customerEvaluationList
            NSArray *oldList = responseDict[JSONDataKeyCustomerAppraiseList];
            NSMutableArray *newList = [NSMutableArray arrayWithCapacity:oldList.count];
            for (id obj in oldList) {
                ICustomerEvaluation *icv = [ICustomerEvaluation iCustomerEvaluationWithJSON:obj];
                [newList addObject:icv];
            }
            dict[kInfoKeyObjectList] = newList;
        }
        
        // errorCode 和 extra
        dict[kInfoKeyErrorCode] = @(code);
        if (extra) {
            dict[kInfoKeyExtra] = extra;
        }
        // 把处理完的数据发出去。
       // [self postASAPNotificationName:NameWithActionAndCode(action, code)
       //                           info:dict];
    };
//    [self postAction:action
//               query:@"customerAppraiseService.synCustomerAppraise"
//          parameters:parameters
//             success:success
//               extra:extra];
}

/*!
 客户评估信息新增和修改
 新增：
 customerAppraiseService.addCustomerAppraise
 修改：
 customerAppraiseService.updateCustomerAppraise
 参数：
 customerAppraise.id 	 Long 	 否 	 id（andriod客户端没有这张表不使用）
 customerAppraise.cardId 	 Long 	 否 	 当前用户对应名片ID
 customerAppraise.version 	 int 	 否 	 当前用户对应名片版本号
 customerAppraise.customCardId 	 Long 	 是 	 客户名片ID
 customerAppraise.customType 	 String 	 是 客户类型（决定客户手机的类型）linkman---名片ID|me---私有名片ID）
 customerAppraise.customPosition 	 String 	 否 	 客户所在位置
 customerAppraise.relateDepth 	 String 	 否 	 关系深度
 customerAppraise.customCost String 否 	 客户价值
 knowTimeTemp 	 String 	 否 	 认识时间
 customerAppraise.knowAddress 	 String 	 否 	 认识地址
 customerAppraise.col1 	 String 	 否 	 备注1
 customerAppraise.col2 	 String 	 否 	 备注2
 */
- (void)createOrUpdateEvaluation:(ICustomerEvaluation *)icv
                   aboutCustomer:(Card *)aCard
                      withMyCard:(MyCard *)myCard {
    // 参数
    NSMutableDictionary *parameters;
    parameters = [NSMutableDictionary dictionaryWithDictionary:@{
                  @"customerAppraise.id"             : (icv.id         ? icv.id.stringValue         : @""),
                  @"customerAppraise.cardId"         : (myCard.id      ? myCard.id.stringValue      : @""),
                  @"customerAppraise.version"        : (myCard.version ? myCard.version.stringValue : @""),
                  @"customerAppraise.customCardId"   : (aCard.id       ? aCard.id.stringValue       : @""),
                  @"customerAppraise.customType"     : (aCard          ? [aCard nameForServer]      : @""),
                  }];
    //    @"customerAppraise.customPosition" : @"",
    //    @"customerAppraise.col1"           : @"",
    //    @"customerAppraise.col2"           : @"",
    if (icv.degree) {
        parameters[@"customerAppraise.relateDepth" ] = icv.degree.stringValue;
    }
    if (icv.value) {
        parameters[@"customerAppraise.customCost"] = icv.value.stringValue;
    }
    if (icv.remarks) {
        parameters[@"customerAppraise.col1"] = icv.remarks; //备注？
    }
    if (icv.firstMeetDate) {
        parameters[@"knowTimeTemp" ] = icv.firstMeetDate;
    }
    if (icv.firstMeetAddress) {
        parameters[@"customerAppraise.knowAddress"] = icv.firstMeetAddress;
    }
    // action
   // NSString *action = kActionNetworkCreateOrUpdateEvaluation;
    // query
    NSString *query;
    if (aCard.evaluation) {
        query = @"customerAppraiseService.updateCustomerAppraise";
    } else {
        query = @"customerAppraiseService.addCustomerAppraise";
    }
    //
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        DLog(@"[II] response = %@", responseDict);
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
        // 把返回的数据转成本地数据
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        if (KHHErrorCodeSucceeded == code) {
            NSNumber *ID = [NSNumber numberFromObject:responseDict[JSONDataKeyID]
                                   zeroIfUnresolvable:NO];
            if (nil == aCard.evaluation) {
                icv.id = ID;
            }
            if (nil == icv.customerCardID) {
                icv.customerCardID = aCard.id;
            }
            icv.customerCardModelType = aCard.modelTypeValue;
            dict[kInfoKeyObject] = icv;
        }
        // errorCode
        dict[kInfoKeyErrorCode] = @(code);
        // 把处理完的数据发出去。
      //  [self postASAPNotificationName:NameWithActionAndCode(action, code)
       //                           info:dict];
    };
    // 发请求
//    [self postAction:action
//               query:query
//          parameters:parameters
//             success:success];
}
@end
