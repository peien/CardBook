//
//  InterPlan.h
//  CardBook
//
//  Created by CJK on 13-1-21.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InterSign.h"

@interface InterPlan : InterSign

@property (nonatomic, strong) NSString *customCardIds;
@property (nonatomic, strong) NSString *customerName;

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *planTime;

@property (nonatomic, strong) NSString *remind;
@property (nonatomic, strong) NSString *remindDate;

@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *accompanist;
@property (nonatomic, strong) NSString *finished;

@property (nonatomic, strong) NSMutableArray *imgs;

//return
@property (nonatomic, strong) NSNumber *id;

//util
@property (nonatomic, strong) NSArray *cardsArr;
@property (nonatomic, strong) NSArray *imgViews;
@property (nonatomic, strong) NSString *localStr;
@end
