//
//  KHHTargetCell.m
//  CardBook
//
//  Created by CJK on 13-1-4.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHTargetCell.h"

@implementation KHHTargetCell
{
    UITextField *field;   
    UIFont *font;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        font = [UIFont systemFontOfSize:13];
        self.textLabel.font = [UIFont systemFontOfSize:12];
        field = [[UITextField alloc]init];
       // field.placeholder = @"请选择拜访对象";
        field.font = font;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    return;
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect r = self.bounds;    
    CGSize size = [self.textLabel.text sizeWithFont:font]; 
  
    field.frame = CGRectMake(r.origin.x+10+size.width+30, (r.size.height-size.height)/2, r.size.width - 40-40 -size.width, size.height);
    field.placeholder = _placeStr;
    self.textLabel.text = _headStr;
    
    [self.contentView addSubview:field];
     self.textLabel.font = [UIFont systemFontOfSize:12];
    

}

@end
