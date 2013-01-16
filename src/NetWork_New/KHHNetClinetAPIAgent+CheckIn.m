//
//  KHHNetClinetAPIAgent+CheckIn.m
//  CardBook
//
//  Created by 王定方 on 13-1-13.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent+CheckIn.h"
#import "ICheckIn.h"
#import "ICheckInForNetWork.h"
#import "NSString+SM.h"
#import "UIImage+KHH.h"

@implementation KHHNetClinetAPIAgent (CheckIn)
/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=276
 * 员工签到
 * url checkIn
 * 方法 post
 */
- (void)checkIn:(ICheckIn *)iCheckIn delegate:(id<KHHNetAgentCheckInDelegates>) delegate
{
    //检查网络
    if (![self networkStateIsValid:delegate selector:@"checkInFailed:"]) {
        return;
    }
    
    //检查参数
    if (!iCheckIn) {
        [self parametersNotMeetRequirementFailedResponse:delegate selector:@"checkInFailed:"];
        return;
    }
    
    //url 
    NSString *path = @"checkIn";
    //    CLPlacemark *placemark = iCheckIn.placemark;
    BMKGeocoderAddressComponent *addrComp = iCheckIn.addressComponent;
    
    //组装详细地址，空的直接加入的会出现(null)值
    NSMutableString *detailAddress = [[NSMutableString alloc] initWithCapacity:20];
    if (addrComp.district) {
        [detailAddress appendString:addrComp.district];
    }
    
    if (addrComp.streetName) {
        [detailAddress appendString:addrComp.streetName];
    }
    
    if (addrComp.streetNumber) {
        [detailAddress appendString:addrComp.streetNumber];
    }
    
    // 组合string参数
    NSDictionary *parameters = @{
    @"bean.cardId"      : [NSString stringFromObject:iCheckIn.cardID],
    @"bean.deviceToken" : [NSString stringFromObject:iCheckIn.deviceToken],
    @"bean.latitude"    : [NSString stringFromObject:iCheckIn.latitude],
    @"bean.longitude"   : [NSString stringFromObject:iCheckIn.longitude],
    //    //默认的定们解析
    //    @"bean.country"     : [NSString stringFromObject:placemark.country],
    //    @"bean.province"    : [NSString stringWithFormat:@"%@",
    //                           [NSString stringFromObject:placemark.administrativeArea]],
    //    @"bean.city"        : [NSString stringWithFormat:@"%@%@",
    //                           [NSString stringFromObject:placemark.locality],
    //                           [NSString stringFromObject:placemark.subLocality]],
    //    @"bean.address"     : [NSString stringWithFormat:@"%@%@",
    //                           [NSString stringFromObject:placemark.thoroughfare],
    //                           [NSString stringFromObject:placemark.subThoroughfare]],
    //百度地图(百度只能识别中国)
    @"bean.country"     : [NSString stringFromObject:@"中国"],
    @"bean.province"    : [NSString stringWithFormat:@"%@",addrComp.province],
    @"bean.city"        : [NSString stringWithFormat:@"%@",addrComp.city],
    @"bean.address"     : detailAddress,
    @"bean.col1"        : [NSString stringFromObject:iCheckIn.memo],
    };
    
    // 打包图片
    KHHConstructionBlock construction = ^(id <AFMultipartFormData>formData) {
        NSArray *imageArray = iCheckIn.imageArray;
        for (UIImage *image in imageArray) {
            NSData *imageData = [image resizedImageDataForKHHUpload];
            [formData appendPartWithFileData:imageData
                                        name:@"imgFiles"
                                    fileName:@"imgFiles"
                                    mimeType:@"image/jpeg"];
        }
    };
    
    //服务器有返回值
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        DLog(@"[II] response = %@", responseDict);
        // 把返回的数据转成本地数据
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        
        if (KHHErrorCodeSucceeded == code) {
            //修改成功, 返回到data层进行同步
            if ([delegate respondsToSelector:@selector(checkInSuccess)]) {
                [delegate checkInSuccess];
            }
        }else {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
            // errorCode
            dict[kInfoKeyErrorCode] = @(code);
            //错误信息
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //修改失败，返回失败信息
            if ([delegate respondsToSelector:@selector(checkInFailed:)]) {
                [delegate checkInFailed:dict];
            }
        }
    };
    
    //其他错误返回
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"checkInFailed:"];
    
    //调接口
    [self multipartFormRequestWithPOSTPath:path parameters:parameters constructingBodyWithBlock:construction success:success failure:failed];
}

/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=278
 * 增量获取员工签到记录
 * url checkIn/{cardId}/{lastUpdateDateStr}
 * 方法 get
 */
