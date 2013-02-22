//
//  KHHManagementViewController.h
//  CardBook
//
//  Created by 孙铭 on 8/7/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "MsgDelegates.h"
#import "KHHManagementViewController.h"
#import "KHHFilterPopup.h"

#import "KHHDataNew+SyncContact.h"
#import "KHHDataTemplateDelegate.h"
#import "KHHDataGroupDelegate.h"
#import "KHHDataNew+Card.h"
#import "KHHDataNew+SignForPlan.h"
#import "KHHDataNew+Customer.h"

@interface KHHManagementViewController : SuperViewController <UIAlertViewDelegate,KHHFilterPopupDelegate,KHHDataSyncContactDelegate,KHHDataTemplateDelegate,KHHDataGroupDelegate,KHHDataCardDelegate,KHHDataSignPlanDelegate,KHHDataCustomerDelegate>
@property (nonatomic, strong) UIView *entranceView;
@property (strong, nonatomic) UIButton *signButton;
@property (strong, nonatomic) IBOutlet UIButton *guide;
- (IBAction)radarBtnClick:(id)sender;
- (IBAction)funnelBtnClick:(id)sender;
- (IBAction)organizationBtnClick:(id)sender;
- (IBAction)manageEmployeesBtnClick:(id)sender;
- (IBAction)locationBtnClick:(id)sender;
- (IBAction)personBtnClick:(id)sender;
- (IBAction)moreBtnClick:(id)sender;
- (IBAction)reviewGuide:(id)sender;

- (void)doInitWithUser;
@end
