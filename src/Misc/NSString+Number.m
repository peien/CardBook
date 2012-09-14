//
//  NSString+Number.m
//  CardBook
//
//  Created by 孙铭 on 12-9-13.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "NSString+Number.h"

@implementation NSString (Number)
- (NSNumber *)numberValue {
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * result = [f numberFromString:self];
    return result;
}
@end
