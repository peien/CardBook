//
//  KHHClientCellLNPCC.m
//  CardBook
//
//  Created by 孙铭 on 8/8/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHClientCellLNPCC.h"

const NSInteger CheckboxSize = 27;
const NSInteger CheckboxPadding = 10;

@implementation KHHClientCellLNPCC
@synthesize logoBtn = _logoBtn;

- (void)dealloc {
    self.checkbox = nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _checkbox = [[SMCheckbox alloc] init];
    [self addSubview:_checkbox];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGSize size = self.bounds.size;
    CGFloat w = size.width;
    CGFloat h = size.height;
    _checkbox.frame = CGRectMake(w - CheckboxSize - CheckboxPadding,
                                 h / 2 - CheckboxSize / 2,
                                 CheckboxSize,
                                 CheckboxSize);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
