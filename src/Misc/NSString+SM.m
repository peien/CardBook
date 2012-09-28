//
//  NSString+SM.m
//  CardBook
//
//  Created by 孙铭 on 12-9-18.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "NSString+SM.h"
#import "NSNumber+SM.h"

@implementation NSString (SM)
// 主要针对 string 和 number，其他都是@"%@"
+ (NSString *)stringFromObject:(id)obj {
    NSString *result = @"";
    if ([obj isKindOfClass:[NSString class]]) {
        result = obj;
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        result = [(NSNumber *)obj stringValue];
    } else if (nil == obj || [NSNull null] == obj) {
        result = @"";
    } else {
        result = [NSString stringWithFormat:@"%@",obj];
    }
    return result;
}

// 如果string为nil则返回@""。否则返回string本身。
+ (NSString *)stringByFilterNilFromString:(NSString *)string {
    return string?string:@"";
}

// nil if unresolvable; 1 if @"yes", 0 if @"no";
- (NSNumber *)numberValue {
    return [NSNumber numberFromString:self];
}
@end
