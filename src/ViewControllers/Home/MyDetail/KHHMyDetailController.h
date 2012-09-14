//
//  KHHMyDetailController.h
//  CardBook
//
//  Created by 孙铭 on 8/7/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
@class KHHVisitCalendarView;
@class KHHCardView;
@interface KHHMyDetailController : SuperViewController
@property (nonatomic, strong) UISegmentedControl *segmCtrl;
@property (strong, nonatomic) IBOutlet UIView             *containView;
@property (nonatomic, strong) KHHVisitCalendarView        *visitView;
@property (nonatomic, strong) KHHCardView                 *cardView;
@property (assign, nonatomic)  NSUInteger                 lastBtn;
@end
