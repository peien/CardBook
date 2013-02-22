//
//  KHHDateUtil.m
//  CardBook
//
//  Created by CJK on 13-1-4.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDateUtil.h"

static NSDateFormatter *dateFormatter;

@implementation KHHDateUtil


+ (NSString *)nowDate
{    
    return [self strFromDate:[NSDate date]];
}

+ (NSString *)strFromDate:(NSDate *)date
{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)strTimeFromDate:(NSDate *)date
{
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    [dateFormatter setDateFormat:@"HH:mm"];
    return [dateFormatter stringFromDate:date];
}


@end
