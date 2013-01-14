//
//  KHHNetClinetAPIAgent+VisitSchedule.m
//  CardBook
//
//  Created by 王定方 on 13-1-11.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent+VisitSchedule.h"
#import "NSObject+SM.h"
#import "Card.h"
#import "UIImage+KHH.h"
#import "NSNumber+SM.h"

@implementation KHHNetClinetAPIAgent (VisitSchedule)
/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=252
 * url  visitPlan/sync 查询所有
 *      visitPlan/sync/{timestamp} 查询某个时间点后面的数据
 * 方法  get
 */
-(void)syncVisitScheduleWithDate:(NSString *) lastDate delegate:(id<KHHNetAgentVisitScheduleDelegates>) delegate
{
    //网络状态
//    if (![self networkStateIsValid]) {
//        if ([delegate respondsToSelector:@selector(syncVisitScheduleFailed:)]) {
//            NSDictionary * dict = [self networkUnableFailedResponseDictionary];
//            [delegate syncVisitScheduleFailed:dict];
//        }
//        
//        return;
//    }
    if ([self networkStateIsValid:delegate selector:@"syncVisitScheduleFailed:"]) {
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
            if ([delegate respondsToSelector:@selector(syncVisitScheduleSuccess:)]) {
                [delegate syncVisitScheduleSuccess:dict];
            }
        }else {
            //错误码
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //同步失败，返回错误信息、
            if ([delegate respondsToSelector:@selector(syncVisitScheduleFailed:)]) {
                [delegate syncVisitScheduleFailed:dict];
            }
        }
    };
        
    //其它失败的block
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"syncVisitScheduleFailed:"];
    
    //发送请求
    [self getPath:path parameters:nil success:success failure:failed];
}

/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=253
 * url visitPlan
 * 方法  post
 */
-(void)addVisitSchedule:(OSchedule *) oSchedule cardID:(long) cardID delegate:(id<KHHNetAgentVisitScheduleDelegates>) delegate
{
    //网络状态
//    if (![self networkStateIsValid]) {
//        if ([delegate respondsToSelector:@selector(addVisitScheduleFailed:)]) {
//            NSDictionary * dict = [self networkUnableFailedResponseDictionary];
//            [delegate addVisitScheduleFailed:dict];
//        }
//        
//        return;
//    }
    if ([self networkStateIsValid:delegate selector:@"addVisitScheduleFailed:"]) {
        return;
    }
    
    // 检查参数
    if (cardID < 0 || !oSchedule) {
//        if ([delegate respondsToSelector:@selector(addVisitScheduleFailed:)]) {
//            //参数错误
//            NSDictionary * dict = [self parametersNotMeetRequirementFailedResponseDictionary];
//            [delegate addVisitScheduleFailed:dict];
//        }
        [self parametersNotMeetRequirementFailedResponse:delegate selector:@"addVisitScheduleFailed:"];
        return;
    }
    
    NSString *path = @"visitPlan";
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:10];
    //创建人公司名片id
    parameters[@"cardId"]           = [NSString stringWithFormat:@"%ld", cardID];
    
    if (oSchedule.customer.length)
        parameters[@"customName"]   = oSchedule.customer;
    if (oSchedule.plannedDate)
        parameters[@"planTimeTemp"] = KHHDateStringFromDate(oSchedule.plannedDate);
    if (oSchedule.isRemind)
        parameters[@"isRemind"]     = oSchedule.isRemind.stringValue;
    if (oSchedule.minutesToRemind)
        parameters[@"remindDate"]   = oSchedule.minutesToRemind.stringValue;
    if (oSchedule.addressProvince.length)
        parameters[@"province"]     = oSchedule.addressProvince;
    if (oSchedule.addressCity.length)
        parameters[@"city"]         = oSchedule.addressCity;
    if (oSchedule.addressOther.length)
        parameters[@"address"]      = oSchedule.addressOther;
    if (oSchedule.companion.length)
        parameters[@"withPerson"]   = oSchedule.companion;
    if (oSchedule.content.length) {
        parameters[@"visitContext"]     = oSchedule.content;
    }
    if (oSchedule.isFinished)
        parameters[@"isFinished"]  = (oSchedule.isFinished.boolValue)? @"y": @"n";
    
    NSMutableString *cardIDs = [NSMutableString string];
    NSMutableString *cardTypes = [NSMutableString string];
    for (Card *card in oSchedule.targetCardList) {
        [cardIDs appendFormat:@"%@%@",card.id.stringValue, KHH_SEPARATOR];
        [cardTypes appendFormat:@"%@%@",card.nameForServer, KHH_SEPARATOR];
    }
    if (cardIDs.length) {
        parameters[@"customCardIds"] = cardIDs;
        parameters[@"customTypes"]   = cardTypes;
    }
    
    // 图片
    KHHConstructionBlock construction = ^(id <AFMultipartFormData> formData) {
        for (UIImage *image in oSchedule.imageList) {
            NSData *imageData = [image resizedImageDataForKHHUpload];
            [formData appendPartWithFileData:imageData
                                        name:@"imgs"
                                    fileName:@"imgs"
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
            oSchedule.id = [NSNumber numberFromObject:responseDict[JSONDataKeyID]
                                   zeroIfUnresolvable:NO];
            dict[kInfoKeyObject]    = oSchedule;
            
            //操作成功
            if ([delegate respondsToSelector:@selector(addVisitScheduleSuccess:)]) {
                [delegate addVisitScheduleSuccess:dict];
            }
        }else {
            //错误信息
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //操作失败
            if ([delegate respondsToSelector:@selector(addVisitScheduleFailed:)]) {
                [delegate addVisitScheduleFailed:dict];
            }
        }
    };
    
    //其他错误返回
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"addVisitScheduleFailed:"];
    
    //调接口
    [self multipartFormRequestWithPOSTPath:path parameters:parameters constructingBodyWithBlock:construction success:success failure:failed];
}

