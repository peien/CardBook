//
//  NSNumber+String.m
//  CardBook
//
//  Created by 孙铭 on 12-9-13.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "NSNumber+String.h"

@implementation NSNumber (String)
+ (NSNumber *)numberFromString:(NSString *)string {
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * result = [f numberFromString:string];
    return result;
}
@end
