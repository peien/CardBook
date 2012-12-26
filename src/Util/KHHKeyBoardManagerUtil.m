//
//  KHHKeyBoardManagerUtil.m
//  CardBook
//
//  Created by 王定方 on 12-12-24.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHKeyBoardManagerUtil.h"


//键盘高度216,35是为了在输入法切换成中文时多出的框也不要挡住输入框
static float const KHH_Keyboard_Height = 216.0 + 35;

@implementation KHHKeyBoardManagerUtil

/* 显示键盘，如果textFiled被挡住就要重新设置界面rootView的frame
 * 这个rootView一般为界面的self.view
 * frame 当前编辑的textField的在屏幕上的位置（如果是在某parent下就要传parent）
 */
+(void) adjustPanelsWithKeybord:(UIView *) rootView textFieldRect:(CGRect) frame
{
    if (!rootView) {
        return;
    }
    
    int offset = frame.origin.y + frame.size.height - (rootView.frame.size.height - KHH_Keyboard_Height);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = rootView.frame.size.width;
    float height = rootView.frame.size.height;
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        rootView.frame = rect;
    }
    [UIView commitAnimations];
}

+(void) hideKeyboard:(UIView *) rootView
{
    [self hideKeyboard:KHH_Default_Point rootView:rootView];
}

//隐藏键盘，还原rootView
+(void) hideKeyboard:(CGPoint) orgine rootView:(UIView *) rootView
{
    if (!rootView) {
        return;
    }
    
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, rootView.frame.size.width, rootView.frame.size.height);
    rootView.frame = rect;
    [UIView commitAnimations];
}
@end
