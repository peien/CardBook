//
//  AppRegisterController.m
//  CardBook
//
//  Created by Ming Sun on 10/27/12.
//  Copyright (c) 2012 Kinghanhong. All rights reserved.
//

#import "AppRegisterController.h"
#import "KHHLog.h"
#import "KHHNotifications.h"
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

@interface AppRegisterController ()<SMCheckboxDelegate>
- (IBAction)createAccount:(id)sender;
- (IBAction)showAgreement:(id)sender;
@end

@implementation AppRegisterController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = NSLocalizedString(@"注册", nil);
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"返回", nil)
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(goBack:)];
        self.navigationItem.leftBarButtonItem = backItem;
        
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
#warning TODO
    DLog(@"[II] 未完成！");
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
