//
//  KHHViewAdapterUtil.m
//  CardBook
//
//  Created by 王定方 on 13-1-7.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHViewAdapterUtil.h"

@implementation KHHViewAdapterUtil
//往下移iphone5比前iphone高出的高度
+(void) checkIsNeedMoveDownForIphone5:(UIView *) view
{
    if (!view) {
        return;
    }
    
    //iphone5 要做区分
    //iphone5的屏高为568,iphone4s及以前的是480
    if (iPhone5) {
        CGRect frame = view.frame;
        frame.origin.y += 568 - 480;
        view.frame = frame;
    }
}

//是否要下移5比4s及以前高出部分的一半高度
+(void) checkIsNeedMoveHalfDownForIphone5:(UIView *) view
{
    [self checkIsNeedMoveDownForIphone5:view height:(568 - 480) / 2];
}


//往下移某个高度
+(void) checkIsNeedMoveDownForIphone5:(UIView *) view height:(float) height
{
    if (!view) {
        return;
    }
    
    //iphone5 要做区分
    //iphone5的屏高为568,iphone4s及以前的是480
    if (iPhone5) {
        CGRect frame = view.frame;
        frame.origin.y += height;
        view.frame = frame;
    }
}

//是否要增加高度
+(void) checkIsNeedAddHeightForIphone5:(UIView *) view
{
    if (!view) {
        return;
    }
    
    //iphone5 要做区分
    //iphone5的屏高为568,iphone4s及以前的是480
    if (iPhone5) {
        CGRect frame = view.frame;
        frame.size.height += 568 - 480;
        view.frame = frame;
    }
}
@end
