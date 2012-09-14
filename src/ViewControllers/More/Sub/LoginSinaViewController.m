//
//  LoginSinaViewController.m
//  LoveCard
//
//  Created by gh w on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginSinaViewController.h"
#import "WebSinaViewController.h"
#import "SMCheckbox.h"

#define LoginAccountFieldTag   10001
#define LoginPasswordFieldTag  10002
@interface LoginSinaViewController ()<UITextFieldDelegate>

@end

@implementation LoginSinaViewController
@synthesize theTable = _theTable;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title =@"分享到新浪微薄";
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, 220, 44)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 70, 44)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:46.0f/256 green:81.0f/256 blue:138.0f/256 alpha:1.0];//r46 g81 b138
        label.textAlignment = UITextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.userInteractionEnabled = YES;
        textField.delegate = self;
        textField.font = [UIFont systemFontOfSize:15.0f];
        switch (indexPath.row) {
            case 0:
                label.text = NSLocalizedString(@"微薄账号", @"Login account");
                textField.placeholder = NSLocalizedString(@"邮箱／会员帐号／手机号", @"Login account placeholder");
                textField.keyboardType = UIKeyboardTypePhonePad;
                textField.returnKeyType = UIReturnKeyNext;
                textField.tag = LoginAccountFieldTag;
                break;
            case 1:
                label.text = NSLocalizedString(@"密码", @"Login password");
                textField.placeholder = NSLocalizedString(@"请输入密码", @"Login password placeholder");
                textField.keyboardType = UIKeyboardTypeASCIICapable;
                textField.returnKeyType = UIReturnKeyDone;
                textField.secureTextEntry = YES;
                textField.tag = LoginPasswordFieldTag;
                break;
        }
        [cell addSubview:label];
        [cell addSubview:textField];
    }
    cell.userInteractionEnabled = YES;
    return cell;
}


#pragma mark - SMCheckbox delegate methods
- (void)checkbox:(SMCheckbox *)checkBox valueChanged:(BOOL)newValue
{

}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag) {
        case LoginAccountFieldTag:
            [[self.view viewWithTag:LoginAccountFieldTag] becomeFirstResponder];
            break;
        case LoginPasswordFieldTag:
            [[self.view viewWithTag:LoginPasswordFieldTag] resignFirstResponder];
        default:
            break;
    }
    return YES;
    
}

- (IBAction)loginAndShare:(id)sender
{
    UITextField *tfAccount = (UITextField *)[self.view viewWithTag:LoginAccountFieldTag];
    UITextField *tfPassword = (UITextField *)[self.view viewWithTag:LoginPasswordFieldTag];
    [tfAccount resignFirstResponder];
    [tfPassword resignFirstResponder];
    WebSinaViewController *sinaVC = [[WebSinaViewController alloc] initWithNibName:@"WebSinaViewController" bundle:nil];
    [self.navigationController pushViewController:sinaVC animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