- (void)syncMySelfCheckInRecordWithDate:(NSString *) lastDate cardID:(long) cardID delegate:(id<KHHNetAgentCheckInDelegates>) delegate
{
    //检查网络
    if (![self networkStateIsValid:delegate selector:@"syncMySelfCheckInRecordFailed:"]) {
        return;
    }
    
    //检查参数
    if (cardID <= 0) {
        [self parametersNotMeetRequirementFailedResponse:delegate selector:@"syncMySelfCheckInRecordFailed:"];
        return;
    }
    
    //url
    NSString *pathFormat = @"checkIn/%ld/%@";
    NSString *path = [NSString stringWithFormat:pathFormat, cardID, lastDate.length > 0 ? lastDate : @""];
    
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
            //count
            dict[kInfoKeyCount] = [NSNumber numberFromObject:[responseDict valueForKey:JSONDataKeyCount] zeroIfUnresolvable:NO];
            //syncTime
            dict[kInfoKeySyncTime] = [NSString stringFromObject:[responseDict valueForKey:JSONDataKeySynTime]];
            //visitHistoryList --> ICheckInNetwork
            NSArray *planList = responseDict[JSONDataKeyPlanList];
            NSMutableArray *newList = [NSMutableArray arrayWithCapacity:planList.count];
            for (id obj in planList) {
                ICheckInForNetwork *iSchedule = [[[ICheckInForNetwork alloc] init] updateWithJSON:obj];
                DLog(@"[II] ICheckInForNetwork = %@", iSchedule);
                [newList addObject:iSchedule];
            }
            dict[kInfoKeyObjectList] = newList;
            
            //同步成功, 返回到data层进行保存
            if ([delegate respondsToSelector:@selector(syncMySelfCheckInRecordSuccess:)]) {
                [delegate syncMySelfCheckInRecordSuccess:dict];
            }
        }else {
            //错误信息
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //同步失败，返回失败信息
            if ([delegate respondsToSelector:@selector(syncMySelfCheckInRecordFailed:)]) {
                [delegate syncMySelfCheckInRecordFailed:dict];
            }
        }
    };
    
    //其他错误返回
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"syncMySelfCheckInRecordFailed:"];
    
    //调接口
    [self getPath:path parameters:nil success:success failure:failed];
}

/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=279
 * 增量获取员工签到记录
 * url checkIn/history/{cardId}/{startPage}/{ pageSize}/{lastUpdateDateStr}
 * 方法 get
 */
- (void)syncSubordinateCheckInRecordWithPage:(NSString *) startPage pageSize:(NSString *) pageSize cardID:(long) cardID lastDate:(NSString *) lastDate delegate:(id<KHHNetAgentCheckInDelegates>) delegate
{
    //检查网络
    if (![self networkStateIsValid:delegate selector:@"syncSubordinateCheckInRecordFailed:"]) {
        return;
    }
    
    //检查参数
    if (cardID <= 0 || startPage.length <= 0 || pageSize.length <= 0) {
        [self parametersNotMeetRequirementFailedResponse:delegate selector:@"syncSubordinateCheckInRecordFailed:"];
        return;
    }
    
    //url
    NSString *pathFormat = @"checkIn/history/%ld/%@/%@/%@";
    NSString *path = [NSString stringWithFormat:pathFormat, cardID, startPage, pageSize, lastDate.length > 0 ? lastDate : @""];
    
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
            //count
            dict[kInfoKeyCount] = [NSNumber numberFromObject:[responseDict valueForKey:JSONDataKeyCount] zeroIfUnresolvable:NO];
            //syncTime
            dict[kInfoKeySyncTime] = [NSString stringFromObject:[responseDict valueForKey:JSONDataKeySynTime]];
            //visitHistoryList --> ICheckInNetwork
            NSArray *planList = responseDict[JSONDataKeyPlanList];
            NSMutableArray *newList = [NSMutableArray arrayWithCapacity:planList.count];
            for (id obj in planList) {
                ICheckInForNetwork *iSchedule = [[[ICheckInForNetwork alloc] init] updateWithJSON:obj];
                DLog(@"[II] ICheckInForNetwork = %@", iSchedule);
                [newList addObject:iSchedule];
            }
            dict[kInfoKeyObjectList] = newList;
            
            //同步成功, 返回到data层进行保存
            if ([delegate respondsToSelector:@selector(syncSubordinateCheckInRecordSuccess:)]) {
                [delegate syncSubordinateCheckInRecordSuccess:dict];
            }
        }else {
            //错误信息
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //同步失败，返回失败信息
            if ([delegate respondsToSelector:@selector(syncSubordinateCheckInRecordFailed:)]) {
                [delegate syncSubordinateCheckInRecordFailed:dict];
            }
        }
    };
    
    //其他错误返回
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"syncSubordinateCheckInRecordFailed:"];
    
    //调接口
    [self getPath:path parameters:nil success:success failure:failed];
}
@end
