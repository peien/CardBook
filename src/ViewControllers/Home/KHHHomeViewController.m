//
//  KHHHomeViewController.m
//  CardBook
//
//  Created by 孙铭 on 8/6/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHHomeViewController.h"
#import "KHHMyDetailController.h"
#import "KHHDefaults.h"

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
//#import "MapController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>


#import "KHHNewEdit_ecardViewController.h"
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
#import "KHHDataNew+Card.h"


//同事移到组织架构里去
#define POPDismiss [self.popover dismissPopoverAnimated:YES];


@interface KHHHomeViewController ()<UIActionSheetDelegate,UIAlertViewDelegate,
                                   UITextFieldDelegate,UISearchBarDelegate,UISearchDisplayDelegate,KHHDataGroupDelegate
                                   >
@property (nonatomic, strong)  WEPopoverController    *popover;
@property (strong, nonatomic)  NSArray                *keys;
@property (strong, nonatomic)  KHHAppDelegate         *app;
@property (strong, nonatomic)  myAlertView            *alert;
@property (strong, nonatomic)  NSString               *titleStr;
@property (strong, nonatomic)  NSArray                *resultArray;
@property (strong, nonatomic)  NSArray                *searchArray;
//@property (strong, nonatomic)  KHHData                *dataControl;
//@property (strong, nonatomic)  NSArray                *allArray;
@property (strong, nonatomic)  NSArray                *ReceNewArray;
@property (strong, nonatomic)  NSArray                *myCardArray;
@property (strong, nonatomic)  KHHFloatBarController  *floatBarVC;
@property (assign, nonatomic)  bool                   isOwnGroup;

@property (assign, nonatomic)  int                    currentTag;
@property (assign, nonatomic)  bool                   isAddressBookData;
//多选时记录选择位置（bug 1176 要改成一次只先一个，方文苑确认了）
//@property (strong, nonatomic)  NSMutableArray         *selectedItemArr;
@property (strong, nonatomic)  NSIndexPath            *currentIndexPath;
@property (strong, nonatomic)  IGroup                 *interGroup;
@property (strong, nonatomic)  UITextField            *groupTf;
@property (strong, nonatomic)  MBProgressHUD          *hud;

@property (assign, nonatomic)  bool                   isNewContactsClick;
@property (assign, nonatomic)  int                    baseNum;
@property (strong, nonatomic)  UIImageView            *messageImageView;
@property (strong, nonatomic)  UILabel                *numLab2;
@property (strong, nonatomic)  KHHDefaults            *myDefaults;

@end

@implementation KHHHomeViewController

@synthesize btnTitleArr = _btnTitleArr;
@synthesize lastBtnTag = _lastBtnTag;
@synthesize btnTable = _btnTable;
@synthesize btnArray = _btnArray;
@synthesize isShowData = _isShowData;
@synthesize currentBtn = _currentBtn;
@synthesize isAddGroup = _isAddGroup;
@synthesize dicBtnTttle = _dicBtnTttle;
@synthesize keys = _keys;
@synthesize searCtrl = _searCtrl;
@synthesize lastIndexPath = _lastIndexPath;
@synthesize isNotHomePage = _isNotHomePage;
@synthesize isNormalSearchBar = _isNormalSearchBar;
@synthesize smallBtn = _smallBtn;
@synthesize bigTable = _bigTable;
@synthesize app = _app;
@synthesize smallImageView = _smallImageView;
@synthesize footView = _footView;
@synthesize btnForCancel = _btnForCancel;
@synthesize btnBackbg = _btnBackbg;
@synthesize btnDic = _btnDic;
@synthesize alert = _alert;
@synthesize titleStr = _titleStr;
@synthesize resultArray = _resultArray;
@synthesize searchArray = _searchArray;
@synthesize type = _type;
//@synthesize dataControl;
//@synthesize allArray;
@synthesize generalArray;
@synthesize ReceNewArray;
@synthesize floatBarVC;
@synthesize isOwnGroup;
@synthesize oWnGroupArray;
@synthesize myCardArray;
@synthesize isNeedReloadTable;
@synthesize currentTag;
@synthesize isAddressBookData;
@synthesize currentIndexPath;
@synthesize interGroup;
@synthesize groupTf;


@synthesize visitVC;
@synthesize isNewContactsClick;
@synthesize baseNum;
@synthesize messageImageView;
@synthesize numLab2;
@synthesize myDefaults;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.navigationItem.leftBarButtonItem = nil;
        //self.leftBtn.hidden = YES;
        //*****************
        self.interGroup = [[IGroup alloc] init];
        //self.dataControl = [KHHData sharedData];
       // self.myDefaults = [KHHDefaults sharedDefaults];
        //[self.rightBtn setTitle:NSLocalizedString(@"我的名片", nil) forState:UIControlStateNormal];
        self.rightBtn.hidden = YES;
    }
    return self;
}

- (void)dealloc {
    self.popover = nil;
}

