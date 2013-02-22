//
//  InterShake.m
//  CardBook
//
//  Created by CJK on 13-2-1.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "InterShake.h"

@implementation InterShake

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate
{
    _longitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
    _latitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
}

- (void)setCard:(Card *)card
{
    _cardId = [NSString stringWithFormat:@"%lld",card.idValue];
    _version = [NSString stringWithFormat:@"%lld",card.versionValue];
}

- (NSMutableDictionary *)toNetParam
{
    NSMutableDictionary *dicPro = [[NSMutableDictionary alloc]initWithCapacity:7];
    dicPro[@"longitude"] = _longitude;
    dicPro[@"latitude"] = _latitude;
    dicPro[@"cardId"] = _cardId;
    dicPro[@"version"] = _version;
    dicPro[@"invalidTime"] = @(15*1000).stringValue;
    dicPro[@"hasGps"] = @"true";
    return dicPro;
}



@end
