//
//  RegViewController.m
//  eCard
//
//  Created by Ming Sun on 12-4-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "RegViewController.h"
#import "StartupViewController.h"
#import "NSString+Validation.h"
#import "AgreementViewController.h"
#import "SMCheckBox.h"
#import "KHHDefaults.h"
#import "KHHKeys.h"
#import "KHHNetworkAPI.h"
#import "KHHNotifications.h"

#define textOK NSLocalizedString(KHHMessageSure, @"OK")
#define textRegister NSLocalizedString(@"注册",nil)
#define textWarnRealPhoneNumber NSLocalizedString(@"注册必须用你的真实手机号码，以备密码丢失时重设密码。使用他人手机号码可能导致你的数据外泄或丢失。蜂巢不会透露您的号码给第三方。",nil)
#define textAlertYouShouldAgree NSLocalizedString(@"必须同意隐私声明才能使用本产品。", nil) 
#define textAlertAccountAndPasswordShouldNotBeEmpty NSLocalizedString(@"手机号和密码不能为空！", nil)
#define textAlertPhoneNumberLooksInvalid NSLocalizedString(@"请输入有效的手机号码。", nil)
#define textAlertPasswordInvalid NSLocalizedString(@"密码必须包含4-12位数字、字母、下划线或减号！", nil)

@interface RegViewController () <SMCheckboxDelegate>
@property (nonatomic, strong) KHHDefaults *defaults;
@property (nonatomic, strong) SMCheckbox *showPasswordBox;
@property (nonatomic, strong) SMCheckbox *agreeBox;

@end

@implementation RegViewController

#pragma mark - init 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _defaults = [KHHDefaults sharedDefaults];
        [self observeNotificationName:UIKeyboardWillShowNotification selector:@"keyboardWillShow:"];
        [self observeNotificationName:UIKeyboardDidHideNotification selector:@"keyboardDidHide:"];
        
        self.navigationItem.title = NSLocalizedString(@"注册用户",nil);
        [(UIScrollView*)(self.view) setContentSize:CGSizeMake(320,530)];
        ((UIScrollView*)self.view).bounces = NO;
        [(UIScrollView*)self.view setShowsVerticalScrollIndicator:NO];
    }
    return self;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.showPasswordBox = nil;
    self.agreeBox = nil;
}

#pragma mark - UIViewController methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.showPasswordBox = [[[SMCheckBox alloc] initWithFrame:CGRectMake(10, 110, 25, 25)] autorelease];
    self.showPasswordBox = [[[NSBundle mainBundle] loadNibNamed:@"SMCheckbox" owner:self options:nil] objectAtIndex:0];
    self.showPasswordBox.frame = CGRectMake(10, 110, 25, 25);
    self.showPasswordBox.delegate = self;
//    self.agreeBox = [[[SMCheckBox alloc] initWithFrame:CGRectMake(10, 146, 25, 25)] autorelease];
    self.agreeBox = [[[NSBundle mainBundle] loadNibNamed:@"SMCheckbox" owner:self options:nil] objectAtIndex:0];
    self.agreeBox.frame = CGRectMake(10, 146, 25, 25);
    self.agreeBox.delegate = self;
    self.agreeBox.checked = YES;
    [self.view addSubview:self.showPasswordBox];
    [self.view addSubview:self.agreeBox];
    
    UIImage *okButtonImage = [[UIImage imageNamed:@"OKButton.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:0];
    [self.theRegButton setBackgroundImage:okButtonImage forState:UIControlStateNormal];
    [self.theRegButton setTitle:textRegister forState:UIControlStateNormal];
    
    self.theWarnTextView.text = textWarnRealPhoneNumber;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showKeyboard];
}

#pragma mark - UITableView delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Register Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, 220, 44)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:46.0f/256 green:81.0f/256 blue:138.0f/256 alpha:1.0];//r46 g81 b138
        label.textAlignment = UITextAlignmentRight;
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.clearButtonMode = UITextFieldViewModeAlways;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.delegate = self;
        textField.font = [UIFont systemFontOfSize:15.0f];
        
        switch (indexPath.row) {
            case 0:
                label.text = NSLocalizedString(@"手机号", nil);
                textField.placeholder = NSLocalizedString(@"请输入您的手机号", nil);
                textField.keyboardType = UIKeyboardTypePhonePad;
                textField.returnKeyType = UIReturnKeyNext;
                textField.tag = SignupAccountFieldTag;
                break;
            case 1:
                label.text = NSLocalizedString(@"密码", nil);
                textField.placeholder = NSLocalizedString(@"4-12位数字、字母或下划线", nil);
                textField.keyboardType = UIKeyboardTypeASCIICapable;
                textField.returnKeyType = UIReturnKeyDone;
                textField.secureTextEntry = YES;
                textField.tag = SignupPasswordFieldTag;
                break;
        }
        [cell addSubview:label];
        [cell addSubview:textField];
    }
    
    return cell;

}

