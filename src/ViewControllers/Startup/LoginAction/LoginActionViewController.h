//
//  LoginActionViewController.h
//  eCard
//
//  Created by Ming Sun on 12-6-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

// Login Notifications
// 注意设置userInfo: 包含的keys @"user" @"password"

extern NSString * const ECardNotificationLoginManually;
extern NSString * const ECardNotificationLoginAuto;
extern NSString * const ECardNotificationAutoLoginFailed;
extern NSString * const KHHNotificationStartSyncAfterLogin;
extern NSString * const ECardNotificationSignUpAction;
extern NSString * const ECardNotificationResetPasswordAction;

@interface LoginActionViewController : UIViewController <UIAlertViewDelegate>
@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;
@property (nonatomic, weak) IBOutlet UILabel *actionLabel;
@property (nonatomic, weak) IBOutlet UIImageView *companyImageView;
@end
