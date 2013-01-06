//
//  KHHUpperView.m
//  CardBook
//
//  Created by CJK on 13-1-6.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHUpperView.h"

@implementation KHHUpperView
{
    UIButton *upperBtn;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor grayColor];
        upperBtn = [[UIButton alloc]init];
              
    }
    return self;
}





- (void)layoutSubviews
{
    [super layoutSubviews];    
    
    upperBtn.frame = CGRectMake(320/2-200/2, 50/2-30/2, 200, 30);
    upperBtn.backgroundColor = [UIColor whiteColor];
    [upperBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [upperBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
     [upperBtn setTitle:@"我要上传" forState:UIControlStateNormal];
    [upperBtn setTitle:@"我要上传" forState:UIControlStateHighlighted];
    [self addSubview:upperBtn];
}


@end
