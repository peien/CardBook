//
//  InterSign.h
//  CardBook
//
//  Created by CJK on 13-1-21.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMObject.h"

@interface InterSign : SMObject



@property (nonatomic,strong) NSString *time;

@property (nonatomic,strong) NSString *localStr;
@property (nonatomic,strong) NSString *addressCountry;
@property (nonatomic,strong) NSString *addressProvince;
@property (nonatomic,strong) NSString *addressCity;
@property (nonatomic,strong) NSString *addressDistrict;

@property (nonatomic,strong) NSString *memo;
@property (nonatomic,strong) NSArray *imgs;
@property (nonatomic,strong) NSString *description;

@end
