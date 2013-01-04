//
//  KHHTargetCell.m
//  CardBook
//
//  Created by CJK on 13-1-4.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHTargetCell.h"

@implementation KHHTargetCell
{
    UITextField *field;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        field = [[UITextField alloc]initWithFrame:CGRectMake(60, 10, 200, 60)];
        field.placeholder = @"请选择拜访对象";
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [self addSubview:field];
}

@end
