//
//  loginViewController.h
//  eCard
//
//  Created by fei ye on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"

#define LoginBackgroundViewTag 999
#define LoginAccountFieldTag   1000
#define LoginPasswordFieldTag  1001

@interface LoginViewController : SuperViewController
@property (nonatomic, weak) IBOutlet UITableView *inputTable;
@property (nonatomic, weak) IBOutlet UIButton *theLoginButton;
@property (nonatomic, strong)        UIView   *latestView;
@property (nonatomic, strong) IBOutlet UITextField *accountTf;
@property (nonatomic, strong) IBOutlet UITextField *passWordTf;

- (IBAction)login:(id)sender;
- (IBAction)showResetPasswordPage:(id)sender;
- (IBAction)registBtnClick:(id)sender;
@end
