//
//  KHHViewAdapterUtil.h
//  CardBook
//  
//  Created by 王定方 on 13-1-7.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//
// 屏幕中某些控件在iphone4s及以前的设备上的底部，时到iphone5上要相应降低些

#import <Foundation/Foundation.h>

@interface KHHViewAdapterUtil : NSObject
//是否要下移
+(void) checkIsNeedMoveDownForIphone5:(UIView *) view;
//是否要下移5比4s及以前高出部分的一半高度
+(void) checkIsNeedMoveHalfDownForIphone5:(UIView *) view;
//往下移某个高度
+(void) checkIsNeedMoveDownForIphone5:(UIView *) view height:(float) height;
//是否要增加高度
+(void) checkIsNeedAddHeightForIphone5:(UIView *) view;
@end
