//
//  KHHVisitedPickVC.h
//  CardBook
//
//  Created by 王国辉 on 12-11-14.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "KHHVisitRecoardVC.h"

@interface KHHVisitedPickVC : SuperViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *datePick;
@property (weak, nonatomic) IBOutlet UIPickerView *pick;
@property (strong, nonatomic) NSArray *tempPickArr;
@property (assign, nonatomic) bool    isShowTimeValue;
@property (assign, nonatomic) bool    isShowNoteValue;
@property (assign, nonatomic) bool    isShowWarnValue;
@property (strong, nonatomic) KHHVisitRecoardVC *visitVC;
@property (strong, nonatomic) UIView  *visitedUpdateVale;

@end
