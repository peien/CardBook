//
//  KHHNetClinetAPIAgent+SignPlan.m
//  CardBook
//
//  Created by CJK on 13-1-23.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent+SignPlan.h"
#import "UIImage+KHH.h"
#import "NSNumber+SM.h"
#import "ISchedule.h"

@implementation KHHNetClinetAPIAgent (SignPlan)

#pragma mark - syncPlan
- (void)syncPlan:(NSString *)lastDate delegate:(id<KHHNetAgentSignPlanDelegate>) delegate
{
    
    if (![self networkStateIsValid:delegate selector:@"syncPlanFailed:"]) {
        return;
    }
   
    //url format
    NSString *pathFormat = @"visitPlan/sync/%@";
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
            
            // planList -> visitScheduleList
            NSArray *planList = responseDict[JSONDataKeyPlanList];
            NSMutableArray *newList = [NSMutableArray arrayWithCapacity:planList.count];
            for (id obj in planList) {
                ISchedule *iSchedule = [[[ISchedule alloc] init] updateWithJSON:obj];
                DLog(@"[II] iSchedule = %@", iSchedule);
                [newList addObject:iSchedule];
            }
            dict[kInfoKeyObjectList] = newList;
            
            //同步成功,把解析后的数据传出，上层去保存数据
            if ([delegate respondsToSelector:@selector(syncPlanSuccess:)]) {
                [delegate syncPlanSuccess:dict];
            }
        }else {
            //错误码
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //同步失败，返回错误信息、
            if ([delegate respondsToSelector:@selector(syncPlanFailed:)]) {
                [delegate syncPlanFailed:dict];
            }
        }
    };
    
    //其它失败的block
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"syncPlanFailed:"];
    
    //发送请求
    [self getPath:path parameters:nil success:success failure:failed];
}

#pragma mark - addPlan

- (void)addPlan:(InterPlan *) iPlan delegate:(id<KHHNetAgentSignPlanDelegate>) delegate
{
    if (![self networkStateIsValid:delegate selector:@"addPlanFailed:"]) {
        return;
    }
    
    // 检查参数
    if (!iPlan) {
        //        if ([delegate respondsToSelector:@selector(addVisitScheduleFailed:)]) {
        //            //参数错误
        //            NSDictionary * dict = [self parametersNotMeetRequirementFailedResponseDictionary];
        //            [delegate addVisitScheduleFailed:dict];
        //        }
        [self parametersNotMeetRequirementFailedResponse:delegate selector:@"addPlanFailed:"];
        return;
    }
    
    NSString *path = @"visitPlan";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:10];
    //创建人公司名片id
    // parameters[@"cardId"]           = [NSString stringWithFormat:@"%ld", cardID];
    if (iPlan.customCardIds.length) {
        parameters[@"customCardIds"]   = iPlan.customCardIds;
    }
    if (iPlan.customerName.length)
        parameters[@"customerName"]   = iPlan.customerName;
    
    if (iPlan.content.length)
        parameters[@"content"]   = iPlan.content;
    
    
    
    if (iPlan.planTime.length)
        parameters[@"planTime"]   = iPlan.planTime;
    
    if (iPlan.remind.length)
        parameters[@"remind"]   = iPlan.remind;
    
    if (iPlan.remindDate.length)
        parameters[@"remindDate"]   = iPlan.remindDate;
    
    if (iPlan.province.length)
        parameters[@"province"]   = iPlan.province;
    
    if (iPlan.city.length)
        parameters[@"city"]   = iPlan.city;
    
    if (iPlan.address.length)
        parameters[@"address"]   = iPlan.address;
    
    if (iPlan.accompanist.length)
        parameters[@"finished"]   = iPlan.finished;
    
    
    NSLog(@"%@",parameters);
    // 图片
    KHHConstructionBlock construction = ^(id <AFMultipartFormData> formData) {
        for (UIImage *image in iPlan.imgs) {
            NSData *imageData = [image resizedImageDataForKHHUpload];
            [formData appendPartWithFileData:imageData
                                        name:@"imgs"
                                    fileName:@"imgs.jpg"
                                    mimeType:@"image/jpeg"];
        }
    };
    
    // 处理成功返回
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        //成功失败码
        dict[kInfoKeyErrorCode] = @(code);
        if (code == KHHErrorCodeSucceeded) {
            // 把返回的数据转成本地数据
            // 返回的ID
            iPlan.id = [NSNumber numberFromObject:responseDict[JSONDataKeyID]
                                   zeroIfUnresolvable:NO];
            dict[kInfoKeyObject]    = iPlan;
            
            //操作成功
            if ([delegate respondsToSelector:@selector(addPlanSuccess:)]) {
                [delegate addPlanSuccess:dict];
            }
        }else {
            //错误信息
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //操作失败
            if ([delegate respondsToSelector:@selector(addPlanFailed:)]) {
                [delegate addPlanFailed:dict];
            }
        }
    };
    
    //其他错误返回
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"addPlanFailed:"];
    
    //调接口
    [self multipartFormRequestWithPOSTPath:path parameters:parameters constructingBodyWithBlock:construction success:success failure:failed];
}
@end
