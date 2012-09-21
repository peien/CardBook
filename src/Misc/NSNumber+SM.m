//
//  NSNumber+SM.m
//  CardBook
//
//  Created by 孙铭 on 12-9-18.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "NSNumber+SM.h"

@implementation NSNumber (SM)
// nil if unresolvable; 1 if @"yes", 0 if @"no";
+ (NSNumber *)numberFromString:(NSString *)value {
    NSNumber *result = nil;
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        result = [f numberFromString:value];
        if ([value caseInsensitiveCompare:@"yes"] == NSOrderedSame) {
            result = [NSNumber numberWithBool:YES];
        } else if ([value caseInsensitiveCompare:@"no"] == NSOrderedSame) {
            result = [NSNumber numberWithBool:NO];
        }
    }
    return result;
}
+ (NSNumber *)numberFromObject:(id)obj
            zeroIfUnresolvable:(BOOL)flag {
    return [self numberFromObject:obj
              defaultValue:0
     defaultIfUnresolvable:flag];
}
+ (NSNumber *)numberFromObject:(id)obj
                  defaultValue:(NSInteger)defaultValue
         defaultIfUnresolvable:(BOOL)flag {
    // 设置默认值
    id result = flag? [NSNumber numberWithInteger:defaultValue]: nil;
    DLog(@"[II] obj class = %@", [obj class]);
    if ([obj isKindOfClass:[NSNumber class]]) { //
        result = obj;
    } else if ([obj isKindOfClass:[NSString class]]) { //
        id tmp = [NSNumber numberFromString:obj];
        if (tmp) {
            result = tmp;
        }
    }
    return result;
}
@end
