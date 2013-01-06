//
//  UITextField+HideKeyBoard.m
//  CardBook
//
//  Created by CJK on 13-1-5.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "UITextField+HideKeyBoard.h"

@implementation UITextField (HideKeyBoard)

- (void) hideKeyBoard:(UIView*)view
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(doHideKeyBoard)];
    
    tap.numberOfTapsRequired = 1;
    [view  addGestureRecognizer: tap];
    [tap setCancelsTouchesInView:NO];
   
}

- (void)doHideKeyBoard
{
    if ([self isFirstResponder]) {
        [self resignFirstResponder];
    }

}

@end
