//
//  KHHNetClinetAPIAgent+Exchange.m
//  CardBook
//
//  Created by 王定方 on 13-1-10.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent+Exchange.h"

@implementation KHHNetClinetAPIAgent (Exchange)
/**
 * 发送名片到手机 sendCardService.sendCard
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=235
 * 方法 put
 * 多个手机号时用";"隔开
 */
- (void)sendCard:(long) cardID version:(int) version toPhones:(NSString *) phoneNumbers delegate:(id<KHHNetAgentExchangeDelegates>) delegate
{
    //网络状态
    if (![self networkStateIsValid:delegate selector:@"sendCardToMobileFailed:"]) {
        return;
    }
    
    //检查参数
    if (cardID <= 0 || version < 0 || 0 == phoneNumbers.length) {
        [self parametersNotMeetRequirementFailedResponse:delegate selector:@"sendCardToMobileFailed:"];
        return;
    }
    
   //请求url的格式
    NSString *pathFormat = @"card/mobile/%ld/%d";
    NSString *path = [NSString stringWithFormat:pathFormat, cardID, version];
    
    //参数
    NSDictionary *parameters = @{@"mobiles" : phoneNumbers};
    
    //成功block
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        // 把返回的数据转成本地数据
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        //成功失败标记
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        if (KHHErrorCodeSucceeded == code) {
            //同步成功,返回数据到data层保存数据
            if ([delegate respondsToSelector:@selector(sendCardToMobileSuccess:)]) {
                [delegate sendCardToMobileSuccess];
            }
        }else {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
            //失败code号
            dict[kInfoKeyErrorCode] = @(code);    
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //同步失败
            if ([delegate respondsToSelector:@selector(sendCardToMobileFailed:)]) {
                [delegate sendCardToMobileFailed:dict];
            }
        }
    };
    
    //其它失败的block
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"sendCardToMobileFailed:"];
    
    //发送请求
    [self postPath:path parameters:parameters success:success failure:failed];
}


/**
 * 摇摇交换名片
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=288
 * 方法 POST
 * url card/shakeInfo/{user_id} user_id表示谁摇手机是谁的user_id
 */
- (void)exchangeCard:(Card *)card withCoordinate:(CLLocationCoordinate2D)coordinate delegate:(id<KHHNetAgentExchangeDelegates>) delegate
{
    //网络状态
    if (![self networkStateIsValid:delegate selector:@"exchangeCardFailed:"]) {
        return;
    }
    
    //检查参数
    if (!card || card.version < 0 || card.id.longValue <= 0) {
        [self parametersNotMeetRequirementFailedResponse:delegate selector:@"exchangeCardFailed:"];
        return;
    }
    
    //请求url的格式
  //  NSString *pathFormat = @"card/shakeInfo/%@";
    NSString *path = @"card/shakeInfo";//[NSString stringWithFormat:pathFormat, card.userID.stringValue];
    
    ALog(@"[II] 用于交换的名片 id = %@, version = %@", card.id, card.version);
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:6];
    [parameters setObject:[[card valueForKey:kAttributeKeyID] stringValue]
                   forKey:@"cardId"];
    [parameters setObject:[[card valueForKey:kAttributeKeyVersion] stringValue]
                   forKey:@"version"];
    [parameters setObject:[NSString stringWithFormat:@"%f", coordinate.longitude]
                   forKey:@"longitude"];
    [parameters setObject:[NSString stringWithFormat:@"%f", coordinate.latitude]
                   forKey:@"latitude"];
    [parameters setObject:@(15*1000).stringValue
                   forKey:@"invalidTime"];
    [parameters setObject:@"true"
                   forKey:@"hasGps"];
    
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
            if ([delegate respondsToSelector:@selector(exchangeCardSuccess:)]) {
                [delegate exchangeCardSuccess:dict];
            }
        }else {
            
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //交换失败
            if ([delegate respondsToSelector:@selector(exchangeCardFailed:)]) {
                [delegate sendCardToMobileFailed:dict];
            }
        }
    };
    
    //其它失败的block
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"exchangeCardFailed:"];
    
    //发请求
    [self postPath:path parameters:parameters success:success failure:failed];
}


/**
 * 回赠名片
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=281
 * 方法 Put
 * url card/return/{receiverId}/{cardId}/{version}
 */
- (void)sendCard:(long) cardID version:(int) version toUser:(NSString *)userID delegate:(id<KHHNetAgentExchangeDelegates>) delegate
{
    //网络状态
    if (![self networkStateIsValid:delegate selector:@"sendCardToUserFailed:"]) {
        return;
    }
    
    //检查参数
    if (cardID <= 0 || version < 0 || 0 == userID.length) {
        [self parametersNotMeetRequirementFailedResponse:delegate selector:@"sendCardToUserFailed:"];
        return;
    }
    
    //请求url的格式
    NSString *pathFormat = @"card/return/%ld/%d/%@";
    NSString *path = [NSString stringWithFormat:pathFormat, cardID, version, userID];
    
    //成功block
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        // 把返回的数据转成本地数据
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        //成功失败标记
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        if (KHHErrorCodeSucceeded == code) {
            //同步成功,返回数据到data层保存数据
            if ([delegate respondsToSelector:@selector(sendCardToUserSuccess)]) {
                [delegate sendCardToUserSuccess];
            }
        }else {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
            //失败code号
            dict[kInfoKeyErrorCode] = @(code);
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //同步失败
            if ([delegate respondsToSelector:@selector(sendCardToUserFailed:)]) {
                [delegate sendCardToUserFailed:dict];
            }
        }
    };
    
    //其它失败的block
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"sendCardToUserFailed:"];
    
    //发送请求
    [self putPath:path parameters:nil success:success failure:failed];
}
@end
