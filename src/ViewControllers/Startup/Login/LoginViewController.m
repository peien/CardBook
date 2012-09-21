//
//  loginViewController.m
//  eCard
//
//  Created by fei ye on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "StartupViewController.h"
#import "RegViewController.h"
#import "ResetPasswordViewController.h"
#import "KHHDefaults.h"
#import "SMCheckBox.h"
#import "NSString+Validation.h"
#import "NSObject+Notification.h"
#import "UIViewController+Navigation.h"
#import "KHHNetworkAPIAgent+Account.h"


#define textLogin NSLocalizedString(@"登录", @"")

@interface LoginViewController () <UITableViewDataSource, UITableViewDelegate,
                                    UITextFieldDelegate, SMCheckboxDelegate>
@property (nonatomic, strong) SMCheckbox *showPasswordBox;
@property (nonatomic, strong) SMCheckbox *remberPasswordBox;
@property (nonatomic, strong) KHHDefaults *defaults;
@end

@implementation LoginViewController
@synthesize latestView = _latestView;
@synthesize accountTf = _accountTf;
@synthesize passWordTf = _passWordTf;

#pragma mark -
- (void)dealloc {
    self.showPasswordBox = nil;
    self.defaults = nil;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = NSLocalizedString(@"印象名片", @"");
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] 
                                              initWithTitle:NSLocalizedString(@"注册帐号", @"Sign up") 
                                              style:UIBarButtonItemStylePlain 
                                              target:self 
                                              action:@selector(gotoRegView:)];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                  initWithTitle:@"返回" 
                                                  style:UIBarButtonItemStylePlain 
                                                  target:self action:nil];
        _defaults = [KHHDefaults sharedDefaults];
        
        self.latestView = [[[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:self options:nil] objectAtIndex:0];
        _accountTf.placeholder = NSLocalizedString(@"请输入您的手机号", @"Login account placeholder");
        _accountTf.keyboardType = UIKeyboardTypePhonePad;
        _accountTf.returnKeyType = UIReturnKeyNext;
        _accountTf.tag = LoginAccountFieldTag;
        _accountTf.text = self.defaults.currentUser;
        _accountTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        _passWordTf.placeholder = NSLocalizedString(@"请输入4~12位的密码", @"Login password placeholder");
        _passWordTf.keyboardType = UIKeyboardTypeASCIICapable;
        _passWordTf.returnKeyType = UIReturnKeyDone;
        _passWordTf.secureTextEntry = YES;
        _passWordTf.tag = LoginPasswordFieldTag;
        _passWordTf.text = self.defaults.currentPassword;
        _passWordTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        
        self.showPasswordBox = [[[NSBundle mainBundle] loadNibNamed:@"SMCheckbox"
                                                              owner:self
                                                            options:nil] objectAtIndex:0];
        self.showPasswordBox.frame = CGRectMake(20, 132, 25, 25);
        self.showPasswordBox.delegate = self;
        [self.latestView addSubview:self.showPasswordBox];
       
        self.remberPasswordBox = [[[NSBundle mainBundle] loadNibNamed:@"SMCheckbox"
                                                              owner:self
                                                            options:nil] objectAtIndex:0];
        self.remberPasswordBox.frame = CGRectMake(20, 160, 25, 25);
        self.remberPasswordBox.delegate = self;
        self.remberPasswordBox.selected = YES;
        [self.latestView addSubview:self.remberPasswordBox];
    }
    return self;
}
#pragma mark - UIViewController methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // show password checkbox
//    self.showPasswordBox = [[[NSBundle mainBundle] loadNibNamed:@"SMCheckbox"
//                                                          owner:self
//                                                        options:nil] objectAtIndex:0];
//    self.showPasswordBox.frame = CGRectMake(10, 110, 25, 25);
//    self.showPasswordBox.delegate = self;
//    [self.view addSubview:self.showPasswordBox];
    
    // 登录按钮
    UIImage *okButtonImage = [[UIImage imageNamed:@"OKButton.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [self.theLoginButton setBackgroundImage:okButtonImage forState:UIControlStateNormal];
    [self.theLoginButton setTitle:textLogin forState:UIControlStateNormal];
    
    // 更换背景
    UIImage *bgImage = [[UIImage imageNamed:@"activity_bg.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
    bgImageView.frame = CGRectMake(0, 0, 320, 460);
    [self.inputTable  setBackgroundView:bgImageView];

    [self.view addSubview:self.latestView];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    DLog(@"[II] viewDidUnload...");
    _latestView = nil;
    _passWordTf = nil;
    _accountTf = nil;
}
- (void)viewDidAppear:(BOOL)animated
{
    DLog(@"[II] viewDidAppear...");
    [self performSelector:@selector(showTheKeyboard) withObject:nil afterDelay:0.2f];
    [super viewDidAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     self.navigationController.navigationBarHidden = YES;

}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableView delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Login Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, 220, 44)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:46.0f/256 green:81.0f/256 blue:138.0f/256 alpha:1.0];//r46 g81 b138
        label.textAlignment = UITextAlignmentRight;
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.userInteractionEnabled = YES;
        //textField.delegate = self;
        textField.font = [UIFont systemFontOfSize:15.0f];

        switch (indexPath.row) {
            case 0:
                label.text = NSLocalizedString(@"账号", @"Login account");
                textField.placeholder = NSLocalizedString(@"请输入您的手机号", @"Login account placeholder");
                textField.keyboardType = UIKeyboardTypePhonePad;
                textField.returnKeyType = UIReturnKeyNext;
                textField.tag = LoginAccountFieldTag;
                textField.text = self.defaults.currentUser;
                break;
            case 1:
                label.text = NSLocalizedString(@"密码", @"Login password");
                textField.placeholder = NSLocalizedString(@"请输入4~12位的密码", @"Login password placeholder");
                textField.keyboardType = UIKeyboardTypeASCIICapable;
                textField.returnKeyType = UIReturnKeyDone;
                textField.secureTextEntry = YES;
                textField.tag = LoginPasswordFieldTag;
                textField.text = self.defaults.currentPassword;
                break;
        }
        [cell addSubview:label];
        [cell addSubview:textField];
    }
    cell.userInteractionEnabled = YES;
    return cell;
}

