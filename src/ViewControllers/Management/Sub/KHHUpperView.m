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
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor grayColor];
        _upperBtn = [[UIButton alloc]init];
              
    }
    return self;
}





- (void)layoutSubviews
{
    [super layoutSubviews];    
    
    _upperBtn.frame = CGRectMake(320/2-200/2, 50/2-30/2, 200, 30);
    _upperBtn.backgroundColor = [UIColor whiteColor];
    [_upperBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_upperBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
     [_upperBtn setTitle:@"我要上传" forState:UIControlStateNormal];
    [_upperBtn setTitle:@"我要上传" forState:UIControlStateHighlighted];
    [self addSubview:_upperBtn];
}


@end
