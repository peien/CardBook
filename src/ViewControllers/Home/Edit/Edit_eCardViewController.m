//
//  Edit_eCardViewController.m
//  CardBook
//
//  Created by 王国辉 on 12-8-14.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "Edit_eCardViewController.h"
#import "Edit_eCardViewCell.h"
#import "EditCardPersonCell.h"
#import "PickViewController.h"
#import "XLPageControl.h"
#import "KHHAppDelegate.h"
#import "NSString+Validation.h"
#import "KHHFrameCardView.h"
#import "KHHAddressCell.h"
#import "TSLocateView.h"
#import "KHHShowHideTabBar.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MBProgressHUD.h"
#import "KHHVisualCardViewController.h"
#import "KHHCardTemplageVC.h"

#import "KHHClasses.h"
#import "KHHDataAPI.h"
#import "KHHNotifications.h"
#import "NSString+SM.h"



#define CARD_IMGVIEW_TAG 990
#define CARDMOD_VIEW_TAG 991

#define kBaseTag 2400
#define KBIGADDRESS_TAG 6699

NSString *const kECardSelectTemplateActionName = @"KHHUISelectTeplateAction";

@interface Edit_eCardViewController ()<PickViewControllerDelegate,UIActionSheetDelegate>
@property (strong, nonatomic) XLPageControl *xlPage;
@property (strong, nonatomic) UITextField   *beginEditField;
@property (strong, nonatomic) UILabel       *beginEditLabel;
@property (assign, nonatomic) NSInteger     offset;
@property (assign, nonatomic) NSInteger     indexAll;
@property (strong, nonatomic) NSMutableDictionary *saveInfoDic;
@property (strong, nonatomic) NSString      *strStreet;
@property (strong, nonatomic) NSString      *pc;
@property (strong, nonatomic) NSArray       *placeName;
@property (strong, nonatomic) InterCard     *interCard;
//@property (strong, nonatomic) KHHData       *dataCtrl;
@property (strong, nonatomic) MBProgressHUD *progressHud;
@property (strong, nonatomic) NSString      *province;
@property (strong, nonatomic) NSString      *city;

@end

@implementation Edit_eCardViewController

{
    CGRect rectForKey;
    NSMutableArray *inputsForKeyboard;
    
    
    
    NSMutableArray *section1AddArray;
    NSMutableArray *section2AddArray;
    NSMutableArray *section2HavIn;
    NSMutableArray *section3AddArray;
    NSMutableArray *section3HavIn;
    
    NSMutableDictionary *allFiledForGoto;
    PickViewController *sectionPicker;
}

@synthesize fieldName = _fieldName;
@synthesize fieldValue = _fieldValue;
@synthesize fieldExternOne = _fieldExternOne;
@synthesize fieldExternTwo = _fieldExternTwo;
@synthesize fieldExternThree = _fieldExternThree;
@synthesize oneNums = _oneNums;
@synthesize twoNums = _twoNums;
@synthesize threeNums = _threeNums;
@synthesize pickView = _pickView;
@synthesize whichexternIndex = _whichexternIndex;
@synthesize scroller = _scroller;
@synthesize pageCtrl = _pageCtrl;
@synthesize fieldValueDic = _fieldValueDic;
@synthesize editLab = _editLab;
@synthesize xlPage;
@synthesize beginEditField;
@synthesize beginEditLabel;
@synthesize glCard = _glCard;
@synthesize offset = _offset;
@synthesize indexAll = _indexAll;
@synthesize saveInfoDic;
@synthesize type;
@synthesize strStreet;
@synthesize pc;
@synthesize placeName;
@synthesize interCard;
//@synthesize dataCtrl;
@synthesize progressHud;
@synthesize cardTemp;
@synthesize province;
@synthesize city;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.rightBtn setTitle:NSLocalizedString(KHHMessageSave, nil) forState:UIControlStateNormal];
        self.interCard = [[InterCard alloc] init];
       // self.dataCtrl = [KHHData sharedData];
        _table = [[KHHInputTableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _table.delegate = self;
        _table.dataSource = self;
        _table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _table.hiddenDelgate = self;
        
        [self initArrs];
    }
    return self;
}

- (void)initArrs
{
    section1AddArray = [[NSMutableArray alloc]initWithObjects:@"手机",@"电话",@"传真",@"邮箱", nil];
    section2AddArray = [[NSMutableArray alloc]initWithObjects:@"部门",@"公司邮箱",nil];
    section2HavIn = [[NSMutableArray alloc]initWithCapacity:2];
    section3AddArray = [[NSMutableArray alloc]initWithObjects:@"网页",@"QQ",@"MSN",@"旺旺",@"业务范围",@"银行信息",@"其它信息",nil];
    section3HavIn = [[NSMutableArray alloc]initWithCapacity:7];
    allFiledForGoto = [[NSMutableDictionary alloc]initWithCapacity:15];
}
#pragma mark -
#pragma mark saveCardInfo
//save card info
- (void)rightBarButtonClick:(id)sender
{
    //注册修改card 或 创建card消息
    [self observeNotificationName:KHHUIModifyCardSucceeded selector:@"handleModifyCardSucceeded"];
    [self observeNotificationName:KHHUIModifyCardFailed selector:@"handleModifyCardFailed:"];
    [self observeNotificationName:KHHUICreateCardSucceeded selector:@"handleCreateCardSucceeded:"];
    [self observeNotificationName:KHHUICreateCardFailed selector:@"handleCreateCardFailed:"];
    [self saveCardInfo];
}
#pragma mark - Handle Modify or Create Card Message
- (void)handleModifyCardSucceeded
{
    DLog(@"ModifyCardSucceeded");
    [self stopobservingFor];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)handleModifyCardFailed:(NSNotification *)noti
{
    DLog(@"ModifyCardFailed! noti = %@", noti);
    [self stopobservingFor];
    [self warnAlertMessage:KHHMessageModifyFailed];
}
- (void)handleCreateCardSucceeded:(NSNotification *)noti
{
    DLog(@"CreateCardSucceeded");
    [self stopobservingFor];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)handleCreateCardFailed:(NSNotification *)info
{
    [self stopobservingFor];
    DLog(@"CreateCardFailed");
    
    //设置消息
    NSString *message = nil;
    if ([[info.userInfo objectForKey:@"errorCode"]intValue] == KHHErrorCodeConnectionOffline){
        message = KHHMessageNetworkEorror;
    }
    
    //设置标题
    NSString *title = nil;
    if (self.type == KCardViewControllerTypeNewCreate) {
        title = KHHMessageCreateCardFailed;
    }else {
        title = KHHMessageModifyCardFailed;
    }
    
    //提示没有收到新名片
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:KHHMessageSure
                                          otherButtonTitles:nil, nil];
    [alert show];
}
- (void)stopobservingFor{
    [self stopObservingNotificationName:KHHUIModifyCardSucceeded];
    [self stopObservingNotificationName:KHHUIModifyCardFailed];
    [self stopObservingNotificationName:KHHUICreateCardSucceeded];
    [self stopObservingNotificationName:KHHUICreateCardFailed];
    self.progressHud.hidden = YES ;
    
}
#pragma mark -
#pragma mark UIViewController Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:241 green:238 blue:232 alpha:1.0];
    if (self.type == KCardViewControllerTypeNewCreate) {
        self.title = @"新建名片";
    }else if (self.type == KCardViewControllerTypeShowInfo){
        self.title = @"详细信息";
    }
    
    _table.frame =  CGRectMake(0, 0, 320, self.view.bounds.size.height-44);
    [self.view addSubview:_table];
    [self addImg];
    [self initVCData];
    _table.editing = YES;
}

