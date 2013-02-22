//
//  KHHNetClinetAPIAgent+Template.m
//  CardBook
//
//  Created by 王定方 on 13-1-10.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent+Template.h"

@implementation KHHNetClinetAPIAgent (Template)
/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=234
 * 模板增量接口
 * 方法 get
 */
- (void)syncTemplatesWithDate:(NSString *)lastDate delegate:(id<KHHNetAgentTemplateDelegates>) delegate
{
    //网络状态
    if (![self networkStateIsValid]) {
        if ([delegate respondsToSelector:@selector(syncTemplateFailed:)]) {
            NSDictionary * dict = [self networkUnableFailedResponseDictionary];
            [delegate syncTemplateFailed:dict];
        }
        
        return;
    }
    NSLog(@"lastDate%@",lastDate);
    
    //lastDate为空时表示拿全部数据，这里就没有无效参数判断
    NSString *pathFormat = @"template/sync/%@";
    NSString *path = [NSString stringWithFormat:pathFormat,lastDate&&![lastDate isEqualToString:@"(null)"] ? lastDate : @""];
    
    //成功block
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        // 把返回的数据转成本地数据
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
        //成功失败标记
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        dict[kInfoKeyErrorCode] = @(code);
        if (KHHErrorCodeSucceeded == code) {
            // count
            dict[kInfoKeyCount] = responseDict[JSONDataKeyCount];
            
            // synTime -> syncTime
            NSString *syncTime = responseDict[@"syncTime"];
            dict[kInfoKeySyncTime] = syncTime? syncTime: @"";
            
            // templatelist -> templatelist
            NSArray *oldList = responseDict[JSONDataKeyTemplateList];
            dict[kInfoKeyTemplateList] = oldList;
            
            //同步成功,返回数据到data层保存数据
            if ([delegate respondsToSelector:@selector(syncTemplateSuccess:)]) {
                [delegate syncTemplateSuccess:dict];
            }
        }else {
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //同步失败
            if ([delegate respondsToSelector:@selector(syncTemplateFailed:)]) {
                [delegate syncTemplateFailed:dict];
            }
        }
    };
    
    //其它失败的block
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"syncTemplateFailed:"];
    
    //发送请求
    [self getPath:path parameters:nil success:success failure:failed];
}


/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=285
 * 根据模板id和版本获取联系人模板
 * 拼装方法 模板的id和version，id在前，用-连接，多个使用|间隔，如31-1|170-3
 * 方法 get
 */
//-(void)syncTemplatesWithTemplateIDAndVersion:(NSString *) idAndVersions delegate:(id<KHHNetAgentTemplateDelegates>)delegate
//{
//    //网络状态
//    if (![self networkStateIsValid:delegate selector:@"syncTemplateWithIDAndVersionFailed:"]) {
//        return;
//    }
//    
//    //检查参数
//    if (idAndVersions.length <= 0) {
//        [self parametersNotMeetRequirementFailedResponse:delegate selector:@"syncTemplateWithIDAndVersionFailed:"];
//        return;
//    }
//    
//    //url 文档中未定义
//    NSString *path = @"";
//
//    NSDictionary *parameters = @{@"templateIdAndVersions" : idAndVersions};
//    
//    //成功block
//    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
//        // 把返回的数据转成本地数据
//        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
//        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
//        //成功失败标记
//        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
//        dict[kInfoKeyErrorCode] = @(code);
//        if (KHHErrorCodeSucceeded == code) {
//            // count
//            dict[kInfoKeyCount] = responseDict[JSONDataKeyCount];
//            
//            // templatelist -> templatelist
//            NSArray *oldList = responseDict[JSONDataKeyTemplateList];
//            dict[kInfoKeyTemplateList] = oldList;
//            
//            //同步成功,返回数据到data层保存数据
//            if ([delegate respondsToSelector:@selector(syncTemplateWithIDAndVersionSuccess:)]) {
//                [delegate syncTemplateWithIDAndVersionSuccess:dict];
//            }
//        }else {
//            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
//            //同步失败
//            if ([delegate respondsToSelector:@selector(syncTemplateWithIDAndVersionFailed:)]) {
//                [delegate syncTemplateWithIDAndVersionFailed:dict];
//            }
//        }
//    };
//    
//    //其它失败的block
//    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"syncTemplateWithIDAndVersionFailed:"];
//    
//    //发送请求
//    [self getPath:path parameters:parameters success:success failure:failed];
//}

