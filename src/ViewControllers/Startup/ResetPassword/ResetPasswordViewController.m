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
#import "UIImage+KHH.h"

#define textResetPassword NSLocalizedString(KHHMessageResetPassword, @"")
#define textInvalidPhone NSLocalizedString(KHHMessageInvalidPhone, @"")
#define textRequestSent NSLocalizedString(KHHMessageResetRequestIsSended, @"")
#define textOK   NSLocalizedString(KHHMessageSure, @"")
#define textSend NSLocalizedString(KHHMessageSend, @"")


@implementation ResetPasswordViewController

#pragma mark - init && dealloc
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = textResetPassword;
    }
    return self;
}

#pragma mark - UIViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Button:
    UIButton *button = self.theOKButton;
    UIEdgeInsets buttonBgInsets = {0, 12, 0, 12};
    [button setBackgroundImage:[UIImage imageNamed:@"Button_red.png"
                                            capInsets:buttonBgInsets]
                         forState:UIControlStateNormal];
    [button setTitle:textSend forState:UIControlStateNormal];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showTheKeyboard];
}

#pragma mark - Actions
- (IBAction)actionButtonPressed:(id)sender {
    NSString *user = self.theTextField.text;
    if (user.isValidMobilePhoneNumber) {
        // ok
        //NSDictionary *dict = @{ kInfoKeyUser : user };
        [_delegate doReset:user];
        
//        [self postASAPNotificationName:nAppResetMyPassword
//                                  info:dict];
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



@end
