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
#import "KHHImageTrans.h"
#import "UIButton+WebCache.h"

#import "Group.h"
//#import "Group+ui.h"

#import <MessageUI/MessageUI.h>

#define POPDismiss [self.popover dismissPopoverAnimated:YES];
typedef enum {
    KHHTableIndexGroup = 100,
    KHHTableIndexClient = 101
} KHHTableIndexType;

@interface KHHHomeViewController ()<KHHFloatBarControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate,
                                   UITextFieldDelegate,UISearchBarDelegate,UISearchDisplayDelegate,
                                   KHHMySearchBarDelegate,MFMessageComposeViewControllerDelegate>
@property (nonatomic, strong) WEPopoverController *popover;
@property (strong, nonatomic)  NSArray *keys;
@property (strong, nonatomic)  KHHAppDelegate *app;
@property (strong, nonatomic)  myAlertView *alert;
@property (strong, nonatomic)  NSString    *titleStr;
@property (strong, nonatomic)  NSArray *resultArray;
@property (strong, nonatomic)  NSArray *searchArray;
@end

@implementation KHHHomeViewController
@synthesize btnTitleArr = _btnTitleArr;
@synthesize lastBtnTag = _lastBtnTag;
@synthesize btnTable = _btnTable;
@synthesize btnArray = _btnArray;
@synthesize isShowData = _isShowData;
@synthesize type = _type;
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.rightBtn setTitle:@"kity" forState:UIControlStateNormal];
        //self.navigationItem.leftBarButtonItem = nil;
        self.leftBtn.hidden = YES;
    }
    return self;
}
- (void)dealloc {
    self.popover = nil;
}

