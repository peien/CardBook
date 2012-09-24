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
+ (NSNumber *)numberFromString:(NSString *)string {
    NSNumber *result = nil;
    if ([string isKindOfClass:[NSString class]]) {
        // 先尝试解析
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterNoStyle];
        result = [f numberFromString:string];
        
        if (result) {
            // 解析成功直接返回
            DLog(@"[II] number from string(%@) is %@", string, result);
            return result;
        }
        
        // 解析失败，尝试其他
        // 尝试scan
        NSScanner *scanner = [NSScanner scannerWithString:string];
        NSInteger intValue;
        if ([scanner scanInteger:&intValue]) {
            // 成功直接返回
            result = [NSNumber numberWithInteger:intValue];
            DLog(@"[II] number from string(%@) is %@", string, result);
            return result;
        };
        
        // 不成功则把string转为全大写，然后查字典
        NSString *ucString = [string uppercaseString];
        NSDictionary *mapDict = @{
        @"Y":@1, @"N":@0, @"YES":@1, @"NO":@0,
        };
        result = mapDict[ucString];
    }
    DLog(@"[II] number from string(%@) is %@", string, result);
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
//    DLog(@"[II] obj class = %@", [obj class]);
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
