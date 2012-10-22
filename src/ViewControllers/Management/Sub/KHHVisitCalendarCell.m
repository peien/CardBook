//
//  KHHVisitCalendarCell.m
//  CardBook
//
//  Created by 王国辉 on 12-8-23.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "KHHVisitCalendarCell.h"

@implementation KHHVisitCalendarCell
@synthesize Btn = _Btn;
@synthesize delegate = _delegate;
@synthesize finishBtn = _finishBtn;
@synthesize imgviewIco1;
@synthesize imgviewIco2;
@synthesize imgviewIco3;
@synthesize imgviewIco4;
@synthesize showLocBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)KHHVisitCalendarCellBtnClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if ([_delegate respondsToSelector:@selector(KHHVisitCalendarCellBtnClick:)]) {
        [_delegate KHHVisitCalendarCellBtnClick:button.tag];
    }

}
- (IBAction)showLocBtnClick:(id)sender{
    if ([_delegate respondsToSelector:@selector(KHHVisitCalendarCellBtnClick:)]) {
        [_delegate showLocaButtonClick:sender];
    }

}
@end