- (void)addImg
{
    if (!self.glCard) {
        if (!self.cardTemp) {
            self.cardTemp = [CardTemplate objectByID:@(KHH_Default_CardTemplate_ID) createIfNone:NO];
        }
        
        UIView *viewf = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 220)];
        UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 180)];
        imgview.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoTemplagesVC:)];
        tapp.numberOfTapsRequired = 1;
        tapp.numberOfTouchesRequired = 1;
        [imgview addGestureRecognizer:tapp];
        [imgview setImageWithURL:[NSURL URLWithString:self.cardTemp.bgImage.url] placeholderImage:nil];
        [viewf addSubview:imgview];
        _table.tableHeaderView = viewf;
    }else{
        
        [KHHShowHideTabBar hideTabbar];
        KHHFrameCardView *cardView = [[KHHFrameCardView alloc] initWithFrame:CGRectMake(0, 0, 320, 220) delegate:self isVer:NO callbackAction:kECardSelectTemplateActionName];
        cardView.isOnePage = YES;
        cardView.card = self.glCard;
        [cardView showView];
        _table.tableHeaderView = cardView;
    }

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //card为空时换模板时用图片代替
       
    //注册切换模板的广播接受器
    [self observeNotificationName:kECardSelectTemplateActionName selector:@"gotoTemplagesVC:"];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //停止广播
    [self stopObservingNotificationName:kECardSelectTemplateActionName];
}
#pragma mark - ScrollerDelegateMothed
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_scroller]) {
        CGFloat scrollWidth = scrollView.frame.size.width;
        int page = ((scrollView.contentOffset.x-scrollWidth/2)/scrollWidth)+1;
        XLPageControl *pageCtrl = (XLPageControl *)[self.view viewWithTag:118];
        pageCtrl.currentPage = page;
    }
}
- (void)gotoTemplagesVC:(UITapGestureRecognizer *)sender{
    KHHCardTemplageVC *temVC = [[KHHCardTemplageVC alloc] initWithNibName:nil bundle:nil];
    temVC.editCardVC = self;
    [self.navigationController pushViewController:temVC animated:YES];
}

//构造表需要的数据
- (void)initVCData
{
    
    _oneNums = 5;
    _twoNums = 4;
    _threeNums = 1;
    
    _fieldName = [NSArray arrayWithObjects:[NSMutableArray arrayWithObjects:@"手机",@"电话",@"传真",@"邮箱", nil],
                  [NSMutableArray arrayWithObjects:@"公司",@"地址",@"邮编", nil],
                  [NSMutableArray arrayWithObjects:@"网页",@"QQ",@"MSN",@"旺旺",@"业务范围",@"银行信息",@"其它信息", nil],
                  [NSMutableArray arrayWithObjects:@"公司邮箱", nil],
                  nil];
    self.placeName = [NSArray arrayWithObjects:[NSMutableArray arrayWithObjects:@"请输入手机号",@"请输入电话号码",@"请输入传真",@"请输入邮箱",nil],
                      [NSMutableArray arrayWithObjects:@"请输入公司名称",@"请输入详细地址",@"请输入邮编", nil],
                      [NSMutableArray arrayWithObjects:@"请输入姓名",@"请输入职位",@"请输入分组", nil],
                      
                      nil];
    
    _fieldValue = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",nil];
    _fieldExternOne = [[NSMutableArray alloc] initWithCapacity:0];
    _fieldExternTwo = [[NSMutableArray alloc] initWithCapacity:0];
    _fieldExternThree = [[NSMutableArray alloc] initWithCapacity:0];
    _fieldValueDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.saveInfoDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    // 显示信息
    [self updateFieldValue];
}

