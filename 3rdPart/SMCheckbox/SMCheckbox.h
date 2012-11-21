//
//  SMCheckbox.h
//
//  Created by 孙铭 on 8/9/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SMCheckboxDelegate;

@interface SMCheckbox : UIButton
@property (nonatomic, weak) id<SMCheckboxDelegate> delegate;
@property (nonatomic, getter = isChecked) BOOL checked;
@end

@protocol SMCheckboxDelegate <NSObject>
@required
- (void)checkbox:(SMCheckbox *)checkBox valueChanged:(BOOL)newValue;
@end