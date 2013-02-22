//
//  KHHNetClinetAPIAgent+TransCard.m
//  CardBook
//
//  Created by CJK on 13-1-31.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent+TransCard.h"

@implementation KHHNetClinetAPIAgent (TransCard)

#pragma mark - rebate

- (void)rebateCard:(NSString *)receiverId cardId:(NSString *)cardId cardType:(KHHCardModelType)cardType delegate:(id<KHHNetAgentTransCardDelegate>) delegate
{
    if (![self networkStateIsValid:delegate selector:@"rebateCardFailed:"]) {
        return;
    }
    
    NSString *path ;
    NSMutableDictionary *parameters;
    if (cardType == KHHCardModelTypePrivateCard)
    {
        path = [NSString stringWithFormat:@"card/mobile/%@",cardId];
        parameters = [[NSMutableDictionary alloc]initWithCapacity:1];
        parameters[@"mobiles"] = receiverId;
        //parameters[@"cardId"] = cardId;
    }else{
        
        path = @"card/return";
        parameters = [[NSMutableDictionary alloc]initWithCapacity:2];
        parameters[@"receiverId"] = receiverId;
        parameters[@"cardId"] = cardId;
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
            // dict[kInfoKeyCount] = responseDict[JSONDataKeyCount];
            
            //            // synTime -> syncTime
            //            NSString *syncTime = responseDict[@"syncTime"];
            //            dict[kInfoKeySyncTime] = syncTime? syncTime: @"";
            //            dict[@"myCard"] = responseDict[@"myCard"];
            //            dict[@"templatelist"] = responseDict[@"templatelist"];
            //            dict[@"linkList"] = responseDict[@"linkList"];
            //            dict[@"companyLinkList"] = responseDict[@"companyLinkList"];
            
            //dict[@"customerAppraise"] = responseDict[@"customerAppraise"];
            
            if ([delegate respondsToSelector:@selector(rebateCardSuccess:)]) {
                [delegate rebateCardSuccess:dict];
            }
        }else {
            //错误信息
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //添加失败，返回失败信息
            if ([delegate respondsToSelector:@selector(rebateCardFailed:)]) {
                [delegate rebateCardFailed:dict];
            }
        }
    };
    
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"rebateCardFailed:"];
    if (cardType == KHHCardModelTypePrivateCard){
        [self postPath:path parameters:parameters success:success failure:failed];
        return;
    }
    
    [self putPath:path parameters:parameters success:success failure:failed];
    
    
}

#pragma mark - send to phone

- (void)sendByPhone:(NSArray *)receiverMobiles cardId:(NSString *)cardId delegate:(id<KHHNetAgentTransCardDelegate>) delegate
{
    if (![self networkStateIsValid:delegate selector:@"sendByPhoneFailed:"]) {
        return;
    }
    
    NSString *path ;
    NSMutableDictionary *parameters;
    NSMutableString *mobilesPro = [[NSMutableString alloc]initWithCapacity:[receiverMobiles count]];
    for (int i=0;i<[receiverMobiles count];i++) {
        if (i == 0) {
            [mobilesPro appendString:receiverMobiles[i]];
            continue;
        }
        [mobilesPro appendFormat:@";%@",receiverMobiles[i]];
    }
    
    path = [NSString stringWithFormat:@"card/mobile/%@",cardId];
    parameters = [[NSMutableDictionary alloc]initWithCapacity:1];
    parameters[@"mobiles"] = mobilesPro;
       
    
    
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        DLog(@"[II] response = %@", responseDict);
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
        // 把返回的数据转成本地数据
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        // errorCode
        dict[kInfoKeyErrorCode] = @(code);
        
        if (KHHErrorCodeSucceeded == code) {
            
            if ([delegate respondsToSelector:@selector(sendByPhoneSuccess:)]) {
                [delegate sendByPhoneSuccess:dict];
            }
            
        }else {
            //错误信息
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //添加失败，返回失败信息
            if ([delegate respondsToSelector:@selector(sendByPhoneFailed:)]) {
                [delegate sendByPhoneFailed:dict];
            }
        }
    };
    
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"sendByPhoneFailed:"];
    
    [self postPath:path parameters:parameters success:success failure:failed];
    
}

#pragma mark - exchange

- (void)exchange:(InterShake *)iShake delegate:(id<KHHNetAgentTransCardDelegate>)delegate
{
    if (![self networkStateIsValid:delegate selector:@"exchangeFailed:"]) {
        return;
    }
    
    //检查参数
    if (!iShake || !iShake.longitude.length||!iShake.cardId.length) {
        [self parametersNotMeetRequirementFailedResponse:delegate selector:@"exchangeFailed:"];
        return;
    }
    
    //请求url的格式
   
    NSString *path = @"card/shakeInfo";    
    
    
    //成功block
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        // 把返回的数据转成本地数据
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        //成功失败标记
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
        //失败code号
        dict[kInfoKeyErrorCode] = @(code);
        if (KHHErrorCodeSucceeded == code) {
            //交换过来的名片id
            dict[kInfoKeyID] = [NSNumber numberFromObject:[responseDict valueForKey:JSONDataKeySendCardID] zeroIfUnresolvable:NO];
            //交换成功,返回数据到data层保存数据
            if ([delegate respondsToSelector:@selector(exchangeSuccess:)]) {
                [delegate exchangeSuccess:dict];
            }
        }else {
            
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //交换失败
            if ([delegate respondsToSelector:@selector(exchangeFailed:)]) {
                [delegate exchangeFailed:dict];
            }
        }
    };
    
    //其它失败的block
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"exchangeCardFailed:"];
    
    //发请求
    
    [self postPath:path parameters:[iShake toNetParam]  success:success failure:failed];
  

}


- (void)receiveLastCostomer:(id<KHHNetAgentTransCardDelegate>) delegate
{
    if (![self networkStateIsValid:delegate selector:@"receiveLastCostomerFailed:"]) {
        return;
    }
    
  
   
    
    //请求url的格式
    
    NSString *path = @"customer/last";
    
    
    //成功block
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        // 把返回的数据转成本地数据
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        //成功失败标记
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
        //失败code号
        dict[kInfoKeyErrorCode] = @(code);
        if (KHHErrorCodeSucceeded == code) {
            dict[@"cardBookVo"] = responseDict[@"cardBookVo"];
            //交换成功,返回数据到data层保存数据
            if ([delegate respondsToSelector:@selector(receiveLastCostomerSuccess:)]) {
                [delegate receiveLastCostomerSuccess:dict];
            }
        }else {
            
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //交换失败
            if ([delegate respondsToSelector:@selector(receiveLastCostomerFailed:)]) {
                [delegate receiveLastCostomerFailed:dict];
            }
        }
    };
    
    //其它失败的block
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"receiveLastCostomerFailed:"];
    
    //发请求
    
    [self getPath:path parameters:nil  success:success failure:failed];
}

@end
