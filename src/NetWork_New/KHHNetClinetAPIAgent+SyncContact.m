//
//  KHHNetClinetAPIAgent+SyncContact.m
//  CardBook
//
//  Created by CJK on 13-2-1.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent+SyncContact.h"

@implementation KHHNetClinetAPIAgent (SyncContact)

#pragma mark - syncContact

- (void)syncContact:(NSString *)lastDate lastCardId:(NSString *)lastCardId delegate:(id<KHHNetAgentSyncContactDelegate>) delegate
{
    if (![self networkStateIsValid:delegate selector:@"syncContactFailed:"]) {
        return;
    }
    
   
    
    //请求url的格式
    NSString *path;
    if (lastDate&&lastDate.length>0) {
        path = [NSString stringWithFormat:@"cardSendedRecievedRecord/sync/%@/%@/50/yes",lastDate,lastCardId];
    }else{
        path = @"cardSendedRecievedRecord/sync/50/yes";
    }
        
   
    
    
    //成功block
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        // 把返回的数据转成本地数据
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        //成功失败标记
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
        //失败code号
        dict[kInfoKeyErrorCode] = @(code);
        dict[@"syncTime"] = responseDict[@"syncTime"];
        dict[@"lastCardbookId"] = responseDict[@"lastCardbookId"];
        dict[@"cardBookList"] = responseDict[@"cardBookList"];
        
        if (KHHErrorCodeSucceeded == code) {
           
            //交换成功,返回数据到data层保存数据
            if ([delegate respondsToSelector:@selector(syncContactSuccess:)]) {
                [delegate syncContactSuccess:dict];
            }
        }else {
            
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //交换失败
            if ([delegate respondsToSelector:@selector(syncContactFailed:)]) {
                [delegate syncContactFailed:dict];
            }
        }
    };
    
    //其它失败的block
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"syncContactFailed:"];
    
    //发请求
    
    [self getPath:path parameters:nil  success:success failure:failed];
}


#pragma mark - touchCardForPushMsg

- (void)touchCardForPushMsg:(NSString *)cardId delegate:(id<KHHNetAgentSyncContactDelegate>) delegate
{
    if (![self networkStateIsValid:delegate selector:@"touchCardFailed:"]) {
        return;
    }
    
    
    
    //请求url的格式
    NSString *path = [NSString stringWithFormat:@"card/%@",cardId];
        
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
            dict[@"card"] = responseDict[@"card"];
            //交换成功,返回数据到data层保存数据
            if ([delegate respondsToSelector:@selector(touchCardSuccess:)]) {
                [delegate touchCardSuccess:dict];
            }
        }else {
            
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //交换失败
            if ([delegate respondsToSelector:@selector(touchCardFailed:)]) {
                [delegate touchCardFailed:dict];
            }
        }
    };
    
    //其它失败的block
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"touchCardFailed:"];
    
    //发请求
    
    [self getPath:path parameters:nil  success:success failure:failed];
}

#pragma mark - deleteContact
- (void)deleteContact:(NSString *)contactId delegate:(id<KHHNetAgentSyncContactDelegate>) delegate
{
    if (![self networkStateIsValid:delegate selector:@"deleteContactFailed:"]) {
        return;
    }
     NSString *path = [NSString stringWithFormat:@"customer/%@",contactId];
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        // 把返回的数据转成本地数据
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        //成功失败标记
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
        //失败code号
        dict[kInfoKeyErrorCode] = @(code);
        
        if (KHHErrorCodeSucceeded == code) {
           
            //交换成功,返回数据到data层保存数据
            if ([delegate respondsToSelector:@selector(deleteContactSuccess:)]) {
                [delegate deleteContactSuccess:dict];
            }
        }else {
            
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //交换失败
            if ([delegate respondsToSelector:@selector(deleteContactFailed:)]) {
                [delegate deleteContactFailed:dict];
            }
        }
    };
    
    //其它失败的block
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"deleteContactFailed:"];
    
    //发请求
    
    [self deletePath:path parameters:nil  success:success failure:failed];
}

#pragma mark -sync Mycard
- (void)syncMycard:(id<KHHNetAgentSyncContactDelegate>) delegate
{
    if (![self networkStateIsValid:delegate selector:@"syncMycardFailed:"]) {
        return;
    }
    NSString *path = @"card/mine";
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        // 把返回的数据转成本地数据
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        //成功失败标记
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
        //失败code号
        dict[kInfoKeyErrorCode] = @(code);
        
        if (KHHErrorCodeSucceeded == code) {
            if (responseDict[@"myCard"]&&![responseDict[@"myCard"] isEqual:[NSNull null]]) {
                dict[@"myCard"] = responseDict[@"myCard"];
            }
            //交换成功,返回数据到data层保存数据
            if ([delegate respondsToSelector:@selector(syncMycardSuccess:)]) {
                [delegate syncMycardSuccess:dict];
            }
        }else {
            
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //交换失败
            if ([delegate respondsToSelector:@selector(syncMycardFailed:)]) {
                [delegate syncMycardFailed:dict];
            }
        }
    };
    
    //其它失败的block
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"syncMycardFailed:"];
    
    //发请求
    
    [self getPath:path parameters:nil  success:success failure:failed];
}


@end
