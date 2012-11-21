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

@interface LoginActionViewController : UIViewController <UIAlertViewDelegate>
@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;
@property (nonatomic, weak) IBOutlet UILabel *actionLabel;
@property (nonatomic, weak) IBOutlet UIImageView *companyImageView;
@end
