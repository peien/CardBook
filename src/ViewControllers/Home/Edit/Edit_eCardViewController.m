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
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"

#import "Card.h"
#import "Company.h"
#import "CardTemplate.h"
#import "Address.h"
#import "Group.h"
#import "BankAccount.h"
#import "KHHData+UI.h"
#import "InterCard.h"
#import "MyCard.h"
#import "ReceivedCard.h"
#import "PrivateCard.h"

#define CARD_IMGVIEW_TAG 990
#define CARDMOD_VIEW_TAG 991

#define kBaseTag 2400
#define KBIGADDRESS_TAG 6699

NSString *const kECardListSeparator = @"|";

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
@property (strong, nonatomic) KHHData       *dataCtrl;
@property (strong, nonatomic) MBProgressHUD *progressHud;

@end

@implementation Edit_eCardViewController
@synthesize theTable = _theTable;
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
@synthesize dataCtrl;
@synthesize progressHud;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.rightBtn setTitle:NSLocalizedString(@"保存", nil) forState:UIControlStateNormal];
        self.interCard = [[InterCard alloc] init];
        self.dataCtrl = [KHHData sharedData];
    }
    return self;
}
#pragma mark -
#pragma mark saveCardInfo
//save card info
- (void)rightBarButtonClick:(id)sender
{
    //注册修改card 或 创建card消息
    [self observeNotificationName:KHHUIModifyCardSucceeded selector:@"handleModifyCardSucceeded"];
    [self observeNotificationName:KHHUIModifyCardFailed selector:@"handleModifyCardFailed:"];
    [self observeNotificationName:KHHUICreateCardSucceeded selector:@"handleCreateCardSucceeded"];
    [self observeNotificationName:KHHUICreateCardFailed selector:@"handleCreateCardFailed"];
    [self saveCardInfo];
}
#pragma mark - Handle Modify or Create Card Message
- (void)handleModifyCardSucceeded
{
    DLog(@"ModifyCardSucceeded");
}
- (void)handleModifyCardFailed:(NSNotification *)noti
{
    DLog(@"ModifyCardFailed! noti = %@", noti);
    [self.progressHud removeFromSuperview];
    [self warnAlertMessage:@"修改失败"];
}
- (void)handleCreateCardSucceeded
{
    DLog(@"CreateCardSucceeded");
    [self.progressHud removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)handleCreateCardFailed
{
   [self.progressHud removeFromSuperview];
    DLog(@"CreateCardFailed");
}
#pragma mark -
#pragma mark UIViewController Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:241 green:238 blue:232 alpha:1.0];
    KHHFrameCardView *cardView = [[KHHFrameCardView alloc] initWithFrame:CGRectMake(0, 0, 320, 220) isVer:NO];
    cardView.card = self.glCard;
    [cardView showView];
    _theTable.tableHeaderView = cardView;
    if (self.type == KCardViewControllerTypeNewCreate) {
        self.title = @"新建名片";
    }else if (self.type == KCardViewControllerTypeShowInfo){
       self.title = @"详细信息";
    }

    [self initVCData];
    _theTable.editing = YES;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [KHHShowHideTabBar hideTabbar];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    
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

//构造表需要的数据
- (void)initVCData
{
    
    _oneNums = 5;
    _twoNums = 4;
    _threeNums = 1;
    
    _fieldName = [NSArray arrayWithObjects:[NSMutableArray arrayWithObjects:@"手机",@"电话",@"传真",@"邮箱", nil],
                                           [NSMutableArray arrayWithObjects:@"公司",@"地址",@"邮编", nil],
                                           [NSMutableArray arrayWithObjects:@"网址",@"QQ",@"MSN",@"旺旺",@"业务范围",@"银行信息",@"其它信息", nil],
                                           [NSMutableArray arrayWithObjects:@"部门",@"公司邮箱", nil],
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

    NSArray *mobiels = [_glCard.mobilePhone componentsSeparatedByString:kECardListSeparator];
    for (int i = 0; i<mobiels.count; i++) {
        if (i == 0) {
            [_fieldValue replaceObjectAtIndex:3 withObject:[mobiels objectAtIndex:0]];
        }else{
            [_fieldExternOne addObject:[NSDictionary dictionaryWithObjectsAndKeys:[mobiels objectAtIndex:i],@"value",@"手机",@"key", nil]];
        }
    }
    
    NSArray *tels = [_glCard.telephone componentsSeparatedByString:kECardListSeparator];
    for (int i = 0; i<tels.count; i++) {
        if (i == 0) {
            [_fieldValue replaceObjectAtIndex:4 withObject:[tels objectAtIndex:0]];
        }else{
            [_fieldExternOne addObject:[NSDictionary dictionaryWithObjectsAndKeys:[tels objectAtIndex:i],@"value",@"电话",@"key", nil]];
        }
    }
    
    NSArray *faxs = [_glCard.fax componentsSeparatedByString:kECardListSeparator];
    for (int i = 0; i<faxs.count; i++) {
        if (i == 0) {
            [_fieldValue replaceObjectAtIndex:5 withObject:[faxs objectAtIndex:0]];
        }else{
            [_fieldExternOne addObject:[NSDictionary dictionaryWithObjectsAndKeys:[faxs objectAtIndex:i],@"value",@"传真",@"key", nil]];
        }
    }
    
    NSArray *mails = [_glCard.email componentsSeparatedByString:kECardListSeparator];
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
    
    if (_glCard.company.email.length) {
        [_fieldExternTwo addObject:[NSDictionary dictionaryWithObjectsAndKeys:_glCard.company.email,@"value",@"公司邮箱",@"key", nil]];
    }
    if (_glCard.address.province.length > 0 || _glCard.address.city.length > 0) {
        self.pc = [NSString stringWithFormat:@"%@ %@",_glCard.address.province,_glCard.address.city];
        if ([_glCard.address.district isEqualToString:@"(null)"]) {
            _glCard.address.district = @"";
        }
        if ([_glCard.address.street isEqualToString:@"(null)"]) {
            _glCard.address.street = @"";
        }
        self.strStreet = [NSString stringWithFormat:@"%@%@",_glCard.address.district,_glCard.address.street];
        NSString *allAddress = [NSString stringWithFormat:@"%@|%@",self.pc,self.strStreet];
        [_fieldValue replaceObjectAtIndex:8 withObject:allAddress];
    }

    
    if (_glCard.address.zip.length > 0) {
        [_fieldValue replaceObjectAtIndex:9 withObject:_glCard.address.zip];
    }
    
    if (_glCard.department.length > 0) {
        [_fieldExternTwo addObject:[NSDictionary dictionaryWithObjectsAndKeys:_glCard.department,@"value",@"部门",@"key", nil]];
    }
    //银行信息
    if (_glCard.bankAccount.bank.length > 0 || _glCard.bankAccount.branch.length > 0) {
        NSString *adds = [NSString stringWithFormat:@",%@",_glCard.bankAccount.branch];
        NSString *bankName = [_glCard.bankAccount.bank stringByAppendingString:adds];
       [_fieldExternTwo addObject:[NSDictionary dictionaryWithObjectsAndKeys:bankName,@"value",@"开户行",@"key", nil]];
    }
    if (_glCard.bankAccount.number.length > 0) {
        [_fieldExternThree addObject:[NSDictionary dictionaryWithObjectsAndKeys:_glCard.bankAccount.number,@"value",@"银行帐号",@"key", nil]];
    }
    //
    
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
    _theTable = nil;
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
    self.dataCtrl = nil;
    self.progressHud = nil;
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
            return 2;
        case 1:
            return _oneNums;
        case 2:
            return _twoNums == [[_fieldName objectAtIndex:1] count] + [[_fieldName objectAtIndex:3] count]+1 ?_twoNums-1:_twoNums;
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
        return 60;
    }else if (indexPath.section == 2 && indexPath.row == 1)
    {
        return 55;
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
            cell.nameValue.text = [_fieldValue objectAtIndex:0];
            cell.jobValue.text = [_fieldValue objectAtIndex:1];
            cell.nameValue.placeholder = [[self.placeName objectAtIndex:2] objectAtIndex:0];
            cell.jobValue.placeholder = [[self.placeName objectAtIndex:2] objectAtIndex:1];
            [cell.iconImg setImageWithURL:[NSURL URLWithString:_glCard.logo.url] placeholderImage:[UIImage imageNamed:@"logopic.png"]];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapIconImage:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [cell.iconImg addGestureRecognizer:tap];
            CGRect rect = cell.frame;
            rect.origin.x -= 100;
            cell.frame = rect;
            return cell;
        }else if (indexPath.row == 1){
            Edit_eCardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDZero];
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Edit_eCardViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:1];
                cell.name.text = @"分组";
                cell.value.tag = kBaseTag + 2;
                cell.value.enabled = NO;
                cell.value.text = [_fieldValue objectAtIndex:2];
                cell.value.placeholder = [[self.placeName objectAtIndex:2] objectAtIndex:2];
                UIButton *accessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [accessBtn addTarget:self action:@selector(accessBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                accessBtn.frame = CGRectMake(270, 5, 35, 35);
                [accessBtn setBackgroundImage:[UIImage imageNamed:@"accessBtnico.png"] forState:UIControlStateNormal];
                [cell addSubview:accessBtn];
            }
            return cell;
        }
    }else if (indexPath.section == 1){
        Edit_eCardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDOne];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Edit_eCardViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:1];
        }
        if (indexPath.row < 4) {
            cell.name.text = [[_fieldName objectAtIndex:0] objectAtIndex:indexPath.row];
            cell.value.tag = indexPath.row + kBaseTag + 3;
            cell.value.text = [_fieldValue objectAtIndex:3 + indexPath.row];
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
            cell.value.tag = indexPath.row + kBaseTag + 3;
            cell.value.placeholder = [NSString stringWithFormat:@"请输入%@",cell.name.text];
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
                cell.value.tag = indexPath.row + 7 + _fieldExternOne.count + kBaseTag;
                cell.value.text = [_fieldValue objectAtIndex:7 + indexPath.row];
                cell.value.placeholder = [[self.placeName objectAtIndex:1] objectAtIndex:indexPath.row];
            }else if (indexPath.row == _twoNums-1){
                cell.name.text = @"添加";
                cell.value.enabled = NO;
                cell.value.tag = kBaseTag -1;
            }else if (indexPath.row >= 3 && indexPath.row < _twoNums - 1){
                cell.name.text = [[_fieldExternTwo objectAtIndex:indexPath.row - 3] objectForKey:@"key"];
                cell.value.text = [[_fieldExternTwo objectAtIndex:indexPath.row - 3] objectForKey:@"value"];
                cell.value.tag = indexPath.row + kBaseTag + 7 + _fieldExternOne.count ;
                 cell.value.placeholder = [NSString stringWithFormat:@"请输入%@",cell.name.text];
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
            cell.detailAdress.tag = indexPath.row + 7 + _fieldExternOne.count + kBaseTag;
            NSString *all = [_fieldValue objectAtIndex:8];
            NSArray *arr = [all componentsSeparatedByString:@"|"];
            if (arr.count >= 2) {
                [cell.bigAdress setTitle:[arr objectAtIndex:0] forState:UIControlStateNormal];
                cell.detailAdress.text = [arr objectAtIndex:1];
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
            cell.value.tag = indexPath.row + kBaseTag + 10 + _fieldExternOne.count + _fieldExternTwo.count;
            cell.value.text = [[_fieldExternThree objectAtIndex:indexPath.row] objectForKey:@"value"];
             cell.value.placeholder = [NSString stringWithFormat:@"请输入%@",cell.name.text];
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
        if (indexPath.row == _twoNums-1) {
            return UITableViewCellEditingStyleInsert;
        }else if (indexPath.row > 2 && indexPath.row < _twoNums-1){
            return UITableViewCellEditingStyleDelete;
        }
    }else if (indexPath.section == 3){
        if (indexPath.row == _threeNums -1) {
            return UITableViewCellEditingStyleInsert;
        }else if (indexPath.row < _threeNums -1){
            return UITableViewCellEditingStyleDelete;
        }
    }
    return UITableViewCellEditingStyleNone;
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PickViewController *pickVC = [[PickViewController alloc] initWithNibName:@"PickViewController" bundle:nil];
    pickVC.delegate = self;
    pickVC.dataName = self.fieldName;
    if (editingStyle == UITableViewCellEditingStyleInsert ) {
        if (indexPath.section == 1) {
            pickVC.PickFlag = 0;
            _whichexternIndex = 0;
        }else if (indexPath.section == 2){
            pickVC.PickFlag = 1;
            _whichexternIndex = 1;
        }else if (indexPath.section == 3){
            pickVC.PickFlag = 2;
            _whichexternIndex = 2;
        }
        [self tableAnimationDown];
        
        // 判断是否添加
        pickVC.tempArray = [self isHaveAddedItem];
        [self.navigationController pushViewController:pickVC animated:YES];
        
    }else if (editingStyle == UITableViewCellEditingStyleDelete){
        [self tableAnimationDown];
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
            [_theTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"不可编辑" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
        NSLog(@"country:%@ city:%@ lat:%f lon:%f", location.state,location.city, location.latitude, location.longitude);
        UIButton *btn = (UIButton *)[self.view viewWithTag:KBIGADDRESS_TAG];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        NSString *addStr = [NSString stringWithFormat:@"%@ %@",location.state,location.city];
        [btn setTitle:addStr forState:UIControlStateNormal];
    }
    
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
        fieldTag = _oneNums + 1;
    }else if (_whichexternIndex == 1){
    
        [_fieldExternTwo addObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"key",@"",@"value", nil]];
        ++_twoNums;
        fieldTag = 10 + _fieldExternOne.count + _fieldExternTwo.count - 1;
        
    }else if (_whichexternIndex == 2){
        if ([str isEqualToString:@"银行信息"]) {
            [_fieldExternThree addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"开户行",@"key",@"",@"value", nil]];
            ++_threeNums;
            fieldTag = 10 + _fieldExternOne.count + _fieldExternTwo.count + _fieldExternThree.count - 1;
            [_fieldExternThree addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"银行帐号",@"key",@"",@"value", nil]];
            ++_threeNums;
            [_fieldExternThree addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"户名",@"key",@"",@"value", nil]];
            ++ _threeNums;
            
        }else{
            [_fieldExternThree addObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"key",@"",@"value", nil]];
            ++_threeNums;
            fieldTag = 10 + _fieldExternOne.count + _fieldExternTwo.count + _fieldExternThree.count - 1;
        }

    }else if (_whichexternIndex == -1){
        DLog(@"添加分组");
        [_fieldValue replaceObjectAtIndex:2 withObject:str];
    }
    [_theTable reloadData];
    if(fieldTag != -1){
        [self performSelector:@selector(fieldBecomFirstResponderDelay:) withObject:[NSNumber numberWithInt:kBaseTag+fieldTag] afterDelay:0.1];
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
    [_theTable setEditing:editing animated:animated];
}

