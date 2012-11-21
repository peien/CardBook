//
//  KHHMyAlertViewWithSubView.m
//  CardBook
//
//  Created by 王定方 on 12-11-9.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHMyAlertViewWithSubView.h"
//#import "Card.h"
//#import "KHHFrameCardView.h"

@implementation KHHMyAlertViewWithSubView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

- (id)initWithTitle:(NSString *)title subView:(UIView *)subView delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super initWithTitle:title message:nil delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    if (self) {
        _mySubView = subView;
        [self addSubview:_mySubView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            CGRect btnBounds = view.frame;
            btnBounds.origin.y = _mySubView.frame.origin.y + _mySubView.frame.size.height + 5;
            view.frame = btnBounds;
        }
    }
    
    CGRect bounds = self.frame;
    bounds.size.height =  + _mySubView.frame.size.height + 110;
    self.frame = bounds;
}

@end
