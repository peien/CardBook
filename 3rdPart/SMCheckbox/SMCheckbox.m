//
//  SMCheckbox.m
//
//  Created by 孙铭 on 8/9/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "SMCheckbox.h"
NSString *const SMCheckboxImage_Checked   = @"Checkbox_checked.png";
NSString *const SMCheckboxImage_Unchecked = @"Checkbox_unchecked.png";

@implementation SMCheckbox
@synthesize delegate = _delegate;
@synthesize checked = _checked;

- (void)awakeFromNib {
    [super awakeFromNib];
    DLog(@"[II] Checkbox = %@, button type = %d", self, self.buttonType);
    _checked = NO;
    [self addTarget:self
             action:@selector(buttonTapped:)
   forControlEvents:UIControlEventTouchUpInside];
}

- (void)setChecked:(BOOL)newValue {
    if (_checked != newValue) {
        // 值改变了
        _checked = newValue;
        UIEdgeInsets imgInsets = {0,0,0,0};
        UIImage *checkedImg   = [[UIImage imageNamed:SMCheckboxImage_Checked]
                                 resizableImageWithCapInsets:imgInsets];
        UIImage *uncheckedImg = [[UIImage imageNamed:SMCheckboxImage_Unchecked]
                                 resizableImageWithCapInsets:imgInsets];
        UIImage *image = newValue? checkedImg: uncheckedImg;
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