#pragma mark - UITextField delegate methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag) {
        case SignupAccountFieldTag:
            //跳到密码输入框
            [[self.view viewWithTag:SignupPasswordFieldTag] becomeFirstResponder];            
            break;
        case SignupPasswordFieldTag:
            //关闭键盘？
            [textField resignFirstResponder];
            break;
    }
    return NO;
}// called when 'return' key pressed. return NO to ignore.

// 限制密码长度为12
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (SignupPasswordFieldTag == textField.tag) {
        NSUInteger newLength = textField.text.length + string.length - range.length;
        return (newLength > 12) ? NO : YES;
    }
    return YES;
}// return NO to not change text

#pragma mark - SMCheckBox delegate methods
- (void)checkbox:(SMCheckbox *)checkBox
    valueChanged:(BOOL)newValue {
    if (checkBox == self.agreeBox) {
        //agree?
        ALog(@"Agree? %s", newValue?"Yes":"No");
    }
    if (checkBox == self.showPasswordBox) {
        //showOrHidePassword
        UITextField *textField = (UITextField*)[self.view viewWithTag:SignupPasswordFieldTag];
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

#pragma mark - keyboard notification handlers
- (void)keyboardWillShow:(NSNotification *) notification
{
    if ([[self.view viewWithTag:SignupPasswordFieldTag] isFirstResponder]) {
        UIScrollView* scrollView = (UIScrollView*)self.view;
        [scrollView setContentOffset:CGPointMake(0,28) animated:YES];
    }
    
    if ([[self.view viewWithTag:SignupAccountFieldTag] isFirstResponder]) {
        UIScrollView* scrollView = (UIScrollView*)self.view;
        [scrollView setContentOffset:CGPointMake(0,103) animated:YES];
    }
}
- (void)keyboardDidHide:(NSNotification *) notification
{
    UIScrollView* scrollView = (UIScrollView*)self.view;
    [scrollView setContentOffset:CGPointMake(0,0) animated:YES];
}

#pragma mark - Actions
// When register button touched!
- (IBAction)registerThis:(id)sender
{
    UITextField *accountField = ((UITextField*)[self.view viewWithTag:SignupAccountFieldTag]);
    UITextField *passwordField = ((UITextField*)[self.view viewWithTag:SignupPasswordFieldTag]);
    [accountField resignFirstResponder];
    [passwordField resignFirstResponder];
    NSString *user = accountField.text;// get the accont text
    NSString *password = passwordField.text;// get the password text
    NSLog(@"account: %@, password: %@.", user, password);

    if (!self.agreeBox.isChecked) {
        // NOT agree to the agreement.
        [[[UIAlertView alloc] 
           initWithTitle:nil
           message:textAlertYouShouldAgree 
           delegate:nil 
           cancelButtonTitle:textOK
           otherButtonTitles:nil] show];
        return;
    }
    
    if (0 == user.length || 0 == password.length) {
        //帐号或密码为空
        [[[UIAlertView alloc] 
           initWithTitle:nil 
           message:textAlertAccountAndPasswordShouldNotBeEmpty
           delegate:nil 
           cancelButtonTitle:textOK 
           otherButtonTitles:nil]show];
        return;
    }
    
    if (!user.isRegistrablePhone) {
        //手机号不合法
        [[[UIAlertView alloc] 
           initWithTitle:nil
           message:textAlertPhoneNumberLooksInvalid
           delegate:nil 
           cancelButtonTitle:textOK 
           otherButtonTitles:nil] show];
        return;
    }
    
    if (!password.isValidPassword) {
        //密码不合法
        [[[UIAlertView alloc]
           initWithTitle:nil 
           message:textAlertPasswordInvalid
           delegate:nil 
           cancelButtonTitle:textOK 
           otherButtonTitles:nil] show];
        return;
    }
    
    DLog(@"[II] 手机号和密码看起来ok，开始注册！");
    // 现保存user和password备用
    self.defaults.currentUser = user;
    self.defaults.currentPassword = password;
    
    // 发送开始注册的消息
    [self postASAPNotificationName:nAppCreateThisAccount];
    
} //registerThis

- (IBAction)showAgreement:(id)sender {
    //Open webpage
    AgreementViewController *vc = [[AgreementViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showKeyboard
{
    UITextField *aTextField = ((UITextField*)[self.view viewWithTag:SignupAccountFieldTag]);
    
    if (aTextField.text.length) {
        [[self.view viewWithTag:SignupPasswordFieldTag] becomeFirstResponder];
    } else {
        [aTextField becomeFirstResponder];
    }
}
@end
