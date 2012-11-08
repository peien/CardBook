//
//  KHHHomeViewController.m
//  CardBook
//
//  Created by 孙铭 on 8/6/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHHomeViewController.h"
#import "KHHMyDetailController.h"

#import "KHHClientCellLNPCC.h"
#import "KHHButtonCell.h"

#import "WEPopoverController.h"
#import "KHHFloatBarController.h"

#import "DetailInfoViewController.h"
#import "KHHAddGroupMemberVC.h"
#import "myAlertView.h"
#import "KHHMySearchBar.h"
#import "KHHVisitRecoardVC.h"
#import "KHHAppDelegate.h"
#import "MyTabBarController.h"
#import "KHHShowHideTabBar.h"
#import "MapController.h"
#import "UIButton+WebCache.h"
#import "Edit_eCardViewController.h"
#import "KHHAddressBook.h"
#import "KHHClientCellLNPC.h"

#import "KHHClasses.h"
#import "KHHDataAPI.h"
#import "KHHNotifications.h"
#import "MBProgressHUD.h"
#import "SMCheckbox.h"
#import "KHHClasses.h"

#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#define POPDismiss [self.popover dismissPopoverAnimated:YES];
#define BaseBtnTitleArray   _btnTitleArr = [[NSMutableArray alloc] initWithObjects:@"所有",@"new",@"同事",@"拜访",@"重点",@"未分组",@"手机", nil];

typedef enum {
    KHHTableIndexGroup = 100,
    KHHTableIndexClient = 101
} KHHTableIndexType;

@interface KHHHomeViewController ()<UIActionSheetDelegate,UIAlertViewDelegate,
                                   UITextFieldDelegate,UISearchBarDelegate,UISearchDisplayDelegate
                                   >
@property (nonatomic, strong)  WEPopoverController    *popover;
@property (strong, nonatomic)  NSArray                *keys;
@property (strong, nonatomic)  KHHAppDelegate         *app;
@property (strong, nonatomic)  myAlertView            *alert;
@property (strong, nonatomic)  NSString               *titleStr;
@property (strong, nonatomic)  NSArray                *resultArray;
@property (strong, nonatomic)  NSArray                *searchArray;
@property (strong, nonatomic)  KHHData                *dataControl;
@property (strong, nonatomic)  NSArray                *allArray;
@property (strong, nonatomic)  NSArray                *ReceNewArray;
@property (strong, nonatomic)  NSArray                *myCardArray;
@property (strong, nonatomic)  KHHFloatBarController  *floatBarVC;
@property (assign, nonatomic)  bool                   isOwnGroup;
@property (assign, nonatomic)  NSArray                *privateArr;
@property (assign, nonatomic)  bool                   isNeedReloadTable;
@property (assign, nonatomic)  int                    currentTag;
@property (assign, nonatomic)  bool                   isAddressBookData;
@property (strong, nonatomic)  NSMutableArray         *selectedItemArr;
@property (strong, nonatomic)  NSIndexPath            *currentIndexPath;
@property (strong, nonatomic)  IGroup                 *interGroup;
@property (strong, nonatomic)  UITextField            *groupTf;
@property (strong, nonatomic)  MBProgressHUD          *hud;
@property (strong, nonatomic)  NSArray                *groupTitleArr;

@end

@implementation KHHHomeViewController

@synthesize btnTitleArr = _btnTitleArr;
@synthesize lastBtnTag = _lastBtnTag;
@synthesize btnTable = _btnTable;
@synthesize btnArray = _btnArray;
@synthesize isShowData = _isShowData;
@synthesize currentBtn = _currentBtn;
@synthesize isAddGroup = _isAddGroup;
@synthesize isDelGroup = _isDelGroup;
@synthesize dicBtnTttle = _dicBtnTttle;
@synthesize keys = _keys;
@synthesize searCtrl = _searCtrl;
@synthesize lastIndexPath = _lastIndexPath;
@synthesize isNotHomePage = _isNotHomePage;
@synthesize imgview = _imgview;
@synthesize isNormalSearchBar = _isNormalSearchBar;
@synthesize smallBtn = _smallBtn;
@synthesize bigTable = _bigTable;
@synthesize app = _app;
@synthesize smalImageView = _smalImageView;
@synthesize footView = _footView;
@synthesize btnForCancel = _btnForCancel;
@synthesize btnBackbg = _btnBackbg;
@synthesize btnDic = _btnDic;
@synthesize alert = _alert;
@synthesize titleStr = _titleStr;
@synthesize resultArray = _resultArray;
@synthesize searchArray = _searchArray;
@synthesize type = _type;
@synthesize dataControl;
@synthesize allArray;
@synthesize generalArray;
@synthesize ReceNewArray;
@synthesize floatBarVC;
@synthesize isOwnGroup;
@synthesize oWnGroupArray;
@synthesize myCardArray;
@synthesize privateArr;
@synthesize isNeedReloadTable;
@synthesize currentTag;
@synthesize isAddressBookData;
@synthesize selectedItemArr;
@synthesize currentIndexPath;
@synthesize interGroup;
@synthesize groupTf;
@synthesize hud;
@synthesize groupTitleArr;
@synthesize visitVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.navigationItem.leftBarButtonItem = nil;
        self.leftBtn.hidden = YES;
        //*****************
        self.interGroup = [[IGroup alloc] init];
        self.dataControl = [KHHData sharedData];
        [self.rightBtn setTitle:NSLocalizedString(@"我的名片", nil) forState:UIControlStateNormal];
        
    }
    return self;
}
- (void)dealloc {
    self.popover = nil;
}

