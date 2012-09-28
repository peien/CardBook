//
//  UIColor+HexColor.h
//  CardBook
//
//  Created by 孙铭 on 12-9-25.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)
// 转换不成功默认返回黑色
+ (UIColor *)colorWithHexString:(NSString *)hexString;
@end
