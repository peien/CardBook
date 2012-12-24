//
//  AppRegisterController.m
//  CardBook
//
//  Created by Ming Sun on 10/27/12.
//  Copyright (c) 2012 Kinghanhong. All rights reserved.
//

#import "AppRegisterController.h"
#import "KHHDefaults.h"
#import "KHHKeys.h"
#import "KHHLog.h"
#import "KHHNotifications.h"
#import "NSString+Validation.h"
#import "SMCheckbox.h"
#import "UIImage+KHH.h"
#import "UIViewController+SM.h"
#import "AgreementViewController.h"

enum Tag_ImageView_Cell {
    Tag_ImageView_Cell_Top = 20001,
    Tag_ImageView_Cell_Middle_0,
    Tag_ImageView_Cell_Middle_1,
    Tag_ImageView_Cell_Middle_2,
    Tag_ImageView_Cell_Bottom,
};

enum Tag_TextField {
    Tag_TextField_Name = 22001,
    Tag_TextField_Mobile,
    Tag_TextField_Pass,
    Tag_TextField_Company,
    Tag_TextField_Invation,
};

#define Tag_Checkbox_ShowPass 23001
#define Tag_Checkbox_Agree    23002
#define Tag_Button_Reg        21002
#define Tag_Scroll_Container  9999

#define textOK                     NSLocalizedString(KHHMessageSure, @"OK")
#define textAlertYouShouldAgree    NSLocalizedString(@"必须同意隐私声明才能使用本产品。", nil)
#define textAlertPasswordInvalid   NSLocalizedString(@"密码必须包含4-12位数字、字母、下划线或减号！", nil)
#define textAlertPhoneLooksInvalid NSLocalizedString(@"请输入有效的手机号码。", nil)
#define textAlertShouldNotBeEmpty  NSLocalizedString(@"姓名手机号和密码不能为空！", nil)
#define textWarnRealPhoneNumber    NSLocalizedString(@"注册必须用你的真实手机号码，以备密码丢失时重设密码。使用他人手机号码可能导致你的数据外泄或丢失。蜂巢不会透露您的号码给第三方。",nil)

@interface AppRegisterController ()<SMCheckboxDelegate>
@property (nonatomic, strong) KHHDefaults *defaults;
- (IBAction)createAccount:(id)sender;
- (IBAction)showAgreement:(id)sender;
@end

