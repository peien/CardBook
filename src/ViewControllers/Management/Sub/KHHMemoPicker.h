//
//  KHHMemoPicker.h
//  CardBook
//
//  Created by CJK on 13-1-6.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol KHHMemoPickerDelegate <NSObject>

@required
- (void)showTitle:(NSString*)title;

@end


@interface KHHMemoPicker : UIPickerView<UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,strong) id<KHHMemoPickerDelegate> showDelegate;

- (void)showInView:(UIView *) view;
- (void)cancelPicker:(Boolean)remove;

@end
