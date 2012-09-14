//
//  KHHManagementViewController.h
//  CardBook
//
//  Created by 孙铭 on 8/7/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KHHManagementViewController : UIViewController
@property (nonatomic, strong) UIView *entranceView;
@property (assign, nonatomic) bool   isBoss;
- (IBAction)radarBtnClick:(id)sender;
- (IBAction)funnelBtnClick:(id)sender;
- (IBAction)calendarBtnClick:(id)sender;
- (IBAction)manageEmployeesBtnClick:(id)sender;
- (IBAction)locationBtnClick:(id)sender;
- (IBAction)personBtnClick:(id)sender;
@end
