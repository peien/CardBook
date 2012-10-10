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
#import "KHHData+UI.h"

#import "Group.h"
#import "KHHCardMode.h"
#import "Image.h"
#import "Card.h"

#import <MessageUI/MessageUI.h>

#define POPDismiss [self.popover dismissPopoverAnimated:YES];
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.navigationItem.leftBarButtonItem = nil;
        self.leftBtn.hidden = YES;
        //*****************
        self.dataControl = [KHHData sharedData];
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
    [_btnTable setBackgroundView:bgimgView];
      _imgview.image = bgimg;
    
    UIBarButtonItem *searchBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchBar];
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:nil];
    [self.toolBar setItems:[NSArray arrayWithObjects:searchBarItem, addButtonItem, nil] animated:YES];
    
    self.floatBarVC = [[KHHFloatBarController alloc] initWithNibName:nil bundle:nil];
    self.floatBarVC.viewController = self;
    self.popover = [[WEPopoverController alloc] initWithContentViewController:floatBarVC];
    self.floatBarVC.popover = self.popover;
    
    _btnTitleArr = [[NSMutableArray alloc] initWithObjects:@"全部",@"new",@"同事",@"已发送",@"重点",@"未分组",@"手机", nil];
    _btnArray = [[NSMutableArray alloc] initWithCapacity:0];
    _isShowData = YES;
    NSIndexPath *index = [NSIndexPath indexPathForRow:-1 inSection:0];
    _lastIndexPath = index;
    KHHMySearchBar *mySearchBar = [[KHHMySearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44) simple:_isNormalSearchBar];
    [mySearchBar.synBtn addTarget:self action:@selector(synBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [mySearchBar.takePhoto addTarget:self action:@selector(takePhotoClick:) forControlEvents:UIControlEventTouchUpInside];
    if (_isNormalSearchBar) {
        _smallBtn.hidden = YES;
        self.rightBtn.hidden = YES;
        CGRect Rect = _smalImageView.frame;
        Rect.size.height = 61;
        _smalImageView.frame = Rect;
        _footView.hidden = NO;
        [_btnForCancel setBackgroundImage:[[UIImage imageNamed:@"tongbu_normal.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:2] forState:UIControlStateNormal];
        
    }
    mySearchBar.delegate = self;
    [self.view addSubview:mySearchBar];
    UISearchDisplayController *disCtrl = [[UISearchDisplayController alloc] initWithSearchBar:mySearchBar contentsController:self];
    disCtrl.delegate = self;
    disCtrl.searchResultsDataSource = self;
    disCtrl.searchResultsDelegate = self;
    _searCtrl = disCtrl;
    
    //默认选中哪个按钮
    //cell是nil;
    [self performSelector:@selector(defaultSelectBtn) withObject:nil afterDelay:0.3];

    //添加一个长按动作（bigtable）
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFunc:)];
    longPress.numberOfTouchesRequired = 1;
    longPress.allowableMovement = NO;
    [_bigTable addGestureRecognizer:longPress];
    
    //初始化界面数据
    [self initViewData];
    //我的详情
    Card *myCard = [self.myCardArray lastObject];
    [self.rightBtn setTitle:NSLocalizedString(myCard.name, nil) forState:UIControlStateNormal];
    
}
// 搜索结果
- (void)searcResult
{
    //搜索结果
    _resultArray = [[NSArray alloc] init];
    NSMutableArray *stringArr = [[NSMutableArray alloc] init];
    for (int i = 0; i< self.generalArray.count; i++) {
        KHHCardMode *card = [self.generalArray objectAtIndex:i];
        [stringArr addObject:card.name];
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
    self.allArray = [self.dataControl allReceivedCards];
    self.generalArray = allArray;
    self.myCardArray = [self.dataControl allMyCards];
}
- (void)reloadTable
{
    if (self.currentTag == 105) {
        self.generalArray = [self.dataControl allPrivateCards];
    }else if (self.currentTag == 100){
        self.generalArray = [self.dataControl allReceivedCards];
    }
    [_bigTable reloadData];
    Card *card = [[self.dataControl allMyCards] lastObject];
    [self.rightBtn setTitle:card.name forState:UIControlStateNormal];
    
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
            return 56;
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
                }else
                    DLog(@"recell!!========%@",indexPath);
                cell.button.tag = indexPath.row + 100;
                [cell.button setTitle:NSLocalizedString([_btnTitleArr objectAtIndex:indexPath.row], nil) forState:UIControlStateNormal];
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
            if (_isNormalSearchBar) {
                //选中某一个对象并返回
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                self.isNeedReloadTable = YES;
                KHHClientCellLNPCC *cell = (KHHClientCellLNPCC*)[tableView cellForRowAtIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                DetailInfoViewController *detailVC = [[DetailInfoViewController alloc] initWithNibName:nil bundle:nil];
                detailVC.card = [self.generalArray objectAtIndex:indexPath.row];
                [self.navigationController pushViewController:detailVC animated:YES];
            }
            break;
        }
    }
    
    if (tableView == self.searCtrl.searchResultsTableView) {
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
- (void)cancelBtnClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
//点击图片弹出横框
- (void)logoBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    KHHClientCellLNPCC *cell = (KHHClientCellLNPCC *)[[btn superview] superview];
    NSIndexPath *indexPath = [_bigTable indexPathForCell:cell];
    self.floatBarVC.card = [self.generalArray objectAtIndex:indexPath.row];
    CGRect cellRect = btn.frame;
    cellRect.origin.x = 98;
    CGRect rect = [cell convertRect:cellRect toView:self.view];
    rect.size.height = 45;
    //DLog(@"[II] logo = %@, frame = %@, converted frame = %@", cell.logoView, NSStringFromCGRect(cell.logoView.frame), NSStringFromCGRect(rect));
    UIPopoverArrowDirection arrowDirection = rect.origin.y < self.view.bounds.size.height/2?UIPopoverArrowDirectionUp:UIPopoverArrowDirectionDown;
    [self.popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:arrowDirection animated:YES];
}
//长按单元格弹出横框
- (void)longPressFunc:(id)sender
{
    if (!_isNormalSearchBar) {
        if ([(UILongPressGestureRecognizer *)sender state] == UIGestureRecognizerStateBegan) {
            CGPoint p = [(UILongPressGestureRecognizer *)sender locationInView:_bigTable];
            DLog(@"p.x:%f=======p.y:%f",p.x,p.y);
            NSIndexPath *indexPath = [_bigTable indexPathForRowAtPoint:p];
            DLog(@"indexPath:%@",indexPath);
            self.floatBarVC.card = [self.generalArray objectAtIndex:indexPath.row];
            KHHClientCellLNPCC *cell = (KHHClientCellLNPCC *)[_bigTable cellForRowAtIndexPath:indexPath];
            CGRect cellRect = cell.logoBtn.frame;
            cellRect.origin.x = 98;
            CGRect rect = [cell convertRect:cellRect toView:self.view];
            rect.size.height = 45;
            //DLog(@"[II] logo = %@, frame = %@, converted frame = %@", cell.logoView, NSStringFromCGRect(cell.logoView.frame), NSStringFromCGRect(rect));
            UIPopoverArrowDirection arrowDirection = rect.origin.y < self.view.bounds.size.height/2?UIPopoverArrowDirectionUp:UIPopoverArrowDirectionDown;
            [self.popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:arrowDirection animated:YES];
        }
    }
}
#pragma mark-
#pragma mark groupBtn Click
- (void)cellBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    DLog(@"btn.tag=======%d",btn.tag);
    KHHButtonCell *cell = (KHHButtonCell *)[[btn superview] superview];
    NSIndexPath *indexPath = [_btnTable indexPathForCell:cell];
    DLog(@"%@",indexPath);
    if (_lastIndexPath.row != indexPath.row) {
        KHHButtonCell *lastCell = (KHHButtonCell *)[_btnTable cellForRowAtIndexPath:_lastIndexPath];
        UIButton *lastBtn = lastCell.button;
        [lastBtn setBackgroundImage:[[UIImage imageNamed:@"left_btn_bg.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 25)] forState:UIControlStateNormal];
        [lastBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _isShowData = YES;
    }else {
        _isShowData = NO;
    }
    _lastIndexPath = indexPath;
    _currentBtn = btn;
    if (btn.tag <= 106) {
        self.isOwnGroup = NO;
    }else{
        self.isOwnGroup = YES;
    }
    if (_isShowData) {
        //刷新表
        switch (btn.tag) {
            case 100:
                //DLog(@"100 btn 数据源刷新");
                self.currentTag = btn.tag;
                self.generalArray = self.allArray;
                break;
            case 101:
                DLog(@"101 btn 数据源刷新");
                self.generalArray = self.ReceNewArray;
                break;
            case 102:
                DLog(@"102 btn 数据源刷新");
                break;
            case 103:
                DLog(@"103 btn 数据源刷新");
                break;
            case 104:
                DLog(@"104 btn 数据源刷新");
                break;
            case 105:
                DLog(@"105 btn 数据源刷新");
                self.currentTag = btn.tag;
                self.privateArr = [self.dataControl allPrivateCards];
                self.generalArray = self.privateArr;
                break;
            case 106:

                break;
            default:
                break;
        }
        //DLog(@"刷新表");
        //当是自定义分组时，把btn的tag用groupid进行设置，再根据tag进行读取各个分组的成员
        if (self.isOwnGroup) {
            //调用接口，获得self.ownGroupArray
            self.generalArray = self.oWnGroupArray;
        }
        UIEdgeInsets insets = {0,0,0,25};
        [btn setBackgroundImage:[[UIImage imageNamed:@"left_btn_bg_selected.png"] resizableImageWithCapInsets:insets] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_bigTable reloadData];
    }else{
        
        _type = KUIActionSheetStyleEditGroupMember;
        if (btn.tag >= 107) {
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
        KHHAddGroupMemberVC *addMemVC = [[KHHAddGroupMemberVC alloc] initWithNibName:@"KHHAddGroupMemberVC" bundle:nil];
        addMemVC.homeVC = self;
        if (buttonIndex == 1) {
            addMemVC.isAdd = YES;
            addMemVC.handleArray = self.allArray;
        }else if(buttonIndex == 2){
            addMemVC.isAdd = NO;
            addMemVC.handleArray = self.generalArray;
        }else if (buttonIndex == 3){
            //修改组名
//            myAlertView *alert = [[myAlertView alloc] initWithTitle:@"修改组名" message:nil delegate:self style:kMyAlertStyleTextField cancelButtonTitle:@"确定" otherButtonTitles:@"取消"];
            _titleStr = NSLocalizedString(@"修改组名", nil);
            _isAddGroup = NO;
            _isDelGroup = NO;
            [_alert show];
            return;
        }else if (buttonIndex == 4){
            //删除分组
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
    }else if (_type == KUIActionSheetStyleUpload){
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
    UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"选择上传方式", nil)
                                                          delegate:self
                                                 cancelButtonTitle:nil
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:nil, nil];
    _type = KUIActionSheetStyleUpload;
    [actSheet addButtonWithTitle:NSLocalizedString(@"拍摄名片", nil)];
    [actSheet addButtonWithTitle:NSLocalizedString(@"选择名片", nil)];
    [actSheet addButtonWithTitle:NSLocalizedString(@"手动制作", nil)];
    [actSheet addButtonWithTitle:NSLocalizedString(@"备份手机通讯录", nil)];
    [actSheet showInView:self.view];
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
    CGRect oldFrame = self.searchBar.frame;
    self.searchBar.frame = CGRectMake(70, oldFrame.origin.y, 250, oldFrame.size.height);

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
                    [_btnTitleArr addObject:tf.text];
                    [_btnTable reloadData];
                    [_btnTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_btnTitleArr count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                    //此时创建一个组，保存到数据库
                    
                }else{
                    //修改组名，
                    if (tf.text == nil) {
                        return;
                    }
                    [_btnTitleArr replaceObjectAtIndex:_currentBtn.tag-100 withObject:tf.text];
                    [_currentBtn setTitle:tf.text forState:UIControlStateNormal];
                }
            }
        }
    }else if(buttonIndex == 0 && _isDelGroup){
        //自己添加的删除完以后，就不可删除
        if (_btnTitleArr.count < 8) {
            return;
        }
        [_btnTitleArr removeObjectAtIndex:_currentBtn.tag - 100];
        [_btnTable reloadData];
    }
    if (buttonIndex == 1) {
        return;
    }
}
#pragma mark - test
- (void)testAction:(id)sender {
    DLog(@"[II] testAction");
    [self.navigationController pushViewController:[[KHHMyDetailController alloc] init] animated:YES];
}
@end
