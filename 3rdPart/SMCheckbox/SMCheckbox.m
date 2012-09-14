//
//  SMCheckbox.m
//
//  Created by 孙铭 on 8/9/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "SMCheckbox.h"
NSString *const SMCheckboxImage_Checked = @"checkbox_yes.png";
NSString *const SMCheckboxImage_Unchecked = @"checkbox_no.png";

@implementation SMCheckbox
@synthesize delegate = _delegate;
@synthesize checked = _checked;

- (void)awakeFromNib {
    [super awakeFromNib];
    _checked = NO;
    [self addTarget:self
             action:@selector(buttonTapped:)
   forControlEvents:UIControlEventTouchUpInside];
}

- (void)setChecked:(BOOL)newValue {
    if (_checked != newValue) {
        // 值改变了
        _checked = newValue;
        UIImage *image = newValue?
                [UIImage imageNamed:SMCheckboxImage_Checked]:
                [UIImage imageNamed:SMCheckboxImage_Unchecked];
        [self setImage:image forState:UIControlStateNormal];
        if (_delegate && [_delegate respondsToSelector:@selector(checkbox:valueChanged:)]) {
            [_delegate checkbox:self valueChanged:newValue];
        } else {
            ALog(@"[II] _delegate(%@) not have selector(checkbox:valueChanged:)", _delegate);
        }
    }
}

- (void)buttonTapped:(id)sender
{
    if (self == sender) {
        [self setChecked:(!_checked)];
    }
}
@end