/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=254
 * url visitPlan
 * 方法  put
 * 这里的更新只更新基本信息，图片的修改要调单独的删除、上传接口
 */
-(void)updateVisitSchedule:(OSchedule *) oSchedule delegate:(id<KHHNetAgentVisitScheduleDelegates>) delegate
{
    //网络状态
//    if (![self networkStateIsValid]) {
//        if ([delegate respondsToSelector:@selector(updateVisitScheduleFailed:)]) {
//            NSDictionary * dict = [self networkUnableFailedResponseDictionary];
//            [delegate updateVisitScheduleFailed:dict];
//        }
//        
//        return;
//    }
    if ([self networkStateIsValid:delegate selector:@"updateVisitScheduleFailed:"]) {
        return;
    }
    
    // 检查参数
    if (!oSchedule || oSchedule.id <= 0) {
//        if ([delegate respondsToSelector:@selector(updateVisitScheduleFailed:)]) {
//            //参数错误
//            NSDictionary * dict = [self parametersNotMeetRequirementFailedResponseDictionary];
//            [delegate updateVisitScheduleFailed:dict];
//        }
        [self parametersNotMeetRequirementFailedResponse:delegate selector:@"updateVisitScheduleFailed:"];
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:10];
    parameters[@"id"]               = oSchedule.id.stringValue;
    if (oSchedule.content.length)
        parameters[@"visitContext"] = oSchedule.content;
    if (oSchedule.customer.length)
        parameters[@"customName"]   = oSchedule.customer;
    if (oSchedule.plannedDate)
        parameters[@"planTimeTemp"] = KHHDateStringFromDate(oSchedule.plannedDate);
    if (oSchedule.isRemind)
        parameters[@"isRemind"]     = oSchedule.isRemind.stringValue;
    if (oSchedule.minutesToRemind)
        parameters[@"remindDate"]   = oSchedule.minutesToRemind.stringValue;
    if (oSchedule.addressProvince.length)
        parameters[@"province"]     = oSchedule.addressProvince;
    if (oSchedule.addressCity.length)
        parameters[@"city"]         = oSchedule.addressCity;
    if (oSchedule.addressOther.length)
        parameters[@"address"]      = oSchedule.addressOther;
    if (oSchedule.companion.length)
        parameters[@"withPerson"]   = oSchedule.companion;
    if (oSchedule.isFinished)
        parameters[@"isFinished"]   = (oSchedule.isFinished.boolValue)? @"y": @"n";
    
    NSMutableString *cardIDs = [NSMutableString string];
    NSMutableString *cardTypes = [NSMutableString string];
    for (Card *card in oSchedule.targetCardList) {
        [cardIDs appendFormat:@"%@%@",card.id.stringValue, KHH_SEPARATOR];
        [cardTypes appendFormat:@"%@%@",card.nameForServer, KHH_SEPARATOR];
    }
    
    //如果有选择的联系人就存入相应值，没有就存nil(可能是更新把原先的删除了)
    if (cardIDs.length) {
        parameters[@"customCardIds"] = cardIDs;
        parameters[@"customTypes"]   = cardTypes;
    }else {
        parameters[@"customCardIds"] = @"";
        parameters[@"customTypes"]   = @"";
    }
    
    //url
    NSString *path = @"visitPlan";
    
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        if (code == KHHErrorCodeSucceeded) {
            //操作成功, 返回上层时与服务器进行次同步
            if ([delegate respondsToSelector:@selector(updateVisitScheduleSuccess)]) {
                [delegate updateVisitScheduleSuccess];
            }
        }else {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
            dict[kInfoKeyErrorCode] = @(code);
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            
            //操作成功
            if ([delegate respondsToSelector:@selector(updateVisitScheduleFailed:)]) {
                [delegate updateVisitScheduleFailed:dict];
            }
        }
    };
    
    //其它错误信息
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"updateVisitScheduleFailed:"];
    
    //与服务进行通讯
    [self putPath:path parameters:parameters success:success failure:failed];
}

