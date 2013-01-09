//
//  KHHMessageViewController.m
//  CardBook
//
//  Created by 王国辉 on 12-8-20.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "KHHMessageViewController.h"
#import "KHHMessageCell.h"
#import "KHHShowHideTabBar.h"
#import "KHHDetailMessageVC.h"
#import "KHHEditMSGViewController.h"
#import "KHHClasses.h"
#import "KHHData+UI.h"
#import "KHHMessage.h"
#import "MBProgressHUD.h"
#import "NetClient+Message.h"


@interface KHHMessageViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) NSArray *messageArr;
@property (strong, nonatomic) KHHData *dataCtrl;
@property (assign, nonatomic) bool    isNeedReloadTable;
@end

@implementation KHHMessageViewController
@synthesize theTable = _theTable;
@synthesize messageArr;
@synthesize dataCtrl;
@synthesize isNeedReloadTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"消息", nil);
        //[self.leftBtn setTitle: NSLocalizedString(@"编辑", nil) forState:UIControlStateNormal];
        [self.rightBtn setTitle: NSLocalizedString(@"刷新", nil) forState:UIControlStateNormal];
        self.dataCtrl = [KHHData sharedData];
    }
    return self;
}
//刷新
- (void)rightBarButtonClick:(id)sender
{
    //弹出同步提示框
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"同步数据"
                                                    message:KhhMessageSyncDataWithServer
                                                   delegate:self
                                          cancelButtonTitle:@"确认"
                                          otherButtonTitles:@"取消", nil];
    alert.tag = KHHAlertSync;
    [alert show];
}
//刷新新到的消
- (void)synMessage{
    
    //注册同步消息
    [self observeNotificationName:nUISyncMessagesSucceeded selector:@"handleSyncMessagesSucceeded:"];
    [self observeNotificationName:nUISyncMessagesFailed selector:@"handlenUISyncMessagesFailed:"];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = KHHMessageSyncMessage;
    [self.dataCtrl syncMessages];
}
#pragma mark -
- (void)handleSyncMessagesSucceeded:(NSNotification *)noti{
    
    DLog(@"handleSyncMessagesSucceeded! noti is ======%@",noti.userInfo);
    [self stopObservingForMessage];
    [self refreshTable];
}

- (void) refreshTable {
    self.messageArr = [self.dataCtrl allMessages];
    [_theTable reloadData];
}

- (void)handlenUISyncMessagesFailed:(NSNotification *)noti{
    DLog(@"handlenUISyncMessagesFailed! noti is ======%@",noti.userInfo);
    [self stopObservingForMessage];
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"错误提示", nil)
                                message:@"同步消息失败,请确保网络可用"
                               delegate:nil
                      cancelButtonTitle:NSLocalizedString(KHHMessageSure, nil)
                      otherButtonTitles:nil] show];
    
}
- (void)stopObservingForMessage{
    [self stopObservingNotificationName:nUISyncMessagesSucceeded];
    [self stopObservingNotificationName:nUISyncMessagesFailed];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _theTable.backgroundColor = [UIColor clearColor];
    [self.view setBackgroundColor:[UIColor colorWithRed:241 green:238 blue:232 alpha:1.0]];
    self.messageArr = [self.dataCtrl allMessages];
        
    //iphone5 适配
    [KHHViewAdapterUtil checkIsNeedMoveDownForIphone5:_editBtn];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [NetClient sharedClient].inMsgView = YES;
    
    [KHHShowHideTabBar showTabbar];
    if (self.isNeedReloadTable) {
        [self refreshTable];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [NetClient sharedClient].inMsgView = NO;
    //[KHHShowHideTabBar hideTabbar];
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _theTable = nil;
    self.messageArr = nil;
    self.dataCtrl = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.messageArr count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"CELLID";
    KHHMessageCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"KHHMessageCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    KHHMessage *message = [self.messageArr objectAtIndex:indexPath.row];
    if (!message.subject||[message.subject isEqualToString:@""]) {
        cell.subTitleLab.text = @"无标题";
    }else{
        cell.subTitleLab.text = message.subject;
    }
    
    cell.contentLab.text = message.content;
    cell.timeLab.text = message.time;
    if ([message.isRead isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        cell.messageImage.hidden = YES;
    }
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    self.isNeedReloadTable = YES;
    KHHMessage *message = [self.messageArr objectAtIndex:indexPath.row];
    message.isRead = [NSNumber numberWithBool:YES];
    [[NetClient sharedClient] doDelete:self messages:[NSArray arrayWithObject:message]];
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    KHHDetailMessageVC *messageVC = [[KHHDetailMessageVC alloc] initWithNibName:@"KHHDetailMessageVC" bundle:nil];
    messageVC.message = [messageArr objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:messageVC animated:YES];
    
}
#pragma mark -
- (IBAction)editMessageBtnClick:(id)sender{
    
    KHHEditMSGViewController *editVC = [[KHHEditMSGViewController alloc] initWithNibName:nil bundle:nil];
    editVC.messageArr = self.messageArr;
    
    self.isNeedReloadTable = YES;
    [self.navigationController pushViewController:editVC animated:YES];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - alert
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (!alertView || !alertView.tag) {
        return;
    }
    
    KHHAlertType type = alertView.tag;
    switch (type) {
        case KHHAlertSync:{
            if (buttonIndex == 0) {
                [self synMessage];
            }
        }
        default:
            break;
    }
}

#pragma mark - del delegate

- (void)deleFail
{
    [self refreshTable];
}

- (void)deleDone
{
    
}

@end
