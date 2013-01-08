//
//  KHHDateCell.m
//  CardBook
//
//  Created by CJK on 13-1-4.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDateCell.h"

@implementation KHHDateCell

{   
    UILabel *label;
    UIFont *font;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        font = [UIFont systemFontOfSize:13];
        self.textLabel.font = [UIFont systemFontOfSize:12];
        label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.font = font;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect r = self.bounds;
    CGSize size = [self.textLabel.text sizeWithFont:font];
    label.frame = CGRectMake(r.origin.x+10+size.width+30, (r.size.height-size.height)/2, r.size.width - 40-40 -size.width, size.height);
    
    self.textLabel.text = _headStr;
    label.text = _dateStr;
    [self.contentView addSubview:label];
    self.textLabel.font = [UIFont systemFontOfSize:12];
}


@end