/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=286
 * 根据模板id获取模板详细信息
 * url
 * 方法 get
 */
- (void)syncTemplateItemsWithTemplateID:(long) templateID delegate:(id<KHHNetAgentTemplateDelegates>)delegate
{
    //网络状态
    if (![self networkStateIsValid:delegate selector:@"syncTemplateItemsWithTemplateIDFailed:"]) {
        return;
    }
    
    //检查参数
    if (templateID <= 0) {
        [self parametersNotMeetRequirementFailedResponse:delegate selector:@"syncTemplateItemsWithTemplateIDFailed:"];
        return;
    }
    
    //url
    NSString *pathFormat = @"template/detail/%ld";
    NSString *path = [NSString stringWithFormat:pathFormat, templateID];
    
    //成功block
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        // 把返回的数据转成本地数据
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
        //成功失败标记
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        dict[kInfoKeyErrorCode] = @(code);
        if (KHHErrorCodeSucceeded == code) {
                      
            
            // templatelist -> templatelist
            
            NSDictionary *dicPro = responseDict[JSONDataKeyTemplateList_Single];
            dict[kInfoKeyTemplateList] = [[NSArray alloc]initWithObjects:dicPro, nil];
            
            //同步成功,返回数据到data层保存数据
            if ([delegate respondsToSelector:@selector(syncTemplateItemsWithTemplateIDSuccess:)]) {
                [delegate syncTemplateItemsWithTemplateIDSuccess:dict];
            }
        }else {
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //同步失败
            if ([delegate respondsToSelector:@selector(syncTemplateItemsWithTemplateIDFailed:)]) {
                [delegate syncTemplateItemsWithTemplateIDFailed:dict];
            }
        }
    };
    
    //其它失败的block
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"syncTemplateItemsWithTemplateIDFailed:"];
    
    //发送请求
    [self getPath:path parameters:nil success:success failure:failed];
}

/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=303
 * 一次获取多个模板的详细信息
 * url template/templates/{templateIds}
 * 方法 get
 * templateIds多个是多个templateId通过英文逗号（,）进行分割的，最后一个id的后面没有逗号，示例：1,2,3,4，表示四个模板
 */
- (void)syncTemplateItemsWithTemplateIDs:(NSString *) templateIDs delegate:(id<KHHNetAgentTemplateDelegates>)delegate
{
    //网络状态
    if (![self networkStateIsValid:delegate selector:@"syncTemplateItemsWithTemplateIDsFailed:"]) {
        return;
    }
    
    //检查参数
    if (templateIDs.length <= 0) {
        [self parametersNotMeetRequirementFailedResponse:delegate selector:@"syncTemplateItemsWithTemplateIDsFailed:"];
        return;
    }
    
    //url
    NSString *pathFormat = @"template/templates/%@";
    NSString *path = [NSString stringWithFormat:pathFormat, templateIDs];
    
    //成功block
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        // 把返回的数据转成本地数据
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
        //成功失败标记
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        dict[kInfoKeyErrorCode] = @(code);
        if (KHHErrorCodeSucceeded == code) {
            // count
            dict[kInfoKeyCount] = responseDict[JSONDataKeyCount];
            
            // templatelist -> templatelist
            NSArray *oldList = responseDict[@"templatelist"];
            dict[kInfoKeyTemplateList] = oldList;
            
            //同步成功,返回数据到data层保存数据
            if ([delegate respondsToSelector:@selector(syncTemplateItemsWithTemplateIDsSuccess:)]) {
                [delegate syncTemplateItemsWithTemplateIDsSuccess:dict];
            }
        }else {
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //同步失败
            if ([delegate respondsToSelector:@selector(syncTemplateItemsWithTemplateIDsFailed:)]) {
                [delegate syncTemplateItemsWithTemplateIDsFailed:dict];
            }
        }
    };
    
    //其它失败的block
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"syncTemplateItemsWithTemplateIDsFailed:"];
    
    //发送请求
    [self getPath:path parameters:nil success:success failure:failed];
}
@end
