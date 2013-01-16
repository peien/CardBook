//
//  KHHNetClinetAPIAgent+CustomerEvaluation.m
//  CardBook
//
//  Created by 王定方 on 13-1-12.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent+CustomerEvaluation.h"
#import "Card.h"
#import "MyCard.h"
#import "UIImage+KHH.h"

@implementation KHHNetClinetAPIAgent (CustomerEvaluation)
/**
 * 客户评估信息增量接口
 * url CustomerRelations/{syncTime}
 * 方法 get
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=263
 */
- (void)syncCustomerEvaluationWithDate:(NSString *)lastDate delegate:(id<KHHNetAgentCustomerEvaluationDelegates>) delegate
{
    //网络状态
    if ([self networkStateIsValid:delegate selector:@"syncCustomerEvaluationFailed:"]) {
        return;
    }
    
    //url format
    //url format
    NSString *pathFormat = @"CustomerRelations/%@";
    //以前同步过
    NSString *path = [NSString stringWithFormat:pathFormat, lastDate.length > 0 ? lastDate : @""];
    
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *op, id response) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:response];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
        // 把返回的数据转成本地数据
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        // errorCode
        dict[kInfoKeyErrorCode] = @(code);
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
            
            //同步成功,把解析后的数据传出，上层去保存数据
            if ([delegate respondsToSelector:@selector(syncCustomerEvaluationSuccess:)]) {
                [delegate syncCustomerEvaluationSuccess:dict];
            }
        }else {
            //错误码
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //同步失败，返回错误信息、
            if ([delegate respondsToSelector:@selector(syncCustomerEvaluationFailed:)]) {
                [delegate syncCustomerEvaluationFailed:dict];
            }
        }
    };
    
    //其它失败的block
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"syncCustomerEvaluationFailed:"];
    
    //发送请求
    [self getPath:path parameters:nil success:success failure:failed];
}

