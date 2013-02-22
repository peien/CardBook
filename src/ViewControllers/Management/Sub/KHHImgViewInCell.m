//
//  KHHImgViewInCell.m
//  CardBook
//
//  Created by CJK on 13-1-7.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHImgViewInCell.h"

@implementation KHHImgViewInCell
{
    NSTimeInterval begin;
    NSTimeInterval end;
    UITapGestureRecognizer *singleTap;
    UILongPressGestureRecognizer *longPress;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
     
        self.userInteractionEnabled = YES;
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    begin = touch.timestamp;
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    if (end!=0&&touch.timestamp-end<=0.5) {
        return;
    }
    end = touch.timestamp;
    if(end - begin<=0.5){
        [_touchDelegate showLarge:self];
    }else{
        [_touchDelegate doDelete:self];
    }
    
}

//- (void)drawRect:(CGRect)rect
//{
//    [_img drawInRect:rect];
//}


@end