@implementation AppRegisterController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = NSLocalizedString(@"注册", nil);
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                                 initWithTitle:NSLocalizedString(KHHMessageBack, nil)
                                                 style:UIBarButtonItemStylePlain
                                                 target:self
                                                 action:@selector(goBack:)];
        self.defaults = [KHHDefaults sharedDefaults];
        [self observeNotificationName:UIKeyboardDidShowNotification
                             selector:@"keyboardShow:"];
        [self observeNotificationName:UIKeyboardWillHideNotification
                             selector:@"keyboardHide:"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *root = self.view;
    
    // Scroll:
    UIScrollView *scroll = (UIScrollView *)[root viewWithTag:Tag_Scroll_Container];
    scroll.contentSize = self.view.frame.size;
    
    // Checkbox:
    SMCheckbox *showPass = (SMCheckbox *)[root viewWithTag:Tag_Checkbox_ShowPass];
    SMCheckbox *agree    = (SMCheckbox *)[root viewWithTag:Tag_Checkbox_Agree];
    showPass.delegate = self;
    agree.delegate    = self;
    agree.checked     = YES;
    
    // Cell background:
    UIEdgeInsets cellBgInsets = {0, 13, 0, 13};
    UIImage *topBgImg    = [UIImage imageNamed:@"Cell_top.png"    capInsets:cellBgInsets];
    UIImage *bottomBgImg = [UIImage imageNamed:@"Cell_bottom.png" capInsets:cellBgInsets];
    UIImage *middleBgImg = [UIImage imageNamed:@"Cell_middle.png" capInsets:cellBgInsets];
    UIImageView *topBg    = (UIImageView *)[root viewWithTag:Tag_ImageView_Cell_Top];
    UIImageView *bottomBg = (UIImageView *)[root viewWithTag:Tag_ImageView_Cell_Bottom];
    topBg.image    = topBgImg;
    bottomBg.image = bottomBgImg;
    for (NSInteger tag = Tag_ImageView_Cell_Middle_0;
         tag <= Tag_ImageView_Cell_Middle_2; tag++) {
        UIImageView *middleBg = (UIImageView *)[root viewWithTag:tag];
        middleBg.image = middleBgImg;
    }
    
    // Button:
    UIButton *regButton = (UIButton *)[root viewWithTag:Tag_Button_Reg];
    UIEdgeInsets buttonBgInsets = {0, 12, 0, 12};
    [regButton setBackgroundImage:[UIImage imageNamed:@"Button_red.png"
                                            capInsets:buttonBgInsets]
                           forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (void)goBack:(id)sender {
    [self postASAPNotificationName:nAppShowPreviousView];
}
- (IBAction)createAccount:(id)sender {
    UITextField *nameField = (UITextField *)[self.view viewWithTag:Tag_TextField_Name];
    UITextField *userField = (UITextField *)[self.view viewWithTag:Tag_TextField_Mobile];
    UITextField *passField = (UITextField *)[self.view viewWithTag:Tag_TextField_Pass];
    UITextField *comField  = (UITextField *)[self.view viewWithTag:Tag_TextField_Company];
    UITextField *invField  = (UITextField *)[self.view viewWithTag:Tag_TextField_Invation];
    NSString *name     = nameField.text;
    NSString *user     = userField.text;
    NSString *password = passField.text;
    NSLog(@"姓名: %@, 手机号: %@, 密码: %@.", name, user, password);
    
    SMCheckbox *agreeBox = (SMCheckbox *)[self.view viewWithTag:Tag_Checkbox_Agree];
    if (!(agreeBox.isChecked)) {
        // NOT agree to the agreement.
        [[[UIAlertView alloc]
          initWithTitle:nil
          message:textAlertYouShouldAgree
          delegate:nil
          cancelButtonTitle:textOK
          otherButtonTitles:nil] show];
        return;
    }
    
    if (!(name.length && user.length && password.length)) {
        //姓名帐号或密码为空
        [[[UIAlertView alloc]
          initWithTitle:nil
          message:textAlertShouldNotBeEmpty
          delegate:nil
          cancelButtonTitle:textOK
          otherButtonTitles:nil]show];
        return;
    }
    
    if (!(user.isRegistrablePhone)) {
        //手机号不合法
        [[[UIAlertView alloc]
          initWithTitle:nil
          message:textAlertPhoneLooksInvalid
          delegate:nil
          cancelButtonTitle:textOK
          otherButtonTitles:nil] show];
        return;
    }
    
    if (!(password.isValidPassword)) {
        //密码不合法
        [[[UIAlertView alloc]
          initWithTitle:nil
          message:textAlertPasswordInvalid
          delegate:nil
          cancelButtonTitle:textOK
          otherButtonTitles:nil] show];
        return;
    }

    DLog(@"[II] 用户名密码等数据看起来ok，开始注册！");
    // 把user和password保存到UserDefaults，其他通过Notification发出去
    self.defaults.currentUser     = user;
    self.defaults.currentPassword = password;
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithCapacity:3];
    info[kAccountKeyName]     = name;
    info[kAccountKeyUser]     = user;
    info[kAccountKeyPassword] = password;
    if(comField.text.length) info[kAccountKeyCompany] = comField.text;
    if(invField.text.length) info[kAccountKeyInvitationCode] = invField.text;
    [self postASAPNotificationName:nAppCreateThisAccount
                              info:info];
}
- (IBAction)showAgreement:(id)sender {
    [self pushViewControllerClass:[AgreementViewController class]
                         animated:YES];
}
#pragma mark - SMCheckbox delegate methods
- (void)checkbox:(SMCheckbox *)checkBox
    valueChanged:(BOOL)newValue {
    UIView *root = self.view;
    SMCheckbox  *showPass  = (SMCheckbox *)[root viewWithTag:Tag_Checkbox_ShowPass];
    UITextField *textField = (UITextField *)[root viewWithTag:Tag_TextField_Pass];
    if (checkBox == showPass) {
        //showOrHidePassword
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
    NSInteger theTag = textField.tag;
    if (theTag >= Tag_TextField_Name
        && theTag < Tag_TextField_Invation) {
        UITextField *tf = (UITextField *)[self.view viewWithTag:(theTag + 1)];
        [tf becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return YES;
}
// 限制密码长度为12// return NO to not change text
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = textField.text.length + string.length - range.length;
    if (textField == [self.view viewWithTag:Tag_TextField_Pass])
        return (newLength > 12) ? NO : YES;
    return YES;
}
#pragma mark - keyboard notification handlers
- (void)keyboardShow:(NSNotification *)noti {
    DLog(@"[II] noti = %@", noti);
    // 改变Scrollview的高度，以便滚动。
    UIScrollView *scroll = (UIScrollView *)[self.view viewWithTag:Tag_Scroll_Container];
    CGRect newFrame = scroll.frame;
    CGFloat kbHeight = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    newFrame.size.height = self.view.frame.size.height - kbHeight;
    scroll.frame = newFrame;
}
- (void)keyboardHide:(NSNotification *)noti {
    UIScrollView *scroll = (UIScrollView *)[self.view viewWithTag:Tag_Scroll_Container];
    if (scroll.frame.size.height < self.view.frame.size.height) {
        [UIView animateWithDuration:0.25f animations:^{
            scroll.frame = self.view.frame;
        }];
    }
}

@end