- (void)rightBarButtonClick:(id)sender
{
//    self.isNeedReloadTable = YES;
//    KHHMyDetailController *myDetailVC = [[KHHMyDetailController alloc] initWithNibName:nil bundle:nil];
//    myDetailVC.card = [self.myCardArray lastObject];
//    [self.navigationController pushViewController:myDetailVC animated:YES];
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
    _smallImageView.image = bgimg;
    
//    UIBarButtonItem *searchBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchBar];
//    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:nil];
    
    //默认选中哪个按钮
    //cell是nil;
    [self performSelector:@selector(defaultSelectBtn) withObject:nil afterDelay:0.3];
    //获取分组
     [self refreshAllGroups];
   
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
    KHHMySearchBar *mySearchBar = [[KHHMySearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44) simple:_isNormalSearchBar showSearchBtn:NO];
    //搜索按钮
//    [mySearchBar.synBtn addTarget:self action:@selector(synBtnClick:) forControlEvents:UIControlEventTouchUpInside];
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
        
        //显示下方的确定按钮 bug 1176 改成选中一个就返回了，就个view暂时不需要了
        //把原来添加分组的高度设置成0 把btnTable的高度加上原添加分组的iamgeView的高度
        CGRect rectImageView = _smallImageView.frame;
        CGRect rectGroup = _btnTable.frame;
        rectGroup.size.height = rectGroup.size.height + rectImageView.size.height;
        rectImageView.size.height = 0;
        _smallImageView.frame = rectImageView;
        _btnTable.frame = rectGroup;
//        _footView.hidden = NO;
//        [_btnForCancel setBackgroundImage:[[UIImage imageNamed:@"tongbu_normal.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:2] forState:UIControlStateNormal];
    }
    
    //判断是否是iphone5,把图标位置改一下
    [KHHViewAdapterUtil checkIsNeedMoveDownForIphone5:_smallBtn];
    [KHHViewAdapterUtil checkIsNeedMoveDownForIphone5:_smallImageView];
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
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self showNewContactsNum];
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
    self.searCtrl = nil;
    self.smallBtn = nil;
    self.bigTable = nil;
    self.app = nil;
    self.smallImageView = nil;
    self.footView = nil;
    self.btnForCancel = nil;
    self.btnBackbg = nil;
    self.btnDic = nil;
    self.alert = nil;
    self.titleStr = nil;
    self.resultArray = nil;
    self.searchArray = nil;
   // self.dataControl = nil;
//    self.allArray = nil;
    self.generalArray = nil;
    self.ReceNewArray = nil;
    self.floatBarVC = nil;
    self.oWnGroupArray = nil;
    self.myCardArray = nil;
//    self.selectedItemArr = nil;
    self.currentIndexPath = nil;
    self.interGroup = nil;
    self.groupTf = nil;
    self.hud = nil;
    
    self.visitVC = nil;
    self.messageImageView = nil;
    self.numLab2 = nil;
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
    self.generalArray = [[KHHDataNew sharedData] cardsOfAll];
    //我的卡片
