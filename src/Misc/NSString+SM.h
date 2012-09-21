//
//  NSString+SM.h
//  CardBook
//
//  Created by 孙铭 on 12-9-18.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SM)
+ (NSString *)stringFromObject:(id)obj; // 主要针对 string 和 number，其他都是@"%@"
- (NSNumber *)numberValue; // nil if unresolvable; 1 if @"yes", 0 if @"no";
@end
