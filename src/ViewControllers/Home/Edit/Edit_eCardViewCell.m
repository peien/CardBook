//
//  Edit_eCardViewCell.m
//  CardBook
//
//  Created by 王国辉 on 12-8-14.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "Edit_eCardViewCell.h"

@implementation Edit_eCardViewCell
@synthesize name = _name;
@synthesize value = _value;
@synthesize styleLab = _styleLab;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