//    self.myCardArray = [self.dataControl allMyCards];
//    if (!self.myCardArray || self.myCardArray.count <= 0) {
//        //提示数据未同步完成
//        //提示用户数据没有同步下来，先同步一下数据
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:KhhMessageDataErrorTitle
//                                                        message:KhhMessageDataError
//                                                       delegate:self
//                                              cancelButtonTitle:KHHMessageSure
//                                              otherButtonTitles:KHHMessageCancle, nil];
//        alert.tag = KHHAlertSync;
//        [alert show];
//    }
}
//获取分组
- (void)refreshAllGroups{
    //初始化分组，如果是选择人的话就默认只有两个固定分组
    //默认只有2个分组（所有、未分组）如果用户设置显示手机就分组数 +1 ,如果是同事 +1
    
    if (!_btnTitleArr) {
         _btnTitleArr = [[NSMutableArray alloc] init];
    }else{
        [_btnTitleArr removeAllObjects];
    }
    
    self.oWnGroupArray = [[KHHDataNew sharedData] allTopLevelGroups];
    [_btnTitleArr addObject:@"所有"];
    [_btnTitleArr addObject:@"未分组"];
    for (int i = 0; i < self.oWnGroupArray.count; i++) {
        Group *group = [self.oWnGroupArray objectAtIndex:i];
        NSLog(@"%lld,%@",group.idValue,group.name);
        [_btnTitleArr addObject:group.name];
    }
    if ([KHHUser shareInstance].isAddMobPhoneGroup) {
        [_btnTitleArr addObject:@"手机"];
    }
    
    

}
- (void)reloadTable
{
    //如果删除的是最后一个自建分组，得把self.isOwnGroup置成false
    if (_btnTitleArr.count == self.baseNum) {
        self.isOwnGroup = NO;
        _currentBtn = nil;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.baseNum - 1 inSection:0];
        KHHButtonCell *cell = (KHHButtonCell *)[_btnTable cellForRowAtIndexPath:indexPath];
        [self performSelector:@selector(cellBtnClick:) withObject:cell.button afterDelay:0.1];
        return;
    }
    
    BOOL isNeedRefresh = YES;
    if (self.isOwnGroup) {
        isNeedRefresh = [self updateOwnGroupArray];
    }else {
        NSString *btnName = _currentBtn.titleLabel.text;
        if ([btnName isEqualToString:KHHMessageDefaultGroupUnGroup]) {
            self.generalArray = [[KHHDataNew sharedData] cardsOfUngrouped];
        }else if ([btnName isEqualToString:KHHMessageDefaultGroupAll]){
            self.generalArray = [[KHHDataNew sharedData] cardsOfAll];
        }
    }
    
    if (isNeedRefresh) {
        [_bigTable reloadData];
    }
}
//显示联系人个数
- (void)showNewContactsNum{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    KHHButtonCell *cell = (KHHButtonCell *)[_btnTable cellForRowAtIndexPath:indexPath];
    if (self.messageImageView == nil) {
        self.messageImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"message_bg.png"]stretchableImageWithLeftCapWidth:0 topCapHeight:0]];
        self.messageImageView.frame = CGRectMake(40, -8, 35, 35);
        //self.messageImageView.backgroundColor = [UIColor grayColor];
        numLab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 35, 35)];
        numLab2.backgroundColor = [UIColor clearColor];
        numLab2.font = [UIFont systemFontOfSize:10];
        numLab2.textColor = [UIColor whiteColor];
        numLab2.textAlignment = UITextAlignmentCenter;
        [self.messageImageView addSubview:numLab2];
        [cell.button addSubview:self.messageImageView];
    }
    int num = [[KHHDataNew sharedData] cardsOfNew].count;
    if (num > 0) {
        self.messageImageView.hidden = NO;
        numLab2.text = [NSString stringWithFormat:@"%d",num];
    }else if (num == 0){
        self.messageImageView.hidden = YES;
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    if (tableView == self.searCtrl.searchResultsTableView) {
        return [_resultArray count];
    }else{
        NSInteger tableTag = tableView.tag;
        return (tableTag == KHHTableIndexGroup?_btnTitleArr.count:(tableTag == KHHTableIndexClient)?[self.generalArray count]:0);
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
                    cell.backgroundColor = [UIColor clearColor];
                }
                cell.button.tag = indexPath.row + 100;
                cell.button.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
                cell.button.titleLabel.numberOfLines = 2;
                [cell.button setTitle:NSLocalizedString([_btnTitleArr objectAtIndex:indexPath.row], nil) forState:UIControlStateNormal];
                [cell.button addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                UIEdgeInsets insets = {0, 0, 45, 25};
                if (indexPath.row != _lastIndexPath.row) {
                    [cell.button setBackgroundImage:[[UIImage imageNamed:@"left_btn_bg.png"] resizableImageWithCapInsets:insets] forState:UIControlStateNormal];
                    [cell.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }else{
                    [cell.button setBackgroundImage:[[UIImage imageNamed:@"left_btn_bg.png"] resizableImageWithCapInsets:insets] forState:UIControlStateNormal];
                    [cell.button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                }
                int num = [[[KHHDataNew sharedData] cardsOfNew] count];
                if (indexPath.row == 0 && num > 0) {
                    [cell.button addSubview:self.messageImageView];
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
//                if (self.isNormalSearchBar) {
//                    if ([[self.selectedItemArr objectAtIndex:indexPath.row] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
//                        UIImageView *cellImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checked.png"]];
//                        cellImageView.frame = CGRectMake(200, 10, 30, 30);
//                        //[cell addSubview:cellImageView];
//                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//                    }else{
//                        UIImageView *cellImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unchecked.png"]];
//                        cellImageView.frame = CGRectMake(200, 10, 30, 30);
//                        //[cell addSubview:cellImageView];
//                        cell.accessoryType = UITableViewCellAccessoryNone;
//                    }
//                }
                //从网络获取头像
                if ([[self.generalArray objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]]) {
                    DLog(@"self.generalArray 应该是card 类型，但是却是字典类型，所以挂掉了");
                    //return nil;
                }
                Card *card = [self.generalArray objectAtIndex:indexPath.row];
                UIImage *imgNor = [UIImage imageNamed:@"logopic.png"];
                if ([card isKindOfClass:[ReceivedCard class]]) {
                    ReceivedCard *reCard = (ReceivedCard *)card;
                    if (reCard.isReadValue) {
                        cell.newicon.hidden = YES;
                    }else{
                        cell.newicon.hidden =  NO;
                    }
                }else{
                    cell.newicon.hidden = YES;
                }
                
                CALayer *l = [cell.logoImage layer];
                [cell.logoImage setImageWithURL:[NSURL URLWithString:card.logo.url]
                             placeholderImage:imgNor
                                      success:^(UIImage *image, BOOL cached){
                                          
                                          if(!CGSizeEqualToSize(image.size, CGSizeZero)){
                                              
                                              [l setMasksToBounds:YES];
                                              [l setCornerRadius:6.0];
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
            if (_isNormalSearchBar) { //暂时限制手机
                //20121217 bug1176 拜访人选中一个就返回(方文苑确认)
//                NSNumber *state = [self.selectedItemArr objectAtIndex:indexPath.row];
//                if ([state isEqualToNumber:[NSNumber numberWithBool:YES]]) {
//                    state = [NSNumber numberWithBool:NO];
//                }else{
//                    state = [NSNumber numberWithBool:YES];
//                }
//                [self.selectedItemArr replaceObjectAtIndex:indexPath.row withObject:state];
//                [_bigTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
//                [_bigTable deselectRowAtIndexPath:indexPath animated:NO];
                
                //选中某一个对象并返回
              
                if (!self.visitVC.objectNameArr) {
                    self.visitVC.objectNameArr = [[NSMutableArray alloc] initWithCapacity:0];
                }
                if (_appendCardName) {
                    _appendCardName ([self.generalArray objectAtIndex:indexPath.row]);
                }
//                if(_cardsArr){
//                    _cardsArr = [[NSMutableArray alloc] initWithCapacity:0];
//                }
//                [_cardsArr addObject:[self.generalArray objectAtIndex:indexPath.row]];
                
                //[self.visitVC.objectNameArr addObject:[self.generalArray objectAtIndex:indexPath.row]];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                if (self.isAddressBookData) {
                    DLog(@"contact item click!");
                    KHHClientCellLNPC *cell = (KHHClientCellLNPC *)[_bigTable cellForRowAtIndexPath:indexPath];
                    CGRect cellRect = cell.logoView.frame;
                    cellRect.origin.x = 98;
                    CGRect rect = [cell convertRect:cellRect toView:self.view];
                    [self showQuickAction:rect currentCard:nil contactDic:[self.generalArray objectAtIndex:indexPath.row]];
                    return;
                }else{
                    self.isNeedReloadTable = YES;
                    KHHClientCellLNPCC *cell = (KHHClientCellLNPCC*)[tableView cellForRowAtIndexPath:indexPath];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    DetailInfoViewController *detailVC = [[DetailInfoViewController alloc] initWithNibName:nil bundle:nil];
                    
                    Card *card = (Card *)[self.generalArray objectAtIndex:indexPath.row];
                    detailVC.card = card;
                    detailVC.deleteSelfSuccess = ^(){
                        
                        [self dataArrayRefresh];
                    };
                    
                    if ([card isKindOfClass:[ReceivedCard class]]){
                        ReceivedCard *receCard = (ReceivedCard *)card;
                        if (!receCard.isReadValue) {
                            [[KHHDataNew sharedData] doMarkIsRead:receCard delegate:self];
                        }
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
                self.searCtrl.active = NO;
                if (!_isNormalSearchBar) {
                    DetailInfoViewController *detailVC = [[DetailInfoViewController alloc] initWithNibName:nil bundle:nil];
                    detailVC.card = card;
                    detailVC.deleteSelfSuccess = ^(){
                        [self dataArrayRefresh];
                    } ;
                    [self.navigationController pushViewController:detailVC animated:YES];
                    
                }else{
                    if (_appendCardName) {
                        _appendCardName ([self.generalArray objectAtIndex:indexPath.row]);
                    }
                    self.visitVC.searchCard = card;
                    [self.navigationController popViewControllerAnimated:YES];
                }
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
//20121217 bug1176 选中一个就返回，在table cell选中时就做了
- (void)cancelBtnClick:(id)sender{
    
//    NSMutableArray *visitNameArr = [[NSMutableArray alloc] initWithCapacity:0];
//    for (int i = 0; i < self.selectedItemArr.count; i++) {
//        if ([[self.selectedItemArr objectAtIndex:i] isEqualToNumber:[NSNumber numberWithBool:YES]]) {
//            [visitNameArr addObject:[self.generalArray objectAtIndex:i]];
//        }
//    }
//    self.visitVC.objectNameArr = visitNameArr;
//    [self.navigationController popViewControllerAnimated:YES];
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
    CGRect cellRect = cell.logoBtn.frame;
    cellRect.origin.x = 98;
    CGRect rect = [cell convertRect:cellRect toView:self.view];
    [self showQuickAction:rect currentCard:card contactDic:nil];
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
            KHHClientCellLNPCC *cell = (KHHClientCellLNPCC *)[_bigTable cellForRowAtIndexPath:indexPath];
            Card *card = [self.generalArray objectAtIndex:indexPath.row];
            CGRect cellRect = cell.logoBtn.frame;
            cellRect.origin.x = 98;
            CGRect rect = [cell convertRect:cellRect toView:self.view];
            [self showQuickAction:rect currentCard:card contactDic:nil];
        }
    }
}

//显示插件
//是联系人就传card，是手机的就传dictionary
-(void) showQuickAction:(CGRect) rect currentCard:(Card *) card contactDic:(NSDictionary *) dict{
    if (card) {
        self.floatBarVC.card = card;
        self.floatBarVC.contactDic = nil;
        NSNumber *companyID = [self.myDefaults currentCompanyID];
        if(companyID.longValue > 0 && card.company.id.longValue == companyID.longValue) {
            self.floatBarVC.isJustNormalComunication = YES;
        }else {
            self.floatBarVC.isJustNormalComunication = NO;
        }
    }else {
        self.floatBarVC.card = nil;
        self.floatBarVC.contactDic = dict;
        self.floatBarVC.isContactCellClick = YES;
    }
    rect.size.height = 45;
    //DLog(@"[II] logo = %@, frame = %@, converted frame = %@", cell.logoView, NSStringFromCGRect(cell.logoView.frame), NSStringFromCGRect(rect));
    UIPopoverArrowDirection arrowDirection = rect.origin.y < self.view.bounds.size.height/2?UIPopoverArrowDirectionUp:UIPopoverArrowDirectionDown;
    [self.popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:arrowDirection animated:YES];    
}
#pragma mark-

- (Boolean)isOWnGroupSelected:(NSIndexPath *)indexPath
{
    return indexPath.row > 2 && !([KHHUser shareInstance].isAddMobPhoneGroup && indexPath.row == [_btnTitleArr count]-1);
}

#pragma mark groupBtn Click
- (void)cellBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSString *btnName = btn.titleLabel.text;
    DLog(@"cellBtn.tag=======%d,name = %@",btn.tag,btnName);
    self.isAddressBookData = NO;
    self.floatBarVC.isContactCellClick = NO;

    KHHButtonCell *cell = (KHHButtonCell *)[[btn superview] superview];
    NSIndexPath *indexPath = [_btnTable indexPathForCell:cell];
    self.currentIndexPath = indexPath;
    DLog(@"%@",indexPath);
    if (_lastIndexPath.row != indexPath.row) {
        KHHButtonCell *lastCell = (KHHButtonCell *)[_btnTable cellForRowAtIndexPath:_lastIndexPath];
        UIButton *lastBtn = lastCell.button;
        [lastBtn setBackgroundImage:[[UIImage imageNamed:@"left_btn_bg.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 40, 25)] forState:UIControlStateNormal];
        [lastBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _isShowData = YES;
        self.currentTag = btn.tag;
    }else {
        _isShowData = NO;
    }
    
    _lastIndexPath = indexPath;
    _currentBtn = btn;
    
//    if (indexPath.row <= self.baseNum - 1) {
//        self.isOwnGroup = NO;
//    }else{
//        self.isOwnGroup = YES;
//    }
    if (_isShowData) {
        //DLog(@"刷新表");
        //当是自定义分组时，把btn的tag用groupid进行设置，再根据tag进行读取各个分组的成员//(每个分组有cards属性)
        if ([self isOWnGroupSelected:indexPath]) {
            //调用接口，获得self.ownGroupArray
            self.currentTag = btn.tag;
            [self updateOwnGroupArray];
        }else {
            //刷新表
            if ([btnName isEqualToString:KHHMessageDefaultGroupAll] || [btnName isEqualToString:[NSString string]]) {
                self.generalArray = [[KHHDataNew sharedData] cardsOfAll];
            }else if([btnName isEqualToString:KHHMessageDefaultGroupUnGroup]){
                self.generalArray = [[KHHDataNew sharedData] cardsOfUngrouped];
            }else if([btnName isEqualToString:@"竞争对手"]){
                self.generalArray = [[KHHDataNew sharedData] cardsOfCompetitors];            
            }else if([btnName isEqualToString:KHHMessageDefaultGroupLocal]){
                if ([KHHUser shareInstance].isAddMobPhoneGroup) {
                    self.isAddressBookData = YES;
                    self.floatBarVC.isContactCellClick = YES;
                    NSArray *addressArr = [KHHAddressBook getAddressBookData];
                        self.generalArray = addressArr;
                    }
            }
        }
        
//        //bug 1176 需求改成一次只能选择一个
//        if (self.isNormalSearchBar) {
//            self.selectedItemArr = [self mutilyFlagForSelected];
//        }
        
//        UIEdgeInsets insets = {0,0,0,25};
//        [btn setBackgroundImage:[[UIImage imageNamed:@"left_btn_bg_selected.png"] resizableImageWithCapInsets:insets] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_bigTable reloadData];
        
        //导航条文字更改(直接设置self.navigationController.title值是有了，界面就是显示不出来)
        self.title = btn.titleLabel.text;
    }else if(!_isNormalSearchBar){
        //不是选择拜访客户时才显示
        _type = KUIActionSheetStyleEditGroupMember;
        
        if ([self isOWnGroupSelected:indexPath]) {
            UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                  delegate:self
                                                         cancelButtonTitle:NSLocalizedString(KHHMessageCancle,nil)
                                                    destructiveButtonTitle:nil
                                                         otherButtonTitles:nil, nil];
            
            [actSheet addButtonWithTitle:NSLocalizedString(KHHMessageAddGroupMember, nil)];
            [actSheet addButtonWithTitle:NSLocalizedString(KHHMessageDeleteGroupMember, nil)];
            [actSheet addButtonWithTitle:NSLocalizedString(KHHMessageModifyGroup, nil)];
            [actSheet addButtonWithTitle:NSLocalizedString(KHHMessageDeleteGroup, nil)];
            [actSheet showInView:self.view];
        }
    }
}

- (void)dataArrayRefresh
{
    if ([self isOWnGroupSelected:_lastIndexPath]) {
        //调用接口，获得self.ownGroupArray
       // self.currentTag = btn.tag;
        [self updateOwnGroupArray];
    }else {
        //刷新表
        if (_lastIndexPath.row == 0) {
            self.generalArray = [[KHHDataNew sharedData] cardsOfAll];
        }else if(_lastIndexPath.row == 1){
            self.generalArray = [[KHHDataNew sharedData] cardsOfUngrouped];
        }else if(_lastIndexPath.row == 2){
            self.generalArray = [[KHHDataNew sharedData] cardsOfCompetitors];
        }
    }
    [_bigTable reloadData];
}

//返回是否要刷新 _bigTable
- (BOOL)updateOwnGroupArray{
    
    Group *group = [self.oWnGroupArray objectAtIndex:self.currentIndexPath.row];
    self.generalArray = [group.cards sortedArrayUsingDescriptors:[Card defaultSortDescriptors]];    
    return YES;
}
#pragma mark -
#pragma mark synBtnClick
- (void)synBtnClick:(id)sender
{
    NSLog(@"start syn");
    [self observeNotificationName:nDataSyncAllSucceeded selector:@"handleDataSyncAllSucceeded:"];
    [self observeNotificationName:nDataSyncAllFailed selector:@"handleDataSyncAllFailed:"];
    KHHAppDelegate *app = (KHHAppDelegate *)[UIApplication sharedApplication].delegate;
    MBProgressHUD *hudp = [MBProgressHUD showHUDAddedTo:app.window animated:YES];
    hudp.labelText = KHHMessageSyncAll;
    //[self.dataControl startSyncAllData];
}
- (void)handleDataSyncAllSucceeded:(NSNotification *)noti{
    [self stopObservingStartSynAllData];
    DLog(@"handleDataSyncAllSucceeded! ====== noti is %@",noti.userInfo);
}
- (void)handleDataSyncAllFailed:(NSNotification *)noti{
    [self stopObservingStartSynAllData];
    DLog(@"handleDataSyncAllFailed! ====== noti is %@",noti.userInfo);
}
- (void)stopObservingStartSynAllData{
    
    [self stopObservingNotificationName:nDataSyncAllSucceeded];
    [self stopObservingNotificationName:nDataSyncAllFailed];
    KHHAppDelegate *app = (KHHAppDelegate *)[UIApplication sharedApplication].delegate;
    [MBProgressHUD hideHUDForView:app.window animated:YES];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_type == KUIActionSheetStyleEditGroupMember) {
        self.oWnGroupArray = [[KHHDataNew sharedData] allTopLevelGroups];
        Group *group = [self.oWnGroupArray objectAtIndex:self.currentTag - 100 - self.baseNum];
        KHHAddGroupMemberVC *addMemVC = [[KHHAddGroupMemberVC alloc] initWithNibName:@"KHHAddGroupMemberVC" bundle:nil];
        addMemVC.group = group;
        addMemVC.homeVC = self;
        addMemVC.moveSuccess = ^(){
            [self updateOwnGroupArray];
            [_bigTable reloadData];
        };
        self.isNeedReloadTable = YES;
        if (buttonIndex == 1) {
            self.isNeedReloadTable = YES;
            addMemVC.isAdd = YES;
            //addMemVC.handleArray = self.allArray;
        }else if(buttonIndex == 2){
            self.isNeedReloadTable = YES;
            addMemVC.isAdd = NO;
            addMemVC.handleArray = self.generalArray;
        }else if (buttonIndex == 3){
            //修改组名
            myAlertView *alert = [[myAlertView alloc] initWithTitle:@"修改组名" message:nil delegate:self style:kMyAlertStyleTextField cancelButtonTitle:KHHMessageSure otherButtonTitles:KHHMessageCancle];
            _titleStr = NSLocalizedString(@"修改组名", nil);
            _isAddGroup = NO;
            [alert show];
            return;
        }else if (buttonIndex == 4){
            //删除分组
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"删除", nil)
                                                            message:NSLocalizedString(@"将会删除该组", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(KHHMessageSure, nil) 
                                                  otherButtonTitles:NSLocalizedString(KHHMessageCancle, nil), nil];
            alert.tag = KHHAlertDelete;
            [alert show];
            return;
        
        }else if (buttonIndex == 0){
            return;
        }
        [self.navigationController pushViewController:addMemVC animated:YES];
    }else if (_type == KUIActionSheetStyleUpload){//暂时直接跳转到编辑界面了，这个地方不会执行。
        if (buttonIndex == 2) {
            //拍摄名片;
            [self takePhotos];
        }else if (buttonIndex == 3){
            //选择名片;
        }else if (buttonIndex == 0){
            //手动制作;
//            self.isNeedReloadTable = YES;
//            Edit_eCardViewController *creatCardVC = [[Edit_eCardViewController alloc] initWithNibName:nil bundle:nil];
//            creatCardVC.type = KCardViewControllerTypeNewCreate;
//            [self.navigationController pushViewController:creatCardVC animated:YES];
        }else if (buttonIndex == 1){
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
//    [actSheet addButtonWithTitle:NSLocalizedString(@"手动制作", nil)];
    //[actSheet addButtonWithTitle:NSLocalizedString(@"导入手机通讯录", nil)];
    //[actSheet showInView:self.view];
    
    self.isNeedReloadTable = YES;
//    Edit_eCardViewController *creatCardVC = [[Edit_eCardViewController alloc] initWithNibName:nil bundle:nil];
//    creatCardVC.type = KCardViewControllerTypeNewCreate;
    KHHNewEdit_ecardViewController *creatCardVC = [[KHHNewEdit_ecardViewController alloc]init];
    creatCardVC.addCardSuccess = ^(){
       // generalArray = [[KHHDataNew sharedData] cardsOfUngrouped];
        generalArray = [[KHHDataNew sharedData] cardsOfAll];
        [_bigTable reloadData];
    };
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
    //把原本的按钮隐藏，显示系统默认的按钮
    for (UIButton *btn in controller.searchBar.subviews) {
        if (btn.tag == 1111 || btn.tag == 2222) {
            btn.hidden = YES;
        }
    }
    
    //标记正在搜索YES
    if ([controller.searchBar isKindOfClass:[KHHMySearchBar class]]) {
        KHHMySearchBar *mySearchBar = (KHHMySearchBar *) controller.searchBar;
        mySearchBar.isSearching = YES;
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
    
    //标记正在搜索NO
    if ([controller.searchBar isKindOfClass:[KHHMySearchBar class]]) {
        KHHMySearchBar *mySearchBar = (KHHMySearchBar *) controller.searchBar;
        mySearchBar.isSearching = NO;
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
   _titleStr = NSLocalizedString(@"新建分组", nil) ;
   _alert = [[myAlertView alloc] initWithTitle:_titleStr
                                       message:nil
                                      delegate:self
                                         style:kMyAlertStyleTextField
                             cancelButtonTitle:NSLocalizedString(KHHMessageSure, nil)
                             otherButtonTitles:NSLocalizedString(KHHMessageCancle,nil)];
    _isAddGroup = YES;
    [_alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //是添加分组的alert
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    if (alertView.tag == KHHAlertMessage||alertView.tag == KHHAlertContact) {
        return;
    }
    
    if ([alertView isMemberOfClass:[myAlertView class]]) {
        if (buttonIndex == 0) {
            for (UIView *view in alertView.subviews) {
                if ([view isKindOfClass:[UITextField class]]) {
                    UITextField *tf = (UITextField *)view;
                    if (tf.text.length > 0 && _isAddGroup) {
                        //[_btnTitleArr addObject:tf.text];
//                        if (!self.myCardArray || self.myCardArray.count <= 0) {
//                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:KhhMessageDataErrorTitle
//                                                                            message:KhhMessageDataError
//                                                                           delegate:self
//                                                                  cancelButtonTitle:KHHMessageSure
//                                                                  otherButtonTitles:KHHMessageCancle, nil];
//                            alert.tag = KHHAlertSync;
//                            [alert show];
//                            return;
//                        }
                        if ([self isInGroupNameDefault:tf.text]||[Group objectByKey:@"name" value:tf.text createIfNone:NO]) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"不能创建同名分组"
                                                                            message:nil
                                                                           delegate:self
                                                                  cancelButtonTitle:@"确定"
                                                                  otherButtonTitles:nil];
                             [alert show];
                            return;
                        }
//                        //注册新建分组消息
//                        [self observeNotificationName:KHHUICreateGroupSucceeded selector:@"handleCreateGroupSucceeded:"];
//                        [self observeNotificationName:KHHUICreateGroupFailed selector:@"handleCreateGroupFailed:"];
                        
                        //同步，从新调用自定义的所有分组，然后再刷新表
                        [self showHudForNetWorkWarn:KHHMessageCreatingGroup];
//                        self.groupTf = tf;
//                        self.interGroup.name = tf.text;
                        IGroup *groupPro = [[IGroup alloc]init];
                        groupPro.name = tf.text;
                        //todo cardId;
                        [[KHHDataNew sharedData] doAddGroup:groupPro userCardID:0 delegate:self];
                        //[_btnTable reloadData];
                        //[_btnTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_btnTitleArr count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                        
                    }else{
                        //修改组名，
                        if (tf.text == nil) {
                            return;
                        }

                        if ([self isInGroupNameDefault:tf.text]||[Group objectByKey:@"name" value:tf.text createIfNone:NO]) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分组不能重名"
                                                                            message:nil
                                                                           delegate:self
                                                                  cancelButtonTitle:@"确定"
                                                                  otherButtonTitles:nil];
                            [alert show];
                            return;
                        }

                        // 注册修改分组名消息
//                        [self observeNotificationName:KHHUIUpdateGroupSucceeded selector:@"handleUpdateGroupSucceeded:"];
//                        [self observeNotificationName:KHHUIUpdateGroupFailed selector:@"handleUpdateGroupFailed:"];            

                        [self showHudForNetWorkWarn:KHHMessageModifingGroup];
                        Group *groupPro = [self.oWnGroupArray objectAtIndex:self.currentIndexPath.row - self.baseNum];
                        //groupPro.name = tf.text;
                        IGroup *group = [[IGroup alloc]init];
                        group.id = groupPro.id;
                        NSLog(@"%@",group.id);
                        group.name = tf.text;
                        if ([groupPro.cardsSet count]>0) {
                            group.cardID = ((Card *)[[groupPro.cardsSet allObjects]objectAtIndex:0]).id;
                        }
                        if (groupPro.parent) {
                            group.parentID = groupPro.parent.id;
                        }
                        [[KHHDataNew sharedData]doUpdateGroupName:group delegate:self];
//                        self.groupTf = tf;
//                        Group *group = ;
//                        self.interGroup.id = group.id;
//                        self.interGroup.name = tf.text;
//                        MyCard *card = [self.myCardArray objectAtIndex:0];
//                        self.interGroup.cardID = card.id;
//                       [self.dataControl updateGroup:self.interGroup];
                    }
                }
            }
        }
    }else if(KHHAlertDelete == alertView.tag){
        if (0 == buttonIndex) {
            //自己添加的删除完以后，就不可删除
//            if (_btnTitleArr.count < self.baseNum + 1) {
//                return;
//            }
            //注册删除分组的消息
//            [self observeNotificationName:KHHUIDeleteGroupSucceeded selector:@"handleDeleteGroupSucceeded:"];
//            [self observeNotificationName:KHHUIDeleteGroupFailed selector:@"handleDeleteGroupFailed:"];
//            [self showHudForNetWorkWarn:KHHMessageDeletingGroup];
           // self.oWnGroupArray = [self.dataControl allTopLevelGroups];
            Group *group = [self.oWnGroupArray objectAtIndex:currentIndexPath.row - self.baseNum];
            [self showHudForNetWorkWarn:KHHMessageDeletingGroup];
            [[KHHDataNew sharedData] doDeleteGroup:group.idValue delegate:self];
           // [self.dataControl deleteGroup:group];
            //[_btnTitleArr removeObjectAtIndex:_currentBtn.tag - 100];
            //[_btnTable reloadData];
        }
    }else if(KHHAlertSync == alertView.tag) {
        if (0 == buttonIndex) {
            //同步数据
            [self synBtnClick:nil];
        }
    }
}

- (Boolean)isInGroupNameDefault:(NSString *)name{
    NSArray *arrPro =[NSArray arrayWithObjects:@"所有",@"未分组",@"同事",@"手机",nil];
    for (NSString *strPro in arrPro) {
        if([name isEqualToString:strPro]){
            return YES;
        }
    }
    return NO;
}

#pragma mark - handleGroup
//创建组
- (void)handleCreateGroupSucceeded:(NSNotification *)info{
    DLog(@"handleCreateGroupSucceeded! info is ====== %@",info);
    [self stopObservingForCreatGroup];
    //[_btnTitleArr addObject:self.groupTf.text];
    [self refreshAllGroups];
    [_btnTable reloadData];
    [_btnTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_btnTitleArr count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [self netWorkWarnForHandleGroup:[NSString stringWithFormat:@"%@%@",KHHMessageCreateGroup,KHHMessageSucceed]];
    
}
- (void)handleCreateGroupFailed:(NSNotification *)info{
    DLog(@"handleCreateGroupFailed! info is ====== %@",info);
    [self stopObservingForCreatGroup];
    [self netWorkWarnForHandleGroup:[NSString stringWithFormat:@"%@%@",KHHMessageCreateGroup,KHHMessageFailed]];

}
//删除组
- (void)handleDeleteGroupSucceeded:(NSNotification *)info{
    DLog(@"handleDeleteGroupSucceeded! info is ====== %@",info);
    [self stopObservingForDelGroup];
    [self netWorkWarnForHandleGroup:[NSString stringWithFormat:@"%@%@",KHHMessageDeleteGroup,KHHMessageSucceed]];
    [_btnTitleArr removeObjectAtIndex:_currentBtn.tag - 100];
    [_btnTable reloadData];
    self.generalArray = nil;
    [self reloadTable];

}
- (void)handleDeleteGroupFailed:(NSNotification *)info{
    DLog(@"handleDeleteGroupFailed! info is ====== %@",info);
    [self stopObservingForDelGroup];
     [self netWorkWarnForHandleGroup:[NSString stringWithFormat:@"%@%@",KHHMessageDeleteGroup,KHHMessageFailed]];

}
//修改组
- (void)handleUpdateGroupSucceeded:(NSNotification *)info{
    DLog(@"handleUpdateGroupSucceeded! info is ====== %@",info);
    [self stopObservingForUpdateGroup];
    [self netWorkWarnForHandleGroup:[NSString stringWithFormat:@"%@%@",KHHMessageModifyGroup,KHHMessageSucceed]];
    [_btnTitleArr replaceObjectAtIndex:_currentBtn.tag - 100 withObject:self.groupTf.text];
    [_currentBtn setTitle:self.groupTf.text forState:UIControlStateNormal];
    

}
- (void)handleUpdateGroupFailed:(NSNotification *)info{
    DLog(@"handleUpdateGroupFailed! info is ====== %@",info);
    [self stopObservingForUpdateGroup];
    [self netWorkWarnForHandleGroup:[NSString stringWithFormat:@"%@%@",KHHMessageModifyGroup,KHHMessageFailed]];
    

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
- (void)showHudForNetWorkWarn:(NSString *) message{
    KHHAppDelegate *app = (KHHAppDelegate *)[UIApplication sharedApplication].delegate;
    self.hud = [MBProgressHUD showHUDAddedTo:app.window animated:YES];
    if (message) {
        self.hud.labelText = message;
    }

}
#pragma mark - test
- (void)testAction:(id)sender {
    DLog(@"[II] testAction");
    [self.navigationController pushViewController:[[KHHMyDetailController alloc] init] animated:YES];
}

#pragma mark - delegate group

- (void)addGroupForUISuccess
{
    [self refreshAllGroups];
    [_hud hide:YES];
    [_btnTable reloadData];
   // [_btnTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_btnTitleArr count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    NSLog(@"%d",[_btnTitleArr count] );
    [self cellBtnClick:((KHHButtonCell *)[_btnTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[_btnTitleArr count] - ([KHHUser shareInstance].isAddMobPhoneGroup?2:1) inSection:0]]).button];
}

- (void)addGroupForUIFailed:(NSDictionary *) dict
{
    [_hud hide:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"创建分组失败"
                                                    message:dict[kInfoKeyErrorMessage]
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)deleteGroupForUISuccess
{
    [self refreshAllGroups];
    [_hud hide:YES];
    [_btnTable reloadData];
    [self cellBtnClick:((KHHButtonCell *)[_btnTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentIndexPath.row-1 inSection:0]]).button];
}

- (void)deleteGroupForUIFailed:(NSDictionary *)dict
{
    [_hud hide:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除分组失败"
                                                    message:dict[kInfoKeyErrorMessage]
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)updateGroupNameForUISuccess
{
    [self refreshAllGroups];
    [_hud hide:YES];
    [_btnTable reloadData];
}

- (void)updateGroupNameForUIFailed:(NSDictionary *)dict
{
    [_hud hide:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"修改组名失败"
                                                    message:dict[kInfoKeyErrorMessage]
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
