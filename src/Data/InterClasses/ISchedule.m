//
//  ISchedule.m
//  CardBook
//
//  Created by Sun Ming on 12-10-9.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "ISchedule.h"
#import "KHHKeys.h"
#import "Card.h"
#import "InterCard.h"
#import "IImage.h"
#import "NSNumber+SM.h"
#import "NSString+SM.h"

@implementation ISchedule

@end
@implementation ISchedule (KHHTransformation)

- (id)updateWithJSON:(NSDictionary *)json {
    self.id = [NSNumber numberFromObject:json[JSONDataKeyID] zeroIfUnresolvable:NO]; //id,
    self.version         = [NSNumber numberFromObject:json[JSONDataKeyVersion] zeroIfUnresolvable:YES]; //version,
    self.isDeleted       = [NSNumber numberFromObject:json[JSONDataKeyIsDelete] zeroIfUnresolvable:YES]; //isDelete,
    self.isFinished      = [NSNumber numberFromObject:json[JSONDataKeyIsFinished] zeroIfUnresolvable:YES]; //isFinished
    self.customer        = [NSString stringFromObject:json[JSONDataKeyCustomName]];//customName,
    self.companion       = [NSString stringFromObject:json[JSONDataKeyWithPerson]]; //withPerson,
    self.content         = [NSString stringFromObject:json[JSONDataKeyVisitContext]]; //visitContext,
    self.plannedDate     = [NSString stringFromObject:json[JSONDataKeyPlanTime]]; //planTime,
    self.isRemind        = [NSNumber numberFromObject:json[JSONDataKeyIsRemind] zeroIfUnresolvable:NO];//isRemind,
    self.minutesToRemind = [NSNumber numberFromObject:json[JSONDataKeyRemindDate] zeroIfUnresolvable:YES];//remindDate,
    
    //appendixs, IImage数组
    NSArray *imgList = json[JSONDataKeyAppendixs];
    
    self.imageList = [NSMutableArray arrayWithCapacity:imgList.count];
    for (id img in imgList) {
        IImage *ii = [[[IImage alloc] init] updateWithJSON:img];
        [self.imageList addObject:ii];
    }
    
    NSString *cardIDs   = [NSString stringFromObject:json[JSONDataKeyCustomCardIds]];
    NSString *cardTypes = [NSString stringFromObject:json[JSONDataKeyCustomTypes]];
    NSArray *cardIDList = [cardIDs componentsSeparatedByString:KHH_SEPARATOR];
    NSArray *cardTypeList = [cardTypes componentsSeparatedByString:KHH_SEPARATOR];
    self.targetCardList= [NSMutableArray arrayWithCapacity:cardIDList.count];
    for (NSInteger i = 0; i < cardIDList.count; i++ ) {
        NSNumber *ID = [NSNumber numberFromObject:cardIDList[i] zeroIfUnresolvable:NO];
        if (ID) {
            InterCard *iCard = [[InterCard alloc] init];
            iCard.id = ID;
            iCard.modelType = [Card CardModelTypeForServerName:cardTypeList[i]];
            [self.targetCardList addObject:iCard];
        }
    }
    // 地址信息
    self.address = [[[IAddress alloc] init] updateWithJSON:json];
    return self;
}
@end