/*
 * http://192.168.1.151/zentaopms/www/index.php?m=docf=view&docID=255
 * url visitPlan/{id}
 * 方法   delete
 */
-(void)deleteVisitScheduleByID:(long) scheduleID delegate:(id<KHHNetAgentVisitScheduleDelegates>) delegate
{
    //判断网络
    if ([self networkStateIsValid:delegate selector:@"deleteVisitScheduleFailed:"]) {
        return;
    }
    
    //检查参数
    if (scheduleID <= 0) {
        //        if ([delegate respondsToSelector:@selector(deleteVisitScheduleFailed:)]) {
        //            NSDictionary *dict = [self parametersNotMeetRequirementFailedResponseDictionary];
        //            [delegate deleteVisitScheduleFailed:dict];
        //        }
        [self parametersNotMeetRequirementFailedResponse:delegate selector:@"deleteVisitScheduleFailed:"];
        return;
    }
    
    //urlFormat
    NSString *pathFormat = @"visitPlan/%ld";
    NSString *path = [NSString stringWithFormat:pathFormat, scheduleID];
    
    //服务器成功返回数据
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        if (code == KHHErrorCodeSucceeded) {
            //操作成功, 返回上层时与服务器进行次同步
            if ([delegate respondsToSelector:@selector(deleteVisitScheduleSuccess)]) {
                [delegate deleteVisitScheduleSuccess];
            }
        }else {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
            dict[kInfoKeyErrorCode] = @(code);
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            
            //操作成功
            if ([delegate respondsToSelector:@selector(deleteVisitScheduleFailed:)]) {
                [delegate deleteVisitScheduleFailed:dict];
            }
        }
    };
    
    //其它错误信息
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"deleteVisitScheduleFailed:"];
    
    //调网络接
    [self deletePath:path parameters:nil success:success failure:failed];
}


/*
 * 更新拜访计划时上传拜访图片
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=295
 * url visitPlan/{visitPlan_id}
 * 方法 put
 */
