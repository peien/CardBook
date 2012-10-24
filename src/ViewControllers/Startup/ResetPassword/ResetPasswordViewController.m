//
//  ResetPasswordViewController.m
//  eCard
//
//  Created by Ming Sun on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "NSString+Validation.h"
#import "StartupViewController.h"
#import "KHHNetworkAPI.h"
#import "KHHNotifications.h"

#define textResetPassword NSLocalizedString(@"重置密码", @"")
#define textInvalidPhone NSLocalizedString(@"无效手机号", @"")
#define textRequestSent NSLocalizedString(@"重置请求已发送", @"")
#define textOK NSLocalizedString(@"确定", @"")


@implementation ResetPasswordViewController

#pragma mark - init && dealloc
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = textResetPassword;
        self.rightBtn.hidden = YES;
    }
    return self;
}
- (void)dealloc {
}

#pragma mark - UIViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *okButtonImage = [[UIImage imageNamed:@"OKButton.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [self.theOKButton setBackgroundImage:okButtonImage forState:UIControlStateNormal];
    [self.theOKButton setTitle:textOK forState:UIControlStateNormal];
    
}
- (void)viewDidUnload
{
    [self setTheTextField:nil];
    [self setTheOKButton:nil];
    [self setTheView:nil];
    [super viewDidUnload];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showTheKeyboard];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions
- (IBAction)actionButtonPressed:(id)sender {
    NSString *user = self.theTextField.text;
    if (user.isValidMobilePhoneNumber) {
        // ok
        [self hideTheKeyboard];
        NSString *notiName = KHHUIStartResetPassword;
        NSDictionary *dict = @{ kInfoKeyUser : user };
        DLog(@"[II] 重设密码: 发送 %@", notiName);
        [self postASAPNotificationName:notiName
                          info:dict];
    } else {
        // invalid phone
        [[[UIAlertView alloc]
           initWithTitle:nil 
           message:textInvalidPhone
           delegate:nil 
           cancelButtonTitle:textOK 
           otherButtonTitles:nil] show];
    }
}

- (void)showTheKeyboard
{
    [self.theTextField becomeFirstResponder];
}
- (void)hideTheKeyboard
{
    [self.theTextField resignFirstResponder];
}
@end
