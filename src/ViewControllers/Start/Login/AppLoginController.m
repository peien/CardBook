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
#import "KHHLog.h"
#import "KHHNotifications.h"
#import "NSString+Validation.h"
#import "UIImage+KHH.h"
#import "UIViewController+SM.h"
#import "RegViewController.h"
#import "ResetPasswordViewController.h"

#define Tag_ImageView_CellTop    20001
#define Tag_ImageView_CellBottom 20002
#define Tag_ImageView_UserIcon   20003
#define Tag_ImageView_PassIcon   20004
#define Tag_Button_Login         21001
#define Tag_Button_Reg           21002

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
        // Title:
        self.navigationItem.title = NSLocalizedString(@"登录", nil);
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                 initWithTitle:@"返回"
                                                 style:UIBarButtonItemStylePlain
                                                 target:self action:nil];
        self.defaults = [KHHDefaults sharedDefaults];
    }
    return self;
}
- (void)dealloc {
    self.defaults = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *root = self.view;
    // Checkbox:
    self.showPasswordBox.delegate = self;
    // Cell background:
    UIImageView *userBg = (UIImageView *)[root viewWithTag:Tag_ImageView_CellTop];
    UIImageView *passBg = (UIImageView *)[root viewWithTag:Tag_ImageView_CellBottom];
    UIEdgeInsets cellBgInsets = {0, 13, 0, 13};
    userBg.image = [UIImage imageNamed:@"Cell_top.png" capInsets:cellBgInsets];
    passBg.image = [UIImage imageNamed:@"Cell_bottom.png" capInsets:cellBgInsets];
    // Button:
    UIButton *loginButton = (UIButton *)[root viewWithTag:Tag_Button_Login];
    UIButton *regButton   = (UIButton *)[root viewWithTag:Tag_Button_Reg];
    UIEdgeInsets buttonBgInsets = {0, 12, 0, 12};
    [loginButton setBackgroundImage:[UIImage imageNamed:@"Button_red.png"
                                              capInsets:buttonBgInsets]
                           forState:UIControlStateNormal];
    [regButton   setBackgroundImage:[UIImage imageNamed:@"Button_grey.png"
                                              capInsets:buttonBgInsets]
                           forState:UIControlStateNormal];
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
//    [self pushViewControllerClass:[RegViewController class]
//                         animated:YES];
    [self postASAPNotificationName:nAppShowCreateAccount];
}
- (IBAction)login:(id)sender {
    [self hideKeyboard];
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
        [self postASAPNotificationName:nAppLogMeIn];
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

#pragma mark - UITextField delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.backgroundColor = [UIColor clearColor];
}
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    // 检查用户名和密码
//    if (textField == self.userField) {
//        NSString *text = textField.text;
//        if (text.length && (![text isValidMobilePhoneNumber])) {
//            textField.backgroundColor = [UIColor redColor];
//        }
//        return;
//    }
//    if (textField == self.passwordField) {
//        //
//        return;
//    }
//}
// called when 'return' key pressed. return NO to ignore.
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.passwordField) {
        [textField resignFirstResponder];
    }
    return YES;
}
// 限制密码长度为12// return NO to not change text
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = textField.text.length + string.length - range.length;
    if (textField == self.passwordField)
        return (newLength > 12) ? NO : YES;
    return YES;
}

#pragma mark - Misc
- (void)hideKeyboard {
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            [view resignFirstResponder];
        }
    }
}
@end