- (void)tableAnimationUp
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect rect = _theTable.frame;
    rect.origin.y = -188;
    _theTable.frame = rect;
    [UIView commitAnimations];


}
//暂时不用
- (void)animateView:(NSUInteger)tag
{
    CGRect rect = self.theTable.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    if (tag > 2) {
        rect.origin.y = -44.0f * (tag - 2);
    } else {
        rect.origin.y = 0;
    }
    self.theTable.frame = rect;
    [UIView commitAnimations];
}

- (void)tableAnimationDown
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect rect = _theTable.frame;
    rect.origin.y = 0;
    _theTable.frame = rect;
    [UIView commitAnimations];

}
#pragma mark -
#pragma mark UITextfield Delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
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
    DLog(@"textfield.tag======%d",textField.tag);
    [self tableAnimationDown];
    //    if (textField.returnKeyType == UIReturnKeyDone) {
    //        [self tableAnimationDown];
    //        [textField resignFirstResponder];
    //    }
    
    return NO;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self tableAnimationUp];
    //DLog(@"textField.tag>>>>>>>%d",textField.tag);
    if(textField.tag < kBaseTag+10+_fieldExternOne.count+_fieldExternTwo.count+_fieldExternThree.count-1){
        textField.returnKeyType = UIReturnKeyNext;
    }else{
        textField.returnKeyType = UIReturnKeyDone;
    }
    
    self.beginEditField = textField;
    UITableViewCell *cell = (UITableViewCell *)textField.superview.superview;
    
    if([cell isKindOfClass:[Edit_eCardViewCell class]]){
        self.beginEditLabel = [(Edit_eCardViewCell *)cell name];
    }
    
    if([cell isKindOfClass:[KHHAddressCell class]]){
        self.beginEditLabel = [(KHHAddressCell *)cell name];
    }
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
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
    //地址格式特殊，单独写出来重新负值
    if ([self.beginEditLabel.text isEqualToString:@"地址"]) {
        KHHAddressCell *cell = (KHHAddressCell*)[[textField superview] superview];
        NSString *s1 = cell.bigAdress.titleLabel.text;
        NSString *s2 = cell.detailAdress.text;
        [_fieldValue replaceObjectAtIndex:8 withObject:[NSString stringWithFormat:@"%@|%@",s1,s2]];
    }
    self.beginEditLabel = nil;
    

}
- (void)saveCardInfo
{
    //对fieldvalue的值进行判断，如果是有效数据，就给card模型填充，然后保存到数据库
    DLog(@"save=========");
    [self tableAnimationDown];
    [self.beginEditField resignFirstResponder];
    
    NSString *name = [_fieldValue objectAtIndex:0];
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
            [mobiles appendFormat:@"%@%@", kECardListSeparator, value];
            DLog(@"mobiles===%@",mobiles);
        }else if([key isEqualToString:@"电话"]){
            [phones appendFormat:@"%@%@", kECardListSeparator, value];
            DLog(@"phones===%@",phones);
        }else if([key isEqualToString:@"传真"]){
            [faxes appendFormat:@"%@%@", kECardListSeparator, value];
        }else if([key isEqualToString:@"邮箱"]){
            [mails appendFormat:@"%@%@", kECardListSeparator, value];
        }
    }
    
    /////////////////检查第可变手机、电话、传真、邮箱第一行是否为空////////////////
    
    if([mobiles hasPrefix:[NSString stringWithFormat:@"%@", kECardListSeparator]]){
        [mobiles deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    if([phones hasPrefix:[NSString stringWithFormat:@"%@", kECardListSeparator]]){
        [mobiles deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    if([faxes hasPrefix:[NSString stringWithFormat:@"%@", kECardListSeparator]]){
        [mobiles deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    if([mails hasPrefix:[NSString stringWithFormat:@"%@", kECardListSeparator]]){
        [mobiles deleteCharactersInRange:NSMakeRange(0, 1)];
    }
    
    NSString *company = [_fieldValue objectAtIndex:7];
    NSString *address = [_fieldValue objectAtIndex:8];
    NSArray *addressArr = [address componentsSeparatedByString:@"|"];
    NSArray *pcArr = [[addressArr objectAtIndex:0] componentsSeparatedByString:@" "];
    NSString *zipCode = [_fieldValue objectAtIndex:9];

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
    
    [self saveToDictionary:company key:@"company"];
    [self saveToDictionary:address key:@"address"];
    [self saveToDictionary:zipCode key:@"zipCode"];
    self.interCard.companyName = company;
    if (pcArr.count >= 2) {
        self.interCard.addressProvince = [pcArr objectAtIndex:0];
        self.interCard.addressCity = [pcArr objectAtIndex:1];
    }
    //self.interCard.addressCountry =
    //self.interCard.addressDistrict =
    if (addressArr.count >= 2) {
        self.interCard.addressStreet = [addressArr objectAtIndex:1]; 
    }
    self.interCard.addressZip = zipCode;
    
    // 对是否为空或格式进行判断，然后把手机，电话，传真，邮箱保存起来
        if (mobiles.length==0 && phones.length==0) {
            //[self showMessage:@"名片上的电话未空!请至少填写一个手机号码或者电话号码!" withTitile:nil];
            [self warnAlertMessage:@"名片上的电话未空!请至少填写一个手机号码或者电话号码!"];
            return;
        }
    
        if(company.length==0 && address.length==0){
            //[self showMessage:@"名片上的公司信息为空!请至少填写公司或地址中的一项!" withTitile:nil];
            [self warnAlertMessage:@"名片上的公司信息为空!请至少填写公司或地址中的一项!"];
            return;
        }
    
    //    //////////////////////validate//////////////////////
        //validate mobile
        for(NSString *str in [mobiles componentsSeparatedByString:kECardListSeparator]){
            if(str.length>0 && ![str isValidMobilePhoneNumber]){
                //[self showMessage:@"手机格式错误!" withTitile:nil];
                [self warnAlertMessage:@"手机格式错误!!"];
                return;
            }
        }
    
    //    //validate phone
        for(NSString *str in [phones componentsSeparatedByString:kECardListSeparator]){
            if(str.length>0 && ![str isValidTelephoneNUmber]){
                //[self showMessage:@"电话格式错误!" withTitile:nil];
                [self warnAlertMessage:@"电话格式错误!"];
                return;
            }
        }
    
        //validate fax
        for(NSString *str in [faxes componentsSeparatedByString:kECardListSeparator]){
            if(str.length>0 && ![str isValidTelephoneNUmber]){
                //[self showMessage:@"传真格式错误!" withTitile:nil];
                [self warnAlertMessage:@"传真格式错误!"];
               return;
            }
        }
    
        //validate email
        for(NSString *str in [mails componentsSeparatedByString:kECardListSeparator]){
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
        if ([key isEqualToString:@"网址"]) {
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
    
    // 保存到数据库或调用网络接口
    //为了避免保存失败，先给这个临时card给值 InterCard
    self.progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([_glCard isKindOfClass:[MyCard class]]) {
        [self.dataCtrl modifyMyCardWithInterCard:self.interCard];
    }else if ([_glCard isKindOfClass:[PrivateCard class]]){
        [self.dataCtrl modifyPrivateCardWithInterCard:self.interCard];
    }else if (self.type == KCardViewControllerTypeNewCreate){
        //暂时这样写 templateID不确定
        self.interCard.templateID = [NSNumber numberWithInt:10];
        [self.dataCtrl createPrivateCardWithInterCard:self.interCard];
    }
}
- (void)saveToDictionary:(NSString *)object key:(NSString *)key
{
    [self.saveInfoDic setObject:object forKey:key];

}
- (void)accessBtnClick:(id)sender
{
    PickViewController *pickVC = [[PickViewController alloc] initWithNibName:@"PickViewController" bundle:nil];
    pickVC.PickFlag = 3;
    NSArray *arr = [[NSArray alloc] initWithObjects:@"未分组",@"广东（自定义分组）", nil];
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

