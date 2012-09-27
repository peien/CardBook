//
//  KHHAddressCell.m
//  CardBook
//
//  Created by 王国辉 on 12-9-22.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHAddressCell.h"

@implementation KHHAddressCell
@synthesize bigAdress;
@synthesize detailAdress;
@synthesize name;

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
