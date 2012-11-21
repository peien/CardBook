//
//  KHHEditMSGViewController.m
//  CardBook
//
//  Created by 王国辉 on 12-9-14.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "KHHEditMSGViewController.h"
#import "KHHNetworkAPIAgent+Message.h"
#import "KHHMessageCell.h"
#import "KHHMessage.h"
#import "MBProgressHUD.h"
#import "KHHData+UI.h"
#import "KHHShowHideTabBar.h"

@interface KHHEditMSGViewController ()
@property (assign, nonatomic) bool edit;
@property (strong, nonatomic) NSMutableArray *selectItemArray;
@property (strong, nonatomic) NSMutableArray *delMessageArr;
@property (strong, nonatomic) KHHData        *dataCtrl;
@end

@implementation KHHEditMSGViewController
@synthesize edit = _edit;
@synthesize theTable = _theTable;
@synthesize selectItemArray = _selectItemArray;
@synthesize delMessageArr = _delMessageArr;
@synthesize messageArr;
@synthesize dataCtrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.navigationItem.leftBarButtonItem = nil;
        [self.rightBtn setTitle:@"删除" forState:UIControlStateNormal];
        self.dataCtrl = [KHHData sharedData];
        
    }
    return self;
}
- (void)rightBarButtonClick:(id)sender
{
    //注册删除消息,改为本地删除，取消注册消息
//    [self observeNotificationName:nUIDeleteMessagesSucceeded selector:@"handleDeleteMessagesSucceeded:"];
//    [self observeNotificationName:nUIDeleteMessagesFailed selector:@"handleDeleteMessagesFailed:"];
//    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self delMessageFromArray];
}
#pragma mark -
- (void)handleDeleteMessagesSucceeded:(NSNotification *)noti{
    DLog(@"handleDeleteMessagesSucceeded! noti is ====== %@",noti.userInfo);
    //[self stopObservingForDelMessage];
}
- (void)handleDeleteMessagesFailed:(NSNotification *)noti{
    DLog(@"handleDeleteMessagesFailed! noti is ====== %@",noti.userInfo);
    //[self stopObservingForDelMessage];

}
//- (void)stopObservingForDelMessage{
//    [self stopObservingNotificationName:nUIDeleteMessagesSucceeded];
//    [self stopObservingNotificationName:nUIDeleteMessagesFailed];
//    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
//
//}
#pragma mark -
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _selectItemArray = [[NSMutableArray alloc] initWithCapacity:0];
    _delMessageArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i<self.messageArr.count; i++) {
        [_selectItemArray addObject:[NSNumber numberWithBool:NO]];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [KHHShowHideTabBar hideTabbar];
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _theTable = nil;
    _selectItemArray = nil;
    _delMessageArr = nil;
    self.messageArr = nil;
    self.dataCtrl = nil;
}
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArr.count;
}
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    KHHMessageCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"KHHMessageCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([[_selectItemArray objectAtIndex:indexPath.row] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    KHHMessage *message = [self.messageArr objectAtIndex:indexPath.row];
    cell.subTitleLab.text = message.subject;
    cell.timeLab.text = message.time;
    cell.contentLab.text = message.content;
    if ([message.isRead isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        cell.messageImage.hidden = YES;
    }
    return cell;
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *state = [_selectItemArray objectAtIndex:indexPath.row];
    if ([state isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        state = [NSNumber numberWithBool:NO];
    }else{
        state = [NSNumber numberWithBool:YES];
    }
    [_selectItemArray replaceObjectAtIndex:indexPath.row withObject:state];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}
// 删除消息
- (void)delMessageFromArray
{
    for (int i = 0; i<self.messageArr.count; i++) {
        if ([[_selectItemArray objectAtIndex:i] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            //从消息数组里找出对应要删除 消息
            [_delMessageArr addObject:[self.messageArr objectAtIndex:i]];
        }
    }
    [self.dataCtrl deleteMessages:_delMessageArr];
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:YES];
    //_theTable.editing = !_theTable.editing;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
