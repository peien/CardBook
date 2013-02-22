//
//  KHHInputTableView.m
//  CardBook
//
//  Created by CJK on 13-1-6.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//


#import "KHHInputTableView.h"

@implementation KHHInputTableView

{
    Boolean showKeyboard;
    float normalH;
    
    
        float contenProx ;
        float contenProy ;    
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
  //  NSLog(@"%f",self.frame.size.width);
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                        // self.frame = CGRectMake(0.0f, 0,320,normalH);
                         self.contentOffset = CGPointMake(contenProx,contenProy);
                         [self setContentInset:UIEdgeInsetsMake(0,0,0,0)];
                     }
                     completion:^(BOOL finished){
                         _offset = 0;
                     }];
}

- (void)goToInsetForKeyboard:(CGRect)frame
{
    contenProx = self.contentOffset.x;
    contenProy = self.contentOffset.y;
     //contentOffsetPro = CGPointMake(self.contentOffset.x, self.contentOffset.y) ;
   // NSLog(@"%f",self.frame.size.width);
    showKeyboard = YES;
    int offset = -self.contentOffset.y+self.frame.origin.y+frame.origin.y + frame.size.height - (480 - KHH_Keyboard_Height);
    if (iPhone5) {
        offset = -self.contentOffset.y+self.frame.origin.y+frame.origin.y + frame.size.height - (568 - KHH_Keyboard_Height);
    }
   
    if (offset<=0&&self.contentOffset.y<=0) {
        return;
    }
    
    if (offset<=0) {
        offset = 0;
    }
    
   // CGRect rect = CGRectMake(0.0f, 0,320,normalH+120);
    CGPoint pointPro = CGPointMake(0.0, self.contentOffset.y+offset);
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                       //  self.frame = rect;
                         NSLog(@"showKeyboard");
                         [self setContentInset:UIEdgeInsetsMake(0,0,180,0)];
                         self.contentOffset = pointPro;
                     }
                     completion:^(BOOL finished){
                         _offset = self.contentOffset.y+offset;
                         
                     }];
}


@end
