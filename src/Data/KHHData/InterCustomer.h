//
//  InterCustomer.h
//  CardBook
//
//  Created by CJK on 13-1-26.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMObject.h"

@interface InterCustomer : SMObject
@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *customerCard;
@property (nonatomic,strong) NSString *depth;
@property (nonatomic,strong) NSString *cost;
@property (nonatomic,strong) NSString *remarks;
@property (nonatomic,strong) NSString *customType;


@property (nonatomic,strong) NSString *knownTime;
@property (nonatomic,strong) NSString *knownAddress;
@property (nonatomic,strong) NSString *location;

- (void)toDBCustomer;
@end
