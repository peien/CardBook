//
//  MoreViewController.m
//  LoveCard
//
//  Created by gh w on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MoreViewController.h"
#import "ModifyViewController.h"
#import "RecomFridendsViewController.h"
#import "KHHShowHideTabBar.h"
#import "LoginViewController.h"
#import "UseGuideViewController.h"
#import "FeedBackViewController.h"
#import "AboutController.h"
#import "KHHDefaults.h"
#import "KHHNotifications.h"


@interface MoreViewController ()<UIActionSheetDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) KHHDefaults *defaultSet;
@end

@implementation MoreViewController
@synthesize theTable = _theTable;
@synthesize autoLog = _autoLog;
@synthesize autoReturn = _autoReturn;
@synthesize updateStyle = _updateStyle;
@synthesize defaultPage = _defaultPage;
@synthesize titleStr = _titleStr;
@synthesize defaultSet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.leftBarButtonItem = nil;
        self.title = NSLocalizedString(@"更多", nil);
        self.defaultSet = [KHHDefaults sharedDefaults];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //_theTable.backgroundColor = [UIColor clearColor];
    [self.view setBackgroundColor:[UIColor colorWithRed:241 green:238 blue:232 alpha:1.0]];
    int index = [[self.defaultSet defaultMainUI] intValue];
    if (index == 100) {
        _defaultPage.text = NSLocalizedString(@"(名片夹界面)", nil);
    }else if (index == 101){
        _defaultPage.text = NSLocalizedString(@"(CRM管理界面)", nil);
    }else if (index == 102){
        _defaultPage.text = NSLocalizedString(@"(交换名片界面)", nil);
    }else if (index == 103){
        _defaultPage.text = NSLocalizedString(@"(消息界面)", nil);
    }else{
       _defaultPage.text = NSLocalizedString(@"(名片夹界面)", nil);
    }
}
- (void)viewWillAppear:(BOOL)animated{
      [super viewWillAppear:animated];
      [KHHShowHideTabBar showTabbar];
    
}
- (void)viewWillDisappear:(BOOL)animated{
      [super viewWillDisappear:animated];
//    [KHHShowHideTabBar hideTabbar];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _theTable = nil;
    _autoLog = nil;
    _autoReturn = nil;
    _updateStyle = nil;
    _defaultPage = nil;
    _titleStr = nil;
    self.defaultSet = nil;
}
#pragma mark TableDelegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 1) {
        return 60;
    }else if (indexPath.section == 3 && indexPath.row == 0){
        return 60;
    }else
        return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 4;
            break;
        case 3:
            return 2;
            break;
        default:
            return 0;
            break;
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellid = nil;
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:{
                    static NSString *identifier = @"SignIn";
                    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                    if (cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    cell.textLabel.text = NSLocalizedString(@"修改密码", nil);

                }
                    break;
                case 1:{
                    cellid = NSLocalizedString(@"LOGOUT", @"LOGOUT");
                    cell = [tableView dequeueReusableCellWithIdentifier:cellid];
                    if (cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
                        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    cell.textLabel.text = NSLocalizedString(@"登出", nil);
                }
                    break;
                case 2:{
                    cellid = NSLocalizedString(@"autoLogout",@"autoLogout");
                    cell = [tableView dequeueReusableCellWithIdentifier:cellid];
                    if (cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
                        cell.accessoryView = _autoLog;
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    cell.textLabel.text = NSLocalizedString(@"自动登陆", nil);
                }
                    break;
                default:
                    break;
            }
            break;
    
       case 1:
        switch (indexPath.row) {
        case 0:{
            cellid = @"genxin";
            cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
                cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.text = NSLocalizedString(@"检查更新", nil);
        }
            
            break;
            
        case 1:{
            cellid = @"genxin style";
            cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
                cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.text = @"软件更新方式设置";
            _updateStyle.frame = CGRectMake(25, 36, 260, 20);
            [cell addSubview:_updateStyle];
        }
        default:
            break;
    }
    break;
    
    case 2:
    switch (indexPath.row) {
        case 0:{
            cellid = @"use guide";
            cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
                cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.text = NSLocalizedString(@"使用指南", nil);
        }
            
            break;
        case 1:{
            cellid = @"recommend";
            cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
                cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.text = NSLocalizedString(@"推荐给好友", nil);
        }
            break;
        case 2:{
            cellid = @"contact us";
            cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
                cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.text = NSLocalizedString(@"客户反馈", nil);
        
        }
            break;
        case 3:{
            cellid = @"about";
            cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
                cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.text = NSLocalizedString(@"关于印象名片", nil);
        }
            break;
            
        default:
            break;
    }
    
    break;
    
    case 3:
    switch (indexPath.row) {
        case 0:{
            cellid = @"default";
            cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
                cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.text = NSLocalizedString(@"默认页面设置", nil);
            _defaultPage.frame = CGRectMake(18, 36, 260, 20);
            [cell addSubview:_defaultPage];
        }
            break;
        case 1:{
            cellid = @"auto";
            cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
                cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
                cell.accessoryView = _autoReturn;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.text = NSLocalizedString(@"自动回赠名片", nil);
            
        }
            break;
        default:
            break;
    }
            
        default:
            break;
    }

 return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    

}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ModifyViewController *modVC = [[ModifyViewController alloc] initWithNibName:@"ModifyViewController" bundle:nil];
            [self.navigationController pushViewController:modVC animated:YES];
        }else if (indexPath.row == 1) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"登出", nil)
                                                            message:@"确定要登出吗"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
            [alert show];

        }
    }else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            UseGuideViewController *useVC = [[UseGuideViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:useVC animated:YES];
        }else if (indexPath.row == 1) {
            RecomFridendsViewController *recomVC = [[RecomFridendsViewController alloc] initWithNibName:@"RecomFridendsViewController" 
                                                                                                 bundle:nil];
            [self.navigationController pushViewController:recomVC animated:YES];
        }else if (indexPath.row == 2) {
            //客户反馈
            FeedBackViewController *backVC = [[FeedBackViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:backVC animated:YES];
        }else if (indexPath.row == 3){
            AboutController *aboutVC = [[AboutController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 1) {
            _titleStr = @"软件更新方式";
            [self showActionSheet];
        }
    }else if (indexPath.section == 3){
        if (indexPath.row == 0) {
            _titleStr = @"默认页面设置";
            [self showActionSheet];
        }
    }
}

- (void)showActionSheet
{
    UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:_titleStr delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    if ([_titleStr isEqualToString:@"软件更新方式"]) {
        [actSheet addButtonWithTitle:@"仅在wifi网络下自动下载更新"];
        [actSheet addButtonWithTitle:@"自动下载更新"];
        [actSheet addButtonWithTitle:@"手动更新"];
    }else{
        [actSheet addButtonWithTitle:@"名片夹界面"];
        [actSheet addButtonWithTitle:@"CRM管理界面"];
        [actSheet addButtonWithTitle:@"交换名片界面"];
        [actSheet addButtonWithTitle:@"消息界面"];
    
    }
    [actSheet showInView:self.view];

}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    NSString *s = [actionSheet buttonTitleAtIndex:buttonIndex];
    NSString *change = [NSString stringWithFormat:@"(%@)",s];
    if ([actionSheet.title isEqualToString:@"软件更新方式"]) {
        _updateStyle.text = change;
    }else{
        _defaultPage.text = change;
        if (buttonIndex == 1) {
            [self.defaultSet setDefaultMainUI:[NSNumber numberWithInt:100]];
        }else if (buttonIndex == 2){
            [self.defaultSet setDefaultMainUI:[NSNumber numberWithInt:101]];
        }else if (buttonIndex == 3){
            [self.defaultSet setDefaultMainUI:[NSNumber numberWithInt:102]];
        }else if (buttonIndex == 4){
            [self.defaultSet setDefaultMainUI:[NSNumber numberWithInt:103]];
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title isEqualToString:NSLocalizedString(@"登出", nil)]
        && buttonIndex == 1) {
        [self postASAPNotificationName:KHHAppLogout];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