- (void)rightBarButtonClick:(id)sender
{
    self.isNeedReloadTable = YES;
    KHHMyDetailController *myDetailVC = [[KHHMyDetailController alloc] initWithNibName:nil bundle:nil];
    myDetailVC.card = [self.myCardArray lastObject];
    [self.navigationController pushViewController:myDetailVC animated:YES];
}
#pragma mark -
#pragma mark View LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithRed:241 green:238 blue:232 alpha:1.0]];
    [_bigTable setBackgroundColor:[UIColor clearColor]];
    
    UIImage *bgimg = [[UIImage imageNamed:@"left_bg2.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
    UIImageView *bgimgView = [[UIImageView alloc] initWithImage:bgimg];
    _btnTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_btnTable setBackgroundView:bgimgView];
      _imgview.image = bgimg;
    
//    UIBarButtonItem *searchBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchBar];
//    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:nil];
//    [self.toolBar setItems:[NSArray arrayWithObjects:searchBarItem, addButtonItem, nil] animated:YES];
    
    //默认选中哪个按钮
    //cell是nil;
    [self performSelector:@selector(defaultSelectBtn) withObject:nil afterDelay:0.3];
    //获取分组
    self.groupTitleArr = [self getAllGroups];
   
    _btnArray = [[NSMutableArray alloc] initWithCapacity:0];
    _isShowData = YES;
    NSIndexPath *index = [NSIndexPath indexPathForRow:-1 inSection:0];
    _lastIndexPath = index;
    
    //点击联系人出现quickAction的插件view
    self.floatBarVC = [[KHHFloatBarController alloc] initWithNibName:nil bundle:nil];
    self.floatBarVC.viewController = self;
    self.popover = [[WEPopoverController alloc] initWithContentViewController:floatBarVC];
    self.floatBarVC.popover = self.popover;
    
    //自定义searchBar(加同步按钮及摄像头iamgeButton)
    KHHMySearchBar *mySearchBar = [[KHHMySearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44) simple:_isNormalSearchBar];
    [mySearchBar.synBtn addTarget:self action:@selector(synBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [mySearchBar.takePhoto addTarget:self action:@selector(takePhotoClick:) forControlEvents:UIControlEventTouchUpInside];
    
    mySearchBar.delegate = self;
    [self.view addSubview:mySearchBar];
    
    //点击界面上的searchBar时出来新的界面供搜索并显示新数据源(实现searchBar的委托方法)
    UISearchDisplayController *disCtrl = [[UISearchDisplayController alloc] initWithSearchBar:mySearchBar contentsController:self];
    disCtrl.delegate = self;
    disCtrl.searchResultsDataSource = self;
    disCtrl.searchResultsDelegate = self;
    _searCtrl = disCtrl;
    
    //添加一个长按动作（bigtable）
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFunc:)];
    longPress.numberOfTouchesRequired = 1;
    longPress.allowableMovement = NO;
    [_bigTable addGestureRecognizer:longPress];
    
    //初始化界面数据
    [self initViewData];
    
    if (_isNormalSearchBar) {
        //[self mutilyFlagForSelected];
        self.leftBtn.hidden = NO;
        _smallBtn.hidden = YES;
        self.rightBtn.hidden = YES;
        CGRect Rect = _smalImageView.frame;
        Rect.size.height = 61;
        _smalImageView.frame = Rect;
        _footView.hidden = NO;
        [_btnForCancel setBackgroundImage:[[UIImage imageNamed:@"tongbu_normal.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:2] forState:UIControlStateNormal];
    }
    
    
}
// 多选标记
- (NSMutableArray *)mutilyFlagForSelected{
    NSMutableArray *selectedArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < self.generalArray.count; i++) {
        [selectedArray addObject:[NSNumber numberWithBool:NO]];
    }
    return selectedArray;
}

// 搜索结果 临时搜索
- (void)searcResult
{
    //搜索结果,
    //通讯录
    _resultArray = [[NSArray alloc] init];
    NSMutableArray *stringArr = [[NSMutableArray alloc] init];
    
    if (self.isAddressBookData) {
        for (int i = 0; i< self.generalArray.count; i++) {
            NSDictionary *dic = [self.generalArray objectAtIndex:i];
            if ([dic objectForKey:@"name"] != nil) {
               [stringArr addObject:[dic objectForKey:@"name"]]; 
            }
        }
    }else{
        for (int i = 0; i< self.generalArray.count; i++) {
            KHHCardMode *card = [self.generalArray objectAtIndex:i];
            if (card.name.length) {
               [stringArr addObject:card.name]; 
            }
        }
    }
    _searchArray = stringArr;

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_isNormalSearchBar) {
        
    }else{
        [KHHShowHideTabBar showTabbar];
        if (self.isNeedReloadTable) {
            [self reloadTable];
        }
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[KHHShowHideTabBar hideTabbar];
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.popover = nil;
    self.btnTitleArr = nil;
    self.btnArray = nil;
    self.currentBtn = nil;
    self.dicBtnTttle = nil;
    self.keys = nil;
    self.lastIndexPath = nil;
    self.imgview = nil;
    self.searCtrl = nil;
    self.smallBtn = nil;
    self.bigTable = nil;
    self.app = nil;
    self.smalImageView = nil;
    self.footView = nil;
    self.btnForCancel = nil;
    self.btnBackbg = nil;
    self.btnDic = nil;
    self.alert = nil;
    self.titleStr = nil;
    self.resultArray = nil;
    self.searchArray = nil;
    self.dataControl = nil;
    self.allArray = nil;
    self.generalArray = nil;
    self.ReceNewArray = nil;
    self.floatBarVC = nil;
    self.oWnGroupArray = nil;
    self.myCardArray = nil;
    self.privateArr = nil;
    self.selectedItemArr = nil;
    self.currentIndexPath = nil;
    self.interGroup = nil;
    self.groupTf = nil;
    self.hud = nil;
    self.groupTitleArr = nil;
    self.visitVC = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark -
#pragma mark Init ViewData
- (void)initViewData
{
    //调用数据库接口，获取各个分组的array
    //所有
    self.allArray = [self.dataControl cardsOfAll];
    self.generalArray = allArray;
    //我的卡片
    self.myCardArray = [self.dataControl allMyCards];
    //获取分组
    
}
//获取分组
- (NSArray *)getAllGroups{
    BaseBtnTitleArray;
    self.oWnGroupArray = [self.dataControl allTopLevelGroups];
    for (int i = 0; i < self.oWnGroupArray.count; i++) {
        Group *group = [self.oWnGroupArray objectAtIndex:i];
        [_btnTitleArr addObject:group.name];
    }
    NSArray *groupArr = _btnTitleArr;
    return groupArr;

}
- (void)reloadTable
{
    if (self.currentTag == 105) {
        self.generalArray = [self.dataControl cardsOfUngrouped];
    }else if (self.currentTag == 100){
        self.generalArray = [self.dataControl cardsOfAll];
    }else if (self.currentTag == 101){
        self.generalArray = [self.dataControl cardsOfNew];
    }else if (self.currentIndexPath.row > 6){
        if (!self.isDelGroup) {
            [self updateOwnGroupArray];
        }
    }
    [_bigTable reloadData];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    if (tableView == self.searCtrl.searchResultsTableView) {
        return [_resultArray count];
    }else{
        NSInteger tableTag = tableView.tag;
        return (tableTag == KHHTableIndexGroup?self.groupTitleArr.count:(tableTag == KHHTableIndexClient)?[self.generalArray count]:0);
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case KHHTableIndexGroup:
            return 40;
            break;
        case KHHTableIndexClient:
            return 58;
        default:
            return 44;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (tableView == self.searCtrl.searchResultsTableView) {
        static NSString *cellID = @"searchCell";
        UITableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.textLabel.text = [_resultArray objectAtIndex:indexPath.row];
        return cell;

    }else{
        NSInteger tableTag = tableView.tag;
        NSString *cellId = nil;
        switch (tableTag) {
            case KHHTableIndexGroup: {
                cellId = NSStringFromClass([KHHButtonCell class]);
                KHHButtonCell *cell = nil;
                cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (nil == cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:cellId
                                                          owner:self
                                                        options:nil] objectAtIndex:0];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                cell.button.tag = indexPath.row + 100;
                [cell.button setTitle:NSLocalizedString([self.groupTitleArr objectAtIndex:indexPath.row], nil) forState:UIControlStateNormal];
                [cell.button addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                UIEdgeInsets insets = {0, 0, 0, 25};
                if (indexPath.row != _lastIndexPath.row) {
                    [cell.button setBackgroundImage:[[UIImage imageNamed:@"left_btn_bg.png"] resizableImageWithCapInsets:insets] forState:UIControlStateNormal];
                    [cell.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }else{
                    [cell.button setBackgroundImage:[[UIImage imageNamed:@"left_btn_bg_selected.png"] resizableImageWithCapInsets:insets] forState:UIControlStateNormal];
                    [cell.button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                }
                
                return cell;
                break;
            }
            case KHHTableIndexClient: {
                
                //通讯录信息显示
                if (self.isAddressBookData) {
                    cellId = @"contactID";
                    KHHClientCellLNPC *cell = nil;
                    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                    if (cell == nil) {
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"KHHClientCellLNPC"
                                                              owner:self
                                                            options:nil] objectAtIndex:0];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                    }
                    //cell.logoView.image = [UIImage imageNamed:@"logopic.png"];
                    cell.nameLabel.text = [[self.generalArray objectAtIndex:indexPath.row] objectForKey:@"name"];
                    cell.positionLabel.text = [[self.generalArray objectAtIndex:indexPath.row] objectForKey:@"job"];
                    cell.companyLabel.text = [[self.generalArray objectAtIndex:indexPath.row] objectForKey:@"company"];
                    return cell;
                }
                
                cellId = NSStringFromClass([KHHClientCellLNPCC class]);
                KHHClientCellLNPCC *cell = nil;
                cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:cellId
                                                          owner:self
                                                        options:nil] objectAtIndex:0];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                //多选标记
                if (self.isNormalSearchBar) {
                    if ([[self.selectedItemArr objectAtIndex:indexPath.row] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                        UIImageView *cellImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checked.png"]];
                        cellImageView.frame = CGRectMake(200, 10, 30, 30);
                        //[cell addSubview:cellImageView];
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }else{
                        UIImageView *cellImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unchecked.png"]];
                        cellImageView.frame = CGRectMake(200, 10, 30, 30);
                        //[cell addSubview:cellImageView];
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                }
                //从网络获取头像
                if ([[self.generalArray objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]]) {
                    DLog(@"self.generalArray 应该是card 类型，但是却是字典类型，所以挂掉了");
                    //return nil;
                }
                Card *card = [self.generalArray objectAtIndex:indexPath.row];
                [cell.logoBtn setImageWithURL:[NSURL URLWithString:card.logo.url]
                             placeholderImage:[UIImage imageNamed:@"logopic.png"]
                                      success:^(UIImage *image, BOOL cached){
                                          if(CGSizeEqualToSize(image.size, CGSizeZero)){
                                              [cell.logoBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                                          }
                                      }
                                      failure:^(NSError *error){
                                          
                                      }];
                
                if (_isNormalSearchBar) {
                    
    
                }else{
                    [cell.logoBtn addTarget:self action:@selector(logoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                }
                //填充单元格数据
                cell.nameLabel.text = card.name;
                cell.positionLabel.text = card.title;
                cell.companyLabel.text =card.company.name;
                return cell;
                break;
            }
        }
  }
    return nil;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger tableTag = tableView.tag;
    switch (tableTag) {
        case KHHTableIndexGroup: {
            break;
        }
        case KHHTableIndexClient: {
            if (_isNormalSearchBar && self.currentIndexPath.row != 6) { //暂时限制手机
                //选中某一个对象并返回
                //[self.navigationController popViewControllerAnimated:YES];
                NSNumber *state = [self.selectedItemArr objectAtIndex:indexPath.row];
                if ([state isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                    state = [NSNumber numberWithBool:NO];
                }else{
                    state = [NSNumber numberWithBool:YES];
                }
                [self.selectedItemArr replaceObjectAtIndex:indexPath.row withObject:state];
                [_bigTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [_bigTable deselectRowAtIndexPath:indexPath animated:NO];
            }else{
                if (self.isAddressBookData) {
                    DLog(@"contact item click!");
                    KHHClientCellLNPC *cell = (KHHClientCellLNPC *)[_bigTable cellForRowAtIndexPath:indexPath];
                    self.floatBarVC.contactDic = [self.generalArray objectAtIndex:indexPath.row];
                    self.floatBarVC.isContactCellClick = YES;
                    CGRect cellRect = cell.logoView.frame;
                    cellRect.origin.x = 98;
                    CGRect rect = [cell convertRect:cellRect toView:self.view];
                    rect.size.height = 45;
                    
                    //DLog(@"[II] logo = %@, frame = %@, converted frame = %@", cell.logoView, NSStringFromCGRect(cell.logoView.frame), NSStringFromCGRect(rect));
                    UIPopoverArrowDirection arrowDirection = rect.origin.y < self.view.bounds.size.height/2?UIPopoverArrowDirectionUp:UIPopoverArrowDirectionDown;
                    [self.popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:arrowDirection animated:YES];
                    return;
                }else{
                    self.isNeedReloadTable = YES;
                    KHHClientCellLNPCC *cell = (KHHClientCellLNPCC*)[tableView cellForRowAtIndexPath:indexPath];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    DetailInfoViewController *detailVC = [[DetailInfoViewController alloc] initWithNibName:nil bundle:nil];
                    //同事不可评估
                    if (self.currentIndexPath.row == 2) {
                        detailVC.isCompanyColleagues = YES;
                        detailVC.isColleagues = YES;
                    }
                    Card *card = (Card *)[self.generalArray objectAtIndex:indexPath.row];
                    detailVC.card = card;
                    if ([card isKindOfClass:[ReceivedCard class]]){
                        [self.dataControl markIsRead:(ReceivedCard *)card];
                    }
                    [self.navigationController pushViewController:detailVC animated:YES];
                }
            }
            break;
        }
    }
    
    if (tableView == self.searCtrl.searchResultsTableView) {
        if (self.isAddressBookData) {
            return;
        }
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        for (Card *card in self.generalArray) {
            if ([cell.textLabel.text isEqualToString:card.name]) {
                DetailInfoViewController *detailVC = [[DetailInfoViewController alloc] initWithNibName:nil bundle:nil];
                detailVC.card = card;
                self.searCtrl.active = NO;
                [self.navigationController pushViewController:detailVC animated:YES];
            }
        }
    }
}
#pragma mark -
#pragma mark Button Click
- (void)defaultSelectBtn
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    KHHButtonCell *cell = (KHHButtonCell *)[_btnTable cellForRowAtIndexPath:indexPath];
    [self performSelector:@selector(cellBtnClick:) withObject:cell.button afterDelay:0.1];
}

//添加拜访对象下面按钮点击
- (void)cancelBtnClick:(id)sender{
    NSMutableArray *visitNameArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < self.selectedItemArr.count; i++) {
        if ([[self.selectedItemArr objectAtIndex:i] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            [visitNameArr addObject:[self.generalArray objectAtIndex:i]];
        }
    }
    self.visitVC.objectNameArr = visitNameArr;
    [self.navigationController popViewControllerAnimated:YES];
}

//点击图片弹出横框
- (void)logoBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    KHHClientCellLNPCC *cell = (KHHClientCellLNPCC *)[[btn superview] superview];
    if (!cell) {
        return;
    }
    NSIndexPath *indexPath = [_bigTable indexPathForCell:cell];
    Card *card = [self.generalArray objectAtIndex:indexPath.row];
    [self showQuickAction:cell currentCard:card];
}
//长按单元格弹出横框
- (void)longPressFunc:(id)sender
{
    if (self.isAddressBookData) {
        return;
    }
    if (!_isNormalSearchBar) {
        if ([(UILongPressGestureRecognizer *)sender state] == UIGestureRecognizerStateBegan) {
            CGPoint p = [(UILongPressGestureRecognizer *)sender locationInView:_bigTable];
            DLog(@"p.x:%f=======p.y:%f",p.x,p.y);
            NSIndexPath *indexPath = [_bigTable indexPathForRowAtPoint:p];
            DLog(@"indexPath:%@",indexPath);
            Card *card = [self.generalArray objectAtIndex:indexPath.row];
            [self showQuickAction:(KHHClientCellLNPCC *)[_bigTable cellForRowAtIndexPath:indexPath] currentCard:card];
        }
    }
}

//显示插件
-(void) showQuickAction:(KHHClientCellLNPCC *) cell currentCard:(Card *) card {
    self.floatBarVC.card = card;
    CGRect cellRect = cell.logoBtn.frame;
    cellRect.origin.x = 98;
    CGRect rect = [cell convertRect:cellRect toView:self.view];
    rect.size.height = 45;
    //DLog(@"[II] logo = %@, frame = %@, converted frame = %@", cell.logoView, NSStringFromCGRect(cell.logoView.frame), NSStringFromCGRect(rect));
    UIPopoverArrowDirection arrowDirection = rect.origin.y < self.view.bounds.size.height/2?UIPopoverArrowDirectionUp:UIPopoverArrowDirectionDown;
    [self.popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:arrowDirection animated:YES];}
#pragma mark-
#pragma mark groupBtn Click
- (void)cellBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    DLog(@"cellBtn.tag=======%d",btn.tag);
    self.isAddressBookData = NO;
    self.floatBarVC.isContactCellClick = NO;

    KHHButtonCell *cell = (KHHButtonCell *)[[btn superview] superview];
    NSIndexPath *indexPath = [_btnTable indexPathForCell:cell];
    self.currentIndexPath = indexPath;
    DLog(@"%@",indexPath);
    if (_lastIndexPath.row != indexPath.row) {
        KHHButtonCell *lastCell = (KHHButtonCell *)[_btnTable cellForRowAtIndexPath:_lastIndexPath];
        UIButton *lastBtn = lastCell.button;
        [lastBtn setBackgroundImage:[[UIImage imageNamed:@"left_btn_bg.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 25)] forState:UIControlStateNormal];
        [lastBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _isShowData = YES;
        self.currentTag = btn.tag;
    }else {
        _isShowData = NO;
    }
    
    _lastIndexPath = indexPath;
    _currentBtn = btn;
    
    if (indexPath.row <= 6) {
        self.isOwnGroup = NO;
    }else{
        self.isOwnGroup = YES;
    }
    if (_isShowData) {
        //刷新表
        switch (btn.tag) {
            case 100:
                //DLog(@"100 btn 数据源刷新");
                self.allArray = [self.dataControl cardsOfAll];
                self.generalArray = self.allArray;
                break;
            case 101:
                DLog(@"101 btn 数据源刷新");
                self.generalArray = [self.dataControl cardsOfNew];
                break;
            case 102:
                DLog(@"102 btn 数据源刷新");
                self.generalArray = [self.dataControl cardsOfColleague];
                break;
            case 103:
                DLog(@"103 btn 数据源刷新");
                self.generalArray = [self.dataControl cardsOfVisited];
                break;
            case 104:
                DLog(@"104 btn 数据源刷新");
                self.generalArray = [self.dataControl cardsOfVIP];
                break;
            case 105:
                DLog(@"105 btn 数据源刷新");
                self.privateArr = [self.dataControl cardsOfUngrouped];
                self.generalArray = self.privateArr;
                break;
            case 106:{
                self.isAddressBookData = YES;
                self.floatBarVC.isContactCellClick = YES;
                NSArray *addressArr = [KHHAddressBook getAddressBookData];
                self.generalArray = addressArr;
                
            }
                break;
            default:
                break;
        }
        if (self.isNormalSearchBar) {
             self.selectedItemArr = [self mutilyFlagForSelected];
        }
        //DLog(@"刷新表");
        //当是自定义分组时，把btn的tag用groupid进行设置，再根据tag进行读取各个分组的成员//(每个分组有cards属性)
        if (self.isOwnGroup) {
            //调用接口，获得self.ownGroupArray
            self.currentTag = btn.tag;
            [self updateOwnGroupArray];
            
        }
        
        UIEdgeInsets insets = {0,0,0,25};
        [btn setBackgroundImage:[[UIImage imageNamed:@"left_btn_bg_selected.png"] resizableImageWithCapInsets:insets] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_bigTable reloadData];
        
        //导航条文字更改(直接设置self.navigationController.title值是有了，界面就是显示不出来)
        self.title = btn.titleLabel.text;
    }else{
        
        _type = KUIActionSheetStyleEditGroupMember;
        if (indexPath.row >= 7) {
            UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                  delegate:self
                                                         cancelButtonTitle:NSLocalizedString(@"取消",nil)
                                                    destructiveButtonTitle:nil
                                                         otherButtonTitles:nil, nil];
            
            [actSheet addButtonWithTitle:NSLocalizedString(@"添加组员", nil)];
            [actSheet addButtonWithTitle:NSLocalizedString(@"移出组员", nil)];
            [actSheet addButtonWithTitle:NSLocalizedString(@"修改组名", nil)];
            [actSheet addButtonWithTitle:NSLocalizedString(@"删除分组", nil)];
            [actSheet showInView:self.view];
        }
    }
}
- (void)updateOwnGroupArray{
    
    self.oWnGroupArray = [self.dataControl allTopLevelGroups];
    Group *group = [self.oWnGroupArray objectAtIndex:self.currentIndexPath.row - 7];
    NSSet *set = group.cards;
    NSArray *cards = [set allObjects];
    if (cards.count == 0) {
        self.generalArray = nil;
    }else{
        self.generalArray = cards;
    }
}
#pragma mark -
#pragma mark synBtnClick
- (void)synBtnClick:(id)sender
{
    NSLog(@"start syn");
    //进度条，调用同步联系人接口，同步完后，刷新界面

}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_type == KUIActionSheetStyleEditGroupMember) {
        self.oWnGroupArray = [self.dataControl allTopLevelGroups];
        Group *group = [self.oWnGroupArray objectAtIndex:self.currentTag - 100 - 7];
        KHHAddGroupMemberVC *addMemVC = [[KHHAddGroupMemberVC alloc] initWithNibName:@"KHHAddGroupMemberVC" bundle:nil];
        addMemVC.group = group;
        addMemVC.homeVC = self;
        self.isNeedReloadTable = YES;
        if (buttonIndex == 1) {
            self.isNeedReloadTable = YES;
            addMemVC.isAdd = YES;
            self.isDelGroup = NO;
            //addMemVC.handleArray = self.allArray;
        }else if(buttonIndex == 2){
            self.isNeedReloadTable = YES;
            addMemVC.isAdd = NO;
            self.isDelGroup = NO;
            addMemVC.handleArray = self.generalArray;
        }else if (buttonIndex == 3){
            //修改组名
            // 注册修改分组名消息
            [self observeNotificationName:KHHUIUpdateGroupSucceeded selector:@"handleUpdateGroupSucceeded:"];
            [self observeNotificationName:KHHUIUpdateGroupFailed selector:@"handleUpdateGroupFailed:"];
            
            myAlertView *alert = [[myAlertView alloc] initWithTitle:@"修改组名" message:nil delegate:self style:kMyAlertStyleTextField cancelButtonTitle:@"确定" otherButtonTitles:@"取消"];
            _titleStr = NSLocalizedString(@"修改组名", nil);
            _isAddGroup = NO;
            _isDelGroup = NO;
            [alert show];
            return;
        }else if (buttonIndex == 4){
            //删除分组
            //注册删除分组的消息
            [self observeNotificationName:KHHUIDeleteGroupSucceeded selector:@"handleDeleteGroupSucceeded:"];
            [self observeNotificationName:KHHUIDeleteGroupFailed selector:@"handleDeleteGroupFailed:"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"删除", nil) 
                                                            message:NSLocalizedString(@"将会删除该组", nil) 
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"确定", nil) 
                                                  otherButtonTitles:NSLocalizedString(@"取消", nil), nil];
            _isDelGroup = YES;
            [alert show];
            return;
        
        }else if (buttonIndex == 0){
            return;
        }
        [self.navigationController pushViewController:addMemVC animated:YES];
    }else if (_type == KUIActionSheetStyleUpload){//暂时直接跳转到编辑界面了，这个地方不会执行。
        if (buttonIndex == 0) {
            //拍摄名片;
            [self takePhotos];
        }else if (buttonIndex == 1){
            //选择名片;
        }else if (buttonIndex == 2){
            //手动制作;
            self.isNeedReloadTable = YES;
            Edit_eCardViewController *creatCardVC = [[Edit_eCardViewController alloc] initWithNibName:nil bundle:nil];
            creatCardVC.type = KCardViewControllerTypeNewCreate;
            [self.navigationController pushViewController:creatCardVC animated:YES];
        }else if (buttonIndex == 3){
           //备份手机通讯录;

        }
    }
}

// 拍照
- (void)takePhotos
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePickCtrl = [[UIImagePickerController alloc] init];
        imagePickCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickCtrl.delegate = self;
        imagePickCtrl.allowsEditing = YES;
        [self presentModalViewController:imagePickCtrl animated:YES];
    }
}
- (void)takePhotoClick:(id)sender
{
    //[self takePhotos];
    //录入上传
//    UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"选择上传方式", nil)
//                                                          delegate:self
//                                                 cancelButtonTitle:nil
//                                            destructiveButtonTitle:nil
//                                                 otherButtonTitles:nil, nil];
//    _type = KUIActionSheetStyleUpload;
//    [actSheet addButtonWithTitle:NSLocalizedString(@"拍摄名片", nil)];
//    [actSheet addButtonWithTitle:NSLocalizedString(@"选择名片", nil)];
//    [actSheet addButtonWithTitle:NSLocalizedString(@"手动制作", nil)];
//    [actSheet addButtonWithTitle:NSLocalizedString(@"备份手机通讯录", nil)];
//    [actSheet showInView:self.view];
    self.isNeedReloadTable = YES;
    Edit_eCardViewController *creatCardVC = [[Edit_eCardViewController alloc] initWithNibName:nil bundle:nil];
    creatCardVC.type = KCardViewControllerTypeNewCreate;
    [self.navigationController pushViewController:creatCardVC animated:YES];
}
- (void)saveImage:(UIImage *)image
{

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self performSelector:@selector(saveImage:) withObject:image afterDelay:0.5];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

#pragma mark - UISearchDisplayDelegate
// when we start/end showing the search UI
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {

    for (UIButton *btn in controller.searchBar.subviews) {
        if (btn.tag == 1111 || btn.tag == 2222) {
            btn.hidden = YES;
        }
    }
    [self searcResult];
}
    
- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
    
}
- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    for (UIButton *btn in controller.searchBar.subviews) {
        if (btn.tag == 1111 || btn.tag == 2222) {
            btn.hidden = NO;
        }
    }
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
//    CGRect oldFrame = self.searchBar.frame;
//    self.searchBar.frame = CGRectMake(70, oldFrame.origin.y, 250, oldFrame.size.height);

}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSPredicate *resultPre = [NSPredicate predicateWithFormat:@"SELF contains[cd]%@",searchString];
    _resultArray = [_searchArray filteredArrayUsingPredicate:resultPre];
    return YES;
}
#pragma mark - ShowAlertView
- (IBAction)addBtnClick:(id)sender{
    //注册新建分组消息
    [self observeNotificationName:KHHUICreateGroupSucceeded selector:@"handleCreateGroupSucceeded:"];
    [self observeNotificationName:KHHUICreateGroupFailed selector:@"handleCreateGroupFailed:"];
    
    _titleStr = NSLocalizedString(@"新建分组", nil) ;
   _alert = [[myAlertView alloc] initWithTitle:_titleStr
                                       message:nil
                                      delegate:self
                                         style:kMyAlertStyleTextField
                             cancelButtonTitle:NSLocalizedString(@"确定", nil)
                             otherButtonTitles:NSLocalizedString(@"取消",nil)];
    _isAddGroup = YES;
    _isDelGroup = NO;
    [_alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 && !_isDelGroup) {
        for (UIView *view in alertView.subviews) {
            if ([view isKindOfClass:[UITextField class]]) {
                UITextField *tf = (UITextField *)view;
                
                if (tf.text.length > 0 && _isAddGroup) {
                    //[_btnTitleArr addObject:tf.text];
                    //同步，从新调用自定义的所有分组，然后再刷新表
                    [self showHudForNetWorkWarn];
                    self.groupTf = tf;
                    self.interGroup.name = tf.text;
                    [self.dataControl createGroup:interGroup withMyCard:[self.myCardArray lastObject]];
                    //[_btnTable reloadData];
                    //[_btnTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_btnTitleArr count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    
                }else{
                    //修改组名，
                    if (tf.text == nil) {
                        return;
                    }
                    [self showHudForNetWorkWarn];
                    self.groupTf = tf;
                    Group *group = [self.oWnGroupArray objectAtIndex:self.currentIndexPath.row - 7];
                    self.interGroup.id = group.id;
                    self.interGroup.name = tf.text;
                    [self.dataControl updateGroup:self.interGroup];
                }
            }
        }
    }else if(buttonIndex == 0 && _isDelGroup){
        //自己添加的删除完以后，就不可删除
        if (_btnTitleArr.count < 8) {
            return;
        }
        [self showHudForNetWorkWarn];
        self.oWnGroupArray = [self.dataControl allTopLevelGroups];
        Group *group = [self.oWnGroupArray objectAtIndex:currentIndexPath.row - 7];
        [self.dataControl deleteGroup:group];
        //[_btnTitleArr removeObjectAtIndex:_currentBtn.tag - 100];
        //[_btnTable reloadData];
    }
    if (buttonIndex == 1) {
        return;
    }
}
#pragma mark - handleGroup
//创建组
- (void)handleCreateGroupSucceeded:(NSNotification *)info{
    DLog(@"handleCreateGroupSucceeded! info is ====== %@",info);
    [self stopObservingForCreatGroup];
    //[_btnTitleArr addObject:self.groupTf.text];
    self.groupTitleArr = [self getAllGroups];
    [_btnTable reloadData];
    [_btnTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.groupTitleArr count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [self netWorkWarnForHandleGroup:NSLocalizedString(@"", nil)];
    
}
- (void)handleCreateGroupFailed:(NSNotification *)info{
    DLog(@"handleCreateGroupFailed! info is ====== %@",info);
    [self stopObservingForCreatGroup];
    [self netWorkWarnForHandleGroup:NSLocalizedString(@"创建失败", nil)];

}
//删除组
- (void)handleDeleteGroupSucceeded:(NSNotification *)info{
    DLog(@"handleDeleteGroupSucceeded! info is ====== %@",info);
    [self stopObservingForDelGroup];
    [self netWorkWarnForHandleGroup:NSLocalizedString(@"", nil)];
    [_btnTitleArr removeObjectAtIndex:_currentBtn.tag - 100];
    [_btnTable reloadData];
    self.generalArray = nil;
    [_bigTable reloadData];

}
- (void)handleDeleteGroupFailed:(NSNotification *)info{
    DLog(@"handleDeleteGroupFailed! info is ====== %@",info);
    [self stopObservingForDelGroup];
     [self netWorkWarnForHandleGroup:NSLocalizedString(@"删除失败", nil)];

}
//修改组
- (void)handleUpdateGroupSucceeded:(NSNotification *)info{
    DLog(@"handleUpdateGroupSucceeded! info is ====== %@",info);
    [self stopObservingForUpdateGroup];
    [self netWorkWarnForHandleGroup:NSLocalizedString(@"", nil)];
    [_btnTitleArr replaceObjectAtIndex:_currentBtn.tag - 100 withObject:self.groupTf.text];
    [_currentBtn setTitle:self.groupTf.text forState:UIControlStateNormal];
    

}
- (void)handleUpdateGroupFailed:(NSNotification *)info{
    DLog(@"handleUpdateGroupFailed! info is ====== %@",info);
    [self stopObservingForUpdateGroup];
    [self netWorkWarnForHandleGroup:NSLocalizedString(@"修改失败", nil)];
    

}
- (void)stopObservingForCreatGroup{
    [self stopObservingNotificationName:KHHUICreateGroupSucceeded];
    [self stopObservingNotificationName:KHHUICreateGroupFailed];
    
}
- (void)stopObservingForDelGroup{
    [self stopObservingNotificationName:KHHUIDeleteGroupSucceeded];
    [self stopObservingNotificationName:KHHUIDeleteGroupFailed];

}
- (void)stopObservingForUpdateGroup{
    [self stopObservingNotificationName:KHHUIUpdateGroupSucceeded];
    [self stopObservingNotificationName:KHHUIUpdateGroupFailed];

}
- (void)netWorkWarnForHandleGroup:(NSString *)title{
    self.hud.labelText = title;
    [self.hud hide:YES afterDelay:0.5];

}
- (void)showHudForNetWorkWarn{
    KHHAppDelegate *app = (KHHAppDelegate *)[UIApplication sharedApplication].delegate;
    self.hud = [MBProgressHUD showHUDAddedTo:app.window animated:YES];

}
#pragma mark - test
- (void)testAction:(id)sender {
    DLog(@"[II] testAction");
    [self.navigationController pushViewController:[[KHHMyDetailController alloc] init] animated:YES];
}
@end
