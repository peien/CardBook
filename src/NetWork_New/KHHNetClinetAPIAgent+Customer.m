//
//  KHHNetClinetAPIAgent+Customer.m
//  CardBook
//
//  Created by CJK on 13-1-26.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent+Customer.h"


@implementation KHHNetClinetAPIAgent (Customer)

- (void)addUpdateCustomer:(InterCustomer *)iCustomer delegate:(id<KHHNetAgentCustomerDelegate>) delegate
{
    //网络状态
    if (![self networkStateIsValid:delegate selector:@"addUpdateCustomerFailed:"]) {
        return;
    }
    
    // 检查参数
    if (!iCustomer) {
        [self parametersNotMeetRequirementFailedResponse:delegate selector:@"addUpdateCustomerFailed:"];
        return;
    }
    
    NSString *path = @"customerRelations";
    NSMutableDictionary *parameters;
    parameters = [NSMutableDictionary dictionaryWithDictionary:@{
                  @"customerCard"         :  iCustomer.customerCard,
                  @"depth"        : iCustomer.depth,
                  @"cost"   : iCustomer.cost,
                  
                                    }];
    if (iCustomer.remarks&&iCustomer.remarks.length) {
        parameters[@"remarks"] = iCustomer.remarks;
    }
    
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        DLog(@"[II] response = %@", responseDict);
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
        // 把返回的数据转成本地数据
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        // errorCode
        dict[kInfoKeyErrorCode] = @(code);
        if (KHHErrorCodeSucceeded == code) {
//            NSNumber *ID = [NSNumber numberFromObject:responseDict[JSONDataKeyID]
//                                   zeroIfUnresolvable:NO];
//            if (nil == aCard.evaluation) {
//                icv.id = ID;
//            }
//            if (nil == icv.customerCardID) {
//                icv.customerCardID = aCard.id;
//            }
//            icv.customerCardModelType = aCard.modelTypeValue;
//            dict[kInfoKeyObject] = icv;
            //添加成功, 返回到data层进行同步
            if ([delegate respondsToSelector:@selector(addUpdateCustomerSuccess:)]) {
                [delegate addUpdateCustomerSuccess:dict];
            }
        }else {
            //错误信息
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //添加失败，返回失败信息
            if ([delegate respondsToSelector:@selector(addUpdateCustomerFailed:)]) {
                [delegate addUpdateCustomerFailed:dict];
            }
        }
    };
    
    //其他错误返回
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"addUpdateCustomerFailed:"];
    if (iCustomer.id) {
        [parameters setValue:iCustomer.id forKey:@"id"];
        [self putPath:path parameters:parameters success:success failure:failed];
        return;
    }
    [self postPath:path parameters:parameters success:success failure:failed];
}

- (void)syncCustomer:(NSString *) lastDate delegate:(id<KHHNetAgentCustomerDelegate>) delegate
{
    if (![self networkStateIsValid:delegate selector:@"syncCustomerFailed:"]) {
        return;
    }
    
    NSString *path =@"customerRelations/sync";
    if (lastDate.length > 0) {
        path = [NSString stringWithFormat:@"%@/%@",path,lastDate];
    }
    
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        DLog(@"[II] response = %@", responseDict);
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
        // 把返回的数据转成本地数据
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        // errorCode
        dict[kInfoKeyErrorCode] = @(code);
        
        if (KHHErrorCodeSucceeded == code) {
            // count
            dict[kInfoKeyCount] = responseDict[JSONDataKeyCount];
            
            // synTime -> syncTime
            NSString *syncTime = responseDict[@"syncTime"];
            dict[kInfoKeySyncTime] = syncTime? syncTime: @"";
            
            dict[@"customerAppraise"] = responseDict[@"customerAppraise"];
           
            if ([delegate respondsToSelector:@selector(syncCustomerSuccess:)]) {
                [delegate syncCustomerSuccess:dict];
            }
        }else {
            //错误信息
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //添加失败，返回失败信息
            if ([delegate respondsToSelector:@selector(syncCustomerFailed:)]) {
                [delegate syncCustomerFailed:dict];
            }
        }
    };
    
     KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"syncCustomerFailed:"];
    
    [self getPath:path parameters:nil success:success failure:failed];
}
@end
