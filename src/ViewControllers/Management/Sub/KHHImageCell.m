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
    [self addImgViews];
    [self addBtn];    
    self.textLabel.text = _headStr;
    
    
}

- (void)addBtn
{
    [_imageBtn setImage:[UIImage imageNamed:@"tianjia_Btn_Red"] forState: UIControlStateNormal];
    [_imageBtn setImage:[UIImage imageNamed:@"tianjia_Btn_Red"] forState: UIControlStateHighlighted];
    CGRect r = self.bounds;
    CGSize size = [self.textLabel.text sizeWithFont:font];
    _imageBtn.frame = CGRectMake(r.origin.x+10+size.width+30+(_imgArr?_imgArr.count*(50+3):0), (r.size.height-50)/2, 50, 50);
    [self.contentView addSubview:_imageBtn];
}

- (void)addImgViews
{
    CGRect r = self.bounds;
    CGSize size = [self.textLabel.text sizeWithFont:font];
    for (int i=0;i<_imgArr.count;i++) {
        KHHImgViewInCell *img = [_imgArr objectAtIndex:i];
        img.frame = CGRectMake(r.origin.x+10+size.width+30+i*(50+3), (r.size.height-50)/2, 50, 50);
        [self.contentView addSubview:img];
    }
     
    
}

@end
