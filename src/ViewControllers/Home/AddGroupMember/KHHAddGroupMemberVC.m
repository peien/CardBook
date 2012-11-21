//
//  KHHAddGroupMemberVC.m
//  CardBook
//
//  Created by 王国辉 on 12-8-21.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "KHHAddGroupMemberVC.h"
#import "khhClientCellLNPC.h"
#import "SMCheckbox.h"
#import "KHHShowHideTabBar.h"
#import "KHHMySearchBar.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"

#import "KHHCardMode.h"
#import "KHHClasses.h"
#import "KHHDataAPI.h"
#import "KHHNotifications.h"

@interface KHHAddGroupMemberVC ()<UISearchBarDelegate,UISearchDisplayDelegate,
                                 UITableViewDataSource,UITableViewDelegate,SMCheckboxDelegate>

@property (strong, nonatomic) SMCheckbox *box;
@property (strong, nonatomic) KHHData    *dataCtrl;
@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation KHHAddGroupMemberVC
@synthesize searbarCtrl = _searbarCtrl;
@synthesize theTableM = _theTableM;
@synthesize sureBtn = _sureBtn;
@synthesize footView = _footView;
@synthesize cancelBtn = _cancelBtn;
@synthesize numLab = _numLab;
@synthesize isAdd = _isAdd;
@synthesize box = _box;
@synthesize selectedItemArray = _selectedItemArray;
@synthesize addOrDelGroupArray = _addOrDelGroupArray;
@synthesize resultArray = _resultArray;
@synthesize searchArray = _searchArray;
@synthesize handleArray;
@synthesize homeVC;
@synthesize dataCtrl;
@synthesize group;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.rightBarButtonItem = nil;
        self.dataCtrl = [KHHData sharedData];
        //注册移动卡片消息
        [self observeNotificationName:KHHUIMoveCardsSucceeded selector:@"handleMoveCardsSucceeded:"];
        [self observeNotificationName:KHHUIMoveCardsFailed selector:@"handleMoveCardsFailed:"];
        
    }
    return self;
}
- (void)leftBarButtonClick:(id)sender
{
    num = 0;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    KHHMySearchBar *searchBar = [[KHHMySearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 37) simple:YES];
    UISearchDisplayController *searCtrl = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searCtrl.delegate = self;
    searCtrl.searchResultsDataSource = self;
    searCtrl.searchResultsDelegate = self;
    self.searbarCtrl = searCtrl;
    [self.view addSubview:searchBar];
    [_sureBtn setBackgroundImage:[[UIImage imageNamed:@"tongbu_normal.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 8, 0, 8)] forState:UIControlStateNormal];
    [_cancelBtn setBackgroundImage:[[UIImage imageNamed:@"tongbu_normal.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 8, 0, 8)] forState:UIControlStateNormal];
    if (_isAdd) {
        [_sureBtn setTitle:NSLocalizedString(@"添加",nil) forState:UIControlStateNormal];
        self.title = NSLocalizedString(@"添加组员", nil);
    }else{
        [_sureBtn setTitle:NSLocalizedString(@"移出",nil) forState:UIControlStateNormal];
        self.title = NSLocalizedString(@"移出组员", nil);
    }
    [self initViewData];
    _selectedItemArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i<handleArray.count; i++) {
        [_selectedItemArray addObject:[NSNumber numberWithBool:NO]];
    }
    _addOrDelGroupArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    
}
// 搜索结果，暂时只能用姓名搜索
- (void)searcResult
{
    //搜索结果
    _resultArray = [[NSArray alloc] init];
    NSMutableArray *stringArr = [[NSMutableArray alloc] init];
    for (int i = 0; i< self.handleArray.count; i++) {
        KHHCardMode *card = [self.handleArray objectAtIndex:i];
        if (card.name.length) {
            [stringArr addObject:card.name];
        }
        
    }
    _searchArray = stringArr;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [KHHShowHideTabBar hideTabbar];
   
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _theTableM = nil;
    _footView = nil;
    _searbarCtrl = nil;
    _sureBtn = nil;
    _cancelBtn = nil;
    _numLab = nil;
    _box = nil;
    _addOrDelGroupArray = nil;
    _selectedItemArray = nil;
    self.handleArray = nil;
    self.homeVC = nil;
    self.dataCtrl = nil;
    self.group = nil;
    self.hud = nil;
}
// 初始化界面数据
#pragma mark -
#pragma mark InitViewData
- (void)initViewData
{
    if (_isAdd) {
        //获取添加组员界面数据，调用数据库接口（获取非本组下的客户名片列表）
        self.handleArray = [self.dataCtrl cardsOfUngrouped];
    }else{
        //获取删除组员界面数据，获取本组下的客户名片列表
    }

}
#pragma mark -
#pragma mark TableDelegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searbarCtrl.searchResultsTableView ) {
        return [_resultArray count];
    }else
    return [handleArray count];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searbarCtrl.searchResultsTableView) {
        return 44;
    }else
    return 66;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searbarCtrl.searchResultsTableView) {
        static NSString *cellID = @"searchID";
        UITableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.textLabel.text = [_resultArray objectAtIndex:indexPath.row];
        return cell;
        
    }else{
        static NSString *cellID = @"CELLID";
        KHHClientCellLNPC *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        Card *card = [self.handleArray objectAtIndex:indexPath.row];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"KHHClientCellLNPC" owner:self options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.logoView setImageWithURL:[NSURL URLWithString:card.logo.url] placeholderImage:[UIImage imageNamed:@"logopic.png"]];
            
        }
        if ([[_selectedItemArray objectAtIndex:indexPath.row] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkbox_checked.png"]];
            imgView.frame = CGRectMake(280, 10, 30, 30);
            [cell addSubview:imgView];
        }else{
            UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkbox_unchecked.png"]];
            imgView.frame = CGRectMake(280, 10, 30, 30);
            [cell addSubview:imgView];
        }
        cell.nameLabel.text = card.name;
        cell.positionLabel.text = card.title;
        cell.companyLabel.text = card.company.name;
        return cell;
    }
}
int num = 0;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.searbarCtrl.searchResultsTableView) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        for (KHHCardMode *card in self.handleArray) {
            if ([cell.textLabel.text isEqualToString:card.name]) {
                [self.addOrDelGroupArray addObject:card];
            }
        }
        self.searbarCtrl.active = NO;
    }else{
        NSNumber *state = [_selectedItemArray objectAtIndex:indexPath.row];
        if ([state isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            state = [NSNumber numberWithBool:NO];
            num--;
        }else{
            state = [NSNumber numberWithBool:YES];
            num++;
        }
        NSString *s = [NSString stringWithFormat:@"(%d)",num];
        self.numLab.text = s;
        if (num == 0) {
            self.numLab.hidden = YES;
        }else{
            self.numLab.hidden = NO;
        }
        [_selectedItemArray replaceObjectAtIndex:indexPath.row withObject:state];
        [_theTableM reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [_theTableM deselectRowAtIndexPath:indexPath animated:NO];
    }
}
#pragma mark -
#pragma mark ButtonClick
- (IBAction)sureBtnClick:(id)sender
{
    for (int i = 0; i<self.handleArray.count; i++) {
        if ([[_selectedItemArray objectAtIndex:i] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            [_addOrDelGroupArray addObject:[self.handleArray objectAtIndex:i]];
        }
    }
    
    //调用接口
    if (!self.group) {
        return;
    }
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    if (_isAdd) {
       //调用添加组员接口,
        [self.dataCtrl moveCards:_addOrDelGroupArray fromGroup:nil toGroup:self.group];

    }else{
       //调用移出组员接口
        [self.dataCtrl moveCards:_addOrDelGroupArray fromGroup:self.group toGroup:nil];
    }
     num = 0;
    
   
}
#pragma mark -
- (IBAction)cancelBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    num = 0;

}
- (void)checkbox:(SMCheckbox *)checkbox valueChanged:(BOOL)newValue
{
    
}
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    [self searcResult];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSPredicate *resultPre = [NSPredicate predicateWithFormat:@"SELF contains[cd]%@",searchString];
    _resultArray = [_searchArray filteredArrayUsingPredicate:resultPre];
    return YES;
}
#pragma mark -
- (void)handleMoveCardsSucceeded:(NSNotification *)info{
    [self stopObservingForMoveCards];
    DLog(@"handleMoveCardsSucceeded! info is ====== %@",info);
    [self.hud hide:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)handleMoveCardsFailed:(NSNotification *)info{
    [self stopObservingForMoveCards];
    DLog(@"handleMoveCardsFailed! info is ====== %@",info);
    if (_isAdd) {
        self.hud.labelText = NSLocalizedString(@"添加组员失败", nil);
    }else{
        self.hud.labelText = NSLocalizedString(@"删除组员失败", nil);
    }
    [self.hud hide:YES];
}
- (void)stopObservingForMoveCards{
    [self stopObservingNotificationName:KHHUIMoveCardsSucceeded];
    [self stopObservingNotificationName:KHHUIMoveCardsFailed];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
