//
//  KHHTargetCell.m
//  CardBook
//
//  Created by CJK on 13-1-4.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHTargetCell.h"
#import "CustomBadge.h"

@implementation KHHTargetCell
{
       
    UIFont *font;
    NSString *text;
    Boolean _selected;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        font = [UIFont systemFontOfSize:13];
        self.textLabel.font = [UIFont systemFontOfSize:12];
        _field = [[UITextField alloc]init];
        _field.returnKeyType = UIReturnKeyDone;
       // field.placeholder = @"请选择拜访对象";
        _field.font = font;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    _selected = selected;
    if (![_field isFirstResponder]&&selected) {
         [_field becomeFirstResponder];
    }
    
    if ([_field isFirstResponder]&&!selected) {
        [_field resignFirstResponder];
    }
    
}

- (void)registResponder
{
    if (_field.isFirstResponder) {
        [_field resignFirstResponder];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect r = self.bounds;    
    CGSize size = [self.textLabel.text sizeWithFont:font]; 
  
    _field.frame = CGRectMake(r.origin.x+10+size.width+30, (r.size.height-size.height)/2, r.size.width - 40-60 -size.width, size.height);
    _field.placeholder = _placeStr;
    
    if (text) {
         _field.text = text;
    }
   
    
    self.textLabel.text = _headStr;
    
    [self.contentView addSubview:_field];
     self.textLabel.font = [UIFont systemFontOfSize:12];

}

@end