- (void)updateFieldValue
{
    // 获得卡片，判断卡片相应的属性是否有直，如果有直，就分别添加到 _fieldValue 或是扩展数组
    if (_glCard.name.length > 0) {
        [_fieldValue replaceObjectAtIndex:0 withObject:_glCard.name];
    }
    //工作
    
    if (_glCard.title.length > 0) {
        [_fieldValue replaceObjectAtIndex:1 withObject:_glCard.title];
    }
    
    // 分组
    
    
    //手机，电话，传真，邮箱有多个，默认显示第一个
    
    NSArray *mobiels = [_glCard.mobilePhone componentsSeparatedByString:KHH_SEPARATOR];
    for (int i = 0; i<mobiels.count; i++) {
        if (i == 0) {
            [_fieldValue replaceObjectAtIndex:3 withObject:[mobiels objectAtIndex:0]];
        }else{
            [_fieldExternOne addObject:[NSDictionary dictionaryWithObjectsAndKeys:[mobiels objectAtIndex:i],@"value",@"手机",@"key", nil]];
        }
    }
    
    NSArray *tels = [_glCard.telephone componentsSeparatedByString:KHH_SEPARATOR];
    for (int i = 0; i<tels.count; i++) {
        if (i == 0) {
            [_fieldValue replaceObjectAtIndex:4 withObject:[tels objectAtIndex:0]];
        }else{
            [_fieldExternOne addObject:[NSDictionary dictionaryWithObjectsAndKeys:[tels objectAtIndex:i],@"value",@"电话",@"key", nil]];
        }
    }
    
    NSArray *faxs = [_glCard.fax componentsSeparatedByString:KHH_SEPARATOR];
    for (int i = 0; i<faxs.count; i++) {
        if (i == 0) {
            [_fieldValue replaceObjectAtIndex:5 withObject:[faxs objectAtIndex:0]];
        }else{
            [_fieldExternOne addObject:[NSDictionary dictionaryWithObjectsAndKeys:[faxs objectAtIndex:i],@"value",@"传真",@"key", nil]];
        }
    }
    
    NSArray *mails = [_glCard.email componentsSeparatedByString:KHH_SEPARATOR];
    for (int i = 0; i<mails.count; i++) {
        if (i == 0) {
            [_fieldValue replaceObjectAtIndex:6 withObject:[mails objectAtIndex:0]];
        }else{
            [_fieldExternOne addObject:[NSDictionary dictionaryWithObjectsAndKeys:[mails objectAtIndex:i],@"value",@"邮箱",@"key", nil]];
        }
    }
    
    if (_glCard.company.name.length > 0) {
        [_fieldValue replaceObjectAtIndex:7 withObject:_glCard.company.name];
    }
    
    if (self.type == KCardViewControllerTypeNewCreate || _glCard.address.province == nil) {
        NSString *allAddress = KhhMessageAddressEditNotice;
        [_fieldValue replaceObjectAtIndex:8 withObject:allAddress];
    }
    if (_glCard.address.province.length > 0 || _glCard.address.province.length > 0 || _glCard.address.other.length > 0) {
        //赋给临时变量
        self.province = _glCard.address.province;
        self.city = _glCard.address.city;
        NSString *o = [NSString stringByFilterNilFromString:_glCard.address.other];
        [self updateAddressInFeildValue:o];
    }
    
    if (_glCard.address.zip.length > 0) {
        [_fieldValue replaceObjectAtIndex:9 withObject:_glCard.address.zip];
    }
    
    if (_glCard.department.length > 0) {
        [_fieldExternTwo addObject:[NSDictionary dictionaryWithObjectsAndKeys:_glCard.department,@"value",@"部门",@"key", nil]];
    }
    if (_glCard.company.email.length) {
        [_fieldExternTwo addObject:[NSDictionary dictionaryWithObjectsAndKeys:_glCard.company.email,@"value",@"公司邮箱",@"key", nil]];
    }
    //银行信息
    if (_glCard.bankAccount.bank.length > 0 || _glCard.bankAccount.branch.length > 0) {
        if (_glCard.bankAccount.bank == nil) {
            _glCard.bankAccount.bank = @"";
        }
        NSString *bankName = [NSString stringWithFormat:@"%@%@",_glCard.bankAccount.bank,_glCard.bankAccount.branch];
        [_fieldExternThree addObject:[NSDictionary dictionaryWithObjectsAndKeys:bankName,@"value",@"开户行",@"key", nil]];
    }
    
    if (_glCard.bankAccount.number.length > 0) {
        [_fieldExternThree addObject:[NSDictionary dictionaryWithObjectsAndKeys:_glCard.bankAccount.number,@"value",@"银行帐号",@"key", nil]];
    }
    if (_glCard.bankAccount.name.length > 0) {
        [_fieldExternThree addObject:[NSDictionary dictionaryWithObjectsAndKeys:_glCard.bankAccount.name,@"value",@"户名",@"key", nil]];
    }
    
    if (_glCard.web.length > 0) {
        [_fieldExternThree addObject:[NSDictionary dictionaryWithObjectsAndKeys:_glCard.web,@"value",@"网页",@"key", nil]];
    }
    if (_glCard.qq.length > 0) {
        [_fieldExternThree addObject:[NSDictionary dictionaryWithObjectsAndKeys:_glCard.qq,@"value",@"QQ",@"key", nil]];
    }
    if (_glCard.msn.length > 0) {
        [_fieldExternThree addObject:[NSDictionary dictionaryWithObjectsAndKeys:_glCard.msn, @"value", @"MSN",@"key",nil]];
    }
    if (_glCard.aliWangWang.length > 0) {
        [_fieldExternThree addObject:[NSDictionary dictionaryWithObjectsAndKeys:_glCard.aliWangWang,@"value",@"旺旺",@"key", nil]];
    }
    if (_glCard.businessScope.length > 0) {
        [_fieldExternThree addObject:[NSDictionary dictionaryWithObjectsAndKeys:_glCard.businessScope,@"value",@"业务范围",@"key", nil]];
    }
    //其他信息
    if (_glCard.moreInfo.length > 0) {
        [_fieldExternThree addObject:[NSDictionary dictionaryWithObjectsAndKeys:_glCard.moreInfo,@"value",@"其它信息",@"key", nil]];
    }
    
    _oneNums = 5 + _fieldExternOne.count;
    _twoNums = 4 + _fieldExternTwo.count;
    _threeNums = 1 + _fieldExternThree.count;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _table = nil;
    _fieldName = nil;
    _fieldValue = nil;
    _fieldExternOne = nil;
    _fieldExternTwo = nil;
    _fieldExternThree = nil;
    _pickView = nil;
    _fieldValueDic = nil;
    _editLab = nil;
    self.xlPage = nil;
    self.beginEditLabel = nil;
    self.beginEditField = nil;
    _glCard = nil;
    self.saveInfoDic = nil;
    self.pc = nil;
    self.strStreet = nil;
    self.placeName = nil;
    self.interCard = nil;
   // self.dataCtrl = nil;
    self.progressHud = nil;
    self.cardTemp = nil;
}
#pragma mark -
#pragma mark UITableView Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
        case 1:
           // return [[_fieldName objectAtIndex:0] count]+_oneNums+1;
            return _oneNums;
        case 2:
            return _twoNums;
