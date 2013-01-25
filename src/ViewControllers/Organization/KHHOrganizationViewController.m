//
//  KHHOrganizationViewController.m
//  CardBook
//
//  Created by 孙铭 on 8/6/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHOrganizationViewController.h"
#import "KHHMyDetailController.h"
#import "KHHDefaults.h"

#import "KHHClientCellLNPCC.h"
#import "KHHButtonCell.h"

#import "WEPopoverController.h"
#import "KHHFloatBarController.h"

#import "DetailInfoViewController.h"
#import "KHHAddGroupMemberVC.h"
#import "KHHMySearchBar.h"
#import "KHHVisitRecoardVC.h"
#import "KHHAppDelegate.h"
#import "MyTabBarController.h"
#import "KHHShowHideTabBar.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>
#import "KHHAddressBook.h"
#import "KHHClientCellLNPC.h"

#import "KHHClasses.h"
#import "KHHDataAPI.h"
#import "KHHNotifications.h"
#import "SMCheckbox.h"
#import "KHHClasses.h"
#import <MessageUI/MessageUI.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "KHHDataNew+Card.h"

@interface KHHOrganizationViewController ()<UITextFieldDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
@property (nonatomic, strong)  WEPopoverController    *popover;
@property (strong, nonatomic)  NSArray                *keys;
@property (strong, nonatomic)  KHHAppDelegate         *app;
@property (strong, nonatomic)  NSString               *titleStr;
@property (strong, nonatomic)  NSArray                *resultArray;
@property (strong, nonatomic)  NSArray                *searchArray;
@property (strong, nonatomic)  KHHDataNew                *dataControl;
@property (strong, nonatomic)  NSArray                *ReceNewArray;
@property (strong, nonatomic)  NSArray                *myCardArray;
@property (strong, nonatomic)  KHHFloatBarController  *floatBarVC;
@property (assign, nonatomic)  bool                   isNeedReloadTable;
@property (assign, nonatomic)  int                    currentTag;
@property (strong, nonatomic)  NSIndexPath            *currentIndexPath;
@property (strong, nonatomic)  IGroup                 *interGroup;
@property (strong, nonatomic)  UITextField            *groupTf;
@property (strong, nonatomic)  NSArray                *groupTitleArr;
//新名片个数
//@property (strong, nonatomic)  UIImageView            *messageImageView;
//@property (strong, nonatomic)  UILabel                *numLab2;
@property (strong, nonatomic)  KHHDefaults            *myDefaults;

@end

@implementation KHHOrganizationViewController

@synthesize btnTitleArr = _btnTitleArr;
@synthesize lastBtnTag = _lastBtnTag;
@synthesize btnTable = _btnTable;
@synthesize btnArray = _btnArray;
@synthesize isShowData = _isShowData;
@synthesize currentBtn = _currentBtn;
@synthesize dicBtnTttle = _dicBtnTttle;
@synthesize keys = _keys;
@synthesize searCtrl = _searCtrl;
@synthesize lastIndexPath = _lastIndexPath;
@synthesize bigTable = _bigTable;
@synthesize app = _app;
@synthesize btnBackbg = _btnBackbg;
@synthesize btnDic = _btnDic;
@synthesize titleStr = _titleStr;
@synthesize resultArray = _resultArray;
@synthesize searchArray = _searchArray;
@synthesize dataControl;
@synthesize generalArray;
@synthesize ReceNewArray;
@synthesize floatBarVC;
@synthesize oWnGroupArray;
@synthesize myCardArray;
@synthesize isNeedReloadTable;
@synthesize currentTag;
@synthesize currentIndexPath;
@synthesize interGroup;
@synthesize groupTf;
@synthesize groupTitleArr;
@synthesize visitVC;
@synthesize myDefaults;
//@synthesize messageImageView;
//@synthesize numLab2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //分组数据是根据当前登录的人的权限获取其同级和下属部门
        self.interGroup = [[IGroup alloc] init];
        self.dataControl = [KHHDataNew sharedData];
        self.myDefaults = [KHHDefaults sharedDefaults];
        self.rightBtn.hidden = YES;
    }
    return self;
}

- (void)dealloc {
    self.popover = nil;
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
    KHHMySearchBar *mySearchBar = [[KHHMySearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44) simple:YES showSearchBtn:NO];
    //添加自建联系人按钮
//    [mySearchBar.takePhoto addTarget:self action:@selector(takePhotoClick:) forControlEvents:UIControlEventTouchUpInside];
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
}

