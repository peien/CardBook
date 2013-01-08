//
//  KHHInputTableView.m
//  CardBook
//
//  Created by CJK on 13-1-6.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//
static float const KHH_Keyboard_Height = 216.0 + 95;

#import "KHHInputTableView.h"

@implementation KHHInputTableView

{
    Boolean showKeyboard;
    float normalH;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        normalH = H460-44-50;        
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (showKeyboard) {
//        if ([[touches anyObject] locationInView:self].x >=200) {
//            [self showNormal];
//            if (_hiddenDelgate) {
//                [_hiddenDelgate performSelector:@selector(hiddenKeyboard)];
//            }
//        }
    }
    
    [super touchesBegan:touches withEvent:event];
}

- (void)showNormal
{
    showKeyboard = NO;
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         self.frame = CGRectMake(0.0f, 0,self.frame.size.width,normalH);
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void)goToInsetForKeyboard:(CGRect)frame
{
    showKeyboard = YES;
    int offset = frame.origin.y + frame.size.height - (480 - KHH_Keyboard_Height);
    
    if (offset<=0&&self.frame.origin.y==0) {
        return;
    }
    
    if (offset<=0) {
        offset = 0;
    }
    
    CGRect rect = CGRectMake(0.0f, -offset,self.frame.size.width,normalH+120);
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         self.frame = rect;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}


@end