//             == [[_fieldName objectAtIndex:1] count] + [[_fieldName objectAtIndex:3] count]+1 ?_twoNums-1:_twoNums;
            break;
        case 3:
            return _threeNums == [[_fieldName objectAtIndex:2] count]+1 + 2?_threeNums-1:_threeNums;
        case 4:
            return 1;
        default:
            break;
    }
    return 0;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        //头像
        return 60;
    }else if (indexPath.section == 2 && indexPath.row == 1)
    {
        //地址编辑框
        return 70;
    }
    return 44;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIDZero = @"cellIDZero";
    static NSString *cellIDOne = @"cellIDOne";
    static NSString *cellIDTwo = @"cellIDTwo";
    static NSString *cellIDLast = @"cellIDLast";
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            EditCardPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDZero];
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Edit_eCardViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.nameValue.tag = kBaseTag + 0;
            cell.jobValue.tag =  kBaseTag + 1;
            [self addFiled:cell.nameValue];
            [self addFiled:cell.jobValue];
            cell.nameValue.text = [_fieldValue objectAtIndex:0];
            cell.nameValue.delegate = self;
            cell.jobValue.text = [_fieldValue objectAtIndex:1];
            cell.nameValue.placeholder = [[self.placeName objectAtIndex:2] objectAtIndex:0];
            cell.jobValue.placeholder = [[self.placeName objectAtIndex:2] objectAtIndex:1];
           // cell.jobValue.keyboardType
            cell.jobValue.delegate = self;
            [cell.iconImg setImageWithURL:[NSURL URLWithString:_glCard.logo.url] placeholderImage:[UIImage imageNamed:@"logopic.png"]];
            ////            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapIconImage:)];
            //            tap.numberOfTapsRequired = 1;
            //            tap.numberOfTouchesRequired = 1;
            //            [cell.iconImg addGestureRecognizer:tap];
            CGRect rect = cell.frame;
            rect.origin.x -= 100;
            cell.frame = rect;
            return cell;
        }else if (indexPath.row == 1){
            //编辑分组的cell
            //            Edit_eCardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDZero];
            //            if (cell == nil) {
            //                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Edit_eCardViewCell" owner:self options:nil];
            //                cell = [nib objectAtIndex:1];
            //                cell.name.text = @"分组";
            //                cell.value.tag = kBaseTag + 2;
            //                cell.value.enabled = NO;
            //                cell.value.text = [_fieldValue objectAtIndex:2];
            //                cell.value.placeholder = [[self.placeName objectAtIndex:2] objectAtIndex:2];
            //                UIButton *accessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            //                [accessBtn addTarget:self action:@selector(accessBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            //                accessBtn.frame = CGRectMake(270, 5, 35, 35);
            //                [accessBtn setBackgroundImage:[UIImage imageNamed:@"accessBtnico.png"] forState:UIControlStateNormal];
            //                [cell addSubview:accessBtn];
            //            }
            //            return cell;
        }
    }else if (indexPath.section == 1){
        Edit_eCardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDOne];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Edit_eCardViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:1];
        }
        if (indexPath.row < 4) {
            cell.name.text = [[_fieldName objectAtIndex:0] objectAtIndex:indexPath.row];
            cell.value.tag = indexPath.row + kBaseTag + 100;
            [self addFiled:cell.value];
            cell.value.text = [_fieldValue objectAtIndex:3 + indexPath.row];
            cell.value.delegate = self;
            cell.value.placeholder = [[self.placeName objectAtIndex:0] objectAtIndex:indexPath.row];
            
        }else if (indexPath.row == _oneNums-1)
        {
            cell.name.text = @"添加";
            cell.value.tag = kBaseTag - 1;
            cell.value.enabled = NO;
        }
        else if (indexPath.row >= 4 && indexPath.row < _oneNums-1){
            cell.name.text = [[_fieldExternOne objectAtIndex:indexPath.row - 4] objectForKey:@"key"];
            cell.value.text = [[_fieldExternOne objectAtIndex:indexPath.row - 4] objectForKey:@"value"];
            cell.value.tag = indexPath.row + kBaseTag + 100;
            NSLog(@"cell.tag%d",cell.value.tag);
            [self addFiled:cell.value];
            cell.value.placeholder = [NSString stringWithFormat:@"请输入%@",cell.name.text];
            cell.value.delegate = self;
        }
        return cell;
        
    }else if (indexPath.section == 2){
        if (indexPath.row != 1) {
            Edit_eCardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDOne];
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Edit_eCardViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:1];
            }
            if (indexPath.row < 3) {
                cell.name.text = [[_fieldName objectAtIndex:1] objectAtIndex:indexPath.row];
                cell.value.tag = indexPath.row + 200  + kBaseTag;
                
                [self addFiled:cell.value];
                cell.value.text = [_fieldValue objectAtIndex:7 + indexPath.row];
                cell.value.placeholder = [[self.placeName objectAtIndex:1] objectAtIndex:indexPath.row];
            }else if (indexPath.row == _twoNums-1&& [[self havInForPicker:section2AddArray inViewStrs:section2HavIn] count]!=0){
                cell.name.text = @"添加";
                cell.value.enabled = NO;
                cell.value.tag = kBaseTag -1;
            }else if (indexPath.row >= 3 && indexPath.row < _twoNums - 1&& [[self havInForPicker:section2AddArray inViewStrs:section2HavIn] count]!=0){
                cell.name.text = [[_fieldExternTwo objectAtIndex:indexPath.row - 3] objectForKey:@"key"];
                cell.value.text = [[_fieldExternTwo objectAtIndex:indexPath.row - 3] objectForKey:@"value"];
                cell.value.tag = indexPath.row + kBaseTag + 200 ;
                cell.value.placeholder = [NSString stringWithFormat:@"请输入%@",cell.name.text];
                [self addFiled:cell.value];
            }else if ([[self havInForPicker:section2AddArray inViewStrs:section2HavIn] count]==0){
                cell.name.text = [[_fieldExternTwo objectAtIndex:indexPath.row - 3] objectForKey:@"key"];
                cell.value.text = [[_fieldExternTwo objectAtIndex:indexPath.row - 3] objectForKey:@"value"];
                cell.value.tag = indexPath.row + kBaseTag + 200 ;
                cell.value.placeholder = [NSString stringWithFormat:@"请输入%@",cell.name.text];
                [self addFiled:cell.value];
            }
            return cell;
        }
        
        if (indexPath.row == 1) {
            KHHAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDTwo];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"Edit_eCardViewCell" owner:self options:nil] objectAtIndex:2];
            }
            [cell.bigAdress addTarget:self action:@selector(selectProvinceCity:) forControlEvents:UIControlEventTouchUpInside];
            cell.bigAdress.adjustsImageWhenDisabled = NO;
            cell.bigAdress.adjustsImageWhenHighlighted = NO;
            cell.bigAdress.tag = KBIGADDRESS_TAG;
            [cell.bigAdress setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            if (self.type == KCardViewControllerTypeNewCreate || _glCard.address.province == nil) {
                [cell.bigAdress setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }
            cell.detailAdress.tag = indexPath.row + 200 + kBaseTag;
            [self addFiled:cell.detailAdress];
            if (self.glCard.address.other.length > 0 || self.province.length > 0) {
                if (self.province.length > 0) {
                    NSString *p = [NSString stringByFilterNilFromString:self.province];
                    NSString *c = [NSString stringByFilterNilFromString:self.city];
                    [cell.bigAdress setTitle:[NSString stringWithFormat:@"%@ %@",p,c] forState:UIControlStateNormal];
                }else {
                    [cell.bigAdress setTitle:KhhMessageAddressEditNotice forState:UIControlStateNormal];
                }
                
                cell.detailAdress.text = [NSString stringByFilterNilFromString:self.glCard.address.other];
            }
            return cell;
        }
        
        
    }else if (indexPath.section == 3){
        Edit_eCardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDLast];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Edit_eCardViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:1];
            
        }
        if (indexPath.row >= 0 && indexPath.row < _threeNums -1) {
            cell.name.text = [[_fieldExternThree objectAtIndex:indexPath.row] objectForKey:@"key"];
            cell.value.tag = indexPath.row + kBaseTag + 300 + _fieldExternOne.count + _fieldExternTwo.count;
            cell.value.text = [[_fieldExternThree objectAtIndex:indexPath.row] objectForKey:@"value"];
            cell.value.placeholder = [NSString stringWithFormat:@"请输入%@",cell.name.text];
            [self addFiled:cell.value];
            
        }else if (indexPath.row == _threeNums-1){
            cell.name.text = @"添加更多";
            cell.value.tag = kBaseTag - 1;
            cell.value.enabled = NO;
        }
        return cell;
    }
    return nil;
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (indexPath.row == _oneNums-1) {
            return UITableViewCellEditingStyleInsert;
        }else if (indexPath.row >3 && indexPath.row < _oneNums-1){
            return UITableViewCellEditingStyleDelete;
        }
    }else if (indexPath.section == 2){
        if ([[self havInForPicker:section2AddArray inViewStrs:section2HavIn] count]!=0&& indexPath.row == _twoNums-1) {
            return UITableViewCellEditingStyleInsert;
        }else if([[self havInForPicker:section2AddArray inViewStrs:section2HavIn] count]==0&&indexPath.row == _twoNums-1){
            return UITableViewCellEditingStyleDelete;
        }else if (indexPath.row > 2){
            return UITableViewCellEditingStyleDelete;
        }
    }else if (indexPath.section == 3){
        if ([[self havInForPicker:section3AddArray inViewStrs:section3HavIn] count]!=0&& indexPath.row == _threeNums-1) {
            return UITableViewCellEditingStyleInsert;
        }else if([[self havInForPicker:section3AddArray inViewStrs:section3HavIn] count]==0&&indexPath.row == _threeNums-1){
            return UITableViewCellEditingStyleDelete;
        }else{
            return UITableViewCellEditingStyleDelete;
        }
    }
    return UITableViewCellEditingStyleNone;
    
}

