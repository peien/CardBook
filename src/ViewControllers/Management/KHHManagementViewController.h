//
//  KHHManagementViewController.h
//  CardBook
//
//  Created by 孙铭 on 8/7/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "Delegates.h"
#import "KHHManagementViewController.h"

@interface KHHManagementViewController : SuperViewController <UIAlertViewDelegate>
@property (nonatomic, strong) UIView *entranceView;
@property (strong, nonatomic) UIButton *signButton;
- (IBAction)radarBtnClick:(id)sender;
- (IBAction)funnelBtnClick:(id)sender;
- (IBAction)calendarBtnClick:(id)sender;
- (IBAction)manageEmployeesBtnClick:(id)sender;
- (IBAction)locationBtnClick:(id)sender;
- (IBAction)personBtnClick:(id)sender;
- (IBAction)moreBtnClick:(id)sender;
@end
