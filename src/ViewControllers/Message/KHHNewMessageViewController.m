//
//  KHHNewMessageViewController.m
//  CardBook
//
//  Created by CJK on 13-2-22.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNewMessageViewController.h"
#import "KHHDataNew+Message.h"
#import "KHHMessage.h"
#import "KHHDetailMessageVC.h"
#import "KHHMessageNewCell.h"
#import "SVPullToRefresh.h"
#import "KHHDataNew+Message.h"

@interface KHHNewMessageViewController ()
{
    UITableView *_table;
    NSMutableDictionary *_dicParam;
    UIButton *_editBut;
    
    Boolean _refreshing;
}
@end

@implementation KHHNewMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"消息";
        [self.rightBtn setTitle:@"刷新" forState:UIControlStateNormal];
        
        _table = [[UITableView alloc]init];
        _table.dataSource = self;
        _table.delegate = self;
        
        _editBut = [[UIButton alloc]init];
        [_editBut setImage:[UIImage imageNamed:@"edit_Btn_Red"] forState:UIControlStateNormal];
        [_editBut setImage:[UIImage imageNamed:@"edit_Btn_Red"] forState:UIControlStateHighlighted];
        [_editBut addTarget:self action:@selector(editButClick) forControlEvents:UIControlEventTouchUpInside];
        [self initArrs];
        
    }
    return self;
}

- (void)initArrs
{
    _dicParam = [[NSMutableDictionary alloc]init];
    _dicParam[@"accessoryType"] = [NSNumber numberWithInt:UITableViewCellAccessoryDisclosureIndicator];
    _dicParam[@"messArr"] = [NSMutableArray arrayWithArray:[[KHHDataNew sharedData] allMessages]];
    
    _dicParam[@"editingStyle"] = [NSNumber numberWithInt: UITableViewCellEditingStyleNone];
}

- (void)editButClick
{
    _editBut.hidden = YES;
    [self.rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    _table.editing = YES;
}

- (void)rightBarButtonClick:(id)sender
{
    if ([self.rightBtn.titleLabel.text isEqualToString:@"完成"]) {
        _editBut.hidden = NO;
        [self.rightBtn setTitle:@"刷新" forState:UIControlStateNormal];
        _table.editing = NO;
        _dicParam[@"editingStyle"] = [NSNumber numberWithInt: UITableViewCellEditingStyleDelete];
        
    }else{
        [self refresh];
    }
}

- (void)refresh
{
    if(!_refreshing){
        [_table triggerPullToRefresh];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    float height = self.view.frame.size.height-44;
    _table.frame = CGRectMake(0, 0, 320, height);
    _editBut.frame = CGRectMake(320-60, height-60, 50, 50);
    
    __weak KHHNewMessageViewController *weakSelf = self;
    [_table addPullToRefreshWithActionHandler:^{
        [weakSelf forNetWork];
    }];
    
    [self.view addSubview:_table];
    [self.view addSubview:_editBut];
}

- (void)forNetWork
{
    _refreshing = YES;
    [[KHHDataNew sharedData] reseaveMsg:self];
    
}

#pragma mark - KHHDataMessageDelegate

- (void)reseaveMsgForUIFailed:(NSDictionary *)dict
{
    _refreshing = NO;
    [_table.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0.5];
}

- (void)reseaveMsgForUISuccess:(NSDictionary *)dict

{
    _refreshing = NO;
    
    if ([dict[@"haveNew"] isEqualToString:@"0"]) {
        [_table.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0.5];
        return;
    }
    // _dicParam[@"messArr"] = [[KHHDataNew sharedData] allMessages];
    NSMutableIndexSet *setPro = [NSMutableIndexSet indexSetWithIndex:0];
    NSMutableArray *arrPro = [[NSMutableArray alloc]initWithCapacity:[dict[@"fsendList"]  count]];
    for (int i=1; i<[dict[@"fsendList"]  count]; i++) {
        [setPro addIndex:i];
        [arrPro addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [((NSMutableArray *)_dicParam[@"messArr"]) insertObjects:dict[@"fsendList"] atIndexes:setPro];
    
    [_table insertRowsAtIndexPaths:arrPro withRowAnimation:UITableViewRowAnimationNone];
    
    [_table.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0.5];
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - tableview dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dicParam[@"messArr"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"CELLID";
    KHHMessageNewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[KHHMessageNewCell alloc]init];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    }
    
    cell.accessoryType = [_dicParam[@"accessoryType"] integerValue];
    KHHMessage *message = [_dicParam[@"messArr"] objectAtIndex:indexPath.row];
    if (!message.subject||[message.subject isEqualToString:@""]) {
        cell.dicParam[@"title"] = @"无标题";
    }else{
        cell.dicParam[@"title"] = message.subject;
    }
    
    cell.dicParam[@"content"] = message.content;
    
    if (message.time) {
        cell.dicParam[@"time"] = message.time;
        
    }
    
    if ([message.isRead isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        cell.dicParam[@"isRead"]  = @"1";
    }
    
    return cell;
    
}

#pragma mark - tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    
    KHHMessage *message = [_dicParam[@"messArr"] objectAtIndex:indexPath.row];
    if (!message.isReadValue) {
        message.isReadValue = YES;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
        [[KHHDataNew sharedData] setRead:[NSString stringWithFormat:@"%lld", ((KHHMessage *)(_dicParam[@"messArr"][indexPath.row])).idValue] delegate:self];
    } 
    
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    KHHDetailMessageVC *messageVC = [[KHHDetailMessageVC alloc] initWithNibName:@"KHHDetailMessageVC" bundle:nil];
    messageVC.message = [_dicParam[@"messArr"] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:messageVC animated:YES];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [[KHHDataNew sharedData] doDeleteMessage:[NSString stringWithFormat:@"%lld", ((KHHMessage *)(_dicParam[@"messArr"][indexPath.row])).idValue] delegate:self];
    [_dicParam[@"messArr"] removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]withRowAnimation:UITableViewRowAnimationNone];
    
}



@end
