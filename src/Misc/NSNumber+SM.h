//
//  NSNumber+SM.h
//  CardBook
//
//  Created by 孙铭 on 12-9-18.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (SM)
// nil if unresolvable; 1 if @"yes", 0 if @"no";
+ (NSNumber *)numberFromString:(NSString *)string; 

// 调用numberFromObject:defaultValue:defaultIfUnresolvable:;
// flag == NO: 如果无法解析返回nil；
// flag == YES: 如果无法解析返回 0；
+ (NSNumber *)numberFromObject:(id)obj zeroIfUnresolvable:(BOOL)flag;

// 目前只能转nsstring，调用numberFromString;
// flag == NO:如果无法解析返回nil；
// flag == YES: 如果无法解析返回 默认值；
+ (NSNumber *)numberFromObject:(id)obj
                  defaultValue:(NSInteger)defaultValue
         defaultIfUnresolvable:(BOOL)flag; 
@end
