//
//  KHHUpperView.m
//  CardBook
//
//  Created by CJK on 13-1-6.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHUpperView.h"

@implementation KHHUpperView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor grayColor];
        
    }
    return self;
}

- (void)subViews
{
    UIButton *upperBtn = [[UIButton alloc]init];
   
    upperBtn.frame = CGRectMake(320/2-200/2, 50/2-30/2, 200, 30);
    upperBtn.titleLabel.text = @"我要上传";
    [self addSubview:upperBtn];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    
}


@end
