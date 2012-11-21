//
//  NSURL+KHH.m
//  CardBook
//
//  Created by 孙铭 on 8/24/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "NSURL+KHH.h"
#import "KHHMacros.h"

@implementation NSURL (KHH)
+ (NSURL *)KHHBaseURL {
    NSString *url = [NSString stringWithFormat:KHHURLFormat,KHHServer,@""];
    DLog(@"[II] base URL string = %@", url);
    return [NSURL URLWithString:url];
}
@end
