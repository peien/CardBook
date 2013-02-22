//
//  KHHDateUtil.h
//  CardBook
//
//  Created by CJK on 13-1-4.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KHHDateUtil : NSObject


+ (NSString *)nowDate;
+ (NSString *)strFromDate:(NSDate *)date;
+ (NSString *)strTimeFromDate:(NSDate *)date;

@end
