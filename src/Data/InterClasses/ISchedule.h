//
//  ISchedule.h
//  CardBook
//
//  Created by Sun Ming on 12-10-9.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMObject.h"
#import "IAddress.h"

@interface ISchedule : SMObject

@property (nonatomic, strong) NSNumber *id; //id,
@property (nonatomic, strong) NSNumber *version; //version,

@property (nonatomic, strong) NSNumber *isDeleted; //isDelete,
@property (nonatomic, strong) NSNumber *isFinished; //isFinished

@property (nonatomic, strong) NSString *customer;//customName,
@property (nonatomic, strong) NSString *companion; //withPerson,
@property (nonatomic, strong) NSString *content; //visitContext,
@property (nonatomic, strong) NSString *plannedDate; //planTime,
@property (nonatomic, strong) NSNumber *isRemind;//isRemind,
@property (nonatomic, strong) NSNumber *minutesToRemind;//remindDate,
//customCardIds //customTypes
@property (nonatomic, strong) NSMutableArray *targetCardList;//InterCard数组 
@property (nonatomic, strong) NSMutableArray *imageList; //appendixs, IImage数组
// 地址信息
@property (nonatomic, strong) IAddress *address;

// userId
// cardId,为使用???
@end
@interface ISchedule (KHHTransformation)
- (id)updateWithJSON:(NSDictionary *)json;
@end