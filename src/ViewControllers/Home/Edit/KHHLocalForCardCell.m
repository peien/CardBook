//
//  KHHLocalForCardCell.m
//  CardBook
//
//  Created by CJK on 13-1-13.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHLocalForCardCell.h"

@implementation KHHLocalForCardCell
{
    UIFont *font;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
        if (self) {
            font = [UIFont systemFontOfSize:13];
            self.textLabel.font = [UIFont systemFontOfSize:12];
            
            _label = [[UILabel alloc]init];
            _label.font = font;
            _label.textAlignment = NSTextAlignmentLeft;
            [_label setUserInteractionEnabled:YES];
            [_label addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self                 action:@selector(singleTapAction)]];
            _label.backgroundColor = [UIColor clearColor];
            _field = [[UITextField alloc]init];
            _field.font = font;
            _field.placeholder = @"请输入地址";
            
        }
        return self;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect r = self.bounds;
    CGSize size = [self.textLabel.text sizeWithFont:font];
    _label.frame = CGRectMake(r.origin.x+10+size.width+30, (r.size.height-size.height)/2-15, r.size.width - 40-40 -size.width, size.height);
    _label.text = _locationStr;
//    //_button.titleLabel.text = _locationStr;
//   // _button.titleLabel.textColor = [UIColor blackColor];
//    [_button setTitle:_locationStr forState:UIControlStateNormal];
//    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal ];
//   // _button.titleLabel.text = _locationStr;
//    [_button setTitle:_locationStr forState:UIControlStateHighlighted];
//    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted ];
    
    _field.frame = CGRectMake(r.origin.x+10+size.width+30, (r.size.height-size.height)/2+12, r.size.width - 40-40 -size.width, size.height+10);
    
    
    self.textLabel.text = _headStr;
    [self.contentView addSubview:_label];
    [self.contentView addSubview:_field];
    self.textLabel.font = [UIFont systemFontOfSize:12];
}

- (void)singleTapAction
{
    if(_localTip){
        _localTip();
    }
}

@end
