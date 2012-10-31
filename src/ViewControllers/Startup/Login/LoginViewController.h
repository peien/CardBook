//
//  loginViewController.h
//  eCard
//
//  Created by fei ye on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LoginBackgroundViewTag 999
#define LoginAccountFieldTag   1000
#define LoginPasswordFieldTag  1001

@interface LoginViewController : UIViewController
@property (nonatomic, weak)   IBOutlet UITableView *inputTable;
@property (nonatomic, weak)   IBOutlet UIButton    *theLoginButton;
@property (nonatomic, strong)          UIView      *latestView;
@property (nonatomic, strong) IBOutlet UITextField *accountTf;
@property (nonatomic, strong) IBOutlet UITextField *passWordTf;
@property (nonatomic, strong) IBOutlet UIButton    *showPasswordBtn;
@property (nonatomic, strong) IBOutlet UIButton    *remberPasswordBtn;
@property (nonatomic, strong) IBOutlet UIButton    *regiBtn;

- (IBAction)login:(id)sender;
- (IBAction)showResetPasswordPage:(id)sender;
- (IBAction)registBtnClick:(id)sender;
- (IBAction)showPasswordBtnClick:(id)sender;
- (IBAction)remberPasswordBtnClick:(id)sender;
@end
