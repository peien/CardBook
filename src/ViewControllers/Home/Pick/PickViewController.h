//
//  PickViewController.h
//  CardBook
//
//  Created by 王国辉 on 12-8-15.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
@protocol PickViewControllerDelegate<NSObject>
- (void)addToExternArrayFromPick:(NSString *)str;
@end

@interface PickViewController : SuperViewController
@property (strong, nonatomic) IBOutlet UIPickerView *pickView;
@property (assign, nonatomic) NSInteger             PickFlag;
@property (strong, nonatomic) NSArray               *dataName;
@property (assign, nonatomic) id<PickViewControllerDelegate>delegate;
@property (strong, nonatomic) NSArray               *groupArr;
@property (strong, nonatomic) NSMutableArray        *tempArray;
@end
