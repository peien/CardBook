//
//  NSString+Networking.m
//  CardBook
//
//  Created by 孙铭 on 8/23/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "NSString+Networking.h"

@implementation NSString (Networking)
- (NSString *)stringByAppendingQueryParameters:(NSDictionary *)parameters {
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSString *key in parameters) {
        [resultArray addObject:[NSString stringWithFormat:@"%@=%@",key,[parameters objectForKey:key]]];
    }
    NSString *result = [NSString stringWithFormat:@"%@%@", self, [resultArray componentsJoinedByString:@"&"]];
    return result;
}
@end