// 搜索结果 临时搜索
- (void)searcResult
{
    //搜索结果,
    _resultArray = [[NSArray alloc] init];
    NSMutableArray *stringArr = [[NSMutableArray alloc] init];
    for (int i = 0; i< self.generalArray.count; i++) {
        KHHCardMode *card = [self.generalArray objectAtIndex:i];
        if (card.name.length) {
            [stringArr addObject:card.name];
        }
    }
    
    _searchArray = stringArr;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [KHHShowHideTabBar showTabbar];
    if (self.isNeedReloadTable) {
        [self reloadTable];
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self showNewContactsNum];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[KHHShowHideTabBar hideTabbar];
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.popover = nil;
    self.btnTitleArr = nil;
    self.btnArray = nil;
    self.currentBtn = nil;
    self.dicBtnTttle = nil;
    self.keys = nil;
    self.lastIndexPath = nil;
    self.searCtrl = nil;
    self.bigTable = nil;
    self.app = nil;
    self.btnBackbg = nil;
    self.btnDic = nil;
    self.titleStr = nil;
    self.resultArray = nil;
    self.searchArray = nil;
    self.dataControl = nil;
    self.generalArray = nil;
    self.ReceNewArray = nil;
    self.floatBarVC = nil;
    self.oWnGroupArray = nil;
    self.myCardArray = nil;
    self.currentIndexPath = nil;
    self.interGroup = nil;
    self.groupTf = nil;
    self.groupTitleArr = nil;
    self.visitVC = nil;
//    self.messageImageView = nil;
//    self.numLab2 = nil;
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
#warning 取所有同事（按公司组织分）
    self.generalArray = [[KHHDataNew sharedData] cardsOfColleague];
    //我的卡片
    self.myCardArray = [self.dataControl allMyCards];
    if (!self.myCardArray || self.myCardArray.count <= 0) {
        //提示数据未同步完成
        //提示用户数据没有同步下来，先同步一下数据
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:KhhMessageDataErrorTitle
                                                        message:KhhMessageDataErrorNotice
                                                       delegate:nil
                                              cancelButtonTitle:KHHMessageSure
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}
//获取分组
- (NSArray *)getAllGroups{
    _btnTitleArr = [[NSMutableArray alloc] initWithCapacity:5];
#warning 获取当前登录用户下的组织架构,服务器还没做好，就先只添加个同事组
    [_btnTitleArr addObject:@"同事"];
//    self.oWnGroupArray = [self.dataControl allTopLevelGroups];
//    for (int i = 0; i < self.oWnGroupArray.count; i++) {
//        Group *group = [self.oWnGroupArray objectAtIndex:i];
//        [_btnTitleArr addObject:group.name];
//    }
    NSArray *groupArr = _btnTitleArr;
    return groupArr;

}
- (void)reloadTable
{
    BOOL isNeedRefresh = YES;
    isNeedRefresh = [self updateOwnGroupArray];
        
    if (isNeedRefresh) {
        [_bigTable reloadData];
    }
}
//显示联系人个数
//- (void)showNewContactsNum{
//    
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    KHHButtonCell *cell = (KHHButtonCell *)[_btnTable cellForRowAtIndexPath:indexPath];
//    if (self.messageImageView == nil) {
//        self.messageImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"message_bg.png"]stretchableImageWithLeftCapWidth:0 topCapHeight:0]];
//        self.messageImageView.frame = CGRectMake(40, -8, 35, 35);
//        //self.messageImageView.backgroundColor = [UIColor grayColor];
//        numLab2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, 35, 35)];
//        numLab2.backgroundColor = [UIColor clearColor];
//        numLab2.font = [UIFont systemFontOfSize:10];
//        numLab2.textColor = [UIColor whiteColor];
//        numLab2.textAlignment = UITextAlignmentCenter;
//        [self.messageImageView addSubview:numLab2];
//        [cell.button addSubview:self.messageImageView];
//    }
//    int num = [self.dataControl cardsOfNew].count;
//    if (num > 0) {
//        self.messageImageView.hidden = NO;
//        numLab2.text = [NSString stringWithFormat:@"%d",num];
//    }else if (num == 0){
//        self.messageImageView.hidden = YES;
//    }
//}
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
                    cell.backgroundColor = [UIColor clearColor];
                }
                cell.button.tag = indexPath.row + 100;
                cell.button.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
                cell.button.titleLabel.numberOfLines = 2;
                [cell.button setTitle:NSLocalizedString([self.groupTitleArr objectAtIndex:indexPath.row], nil) forState:UIControlStateNormal];
                [cell.button addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                UIEdgeInsets insets = {0, 0, 45, 25};
                if (indexPath.row != _lastIndexPath.row) {
                    [cell.button setBackgroundImage:[[UIImage imageNamed:@"left_btn_bg.png"] resizableImageWithCapInsets:insets] forState:UIControlStateNormal];
                    [cell.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }else{
                    [cell.button setBackgroundImage:[[UIImage imageNamed:@"left_btn_bg.png"] resizableImageWithCapInsets:insets] forState:UIControlStateNormal];
                    [cell.button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                }
                
                //添加名片个数
//                int num = [[self.dataControl cardsOfNew] count];
//                if (indexPath.row == 0 && num > 0) {
//                    [cell.button addSubview:self.messageImageView];
//                }
                return cell;
                break;
            }
            case KHHTableIndexClient: {
                
                cellId = NSStringFromClass([KHHClientCellLNPCC class]);
                KHHClientCellLNPCC *cell = nil;
                cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:cellId
                                                          owner:self
                                                        options:nil] objectAtIndex:0];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                //从网络获取头像
                if ([[self.generalArray objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]]) {
                    DLog(@"self.generalArray 应该是card 类型，但是却是字典类型，所以挂掉了");
                    //return nil;
                }
                Card *card = [self.generalArray objectAtIndex:indexPath.row];
                UIImage *imgNor = [UIImage imageNamed:@"logopic.png"];
                //同事不可能为新的
                cell.newicon.hidden = YES;
                
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
                
                [cell.logoBtn addTarget:self action:@selector(logoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                //填充单元格数据
                cell.nameLabel.text = card.name;
                cell.positionLabel.text = card.title;
                //都是同事，公司名就不显示了，改成显示手机
//                cell.companyLabel.text = card.company.name;
                cell.companyLabel.text = card.mobilePhone;
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
            self.isNeedReloadTable = YES;
            KHHClientCellLNPCC *cell = (KHHClientCellLNPCC*)[tableView cellForRowAtIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            DetailInfoViewController *detailVC = [[DetailInfoViewController alloc] initWithNibName:nil bundle:nil];
            
            Card *card = (Card *)[self.generalArray objectAtIndex:indexPath.row];
            detailVC.card = card;
            if ([card isKindOfClass:[ReceivedCard class]]){
                ReceivedCard *receCard = (ReceivedCard *)card;
                if (!receCard.isReadValue) {
                    [[KHHDataNew sharedData] markIsRead:receCard];
                }
            }
            [self.navigationController pushViewController:detailVC animated:YES];
        }
            break;
    }
    
    if (tableView == self.searCtrl.searchResultsTableView) {
       UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        for (Card *card in self.generalArray) {
            if ([cell.textLabel.text isEqualToString:card.name]) {
                self.searCtrl.active = NO;
                DetailInfoViewController *detailVC = [[DetailInfoViewController alloc] initWithNibName:nil bundle:nil];
                detailVC.card = card;
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
#pragma mark groupBtn Click
- (void)cellBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSString *btnName = btn.titleLabel.text;
    DLog(@"cellBtn.tag=======%d,name = %@",btn.tag,btnName);
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
    
    if (_isShowData) {
        //DLog(@"刷新表");
        //当是自定义分组时，把btn的tag用groupid进行设置，再根据tag进行读取各个分组的成员//(每个分组有cards属性)
        //调用接口，获得self.ownGroupArray
        self.currentTag = btn.tag;
        [self updateOwnGroupArray];
//        UIEdgeInsets insets = {0,0,0,25};
//        [btn setBackgroundImage:[[UIImage imageNamed:@"left_btn_bg_selected.png"] resizableImageWithCapInsets:insets] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_bigTable reloadData];
        
        //导航条文字更改(直接设置self.navigationController.title值是有了，界面就是显示不出来)
        self.title = btn.titleLabel.text;
//        self.title = @"1234564789";
    }
}

//返回是否要刷新 _bigTable
- (BOOL)updateOwnGroupArray{
#warning 服务器那边没做好，这里只能获取所有同事，没有具体分组，就先返回个NO
    return NO;
    
    
    int index = self.currentIndexPath.row;
    self.oWnGroupArray = [self.dataControl allTopLevelGroups];
    if (!self.oWnGroupArray) {
        //默认选择第一个
        [self performSelector:@selector(defaultSelectBtn) withObject:nil afterDelay:0.3];
        return NO;
    }
    
    //如果当前index 大于等于
    if (index >= self.oWnGroupArray.count) {
        index = self.oWnGroupArray.count - 1;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        KHHButtonCell *cell = (KHHButtonCell *)[_btnTable cellForRowAtIndexPath:indexPath];
        [self performSelector:@selector(cellBtnClick:) withObject:cell.button afterDelay:0.1];
        return NO;
    }
    
    Group *group = [self.oWnGroupArray objectAtIndex:index];
    self.generalArray = [group.cards sortedArrayUsingDescriptors:[Card defaultSortDescriptors]];    
    return YES;
}
#pragma mark -

//搜索栏左侧按钮点击事件
- (void)takePhotoClick:(id)sender
{    
//    self.isNeedReloadTable = YES;
//    Edit_eCardViewController *creatCardVC = [[Edit_eCardViewController alloc] initWithNibName:nil bundle:nil];
//    creatCardVC.type = KCardViewControllerTypeNewCreate;
//    [self.navigationController pushViewController:creatCardVC animated:YES];
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
@end