- (void)uploadImage:(UIImage *)img forVisitSchedule:(long) scheduleID delegate:(id<KHHNetAgentVisitScheduleDelegates>) delegate {
    //判断网络
    if ([self networkStateIsValid:delegate selector:@"uploadVisitScheduleImageFailed:"]) {
        return;
    }
    
    //检查参数
    if (nil == img || scheduleID <= 0) {
//        if ([delegate respondsToSelector:@selector(uploadVisitScheduleImageFailed:)]) {
//            NSDictionary *dict = [self parametersNotMeetRequirementFailedResponseDictionary];
//            [delegate uploadVisitScheduleImageFailed:dict];
//        }
        [self parametersNotMeetRequirementFailedResponse:delegate selector:@"uploadVisitScheduleImageFailed:"];
        return;
    }
    
    //url
    NSString * pathFormat = @"visitPlan/%ld";
    NSString * path = [NSString stringWithFormat:pathFormat, scheduleID];
    
    //更新的文件
    KHHConstructionBlock construction = ^(id <AFMultipartFormData> formData) {
        NSData *imageData = [img resizedImageDataForKHHUpload];
        [formData appendPartWithFileData:imageData
                                    name:@"imgs"
                                fileName:@"imgs"
                                mimeType:@"image/jpeg"];
    };
    
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        if (code == KHHErrorCodeSucceeded) {
            //操作成功, 返回上层时与服务器进行次同步
            if ([delegate respondsToSelector:@selector(uploadVisitScheduleImageSuccess)]) {
                [delegate uploadVisitScheduleImageSuccess];
            }
        }else {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
            dict[kInfoKeyErrorCode] = @(code);
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            
            //操作成功
            if ([delegate respondsToSelector:@selector(uploadVisitScheduleImageFailed:)]) {
                [delegate uploadVisitScheduleImageFailed:dict];
            }
        }
    };
    
    //其它错误信息
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"uploadVisitScheduleImageFailed:"];
    
    //调网络接口
    [self multipartFormRequestWithPUTPath:path parameters:nil constructingBodyWithBlock:construction success:success failure:failed];
}

/*
 * 删除拜访计划图片
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=296
 * url visitPlan/{visitPlan_id}/{visitPlanAttachment_ids}
 * visitPlanAttachment_ids 为多个时 拼装格式：图片id,多个使用“,”分割（英文逗号分割），如1,2,3
 * 方法   delete
 */
- (void)deleteImageByIDs:(NSString *) imageIDs fromVisitSchedule:(long) scheduleID delegate:(id<KHHNetAgentVisitScheduleDelegates>) delegate {
    //判断网络
    if ([self networkStateIsValid:delegate selector:@"deleteVisitScheduleImageFailed:"]) {
        return;
    }
    //检查参数
    if (imageIDs.length <= 0 || scheduleID <= 0) {
        [self parametersNotMeetRequirementFailedResponse:delegate selector:@"deleteVisitScheduleImageFailed:"];
        return;
    }
    
    //url
    NSString * pathFormat = @"visitPlan/%ld/%@";
    NSString * path = [NSString stringWithFormat:pathFormat, scheduleID, imageIDs];
    
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        DLog(@"[II] responseDict = %@", responseDict);
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        if (code == KHHErrorCodeSucceeded) {
            //操作成功, 返回上层时与服务器进行次同步
            if ([delegate respondsToSelector:@selector(deleteVisitScheduleImageSuccess)]) {
                [delegate deleteVisitScheduleImageSuccess];
            }
        }else {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
            //错误码
            dict[kInfoKeyErrorCode] = @(code);
            //错误信息
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            
            //操作成功
            if ([delegate respondsToSelector:@selector(deleteVisitScheduleImageFailed:)]) {
                [delegate deleteVisitScheduleImageFailed:dict];
            }
        }
    };
    
    //其它错误信息
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"deleteVisitScheduleImageFailed:"];
    
    //调网络接口
    [self putPath:path parameters:nil success:success failure:failed];
}
@end
