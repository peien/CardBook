//
//  KHHMemoPicker.m
//  CardBook
//
//  Created by CJK on 13-1-6.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHMemoPicker.h"

@implementation KHHMemoPicker
{
    NSMutableArray* memoArr;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        memoArr = [[NSMutableArray alloc]initWithObjects:@"约会",@"聚餐", @"牵手", @"游戏", @"打台球", @"睡觉", nil];
        
    }
    return self;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 5;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title;
    switch (row) {
        case 0:
           title = @"约会";
            break;
        case 1:
           title = @"聚餐";
            break;
        case 2:
          title =  @"牵手";
            break;
        case 3:
           title = @"游戏";
            break;
        case 4:
           title = @"打台球";
            break;            
        default:
            title = @"睡觉";
            break;
    }
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [_showDelegate performSelector:@selector(showTitle:) withObject:[memoArr objectAtIndex:row]];
}

#pragma mark - animation

- (void)showInView:(UIView *) view
{
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
