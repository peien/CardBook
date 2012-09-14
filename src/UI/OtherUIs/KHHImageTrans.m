//
//  KHHImageTrans.m
//  CardBook
//
//  Created by 王国辉 on 12-9-6.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "KHHImageTrans.h"

@implementation KHHImageTrans

@end
@implementation UIImage(Half)

- (id)transformHalf
{
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width, self.size.height));
    [self drawInRect:CGRectMake(0.0f, 0.0f, self.size.width, self.size.height)];
    UIImage *bgImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return bgImg;
}
@end
