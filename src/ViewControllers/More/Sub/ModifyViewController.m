//
//  ModifyViewController.m
//  LoveCard
//
//  Created by gh w on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ModifyViewController.h"
#import "NSString+Validation.h"
#import "KHHDefaults.h"
#import "KHHDataAPI.h"
#import "MBProgressHUD.h"
#import "KHHUser.h"
#import "KHHDataNew+Account.h"

#define LABEL_CELL_TAG 555
#define TEXTFIELD_CELL_TAG 666

#define ChangePasswordTag_Old 1201
#define ChangePasswordTag_New 1202
#define ChangePasswordTag_Re  1203

#define textOldPasswordWrong NSLocalizedString(@"旧密码错误！", nil)
#define textNewPasswordsNotMatch NSLocalizedString(@"两次输入的新密码不同！", @"")
#define textNewPasswordsEqualToOld NSLocalizedString(@"新密码不能跟旧密码相同！", @"")
#define textEmptyNewPassword NSLocalizedString(@"新密码不能为空！", @"")
#define textInvalidNewPassword NSLocalizedString(@"新密码无效！", @"")
#define textInvalidPasswords NSLocalizedString(@"密码无效！", @"")
#define textChangePasswordSucceeded NSLocalizedString(@"密码修改成功", @"")
#define textChangePasswordFailed NSLocalizedString(@"修改密码失败！", @"")
#define textPleaseReLogIn NSLocalizedString(@"请重新登录。", @"")
#define textOK NSLocalizedString(KHHMessageSure, @"")
#define textChanging NSLocalizedString(@"正在修改密码请稍后...", @"")
#define textAlertTitle NSLocalizedString(@"修改密码", @"")
#define textAlertMessageOK NSLocalizedString(@"修改密码成功，请重新登录。", @"")
#define textAlertMessageFailed NSLocalizedString(@"修改密码失败，请稍后再试。", @"")

@interface ModifyViewController ()<UITextFieldDelegate, UIAlertViewDelegate,KHHDataAccountDelegate>
@property (strong, nonatomic) KHHDefaults *defaults;
@property (strong, nonatomic) KHHData  *dataCtr;
@property (strong, nonatomic) MBProgressHUD *hud;
@end

@implementation ModifyViewController
@synthesize theTable = _theTable;
@synthesize defaults = _defaults;
@synthesize dataCtr = _dataCtr;
@synthesize hud = _hud;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
        self.title = textAlertTitle;
        _defaults = [KHHDefaults sharedDefaults];
        _dataCtr = [KHHData sharedData];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _theTable = nil;
    _defaults = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 90.0f, 15.0f)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.numberOfLines = 0;
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.contentMode = UIViewContentModeScaleAspectFit;
        label.tag = LABEL_CELL_TAG;
        [cell.contentView addSubview:label];
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(100.0f, 7.0f, 200.0f, 40.0f)];
        textfield.tag = TEXTFIELD_CELL_TAG;
        textfield.font = [UIFont systemFontOfSize:12];
        textfield.adjustsFontSizeToFitWidth = YES;
        textfield.delegate = self;
        [cell.contentView addSubview:textfield];
    }
    UILabel *lab = (UILabel *)[cell.contentView viewWithTag:LABEL_CELL_TAG];
    UITextField *tf = (UITextField *)[cell.contentView viewWithTag:TEXTFIELD_CELL_TAG];
    if (indexPath.row == 0) {
        lab.text = @"旧密码";
        tf.tag = ChangePasswordTag_Old;
        tf.placeholder = @"请输入旧密码";
    }else if (indexPath.row == 1) {
        lab.text = @"新密码";
        tf.tag = ChangePasswordTag_New;
        tf.placeholder = @"请输入4－12位字符";
    }else if (indexPath.row == 2) {
        lab.text = @"确认密码";
        tf.tag = ChangePasswordTag_Re;
        tf.placeholder = @"请重复密码";
    }
    return cell;

}
- (void)rightBarButtonClick:(id)sender
{
    [self changePassword];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag) {
        case ChangePasswordTag_Old:
            //跳到密码输入框
            [[self.view viewWithTag:ChangePasswordTag_New] becomeFirstResponder];
            break;
        case ChangePasswordTag_New:
            [[self.view viewWithTag:ChangePasswordTag_Re] becomeFirstResponder];
            break;
        case ChangePasswordTag_Re:
            [textField resignFirstResponder];
            break;
    }
    return NO;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger newLength = textField.text.length + string.length - range.length;
    return (newLength > 12) ? NO : YES;
}// return NO to not change text
- (void)changePassword{
    _hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    _hud.labelText = textChanging;
    UITextField *oldField = ((UITextField*)[self.view viewWithTag:ChangePasswordTag_Old]);
    UITextField *newField = ((UITextField*)[self.view viewWithTag:ChangePasswordTag_New]);
    UITextField *reField = ((UITextField*)[self.view viewWithTag:ChangePasswordTag_Re]);
    [oldField resignFirstResponder];
    [newField resignFirstResponder];
    [reField resignFirstResponder];
    //用户输入的当前密码
    NSString *oldPass = oldField.text;
    //用户输入的新密码及确认密码
    NSString *newPass = newField.text;
    NSString *rePass = reField.text;
    //用户当前的密码
    NSString *oldRealPsw = [KHHUser shareInstance].password;
#ifdef DEBUG
    NSLog(@"修改密码: old-%@, new-%@, re-%@.", oldPass, newPass, rePass);
    //    NSLog(@"修改密码: old-%@, new-%@.", oldPass, newPass);
#endif
    if (![oldPass isEqualToString:oldRealPsw]) { // || [oldPass stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length <= 0
        [_hud hide:YES];
        //旧密码错误
        [self popAlartMessage:textOldPasswordWrong];
        return;
    }
    
    //旧密码正确......
    
    if (0 == newPass.length) {
        [_hud hide:YES];
        //新密码为空
        [self popAlartMessage:textEmptyNewPassword];
        return;
    }
    
    //新密码不为空......
    
    if (!(newPass.isValidPassword)) {
        [_hud hide:YES];
        //新密码非法
        [self popAlartMessage:textInvalidNewPassword];
        return;
    }
    
    //新密码合法......
    
    if (![newPass isEqualToString:rePass]) {
        [_hud hide:YES];
        //新密码两次输入不一致
        [self popAlartMessage:textNewPasswordsNotMatch];
        return;
    }
    
    //两次输入一致......
    
    if ([newPass isEqualToString:oldPass]) {
        [_hud hide:YES];
        //新密码跟旧密码相同
        [self popAlartMessage:textNewPasswordsEqualToOld];
        return;
    }
    //万事ok
    NSLog(@"New Passwrod look valid! Let's change the password.");
//    [self observeNotificationName:KHHUIChangePasswordSucceeded selector:@"handleUIChangePasswordSucceeded:"];
//    [self observeNotificationName:KHHUIChangePasswordFailed selector:@"handleUIChangePasswordFailed:"];
   // [_dataCtr changePassword:oldPass newPassword:newPass];
    [[KHHDataNew sharedData] doChangePassword:oldPass newPassword:newPass delegate:self];
}

