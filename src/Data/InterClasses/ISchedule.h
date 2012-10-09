//
//  ISchedule.h
//  CardBook
//
//  Created by Sun Ming on 12-10-9.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISchedule : NSObject

@property (nonatomic, strong) NSNumber *id; //id,
@property (nonatomic, strong) NSNumber *version; //version,

@property (nonatomic, strong) NSNumber *isDeleted; //isDelete,
@property (nonatomic, strong) NSNumber *isFinished; //isFinished

@property (nonatomic, strong) NSString *name;//customName,
@property (nonatomic, strong) NSArray  *targetCardIDsAndTypes; //customCardIds //customTypes

@property (nonatomic, strong) NSString *companion; //withPerson,
@property (nonatomic, strong) NSString *content; //visitContext,
@property (nonatomic, strong) NSString *plannedDate; //planTime,

@property (nonatomic, strong) NSNumber *remind;//isRemind,
@property (nonatomic, strong) NSNumber *minutesToRemind;//remindDate,

@property (nonatomic, strong) NSArray *imageList; //appendixs, IImage数组

// 地址信息
@property (nonatomic, strong) NSString *addressCity; //city,
@property (nonatomic, strong) NSString *addressCountry;
@property (nonatomic, strong) NSString *addressDistrict;
@property (nonatomic, strong) NSString *addressProvince; //province,
@property (nonatomic, strong) NSString *addressStreet;
@property (nonatomic, strong) NSString *addressOther; //address,
@property (nonatomic, strong) NSString *addressZip;

// userId
// cardId,为使用???
@end
@interface ISchedule (transformation)
+ (ISchedule *)iScheduleWithJSON:(NSDictionary *)json;
@end