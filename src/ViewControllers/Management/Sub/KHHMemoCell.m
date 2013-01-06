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
    UIButton *button;
   
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        font = [UIFont systemFontOfSize:13];
        self.textLabel.font = [UIFont systemFontOfSize:12];
        
        button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //button.backgroundColor = [UIColor brownColor];
        button.titleLabel.font = font;
        [button addTarget:self action:@selector(butToDelagte) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];   
}

- (void)butToDelagte
{
    if ([_pickerDelegate respondsToSelector:@selector(selectPicker:)]) {
        [_pickerDelegate performSelector:@selector(selectPicker:) withObject:_indexpath];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.text = _headStr;
    
    
    CGRect r = self.bounds;
    CGSize size = [self.textLabel.text sizeWithFont:font];
    button.frame = CGRectMake(r.origin.x+10+size.width+30, (r.size.height-20)/2, 160, 20);
    [button setTitle:_butTitle forState:0];
    [button setTitle:_butTitle forState:1];
    [self.contentView addSubview:button];
    
}

@end
