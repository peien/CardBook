//
//  KHHMessageCell.m
//  CardBook
//
//  Created by CJK on 13-2-25.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHMessageNewCell.h"

@implementation KHHMessageNewCell
{
    UILabel *_labelTitle;
    UILabel *_labelTime;
    UILabel *_labelContent;
    UIImageView *_imageView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _dicParam = [[NSMutableDictionary alloc]init];
        _labelTitle = [[UILabel alloc]init];
        _labelTitle.font = [UIFont systemFontOfSize:12.0];
        
        _labelTime = [[UILabel alloc]init];
        _labelTime.font = [UIFont systemFontOfSize:7.0];
        
        _labelContent = [[UILabel alloc]init];
        _labelContent.font = [UIFont systemFontOfSize:10.0];
        
        _imageView = [[UIImageView alloc]init];
        _imageView.image = [UIImage imageNamed:@"xiaoxi"];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _labelTitle.frame = CGRectMake(20, 5, 70, 20);
    _labelTime.frame = CGRectMake(90, 10, 100, 70);
    _labelContent.frame = CGRectMake(20, 30, 150, 20);
    _imageView.frame = CGRectMake(5, 5, 10, 45);
    
    if (_dicParam[@"isRead"]) {
        _imageView.hidden = YES;
    }
    
    _labelTitle.text = _dicParam[@"title"];
    
    if (_dicParam[@"time"]) {
        _labelTime.text = _dicParam[@"time"];

    }
    if (_dicParam[@"content"]) {
        _labelContent.text = _dicParam[@"content"];
    }
    
    [self.contentView addSubview:_labelTitle];
    [self.contentView addSubview:_labelTime];
    [self.contentView addSubview:_labelContent];
    [self.contentView addSubview:_imageView];
    
}

@end
