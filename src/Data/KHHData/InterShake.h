//
//  InterShake.h
//  CardBook
//
//  Created by CJK on 13-2-1.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Card.h"

@interface InterShake : NSObject
@property (nonatomic,strong) NSString *longitude;
@property (nonatomic,strong) NSString *latitude;
@property (nonatomic,strong) NSString *cardId;
@property (nonatomic,strong) NSString *version;
@property (nonatomic,strong) NSString *invalidTime;
@property (nonatomic,strong) NSString *hasGps;


//util;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;
@property (nonatomic,strong) Card *card;

- (NSMutableDictionary *)toNetParam;

@end