#pragma mark - UITextField delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag) {
        case LoginAccountFieldTag:
            //检查名字？
            //跳到密码输入框
            [[self.view viewWithTag:LoginPasswordFieldTag] becomeFirstResponder];
            break;
        case LoginPasswordFieldTag:
            //检查密码？
            //关闭键盘？
            [textField resignFirstResponder];
            break;
    }
    return YES;
}// called when 'return' key pressed. return NO to ignore.

// 限制密码长度为12
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = textField.text.length + string.length - range.length;
    if (LoginPasswordFieldTag == textField.tag) 
        return (newLength > 12) ? NO : YES;
    return YES;
}// return NO to not change text

#pragma mark - SMCheckbox delegate methods
- (void)checkbox:(SMCheckbox *)checkBox
    valueChanged:(BOOL)newValue {
    if (checkBox == self.showPasswordBox) {
        //showOrHidePassword
        UITextField *textField = (UITextField*)[self.view viewWithTag:LoginPasswordFieldTag];
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

#pragma mark -
- (IBAction)login:(id)sender {
    UITextField *accountField = ((UITextField*)[self.view viewWithTag:LoginAccountFieldTag]);
    UITextField *passwordField = ((UITextField*)[self.view viewWithTag:LoginPasswordFieldTag]);
    [accountField resignFirstResponder];
    [passwordField resignFirstResponder];
    // get the accont text
    NSString *user = accountField.text;
    // get the password text
    NSString *password = passwordField.text;

    DLog(@"[II] account=%@, password=%@", user, password);
    
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
        NSDictionary *dict = @{ kInfoKeyUser : user, kInfoKeyPassword : password };
        NSString *notiName = ECardNotificationStartLogin;
        [self postNotification:notiName info:dict];
        DLog(@"发送消息 %@", notiName);
    }
} //login:
- (void)gotoRegView:(id)sender
{
    [self pushViewControllerClass:[RegViewController class]
                         animated:YES];
    self.defaults.loggedIn = NO;
} //gotoRegView:
//注册
- (IBAction)registBtnClick:(id)sender
{
    [self pushViewControllerClass:[RegViewController class]
                         animated:YES];
    self.defaults.loggedIn = NO;

}
- (IBAction)showResetPasswordPage:(id)sender
{
    [self pushViewControllerClass:[ResetPasswordViewController class]
                         animated:YES];
    self.defaults.loggedIn = NO;
}
- (void)showTheKeyboard
{
    UITextField *aTextField = ((UITextField*)[self.view viewWithTag:LoginAccountFieldTag]);
    if (aTextField.text.length) {
        [[self.view viewWithTag:LoginPasswordFieldTag] becomeFirstResponder];
    } else {
        [aTextField becomeFirstResponder];
    }
}
@end
