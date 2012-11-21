//
//  NSString+Networking.h
//  CardBook
//
//  Created by 孙铭 on 8/23/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Networking)
- (NSString *)stringByAppendingQueryParameters:(NSDictionary *)parameters;
@end
