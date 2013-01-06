//
//  KHHImageCell.m
//  CardBook
//
//  Created by CJK on 13-1-5.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHImageCell.h"

@implementation KHHImageCell
{
    UIFont *font;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        font = [UIFont systemFontOfSize:13];
        self.textLabel.font = [UIFont systemFontOfSize:12];
        _imageBtn = [[UIButton alloc]init];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  //  [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_imageBtn setImage:[UIImage imageNamed:@"tianjia_Btn_Red"] forState: UIControlStateNormal];
    [_imageBtn setImage:[UIImage imageNamed:@"tianjia_Btn_Red"] forState: UIControlStateHighlighted];
    CGRect r = self.bounds;
    CGSize size = [self.textLabel.text sizeWithFont:font];
    _imageBtn.frame = CGRectMake(r.origin.x+10+size.width+30, (r.size.height-50)/2, 50, 50);
    [self.contentView addSubview:_imageBtn];
    self.textLabel.text = _headStr;
}

@end
