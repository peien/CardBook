//
//  OSchedule.h
//  CardBook
//
//  Created by Sun Ming on 12-10-23.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "SMObject.h"
#import "Schedule.h"

@interface OSchedule : SMObject

@property (nonatomic, strong) NSNumber *id; //id, 新建时空着，修改是必须非空！
@property (nonatomic, strong) NSNumber *isFinished; //isFinished

@property (nonatomic, strong) NSString *customer;//customName,
@property (nonatomic, strong) NSString *companion; //withPerson,
@property (nonatomic, strong) NSString *content; //visitContext,
@property (nonatomic, strong) NSDate   *plannedDate; //planTime,
@property (nonatomic, strong) NSNumber *isRemind;//isRemind,
@property (nonatomic, strong) NSNumber *minutesToRemind;//remindDate,

@property (nonatomic, strong) NSMutableArray *targetCardList;//Card 数组, 拜访对象？
@property (nonatomic, strong) NSMutableArray *imageList; //UIImage 数组

// 地址信息
@property (nonatomic, strong) NSString *addressProvince;
@property (nonatomic, strong) NSString *addressCity;
@property (nonatomic, strong) NSString *addressOther;

@end

@interface OSchedule (Transmission)

@end