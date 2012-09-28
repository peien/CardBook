//
//  UIColor+HexColor.m
//  CardBook
//
//  Created by 孙铭 on 12-9-25.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "UIColor+HexColor.h"

@implementation UIColor (HexColor)
// 转换不成功默认返回黑色
+ (UIColor *)colorWithHexString:(NSString *)hexString {
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    NSUInteger hexInt;
    if ([hexString hasPrefix:@"#"]) {
        scanner.scanLocation = 1;
    } else if ([hexString hasPrefix:@"0x"]) {
        scanner.scanLocation = 2;
    }
    if ([scanner scanHexInt:&hexInt]) {
        // 解析hex成功
        // 开始转换
        CGFloat red = ((hexInt & 0xFF0000) >> 16) / 255.f;
        CGFloat green = ((hexInt & 0xFF00) >> 8) / 255.f;
        CGFloat blue = (hexInt & 0xFF) / 255.f;
        return [UIColor colorWithRed:red
                               green:green
                                blue:blue
                               alpha:1.f];
    }
    // 转换不成功默认返回黑色
    return [UIColor blackColor];

}
@end
