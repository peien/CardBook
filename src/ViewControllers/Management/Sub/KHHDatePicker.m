//
//  KHHDatePicker.m
//  CardBook
//
//  Created by CJK on 13-1-4.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDatePicker.h"

@implementation KHHDatePicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.minimumDate = [NSDate date];       
       
    }
    return self;
}





#pragma mark - animation

- (void)showInView:(UIView *) view
{
    if (iPhone5) {
        if (!self.superview) {
            self.frame = CGRectMake(0, 530, 320, 200);
            [view addSubview:self];
            self.hidden = NO;
        }else{
            self.hidden = NO;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, 330, 320,200);
        }];
        return;
    }
    if (!self.superview) {
        self.frame = CGRectMake(0, view.frame.size.height, self.frame.size.width, self.frame.size.height);
        [view addSubview:self];
         self.hidden = NO;
    }else{
        self.hidden = NO;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
    
}

- (void)cancelPicker:(Boolean)remove
{
    if (iPhone5) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.frame = CGRectMake(0, 530, 320, 200);
                         }
                         completion:^(BOOL finished){
                             if (remove) {
                                 [self removeFromSuperview];
                             }else{
                                 self.hidden = YES;
                             }
                             
                             
                         }];
        return;
    }
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         if (remove) {
                             [self removeFromSuperview];
                         }else{
                             self.hidden = YES;
                         }
     
                         
                     }];
    
}

@end
