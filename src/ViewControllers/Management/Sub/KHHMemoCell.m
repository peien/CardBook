//
//  KHHMemoCell.m
//  CardBook
//
//  Created by CJK on 13-1-6.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHMemoCell.h"

@implementation KHHMemoCell
{
    UIFont *font;
   
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        font = [UIFont systemFontOfSize:13];
        self.textLabel.font = [UIFont systemFontOfSize:12];
        
        _butTitle = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _butTitle.backgroundColor = [UIColor brownColor];
        _butTitle.titleLabel.font = font;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];   
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.text = @"备注";
    
    
    CGRect r = self.bounds;
    CGSize size = [self.textLabel.text sizeWithFont:font];
    _butTitle.frame = CGRectMake(r.origin.x+10+size.width+30, (r.size.height-50)/2, 50, 50);
    [self.contentView addSubview:_butTitle];
}

@end