#pragma mark - account delegate
- (void)changePasswordForUISuccess
{
    [_hud hide:YES];
    //提示密码修改成功
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:textAlertTitle message:textAlertMessageOK delegate:self cancelButtonTitle:textOK otherButtonTitles:nil, nil];
    [alert show];
}

- (void)changePasswordForUIFailed:(NSDictionary *)userInfo
{
    [_hud hide:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"密码修改失败" message:userInfo[kInfoKeyErrorMessage] delegate:nil cancelButtonTitle:textOK otherButtonTitles:nil, nil];
    [alert show];
}
#pragma mark - Utilites
- (void)popAlartMessage:(NSString *)message
{
    [[[UIAlertView alloc]
       initWithTitle:nil
       message:message
       delegate:nil
       cancelButtonTitle:textOK
       otherButtonTitles:nil]
      show];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//修改密码成功
-(void) handleUIChangePasswordSucceeded:(NSNotification *) info {
    [self stopObservingNotificationName:KHHUIChangePasswordSucceeded];
    [self stopObservingNotificationName:KHHUIChangePasswordFailed];
    DLog(@"handleUIChangePasswordSucceeded! ====== info is %@",info.userInfo);
    [_hud hide:YES];
    //提示密码修改成功
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:textAlertTitle message:textAlertMessageOK delegate:self cancelButtonTitle:textOK otherButtonTitles:nil, nil];
    [alert show];
}

-(void) handleUIChangePasswordFailed:(NSNotification *) info {
    [self stopObservingNotificationName:KHHUIChangePasswordSucceeded];
    [self stopObservingNotificationName:KHHUIChangePasswordFailed];
    [_hud hide:YES];
    DLog(@"handleUIChangePasswordFailed! ====== info is %@",info.userInfo);
    //设置消息
    NSString *message = nil;
    if ([[info.userInfo objectForKey:@"errorCode"]intValue] == KHHErrorCodeConnectionOffline){
        message = KHHMessageNetworkEorror;
    }else {
        message = textAlertMessageFailed;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:textAlertTitle message:message delegate:nil cancelButtonTitle:textOK otherButtonTitles:nil, nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            //密码修改成功,要登出
          [self postASAPNotificationName:KHHAppLogout];
            break;
        default:
            break;
    }
}

@end
