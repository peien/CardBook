//
//  KHHButtonCell.m
//  CardBook
//
//  Created by 孙铭 on 8/7/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHButtonCell.h"

@implementation KHHButtonCell
@synthesize button = _button;

//- (id)init {
//    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
//                                          owner:self options:nil] objectAtIndex:0];
//    return self;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