- (NSMutableArray *)havInForPicker:(NSArray *)all inViewStrs:(NSArray *)inViewStrs
{
    NSMutableArray *arrPro = [[NSMutableArray alloc]initWithCapacity:10];
    [all enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        for (NSString * str in inViewStrs) {
            if ([str isEqualToString:(NSString *)obj]) {
                return;
            }
        }
        [arrPro addObject:obj];
    }];
    return arrPro;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (editingStyle == UITableViewCellEditingStyleInsert ) {
        
        sectionPicker = [[PickViewController alloc]initWithNibName:nil bundle:nil];
        
        switch (indexPath.section ) {
            case 1:
                _whichexternIndex = 0;
                sectionPicker.PickFlag = 1;
                sectionPicker.tempArray = section1AddArray;
                sectionPicker.delegate = self;
                break;
            case 2:
                _whichexternIndex = 1;
                sectionPicker.PickFlag = 1;
                sectionPicker.tempArray = [self havInForPicker:section2AddArray inViewStrs:section2HavIn];
                sectionPicker.delegate = self;
                break;
            case 3:
                _whichexternIndex = 2;
                sectionPicker.PickFlag = 1;
                sectionPicker.tempArray = [self havInForPicker:section3AddArray inViewStrs:section3HavIn];
                sectionPicker.delegate = self;
                break;
            default:
                break;
        }
        [self.navigationController pushViewController:sectionPicker animated:YES];
        
        
    }else if (editingStyle == UITableViewCellEditingStyleDelete){
        //   [self tableAnimationDown];
        bool isreloadTable = NO;
        if (indexPath.section == 1) {
            [_fieldExternOne removeObjectAtIndex:indexPath.row - 4];
            --_oneNums;
            
        }else if (indexPath.section == 2){
            if (_twoNums == [[_fieldName objectAtIndex:1] count] + [[_fieldName objectAtIndex:3] count]+1 ) {
                isreloadTable = YES;
            }
            [_fieldExternTwo removeObjectAtIndex:indexPath.row - 3];
            --_twoNums;
            
        }else if (indexPath.section == 3){
            if (_threeNums == [[_fieldName objectAtIndex:2] count]+1 + 2) {
                isreloadTable = YES;
            }
            --_threeNums;
            [_fieldExternThree removeObjectAtIndex:indexPath.row];
        }
        if (isreloadTable) {
            [tableView reloadData];
        }else{
            [_table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

#pragma mark -
- (void)selectProvinceCity:(id)sender
{
    TSLocateView *locateView = [[TSLocateView alloc] initWithTitle:@"定位城市" delegate:self];
    [locateView showInView:self.view];
    
}
//编辑头像
- (void)tapIconImage:(UITapGestureRecognizer *)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"不可编辑" delegate:nil cancelButtonTitle:KHHMessageSure otherButtonTitles:nil, nil];
    [alert show];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }else if (buttonIndex == 1){
        DLog(@"select city:");
        TSLocateView *locateView = (TSLocateView *)actionSheet;
        TSLocation *location = locateView.locate;
        NSLog(@"province:%@ city:%@ lat:%f lon:%f", location.state,location.city, location.latitude, location.longitude);
        self.province = location.state;
        self.city = location.city;
        UIButton *btn = (UIButton *)[self.view viewWithTag:KBIGADDRESS_TAG];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        NSString *addStr = [NSString stringWithFormat:@"%@ %@",location.state,location.city];
        [btn setTitle:addStr forState:UIControlStateNormal];
        //把记录的值换成新
        [self updateAddressInFeildValue:nil];
    }
    
}

//更新地址
-(void) updateAddressInFeildValue:(NSString *) detailAddress {
    if (!_fieldValue) {
        return;
    }
    NSString * newAddress = nil;
    NSString * oldAddress = [_fieldValue objectAtIndex:8];
    NSArray *addressArr = [oldAddress componentsSeparatedByString:KHH_SEPARATOR];
    if (addressArr.count == 2 && !detailAddress) {
        detailAddress = [addressArr objectAtIndex:1];
    }
    newAddress = [NSString stringWithFormat:@"%@ %@%@%@",self.province,self.city,KHH_SEPARATOR,detailAddress];
    
    //更新到feildValue中
    [_fieldValue replaceObjectAtIndex:8 withObject:newAddress];
}

//判断是否添加过
- (NSMutableArray *)isHaveAddedItem
{
    if (_whichexternIndex == 1) {
        NSMutableArray *temp = [NSMutableArray arrayWithArray:[_fieldName objectAtIndex:3]];
        [_fieldExternTwo enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *key = [obj objectForKey:@"key"];
            if([temp containsObject:key]){
                [temp removeObject:key];
            }
        }];
        return temp;
    }else if (_whichexternIndex == 2){
        NSMutableArray *temp = [NSMutableArray arrayWithArray:[_fieldName objectAtIndex:2]];
        [_fieldExternThree enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *key = [obj objectForKey:@"key"];
            if([temp containsObject:key]){
                [temp removeObject:key];
            }
            
            if ([key isEqualToString:@"开户行"]) {
                [temp removeObject:@"银行信息"];
            }
        }];
        return temp;
    }
    return nil;
}

