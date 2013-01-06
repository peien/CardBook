//
//  KHHLocationCell.m
//  CardBook
//
//  Created by CJK on 13-1-5.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHLocationCell.h"
#import "UITextField+HideKeyBoard.h"

@implementation KHHLocationCell
{
    UIFont *font;
    UILabel *label;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        font = [UIFont systemFontOfSize:13];
        self.textLabel.font = [UIFont systemFontOfSize:12];
        
        label = [[UILabel alloc]init];
        label.font = font;
        
        _field = [[UITextField alloc]init];
        _field.font = font;
        _field.placeholder = @"请输入地址";
        
    }
    return self;
}

- (void)registResponder
{
    if (_field.isFirstResponder) {
        [_field resignFirstResponder];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if ([_field isFirstResponder]&&!selected) {
        [_field resignFirstResponder];
    }

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect r = self.bounds;
    CGSize size = [self.textLabel.text sizeWithFont:font];
    label.frame = CGRectMake(r.origin.x+10+size.width+30, (r.size.height-size.height)/2-15, r.size.width - 40-40 -size.width, size.height);
    label.text = _locationStr;
    
    _field.frame = CGRectMake(r.origin.x+10+size.width+30, (r.size.height-size.height)/2+12, r.size.width - 40-40 -size.width, size.height+10);
    [_field hideKeyBoard:self.superview];
    
    self.textLabel.text = _headStr;
    [self.contentView addSubview:label];
    [self.contentView addSubview:_field];
    self.textLabel.font = [UIFont systemFontOfSize:12];
}

@end
