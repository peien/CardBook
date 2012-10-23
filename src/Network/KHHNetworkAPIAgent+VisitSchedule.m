//
//  KHHNetworkAPIAgent+VisitSchedule.m
//  CardBook
//
//  Created by 孙铭 on 8/29/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgent+VisitSchedule.h"
#import "KHHLog.h"
#import "NSNumber+SM.h"
#import "NSObject+SM.h"
#import "UIImage+KHH.h"

@implementation KHHNetworkAPIAgent (VisitSchedule)
/**
 新建拜访计划 kinghhVisitCustomPlanService.create
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=156
 */
- (void)createVisitSchedule:(OSchedule *)oSchedule withMyCard:(MyCard *)myCard {
    NSString *action = kActionNetworkCreateVisitSchedule;
    NSString *query = @"kinghhVisitCustomPlanService.create";
    // 检查参数
    if (nil == myCard.id || 0 == oSchedule.content.length) {
        // 缺少必要的参数
        WarnParametersNotMeetRequirement(action);
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:10];
    parameters[@"cardId"]           = myCard.id.stringValue;
    parameters[@"visitContext"]     = oSchedule.content;
    if (oSchedule.customer)
        parameters[@"customName"]   = oSchedule.customer;
    if (oSchedule.plannedDate)
        parameters[@"planTimeTemp"] = KHHDateStringFromDate(oSchedule.plannedDate);
    if (oSchedule.isRemind)
        parameters[@"isRemind"]     = oSchedule.isRemind.stringValue;
    if (oSchedule.minutesToRemind)
        parameters[@"remindDate"]   = oSchedule.minutesToRemind.stringValue;
    if (oSchedule.addressProvince)
        parameters[@"province"]     = oSchedule.addressProvince;
    if (oSchedule.addressCity)
        parameters[@"city"]         = oSchedule.addressCity;
    if (oSchedule.addressOther)
        parameters[@"address"]      = oSchedule.addressOther;
    if (oSchedule.companion)
        parameters[@"withPerson"]   = oSchedule.companion;
    parameters[@"isFinished"]       = @"n";
    
    NSMutableString *cardIDs = [NSMutableString string];
    NSMutableString *cardTypes = [NSMutableString string];
    for (Card *card in oSchedule.targetCardList) {
        [cardIDs appendFormat:@"%@|",card.id.stringValue];
        [cardTypes appendFormat:@"%@|",card.nameForServer];
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
    
    // 处理返回
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
        KHHNetworkStatusCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        // 把返回的数据转成本地数据
        // 返回的ID
        oSchedule.id = [NSNumber numberFromObject:responseDict[JSONDataKeyID]
                               zeroIfUnresolvable:NO];
        dict[kInfoKeyObject]    = oSchedule;
        dict[kInfoKeyErrorCode] = @(code);
        NSString *name = NameWithActionAndCode(action, code);
        DLog(@"[II] 发送 Notification Name = %@", name);
        [self postASAPNotificationName:name info:dict];
    };
    
    [self postAction:action
               query:query
          parameters:parameters
    constructingBody:construction
             success:success];
}

/**
 修改拜访计划 kinghhVisitCustomPlanService.update
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=158
 */
- (void)updateVisitSchedule:(OSchedule *)oSchedule {
    NSString *action = kActionNetworkUpdateVisitSchedule;
    NSString *query = @"kinghhVisitCustomPlanService.update";
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:10];
//    parameters[@""] = ;
//    parameters[@""] = ;
//    parameters[@""] = ;
//    parameters[@""] = ;
//    parameters[@""] = ;
//    parameters[@""] = ;
//    parameters[@""] = ;
//    parameters[@""] = ;
//    parameters[@""] = ;
//    parameters[@""] = ;
//    parameters[@""] = ;
//    parameters[@""] = ;
//    parameters[@""] = ;
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        
    };
    [self postAction:action
               query:query
          parameters:parameters
             success:success];
}

/**
 删除拜访计划 kinghhVisitCustomPlanService.delete
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=159
 */
- (void)deleteVisitSchedule:(ISchedule *)schedule {
    NSString *action = kActionNetworkDeleteVisitSchedule;
    NSString *query = @"kinghhVisitCustomPlanService.delete";
    NSMutableDictionary *parameters;
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        
    };
    [self postAction:action
               query:query
          parameters:parameters
             success:success];
}

/**
 拜访计划增量 kinghhVisitCustomPlanService.incList
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=155
 */
- (void)visitSchedulesAfterDate:(NSString *)lastDate
                          extra:(NSDictionary *)extra {
    
    NSString *action = @"visitSchedulesAfterDate";
    
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *op, id response) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:response];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
        
        // 把返回的数据转成本地数据
        KHHNetworkStatusCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        if (KHHNetworkStatusCodeSucceeded == code) {
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
        }
        
        // errorCode 和 extra
        dict[kInfoKeyErrorCode] = @(code);
        dict[kInfoKeyExtra] = extra;
        // 把处理完的数据发出去。
        [self postASAPNotificationName:NameWithActionAndCode(action, code)
                                  info:dict];
    };
    
    NSDictionary *parameters = @{
    @"lastUpdTime" : [lastDate length] > 0? lastDate: @""
    };
    [self postAction:action
               query:@"kinghhVisitCustomPlanService.incList"
          parameters:parameters
             success:success
               extra:extra];
}
/**
 上传拜访图片 kinghhVisitCustomPlanService.uploadImg
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=161
 */
//- (BOOL)uploadImage:(NSString *)imgPath
//   forVisitSchedule:(Schedule *)visitSchedule {
//    if (!ScheduleHasRequiredAttributes(visitSchedule, KHHScheduleAttributeID)) {
//        return NO;
//    }
//    NSString *standardizedPath = [imgPath stringByStandardizingPath];
//    UIImage *img = [UIImage imageWithContentsOfFile:standardizedPath];
//    if (nil == img) {
//        return NO;
//    }
//    NSMutableDictionary *parameters = ParametersFromSchedule(visitSchedule, KHHScheduleAttributeID);
//    [parameters setObject:img
//                   forKey:@"imgs"];
//    [self postAction:@"uploadImageForVisitSchedule"
//               query:@"kinghhVisitCustomPlanService.uploadImg"
//          parameters:parameters
//             success:nil];
//    return YES;
//}
/**
 删除拜访图片 kinghhVisitCustomPlanService.delImg
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=160
 */
//- (BOOL)deleteImage:(NSString *)imgID
//  fromVisitSchedule:(Schedule *)visitSchedule {
//
//}
@end
