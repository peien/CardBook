//
//  KHHNetworkAPIAgent+VisitSchedule.m
//  CardBook
//
//  Created by 孙铭 on 8/29/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgent+VisitSchedule.h"
#import "NSNumber+SM.h"
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
    if (nil == myCard.id) {
        // 缺少必要的参数
        WarnParametersNotMeetRequirement(action);
        return;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:10];
    parameters[@"cardId"]           = myCard.id.stringValue;
    
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
    
    // 处理返回
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
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
    // 检查参数
    if (nil == oSchedule.id) {
        // 缺少必要的参数
        WarnParametersNotMeetRequirement(action);
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
    
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
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
             success:success];
}

/**
 删除拜访计划 kinghhVisitCustomPlanService.delete
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=159
 */
- (void)deleteVisitSchedule:(ISchedule *)schedule {
    NSString *action = kActionNetworkDeleteVisitSchedule;
    NSString *query = @"kinghhVisitCustomPlanService.delete";
    // 检查参数
    if (nil == schedule.id) {
        // 缺少必要的参数
        WarnParametersNotMeetRequirement(action);
        return;
    }
    NSMutableDictionary *parameters;
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        // 把返回的数据转成本地数据
        dict[kInfoKeyObject]    = schedule;
        dict[kInfoKeyErrorCode] = @(code);
        NSString *name = NameWithActionAndCode(action, code);
        [self postASAPNotificationName:name info:dict];
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
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
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
- (void)uploadImage:(UIImage *)img 
   forVisitSchedule:(Schedule *)schdl {
    NSString *action = kActionNetworkUploadImageForVisitSchedule;
    if (nil == img || 0 == schdl.id.integerValue) {
        WarnParametersNotMeetRequirement(action);
    }
    KHHConstructionBlock construction = ^(id <AFMultipartFormData> formData) {
        NSData *imageData = [img resizedImageDataForKHHUpload];
        [formData appendPartWithFileData:imageData
                                    name:@"imgs"
                                fileName:@"imgs"
                                mimeType:@"image/jpeg"];
    };
    NSDictionary *parameters = @{ @"id" : schdl.id.stringValue };
    [self postAction:action
               query:@"kinghhVisitCustomPlanService.uploadImg"
          parameters:parameters
    constructingBody:construction
             success:nil];
}
/**
 删除拜访图片 kinghhVisitCustomPlanService.delImg
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=160
 */
- (void)deleteImage:(Image *)anImage
  fromVisitSchedule:(Schedule *)schdl {
    NSString *action = kActionNetworkDeleteImageFromVisitSchedule;
    if (0 == anImage.id.integerValue || 0 == schdl.id.integerValue) {
        WarnParametersNotMeetRequirement(action);
    }
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        DLog(@"[II] responseDict = %@", responseDict);
        
        // errorCode 和 imageID
        dict[kInfoKeyErrorCode] = @(code);
        dict[kInfoKeyObject]    = anImage;
        
        // 把处理完的数据发出去。
        [self postASAPNotificationName:NameWithActionAndCode(action, code)
                                  info:dict];
    };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:2];
    parameters[@"id"]          = schdl.id.stringValue;
    parameters[@"appendixIds"] = anImage.id.stringValue;
    [self postAction:action
               query:@"kinghhVisitCustomPlanService.delImg"
          parameters:parameters
             success:success];
}
@end
