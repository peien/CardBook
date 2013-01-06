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
#import "KHHFilterPopup.h"

@interface KHHManagementViewController : SuperViewController <UIAlertViewDelegate,KHHFilterPopupDelegate>
@property (nonatomic, strong) UIView *entranceView;
@property (strong, nonatomic) UIButton *signButton;
@property (strong, nonatomic) IBOutlet UIButton *guide;
- (IBAction)radarBtnClick:(id)sender;
- (IBAction)funnelBtnClick:(id)sender;
- (IBAction)calendarBtnClick:(id)sender;
- (IBAction)manageEmployeesBtnClick:(id)sender;
- (IBAction)locationBtnClick:(id)sender;
- (IBAction)personBtnClick:(id)sender;
- (IBAction)moreBtnClick:(id)sender;
- (IBAction)reviewGuide:(id)sender;
@end
