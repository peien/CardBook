//
//  KHHMemoPicker.h
//  CardBook
//
//  Created by CJK on 13-1-6.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface KHHMemoPicker : UIPickerView<UIPickerViewDataSource,UIPickerViewDelegate>



@property(nonatomic,strong) void (^showTitle)(NSString *title, int tag);
@property(nonatomic,strong) NSArray *memoArr;


- (void)showInView:(UIView *) view;
- (void)cancelPicker:(Boolean)remove;

@end
