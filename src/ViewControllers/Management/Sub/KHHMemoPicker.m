//
//  KHHMemoPicker.m
//  CardBook
//
//  Created by CJK on 13-1-6.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHMemoPicker.h"

@implementation KHHMemoPicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.showsSelectionIndicator = YES;
        
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (void)setMemoArr:(NSArray *)memoArr
{
    if (_memoArr) {
        _memoArr = memoArr;
        [self reloadAllComponents];
    }
    _memoArr = memoArr;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _memoArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_memoArr objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_showTitle) {
        _showTitle([_memoArr objectAtIndex:row],pickerView.tag);
    }
}

#pragma mark - animation

- (void)showInView:(UIView *) view
{
    if (iPhone5) {
        if (!self.superview) {
            self.frame = CGRectMake(0, 530, 320, 200);
            [view addSubview:self];
            self.hidden = NO;
        }else{
            self.hidden = NO;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, 330, 320,200);
        }];
        return;
    }
    if (!self.superview) {
        self.frame = CGRectMake(0, view.frame.size.height, self.frame.size.width, self.frame.size.height);
        [view addSubview:self];
        self.hidden = NO;
    }else{
        self.hidden = NO;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
    
}

- (void)cancelPicker:(Boolean)remove
{
    if (iPhone5) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.frame = CGRectMake(0, 530, 320, 200);
                         }
                         completion:^(BOOL finished){
                             if (remove) {
                                 [self removeFromSuperview];
                             }else{
                                 self.hidden = YES;
                             }
                             
                             
                         }];
        return;
    }
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, self.frame.size.width, self.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         if (remove) {
                             [self removeFromSuperview];
                         }else{
                             self.hidden = YES;
                         }
                         
                         
                     }];
    
}

@end