/*!
 客户评估信息新增
 http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=264
 url customerRelations
 方法 post
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
- (void)addCustomerEvaluation:(ICustomerEvaluation *)icv aboutCustomer:(Card *)aCard withMyCard:(MyCard *)myCard  delegate:(id<KHHNetAgentCustomerEvaluationDelegates>) delegate
{
    //网络状态
    if ([self networkStateIsValid:delegate selector:@"addCustomerEvaluationFailed:"]) {
        return;
    }
    
    // 检查参数
    if (!icv || !aCard || !myCard) {
        [self parametersNotMeetRequirementFailedResponse:delegate selector:@"addCustomerEvaluationFailed:"];
        return;
    }
    
    NSString *path = @"customerRelations";
    
    // 参数
    NSMutableDictionary *parameters;
    parameters = [NSMutableDictionary dictionaryWithDictionary:@{
                  @"customerAppraise.cardId"         : (myCard.id      ? myCard.id.stringValue      : @""),
                  @"customerAppraise.version"        : (myCard.version ? myCard.version.stringValue : @""),
                  @"customerAppraise.customCardId"   : (aCard.id       ? aCard.id.stringValue       : @""),
                  @"customerAppraise.customType"     : (aCard          ? [aCard nameForServer]      : @""),
                  }];
    //    @"customerAppraise.customPosition" : @"",
    //    @"customerAppraise.col1"           : @"",
    //    @"customerAppraise.col2"           : @"",
    //关系深度
    if (icv.degree) {
        parameters[@"customerAppraise.relateDepth" ] = icv.degree.stringValue;
    }
    //客户价值
    if (icv.value) {
        parameters[@"customerAppraise.customCost"] = icv.value.stringValue;
    }
    //备注
    if (icv.remarks) {
        parameters[@"customerAppraise.col1"] = icv.remarks; //备注？
    }
    
    if (icv.firstMeetDate) {
        parameters[@"knowTimeTemp" ] = icv.firstMeetDate;
    }
    if (icv.firstMeetAddress) {
        parameters[@"customerAppraise.knowAddress"] = icv.firstMeetAddress;
    }
    
    //服务器有返回值
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        DLog(@"[II] response = %@", responseDict);
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
        // 把返回的数据转成本地数据
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        // errorCode
        dict[kInfoKeyErrorCode] = @(code);
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
            //添加成功, 返回到data层进行同步
            if ([delegate respondsToSelector:@selector(addCustomerEvaluationSuccess:)]) {
                [delegate addCustomerEvaluationSuccess:dict];
            }
        }else {
            //错误信息
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //添加失败，返回失败信息
            if ([delegate respondsToSelector:@selector(addCustomerEvaluationFailed:)]) {
                [delegate addCustomerEvaluationFailed:dict];
            }
        }
    };
    
    //其他错误返回
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"addCustomerEvaluationFailed:"];
    
    //调接口
    [self postPath:path parameters:parameters success:success failure:failed];
}


/*!
 客户评估信息修改
 http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=265
 url customerRelations
 方法 put
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
- (void)updateCustomerEvaluation:(ICustomerEvaluation *)icv aboutCustomer:(Card *)aCard withMyCard:(MyCard *)myCard  delegate:(id<KHHNetAgentCustomerEvaluationDelegates>) delegate
{
    //网络状态
    if ([self networkStateIsValid:delegate selector:@"updateCustomerEvaluationFailed:"]) {
        return;
    }
    
    // 检查参数
    if (!icv || !aCard || !myCard) {
        [self parametersNotMeetRequirementFailedResponse:delegate selector:@"updateCustomerEvaluationFailed:"];
        return;
    }
    
    NSString *path = @"customerRelations";
    
    // 参数
    NSMutableDictionary *parameters;
    parameters = [NSMutableDictionary dictionaryWithDictionary:@{
                  @"id"             : icv.id.stringValue,
                  @"cardId"         : (myCard.id      ? myCard.id.stringValue      : @""),
                  @"version"        : (myCard.version ? myCard.version.stringValue : @""),
                  @"customCardId"   : (aCard.id       ? aCard.id.stringValue       : @""),
                  @"customType"     : (aCard          ? [aCard nameForServer]      : @""),
                  }];
    //    @"customPosition" : @"",
    //    @"col1"           : @"",
    //    @"col2"           : @"",
    //关系深度
    if (icv.degree) {
        parameters[@"relateDepth" ] = icv.degree.stringValue;
    }
    //客户价值
    if (icv.value) {
        parameters[@"customCost"] = icv.value.stringValue;
    }
    //备注
    if (icv.remarks) {
        parameters[@"col1"] = icv.remarks; //备注？
    }
    
    if (icv.firstMeetDate) {
        parameters[@"knowTimeTemp" ] = icv.firstMeetDate;
    }
    if (icv.firstMeetAddress) {
        parameters[@"knowAddress"] = icv.firstMeetAddress;
    }
    
    //服务器有返回值
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        DLog(@"[II] response = %@", responseDict);
        // 把返回的数据转成本地数据
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        
        if (KHHErrorCodeSucceeded == code) {
            //修改成功, 返回到data层进行同步
            if ([delegate respondsToSelector:@selector(updateCustomerEvaluationSuccess)]) {
                [delegate updateCustomerEvaluationSuccess];
            }
        }else {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
            // errorCode
            dict[kInfoKeyErrorCode] = @(code);
            //错误信息
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //修改失败，返回失败信息
            if ([delegate respondsToSelector:@selector(updateCustomerEvaluationFailed:)]) {
                [delegate updateCustomerEvaluationFailed:dict];
            }
        }
    };
    
    //其他错误返回
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"updateCustomerEvaluationFailed:"];
    
    //调接口
    [self putPath:path parameters:parameters success:success failure:failed];
}

/*
 * 客户评估删除
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=266
 * url CustomerRelations/{id}
 * 方法 delete
 */
