//
//  AppLoginController.m
//  CardBook
//
//  Created by Sun Ming on 12-10-26.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "AppLoginController.h"
#import "SMCheckbox.h"
#import "KHHDefaults.h"
#import "KHHNotifications.h"
#import "UIViewController+SM.h"
#import "RegViewController.h"
#import "ResetPasswordViewController.h"

@interface AppLoginController () <SMCheckboxDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet SMCheckbox  *showPasswordBox;

@property (nonatomic, strong) KHHDefaults *defaults;

- (IBAction)resetPassword:(id)sender;
- (IBAction)createAccount:(id)sender;
- (IBAction)login:(id)sender;
@end

@implementation AppLoginController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                 initWithTitle:@"返回"
                                                 style:UIBarButtonItemStylePlain
                                                 target:self action:nil];
        self.defaults = [KHHDefaults sharedDefaults];
    }
    return self;
}
- (void)dealloc {
//    self.showPasswordBox = nil;
    self.defaults = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"登录", nil);
    self.showPasswordBox.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)resetPassword:(id)sender {
    [self pushViewControllerClass:[ResetPasswordViewController class]
                         animated:YES];
}
- (IBAction)createAccount:(id)sender {
    [self pushViewControllerClass:[RegViewController class]
                         animated:YES];
}
- (IBAction)login:(id)sender {
    [self.userField     resignFirstResponder];
    [self.passwordField resignFirstResponder];
    // get user & password
    NSString *user     = self.userField .text;
    NSString *password = self.passwordField.text;
    DLog(@"[II] user=%@, password=%@", user, password);
    
    if (0 == user.length || 0 == password.length) {
        DLog(@"[II] 密码或帐号为空");
        [[[UIAlertView alloc]
          initWithTitle:nil
          message:NSLocalizedString(@"账号和密码不能为空。", nil)
          delegate:nil
          cancelButtonTitle:NSLocalizedString(@"OK", nil)
          otherButtonTitles:nil] show];
    } else {
        DLog(@"[II] 用户名密码看起来ok，开始登录！");
        if ([user isEqualToString:self.defaults.lastUser]) {
            self.defaults.showCompanyLogo = YES;
        }
        
        // 把user和password保存到UserDefaults，并通过Notification发出去
        self.defaults.currentUser = user;
        self.defaults.currentPassword = password;
        [self postASAPNotificationName:nAppStartLogMeIn];
    }
}

#pragma mark - SMCheckbox delegate methods
- (void)checkbox:(SMCheckbox *)checkBox
    valueChanged:(BOOL)newValue {
    if (checkBox == self.showPasswordBox) {
        //showOrHidePassword
        UITextField *textField = self.passwordField;
        if (newValue) {
            textField.enabled = NO;
            textField.secureTextEntry = NO;
            textField.enabled = YES;
        } else {
            textField.enabled = NO;
            textField.secureTextEntry = YES;
            textField.enabled = YES;
        }
    }
}
@end
