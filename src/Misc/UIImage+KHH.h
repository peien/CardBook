//
//  UIImage+KHH.h
//  CardBook
//
//  Created by Sun Ming on 12-10-12.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Resize.h"

@interface UIImage (KHH)
+ (UIImage *)imageNamed:(NSString *)name capInsets:(UIEdgeInsets)insets;
- (NSData *)resizedImageDataForKHHUpload;
@end
