//
//  NSString+MD5.h
//  CardBook
//
//  Created by 孙铭 on 8/23/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

/**
 此代码摘取自RestKit
 https://github.com/RestKit/RestKit/blob/master/Code/Support/NSString%2BRKAdditions.h
 */
 
#import <Foundation/Foundation.h>

@interface NSString (MD5)
/**
 Returns a string of the MD5 sum of the receiver.
 
 @return A new string containing the MD5 sum of the receiver.
 */
- (NSString *)MD5;
@end