- (void)rightBarButtonClick:(id)sender
{
    [self.navigationController pushViewController:[[KHHMyDetailController alloc] init] animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithRed:241 green:238 blue:232 alpha:1.0]];
    [_bigTable setBackgroundColor:[UIColor clearColor]];
    _btnTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
      UIImage *bgimg = [[UIImage imageNamed:@"leftbtn_bg.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1];
//    UIImageView *bgimgView = [[UIImageView alloc] initWithImage:bgimg];
//    [_btnTable setBackgroundView:bgimgView];
      _imgview.image = bgimg;
    
    UIBarButtonItem *searchBarItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchBar];
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:nil];
    [self.toolBar setItems:[NSArray arrayWithObjects:searchBarItem, addButtonItem, nil] animated:YES];
    KHHFloatBarController *floatBarVC = [[KHHFloatBarController alloc] initWithNibName:nil bundle:nil];
    floatBarVC.delegate = self;
    self.popover = [[WEPopoverController alloc] initWithContentViewController:floatBarVC];
    _btnTitleArr = [[NSMutableArray alloc] initWithObjects:@"全部",@"new",@"同事",@"拜访",@"重点",@"已发送",@"未分组", nil];
    _btnArray = [[NSMutableArray alloc] initWithCapacity:0];
    _isShowData = YES;
    NSIndexPath *index = [NSIndexPath indexPathForRow:-1 inSection:0];
    _lastIndexPath = index;
    KHHMySearchBar *mySearchBar = [[KHHMySearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44) simple:_isNormalSearchBar];
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
    mySearchBar.delegateKHH = self;
    [self.view addSubview:mySearchBar];
    UISearchDisplayController *disCtrl = [[UISearchDisplayController alloc] initWithSearchBar:mySearchBar contentsController:self];
    disCtrl.delegate = self;
    disCtrl.searchResultsDataSource = self;
    disCtrl.searchResultsDelegate = self;
    _searCtrl = disCtrl;
    
    //默认选中哪个按钮
    //cell是nil;
    [self performSelector:@selector(defaultSelectBtn) withObject:nil afterDelay:1];

    //添加一个长按动作（bigtable）
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFunc:)];
    longPress.numberOfTouchesRequired = 1;
    //longPress.numberOfTapsRequired = 1;
    //longPress.minimumPressDuration = 1;
    longPress.allowableMovement = NO;
    [_bigTable addGestureRecognizer:longPress];
    
    //搜索结果
    _resultArray = [[NSArray alloc] init];
    _searchArray = [[NSArray alloc] initWithObjects:@"孙悟空",@"孙悟空",@"孙悟空",@"孙悟空",@"孙悟空",@"孙悟空",@"孙悟空", nil];
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_isNormalSearchBar) {
        
    }else{
        [KHHShowHideTabBar showTabbar];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[KHHShowHideTabBar hideTabbar];
    
}
- (void)defaultSelectBtn
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    KHHButtonCell *cell = (KHHButtonCell *)[_btnTable cellForRowAtIndexPath:indexPath];
   [self performSelector:@selector(cellBtnClick:) withObject:cell.button afterDelay:0.1];
}
- (void)cancelBtnClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - KHHFloatBarControllerDelegate
- (void)BtnTagValueChanged:(NSInteger)index
{
    
    if (index == 0) {
        UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:@"选择号码" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        _type = KUIActionSheetStylePhone;
        //一个电话号码直接拨
        [actSheet addButtonWithTitle:@"15077358653"];
        //[actSheet addButtonWithTitle:@""];
        [actSheet showInView:self.view];
         POPDismiss;
    }else if (index == 1){
        UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:@"选择号码" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        _type = KUIActionSheetStyleMessage;
        [actSheet addButtonWithTitle:@"15033759865"];
        //[actSheet addButtonWithTitle:@""];
        [actSheet showInView:self.view];
        POPDismiss;
    }else if (index == 2){
        //拍照
        [self takePhotos];
        POPDismiss;
    }else if (index == 3){
        //定位
        MapController *mapVC = [[MapController alloc] initWithNibName:nil bundle:nil];
        mapVC.companyAddr = @"浙江滨江区南环路4280号元光德大厦501室";
        mapVC.companyName = @"浙江金汉弘";
        [self.navigationController pushViewController:mapVC animated:YES];
        POPDismiss;

    }else if (index == 4){
        KHHVisitRecoardVC *newVisVC = [[KHHVisitRecoardVC alloc] initWithNibName:nil bundle:nil];
        newVisVC.style = KVisitRecoardVCStyleNewBuild;
        newVisVC.isNeedWarn = YES;
        [self.navigationController pushViewController:newVisVC animated:YES];
        POPDismiss;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    if (tableView == self.searCtrl.searchResultsTableView) {
        return [_resultArray count];
    }else{
        NSInteger tableTag = tableView.tag;
        return (tableTag == KHHTableIndexGroup?_btnTitleArr.count:(tableTag == KHHTableIndexClient)?20:0);
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
                    DLog(@"new cell create!!======%@",indexPath);
                    cell = [[[NSBundle mainBundle] loadNibNamed:cellId
                                                          owner:self
                                                        options:nil] objectAtIndex:0];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else
                    DLog(@"recell!!========%@",indexPath);
                cell.button.tag = indexPath.row + 100;
                [cell.button setTitle:[_btnTitleArr objectAtIndex:indexPath.row] forState:UIControlStateNormal];
                [cell.button addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                if (indexPath.row != _lastIndexPath.row) {
                    [cell.button setBackgroundImage:[[UIImage imageNamed:@"leftbtn_bg.png"]stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
                    [cell.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }else{
                    [cell.button setBackgroundImage:[[UIImage imageNamed:@"left_btn_bgscrol.png"]stretchableImageWithLeftCapWidth:2 topCapHeight:1] forState:UIControlStateNormal];
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
                [cell.logoBtn setImageWithURL:[NSURL URLWithString:@"http://farm6.static.flickr.com/5094/5464787611_642ee9280d_m.jpg"]
                             placeholderImage:[UIImage imageNamed:@"logopic.png"]
                                      success:^(UIImage *image, BOOL cached){
                                          if(CGSizeEqualToSize(image.size, CGSizeZero)){
                                              //imageView.image = [UIImage imageNamed:@"logopic2.png"];
                                              [cell.logoBtn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                                          }
                                      }
                                      failure:^(NSError *error){
                                          //imageView.image = [UIImage imageNamed:@"logopic2.png"];
                                          [cell.logoBtn setBackgroundImage:[UIImage imageNamed:@"logopic.png"] forState:UIControlStateNormal];
                                      }];
                
                if (_isNormalSearchBar) {
                    
                }else{
                    [cell.logoBtn addTarget:self action:@selector(logoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                }
                return cell;
                break;
            }
        }
  }

    return nil;
}
//点击图片弹出横框
- (void)logoBtnClick:(id)sender
{
    
    UIButton *btn = (UIButton *)sender;
    KHHClientCellLNPCC *cell = (KHHClientCellLNPCC *)[[btn superview] superview];
    CGRect cellRect = btn.frame;
    cellRect.origin.x = 98;
    CGRect rect = [cell convertRect:cellRect toView:self.view];
    rect.size.height = 45;
    //DLog(@"[II] logo = %@, frame = %@, converted frame = %@", cell.logoView, NSStringFromCGRect(cell.logoView.frame), NSStringFromCGRect(rect));
    UIPopoverArrowDirection arrowDirection = rect.origin.y < self.view.bounds.size.height/2?UIPopoverArrowDirectionUp:UIPopoverArrowDirectionDown;
    [self.popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:arrowDirection animated:YES];
}
//长按弹出横框
- (void)longPressFunc:(id)sender
{
    if (!_isNormalSearchBar) {
        if ([(UILongPressGestureRecognizer *)sender state] == UIGestureRecognizerStateBegan) {
            CGPoint p = [(UILongPressGestureRecognizer *)sender locationInView:_bigTable];
            DLog(@"p.x:%f=======p.y:%f",p.x,p.y);
            NSIndexPath *indexPath = [_bigTable indexPathForRowAtPoint:p];
            DLog(@"indexPath:%@",indexPath);
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
        //[lastBtn setBackgroundImage:[[[UIImage imageNamed:@""] transformHalf] stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];
        [lastBtn setBackgroundImage:[[UIImage imageNamed:@"leftbtn_bg.png"]stretchableImageWithLeftCapWidth:0 topCapHeight:0] forState:UIControlStateNormal];

        [lastBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _isShowData = YES;
    }else {
        _isShowData = NO;
    }
    _lastIndexPath = indexPath;
    _currentBtn = btn;
    
    if (_isShowData) {
        //刷新表
        switch (btn.tag) {
            case 100:
                DLog(@"100 btn 数据源刷新");
                break;
            case 101:
                DLog(@"101 btn 数据源刷新");
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
            default:
                break;
        }
        //DLog(@"刷新表");
        [btn setBackgroundImage:[[UIImage imageNamed:@"left_btn_bgscrol.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:1] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }else{
//        UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        _type = KUIActionSheetStyleEditGroupMember;
//        [actSheet addButtonWithTitle:@"添加组员"];
//        [actSheet addButtonWithTitle:@"移出组员"];
        if (btn.tag >= 107) {
            UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            [actSheet addButtonWithTitle:@"添加组员"];
            [actSheet addButtonWithTitle:@"移出组员"];
            [actSheet addButtonWithTitle:@"修改组名"];
            [actSheet addButtonWithTitle:@"删除分组"];
            [actSheet showInView:self.view];
        }
        
    }
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (_type == KUIActionSheetStyleEditGroupMember) {
        KHHAddGroupMemberVC *addMemVC = [[KHHAddGroupMemberVC alloc] initWithNibName:@"KHHAddGroupMemberVC" bundle:nil];
        if (buttonIndex == 1) {
            addMemVC.isAdd = YES;
        }else if(buttonIndex == 2){
            addMemVC.isAdd = NO;
        }else if (buttonIndex == 3){
            //修改组名
//            myAlertView *alert = [[myAlertView alloc] initWithTitle:@"修改组名" message:nil delegate:self style:kMyAlertStyleTextField cancelButtonTitle:@"确定" otherButtonTitles:@"取消"];
            _titleStr = @"修改组名";
            _isAddGroup = NO;
            _isDelGroup = NO;
            [_alert show];
            return;
        }else if (buttonIndex == 4){
            //删除分组
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"删除" message:@"将会删除该组" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            _isDelGroup = YES;
            [alert show];
            return;
        
        }else if (buttonIndex == 0){
            return;
        }
        [self.navigationController pushViewController:addMemVC animated:YES];
    }else if (_type == KUIActionSheetStylePhone){
        if (buttonIndex == 0) {
            return;
        }
        NSString *phone = [actionSheet buttonTitleAtIndex:buttonIndex];
        NSString *urlSting = [NSString stringWithFormat:@"tel://%@",phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlSting]];
    }else if (_type == KUIActionSheetStyleMessage){
        if (buttonIndex == 0) {
            return;
        }
       // NSString *phone = [actionSheet buttonTitleAtIndex:buttonIndex];
        Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
        if (messageClass != nil) {
            if ([messageClass canSendText]) {
                MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc] init];
                NSString *receiver = [actionSheet buttonTitleAtIndex:buttonIndex];
                messageVC.recipients = [NSArray arrayWithObject:receiver];
                messageVC.messageComposeDelegate = self;
                [self presentModalViewController:messageVC animated:YES];
            }else{
                DLog(@"不支持发送短信");
                // 不支持发送短信;
            }
        }else{
            //系统版本过低，只有ios4.0以上才支持程序内发送短信;
        }
    }else if (_type == KUIActionSheetStyleUpload){
        if (buttonIndex == 0) {
           
        }else if (buttonIndex == 1){
            //拍摄名片;
        }else if (buttonIndex == 2){
            //选择名片;
        }else if (buttonIndex == 3){
            //手动制作;
        }else if (buttonIndex == 4){
            //备份手机通讯录;
        }
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultSent:
            break;
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultFailed:
            break;
        default:
            break;
    }
    [self dismissModalViewControllerAnimated:YES];


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
    UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:@"选择上传方式" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    _type = KUIActionSheetStyleUpload;
    [actSheet addButtonWithTitle:@"拍摄名片"];
    [actSheet addButtonWithTitle:@"选择名片"];
    [actSheet addButtonWithTitle:@"手动制作"];
    [actSheet addButtonWithTitle:@"备份手机通讯录"];
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
                KHHClientCellLNPCC *cell = (KHHClientCellLNPCC*)[tableView cellForRowAtIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                DetailInfoViewController *detailVC = [[DetailInfoViewController alloc] initWithNibName:nil bundle:nil];
                [self.navigationController pushViewController:detailVC animated:YES];
            }
            break;
        }
    }
}

#pragma mark - KHHMySearchBarDelegate
- (void)KHHMySearchBarBtnClick:(NSInteger)tag
{
    if (tag == 1111) {
        DLog(@"1111");
    }else if (tag == 2222){
        DLog(@"开始同步");
    }
}

#pragma mark - UISearchDisplayDelegate
// when we start/end showing the search UI
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {

    for (UIButton *btn in controller.searchBar.subviews) {
        if (btn.tag == 1111 || btn.tag == 2222) {
            btn.hidden = YES;
        }
    }
    [controller.searchBar setBackgroundImage:[[UIImage imageNamed:@"searchbar_bg_normal.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1]];
}
    
- (void) searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller {
    
}
- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    for (UIButton *btn in controller.searchBar.subviews) {
        if (btn.tag == 1111 || btn.tag == 2222) {
            btn.hidden = NO;
        }
    }
    if (!_isNormalSearchBar) {
        [controller.searchBar setBackgroundImage:[[UIImage imageNamed:@"searchbarbg.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1]];
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
    _titleStr = @"新建分组";
   _alert = [[myAlertView alloc] initWithTitle:_titleStr message:nil delegate:self style:kMyAlertStyleTextField cancelButtonTitle:@"确定" otherButtonTitles:@"取消"];
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
                    
//                    NSManagedObjectContext *appcontext = [(KHHAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
//                    Group *group = [Group createGroup:appcontext];
//                    group.name = tf.text;
//                    if ([Group saveGroup:group]) {
//                        DLog(@"success save group!!");
//                    }
                    
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
//- (IBAction)cancelBtnClick:(id)sender
//{
//
//}

#pragma mark - test
- (void)testAction:(id)sender {
    DLog(@"[II] testAction");
    [self.navigationController pushViewController:[[KHHMyDetailController alloc] init] animated:YES];
}
@end