- (void)addToExternArrayFromPick:(NSString *)str
{
    int fieldTag = -1;
    if (_whichexternIndex == 0) {
        [_fieldExternOne addObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"key",@"",@"value", nil]];
        ++_oneNums;
        fieldTag = kBaseTag+100+_oneNums-1-1;
        [_table insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_oneNums-1-1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
         
    }else if (_whichexternIndex == 1){
        [section2HavIn addObject:str];
        [_fieldExternTwo addObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"key",@"",@"value", nil]];
       
        
        if ([[self havInForPicker:section2AddArray inViewStrs:section2HavIn] count]==0) {
            --_twoNums;
            [_table deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_twoNums inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
            ++_twoNums;
            fieldTag = kBaseTag+200+_twoNums-1;
            [_table insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_twoNums-1 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            ++_twoNums;
            [_table insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_twoNums-1-1 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
        }
        
        
    }else if (_whichexternIndex == 2){
        if ([str isEqualToString:@"银行信息"]) {
            [_fieldExternThree addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"开户行",@"key",@"",@"value", nil]];
            ++_threeNums;
            fieldTag = kBaseTag+300+_threeNums-1-1;
           
            [_table insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_threeNums-1-1 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
            [_fieldExternThree addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"银行帐号",@"key",@"",@"value", nil]];
            ++_threeNums;
            
            [_table insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_threeNums-1-1 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
            
            [_fieldExternThree addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"户名",@"key",@"",@"value", nil]];
            ++ _threeNums;
            
            [_table insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_threeNums-1-1 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
            
        }else{
            if ([[self havInForPicker:section3AddArray inViewStrs:section3HavIn] count]==0)
            [_fieldExternThree addObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"key",@"",@"value", nil]];
            ++_threeNums;
            fieldTag = kBaseTag+300+_threeNums-1-1;
            
            [_table insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_threeNums-1-1 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }else if (_whichexternIndex == -1){
        DLog(@"添加分组");
        [_fieldValue replaceObjectAtIndex:2 withObject:str];
    }
    
    
    if(fieldTag != -1){
        NSLog(@"cell.tag%d",fieldTag);
        [self fieldBecomFirstResponderDelay:[NSNumber numberWithInt:fieldTag ]];
//        [self performSelector:@selector(fieldBecomFirstResponderDelay:) withObject:[NSNumber numberWithInt:kBaseTag+fieldTag] afterDelay:0.1];
    }
    
}
- (void)fieldBecomFirstResponderDelay:(NSNumber *)tag
{
    UIView *view = [self.view viewWithTag:tag.integerValue];
    if([view isKindOfClass:[UITextField class]]){
        [(UITextField *)view becomeFirstResponder];
    }else{
        
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [_table setEditing:editing animated:animated];
}
//
//- (void)tableAnimationUp
//{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.3];
//    CGRect rect = _theTable.frame;
//    rect.origin.y = -188;
//    _table.frame = rect;
//    [UIView commitAnimations];
//
//
//}
//暂时不用
//- (void)animateView:(NSUInteger)tag
//{
//    CGRect rect = self.theTable.frame;
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.3];
//
//    if (tag > 2) {
//        rect.origin.y = -44.0f * (tag - 2);
//    } else {
//        rect.origin.y = 0;
//    }
//    self.theTable.frame = rect;
//    [UIView commitAnimations];
//}
//
//- (void)tableAnimationDown
//{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.3];
//    CGRect rect = _theTable.frame;
//    rect.origin.y = 0;
//    _theTable.frame = rect;
//    [UIView commitAnimations];
//
//}
#pragma mark -
#pragma mark UITextfield Delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // return [super textFieldShouldReturn:textField];
    //    if (textField.returnKeyType == UIReturnKeyNext) {
    //        int tag = (textField.tag + 1 == kBaseTag + 8 + _fieldExternOne.count)?(textField.tag+2):(textField.tag+1);
    //        UIView *view = [self.view viewWithTag:tag];
    //        if ([view isKindOfClass:[UITextField class]]) {
    //            [(UITextField *)view becomeFirstResponder];
    //            [self animateView:textField.tag-kBaseTag];
    //        }else{
    //            DLog(@"%@",view);
    //        }
    //    }
    [textField resignFirstResponder];
    
    UITextField * filed = [allFiledForGoto objectForKey:[NSString stringWithFormat:@"%d" ,textField.tag+1]];
    if (!filed) {
        filed = [allFiledForGoto objectForKey:[NSString stringWithFormat:@"%d" ,((textField.tag-kBaseTag)/100+1)*100+kBaseTag]];
    }
    if (!filed) {
        return YES;
    }
    [filed becomeFirstResponder];
    DLog(@"textfield.tag======%d",textField.tag);
    DLog(@"textfield.tag======%d",filed.tag);
    // [self tableAnimationDown];
    //    if (textField.returnKeyType == UIReturnKeyDone) {
    //        [self tableAnimationDown];
    //        [textField resignFirstResponder];
    //    }
    
    return YES;
}

- (void)addRes:(id)obj2
{
    
    for (id obj in  inputsForKeyboard) {
        if ([obj isEqual:obj2]) {
            return;
        }
    }
    [inputsForKeyboard addObject:obj2];
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    return YES;
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    rectForKey = textField.superview.superview.frame;
    rectForKey.origin.y += 30;
    [_table goToInsetForKeyboard:rectForKey];
    [self addRes:textField];
    //    if(!self.datePicker.hidden){
    //        [self.datePicker cancelPicker:NO];
    //    }
    if (!self.areaPicker.hidden) {
        [self.areaPicker cancelPicker:NO];
    }
    //    if (!self.memoPicker.hidden) {
    //        [self.memoPicker cancelPicker:NO];
    //    }
    //    if (!self.remindPicker.hidden) {
    //        [self.remindPicker cancelPicker:NO];
    //    }
    
    if ([self filedIsLast:textField.tag]) {
        textField.returnKeyType = UIReturnKeyDone;
    }else{
        textField.returnKeyType = UIReturnKeyNext;
    }
    //    if(textField.tag < kBaseTag+10+_fieldExternOne.count+_fieldExternTwo.count+_fieldExternThree.count-1){
    //        textField.returnKeyType = UIReturnKeyNext;
    //    }else{
    //        textField.returnKeyType = UIReturnKeyDone;
    //    }
    
    self.beginEditField = textField;
    UITableViewCell *cell = (UITableViewCell *)textField.superview.superview;
    
    if([cell isKindOfClass:[Edit_eCardViewCell class]]){
        self.beginEditLabel = [(Edit_eCardViewCell *)cell name];
    }
    
    if([cell isKindOfClass:[KHHAddressCell class]]){
        self.beginEditLabel = [(KHHAddressCell *)cell name];
    }
}

- (void)addFiled:(UITextField *)filed2;
{
    //    for (NSString *tag in [allFiledForGoto allKeys]){
    //        if ([tag integerValue] == filed2.tag) {
    //            return;
    //        }
    //    }
    NSLog(@"!!!%d",filed2.tag);
    [allFiledForGoto setValue:filed2 forKey:[NSString stringWithFormat:@"%d",filed2.tag]];
}

- (Boolean)filedIsLast:(int)tag
{
    for (NSString *tag2 in  [allFiledForGoto allKeys]) {
        if ([tag2 integerValue]> tag) {
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // [_table showNormal];
    DLog(@"beginEditLabel>>>>>>%@",self.beginEditLabel.text);
    DLog(@"textField.tag>>>>>>>>>>%d",textField.tag);
    //判断格式是否有效
    if (self.beginEditField) {
        if ([self.beginEditLabel.text isEqualToString:@"手机"]) {
            if (textField.text.length > 0 && ![textField.text isValidMobilePhoneNumber]) {
                [self warnAlertMessage:@"手机格式错误"];
            }
            
        }else if ([self.beginEditLabel.text isEqualToString:@"电话"]){
            if (textField.text.length > 0 && ![textField.text isValidTelephoneNUmber]) {
                [self warnAlertMessage:@"电话号码格式错误"];
            }
        }else if ([self.beginEditLabel.text isEqualToString:@"传真"]){
            if (textField.text.length > 0 && ![textField.text isValidTelephoneNUmber]) {
                [self warnAlertMessage:@"传真格式错误"];
            }
            
        }else if ([self.beginEditLabel.text isEqualToString:@"邮箱"]){
            if (textField.text.length > 0 && ![textField.text isValidEmail]) {
                [self warnAlertMessage:@"邮箱格式错误"];
            }
            
        }else if ([self.beginEditLabel.text isEqualToString:@"QQ"]){
            if (textField.text.length > 0 && ![textField.text isValidQQ]) {
                [self warnAlertMessage:@"QQ格式错误"];
            }
        }else if ([self.beginEditLabel.text isEqualToString:@"邮编"]){
            if (textField.text.length > 0 && ![textField.text isValidPostalCode]) {
                [self warnAlertMessage:@"邮编格式错误"];
            }
            
        }
    }
    //......
    //判断textfield的值，根据不同的tag值，取代textfield预留的空值
    if (textField.tag < kBaseTag) {
        DLog(@"Could Ignore textField");
    }else if (textField.tag < kBaseTag + 3){
        DLog(@"textField.tag < kBaseTag + 3============%@",textField.text);
        [_fieldValue replaceObjectAtIndex:textField.tag - kBaseTag withObject:textField.text];
    }else if (textField.tag < kBaseTag + 7){
        DLog(@"textField.tag < 7===========%@",textField.text);
        [_fieldValue replaceObjectAtIndex:textField.tag - kBaseTag withObject:textField.text];
    }else if (textField.tag < kBaseTag + 7 + _fieldExternOne.count ){
        DLog(@"ExternOne value============%@",textField.text);
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:textField.text,@"value",self.beginEditLabel.text,@"key", nil];
        [_fieldExternOne replaceObjectAtIndex:textField.tag - kBaseTag - 7 withObject:dic];
    }else if (textField.tag < (kBaseTag + 10 + _fieldExternOne.count)){
        DLog(@"section two value===========%@",textField.text);
        [_fieldValue replaceObjectAtIndex:(textField.tag - kBaseTag - _fieldExternOne.count) withObject:textField.text];
    }else if (textField.tag < (kBaseTag + 10 + _fieldExternOne.count + _fieldExternTwo.count)){
        DLog(@"ExternTwo value============%@",textField.text);
        NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:textField.text,@"value",self.beginEditLabel.text,@"key", nil];
        [_fieldExternTwo replaceObjectAtIndex:(textField.tag - kBaseTag - _fieldExternOne.count - 10) withObject:dic1];
    }else if (textField.tag < (kBaseTag + 10 + _fieldExternOne.count + _fieldExternTwo.count + _fieldExternThree.count)){
        DLog(@"ExternThree value ===========%@",textField.text);
        NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:textField.text,@"value",self.beginEditLabel.text,@"key", nil];
        [_fieldExternThree replaceObjectAtIndex:(textField.tag - kBaseTag - _fieldExternOne.count - _fieldExternTwo.count - 10) withObject:dic2];
    }
    //地址格式特殊，单独写出来重新赋值
    if ([self.beginEditLabel.text isEqualToString:@"地址"]) {
        KHHAddressCell *cell = (KHHAddressCell*)[[textField superview] superview];
        NSString *s2 = cell.detailAdress.text;
        [self updateAddressInFeildValue:s2];
        //这个地方用户自己输入的详细地址，区，以及街道无法保存。
    }
    self.beginEditLabel = nil;
}
- (void)saveCardInfo
{
    //对fieldvalue的值进行判断，如果是有效数据，就给card模型填充，然后保存到数据库
    DLog(@"save=========");
    //[self tableAnimationDown];
    [self.beginEditField resignFirstResponder];
    
    //姓名去除前后空格
    NSString *name = [[_fieldValue objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *job = [_fieldValue objectAtIndex:1];
    NSString *group = [_fieldValue objectAtIndex:2];
    [self saveToDictionary:name key:@"name"];
    [self saveToDictionary:job key:@"title"];
    self.interCard.name = name;
    self.interCard.title = job;
    //暂时用“分组”
    [self saveToDictionary:group key:@"分组"];
    //把多个手机号，用@“｜”串联起来，然后保存
    NSMutableString *mobiles = [NSMutableString stringWithString:[_fieldValue objectAtIndex:3]];
    NSMutableString *phones = [NSMutableString stringWithString:[_fieldValue objectAtIndex:4]];
    NSMutableString *faxes = [NSMutableString stringWithString:[_fieldValue objectAtIndex:5]];
    NSMutableString *mails = [NSMutableString stringWithString:[_fieldValue objectAtIndex:6]];
    
    for (NSDictionary *dic in _fieldExternOne) {
        NSString *key = [dic objectForKey:@"key"];
        NSString *value = [dic objectForKey:@"value"];
        if(value.length == 0){
            continue;
        }
        if([key isEqualToString:@"手机"]){
            [mobiles appendFormat:@"%@%@", KHH_SEPARATOR, value];
            DLog(@"mobiles===%@",mobiles);
        }else if([key isEqualToString:@"电话"]){
            [phones appendFormat:@"%@%@", KHH_SEPARATOR, value];
            DLog(@"phones===%@",phones);
        }else if([key isEqualToString:@"传真"]){
            [faxes appendFormat:@"%@%@", KHH_SEPARATOR, value];
        }else if([key isEqualToString:@"邮箱"]){
            [mails appendFormat:@"%@%@", KHH_SEPARATOR, value];
        }
    }
    
    /////////////////检查第可变手机、电话、传真、邮箱第一行是否为空////////////////
    
    if([mobiles hasPrefix:[NSString stringWithFormat:@"%@", KHH_SEPARATOR]]){
        [mobiles deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    if([phones hasPrefix:[NSString stringWithFormat:@"%@", KHH_SEPARATOR]]){
        [mobiles deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    if([faxes hasPrefix:[NSString stringWithFormat:@"%@", KHH_SEPARATOR]]){
        [mobiles deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    if([mails hasPrefix:[NSString stringWithFormat:@"%@", KHH_SEPARATOR]]){
        [mobiles deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    
    NSString *company = [_fieldValue objectAtIndex:7];
    NSString *address = [_fieldValue objectAtIndex:8];
    NSArray *addressArr = [address componentsSeparatedByString:KHH_SEPARATOR];
    NSArray *pcArr = [[addressArr objectAtIndex:0] componentsSeparatedByString:@" "];
    //区街道无法保存
    UIButton *pcBtn = (UIButton *)[self.view viewWithTag:KBIGADDRESS_TAG];
    NSArray *pcArrBtn = [pcBtn.titleLabel.text componentsSeparatedByString:@" "];
    NSString *zipCode = [_fieldValue objectAtIndex:9];
    self.interCard.addressZip = zipCode;
    
    for (NSDictionary *dic in _fieldExternTwo) {
        NSString *key = [dic objectForKey:@"key"];
        NSString *value = [dic objectForKey:@"value"];
        if ([key isEqualToString:@"部门"]) {
            [self saveToDictionary:value key:@"department"];
            DLog(@"depart=====save:%@",value);
            self.interCard.department = value;
        }else if ([key isEqualToString:@"公司邮箱"]){
            [self saveToDictionary:value key:@"officeEmail"];
            DLog(@"company mail=======save:%@",value);
            self.interCard.companyEmail = value;
        }
    }
    
    self.interCard.companyName = company;
    if (pcArr.count >= 2) {
        self.interCard.addressProvince = [pcArr objectAtIndex:0];
        self.interCard.addressCity = [pcArr objectAtIndex:1];
    }
    if (pcArrBtn.count >=2) {
        self.interCard.addressProvince = [pcArrBtn objectAtIndex:0];
        self.interCard.addressCity = [pcArrBtn objectAtIndex:1];
    }
    //self.interCard.addressCountry =
    //self.interCard.addressDistrict =
    if (addressArr.count >= 2) {
        self.interCard.addressOther = [addressArr objectAtIndex:1];
    }
    
    //姓名检查
    if (name.length <= 0) {
        [self warnAlertMessage:@"名片上的姓名为空!"];
        return;
    }
    
    // 对是否为空或格式进行判断，然后把手机，电话，传真，邮箱保存起来
    if (mobiles.length==0 && phones.length==0) {
        //[self showMessage:@"名片上的电话未空!请至少填写一个手机号码或者电话号码!" withTitile:nil];
        [self warnAlertMessage:@"名片上的电话未空!请至少填写一个手机号码或者电话号码!"];
        return;
    }
    
    if(company.length==0 && (address.length == 0 || [address isEqualToString:KhhMessageAddressEditNotice]) ){
        //[self showMessage:@"名片上的公司信息为空!请至少填写公司或地址中的一项!" withTitile:nil];
        [self warnAlertMessage:@"名片上的公司信息为空!请至少填写公司或地址中的一项!"];
        return;
    }
    
    //    //////////////////////validate//////////////////////
    //validate mobile
    for(NSString *str in [mobiles componentsSeparatedByString:KHH_SEPARATOR]){
        if(str.length>0 && ![str isValidMobilePhoneNumber]){
            //[self showMessage:@"手机格式错误!" withTitile:nil];
            [self warnAlertMessage:@"手机格式错误!!"];
            return;
        }
    }
    
    //    //validate phone
    for(NSString *str in [phones componentsSeparatedByString:KHH_SEPARATOR]){
        if(str.length>0 && ![str isValidTelephoneNUmber]){
            //[self showMessage:@"电话格式错误!" withTitile:nil];
            [self warnAlertMessage:@"电话格式错误!"];
            return;
        }
    }
    
    //validate fax
    for(NSString *str in [faxes componentsSeparatedByString:KHH_SEPARATOR]){
        if(str.length>0 && ![str isValidTelephoneNUmber]){
            //[self showMessage:@"传真格式错误!" withTitile:nil];
            [self warnAlertMessage:@"传真格式错误!"];
            return;
        }
    }
    
    //validate email
    for(NSString *str in [mails componentsSeparatedByString:KHH_SEPARATOR]){
        if(str.length>0 && ![str isValidEmail]){
            //[self showMessage:@"邮箱格式错误!" withTitile:nil];
            [self warnAlertMessage:@"邮箱格式错误!"];
            return;
        }
    }
    
    [self saveToDictionary:mobiles key:@"mobilePhone"];
    [self saveToDictionary:phones key:@"telephone"];
    [self saveToDictionary:faxes key:@"fax"];
    [self saveToDictionary:mails key:@"email"];
    self.interCard.mobilePhone = mobiles;
    self.interCard.telephone = phones;
    self.interCard.fax = faxes;
    self.interCard.email = mails;
    
    //save externThree;
    for (NSDictionary *dic in _fieldExternThree) {
        NSString *key = [dic objectForKey:@"key"];
        DLog(@"key======%@",key);
        NSString *value = [dic objectForKey:@"value"];
        if ([key isEqualToString:@"网页"]) {
            [self saveToDictionary:value key:@"web"];
            self.interCard.web = value;
        }else if ([key isEqualToString:@"QQ"]){
            [self saveToDictionary:value key:@"qq"];
            self.interCard.qq = value;
            
        }else if ([key isEqualToString:@"MSN"]){
            [self saveToDictionary:value key:@"msn"];
            self.interCard.msn = value;
            
        }else if ([key isEqualToString:@"旺旺"]){
            [self saveToDictionary:value key:@"aliWangWang"];
            self.interCard.aliWangWang = value;
            
        }else if ([key isEqualToString:@"业务范围"]){
            [self saveToDictionary:value key:@"businessScope"];
            self.interCard.businessScope = value;
            
        }else if ([key isEqualToString:@"开户行"]){
            [self saveToDictionary:value key:@"branch"];
            DLog(@"开户行======save:%@",value);
            self.interCard.bankAccountBranch = value;
        }else if ([key isEqualToString:@"银行帐号"]){
            [self saveToDictionary:value key:@"number"];
            DLog(@"银行帐号 ======save:%@",value);
            self.interCard.bankAccountNumber = value;
        }else if ([key isEqualToString:@"户名"]){
            DLog(@"户名======save:%@",value);
            [self saveToDictionary:value key:@"户名"];
            self.interCard.bankAccountName = value;
            
        }else if ([key isEqualToString:@"其它信息"]){
            DLog(@"其它信息======save:%@",value);
            [self saveToDictionary:value key:@"moreInfo"];
            self.interCard.moreInfo = value;
        }
    }
    // id，version，userid,templateID付给InterCard，否则不能通过
    self.interCard.id = _glCard.id;
    self.interCard.version = _glCard.version;
    self.interCard.userID = _glCard.userID;
    self.interCard.templateID = _glCard.template.id;
    
#warning 20130114因项目时间紧，本地数据库未改动，添加的名片类型、名片来源需要在这里赋值
    //20121225
    //头像字段没考虑，所以保存后要及时同步一下
    // 保存到数据库或调用网络接口
    //为了避免保存失败，先给这个临时card给值 InterCard
    self.progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([_glCard isKindOfClass:[MyCard class]]) {
        //设置名片类型及名片来源
        self.interCard.cardType = kCardType_Person;
        self.interCard.cardSource = kCardSource_Person;
        
        self.progressHud.labelText = KHHMessageModifyCard;
       // [[KHHDataNew sharedData] modifyMyCardWithInterCard:self.interCard delegate:self];
    }else if ([_glCard isKindOfClass:[PrivateCard class]]){
        //设置名片类型及名片来源
        self.interCard.cardType = kCardType_Person;
        self.interCard.cardSource = kCardSource_Client_SelfBuild;
        
        self.progressHud.labelText = KHHMessageModifyCard;
       // [[KHHDataNew sharedData] modifyPrivateCardWithInterCard:self.interCard];
    }else if (self.type == KCardViewControllerTypeNewCreate){
        //设置名片类型及名片来源
        self.interCard.cardType = kCardType_Person;
        self.interCard.cardSource = kCardSource_Client_SelfBuild;
        
        //修改
        self.progressHud.labelText = KHHMessageCreateCard;
        //暂时这样写 templateID不确定
        self.interCard.templateID = self.cardTemp.id;
        //        NSLog(@"..%@",self.cardTemp);
        //        NSLog(@"..%@",self.interCard);
       // [[KHHDataNew sharedData] createPrivateCardWithInterCard:self.interCard];
        //[[NetClient sharedClient]CreatePrivateCard:self.interCard delegate:self];
    }
}

#pragma mark - Private delegate

- (void)createDone
{
    self.progressHud.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createFail:(NSString *)msg
{
    self.progressHud.hidden = YES;
    [self warnAlertMessage:msg];
}

- (void)saveToDictionary:(NSString *)object key:(NSString *)key
{
    [self.saveInfoDic setObject:object forKey:key];
    
}

//选择分组的PickViewController
- (void)accessBtnClick:(id)sender
{
    PickViewController *pickVC = [[PickViewController alloc] initWithNibName:@"PickViewController" bundle:nil];
    pickVC.PickFlag = 3;
    NSArray *arr = [[NSArray alloc] initWithObjects:@"未分组", nil];
    pickVC.groupArr = arr;
    pickVC.delegate = self;
    _whichexternIndex = -1;
    [self.navigationController pushViewController:pickVC animated:YES];
}
// 非法字符提示
- (void)warnAlertMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:message delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end

