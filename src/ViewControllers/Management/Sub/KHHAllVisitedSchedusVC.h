//
//  KHHAllVisitedSchedusVC.h
//  CardBook
//
//  Created by 王国辉 on 12-11-5.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"

@interface KHHAllVisitedSchedusVC : SuperViewController
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *tableContainer;
@property (assign, nonatomic) bool   isNeedReloadData;
@end