-(void)deleteCustomerEvaluationByID:(long) CEID delegate:(id<KHHNetAgentCustomerEvaluationDelegates>) delegate
{
    //网络状态
    if ([self networkStateIsValid:delegate selector:@"deleteCustomerEvaluationFailed:"]) {
        return;
    }
    
    // 检查参数
    if (CEID <= 0) {
        [self parametersNotMeetRequirementFailedResponse:delegate selector:@"deleteCustomerEvaluationFailed:"];
        return;
    }
    
    NSString *pathFormat = @"customerRelations/%@";
    NSString *path = [NSString stringWithFormat:pathFormat, CEID];
    
    //服务器有返回值
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        DLog(@"[II] response = %@", responseDict);
        // 把返回的数据转成本地数据
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        
        if (KHHErrorCodeSucceeded == code) {
            //修改成功, 返回到data层进行同步
            if ([delegate respondsToSelector:@selector(deleteCustomerEvaluationSuccess)]) {
                [delegate deleteCustomerEvaluationSuccess];
            }
        }else {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
            // errorCode
            dict[kInfoKeyErrorCode] = @(code);
            //错误信息
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //修改失败，返回失败信息
            if ([delegate respondsToSelector:@selector(deleteCustomerEvaluationFailed:)]) {
                [delegate deleteCustomerEvaluationFailed:dict];
            }
        }
    };
    
    //其他错误返回
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"deleteCustomerEvaluationFailed:"];
    
    //调接口
    [self deletePath:path parameters:nil success:success failure:failed];
}

/*
 * 查询单个客户评估信息
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=274
 * 方法 get
 * utl customerRelations/{user_id}/{customerUser_id}
 */
-(void)syncSingleCustomerEvaluationWithID:(long)cutomerUserID myUserID:(long) myUserID delegate:(id<KHHNetAgentCustomerEvaluationDelegates>)delegate
{
    //网络状态
    if ([self networkStateIsValid:delegate selector:@"syncSingleCustomerEvaluationFailed:"]) {
        return;
    }
    
    // 检查参数
    if (cutomerUserID <= 0 || myUserID <= 0) {
        [self parametersNotMeetRequirementFailedResponse:delegate selector:@"syncSingleCustomerEvaluationFailed:"];
        return;
    }
    
    NSString *pathFormat = @"customerRelations/%ld/%ld";
    NSString *path = [NSString stringWithFormat:pathFormat, myUserID, cutomerUserID];
    
    //服务器有返回值
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        DLog(@"[II] response = %@", responseDict);
        // 把返回的数据转成本地数据
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
        // errorCode
        dict[kInfoKeyErrorCode] = @(code);
        if (KHHErrorCodeSucceeded == code) {
            // customerAppraise -> customerEvaluationList
            NSArray *oldList = responseDict[JSONDataKeyCustomerAppraiseList];
            NSMutableArray *newList = [NSMutableArray arrayWithCapacity:oldList.count];
            for (id obj in oldList) {
                ICustomerEvaluation *icv = [ICustomerEvaluation iCustomerEvaluationWithJSON:obj];
                [newList addObject:icv];
            }
            dict[kInfoKeyObjectList] = newList;
            //修改成功, 返回到data层进行同步
            if ([delegate respondsToSelector:@selector(syncSingleCustomerEvaluationSuccess:)]) {
                [delegate syncSingleCustomerEvaluationSuccess:dict];
            }
        }else {
            //错误信息
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //修改失败，返回失败信息
            if ([delegate respondsToSelector:@selector(syncSingleCustomerEvaluationFailed:)]) {
                [delegate syncSingleCustomerEvaluationFailed:dict];
            }
        }
    };
    
    //其他错误返回
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"syncSingleCustomerEvaluationFailed:"];
    
    //调接口
    [self getPath:path parameters:nil success:success failure:failed];
}
@end
