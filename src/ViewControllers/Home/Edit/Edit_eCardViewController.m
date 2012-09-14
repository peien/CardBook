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


#import "Card.h"
//#import "Card+ui.h"
#define CARD_IMGVIEW_TAG 990
#define CARDMOD_VIEW_TAG 991

#define kBaseTag 2400

NSString *const kECardListSeparator = @"|";
//////////////////////////////////////////////////////////////////
@interface TCard : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *job;
@property (strong, nonatomic) NSString *group;
@property (strong, nonatomic) NSString *mobiles;
@property (strong, nonatomic) NSString *tels;
@property (strong, nonatomic) NSString *faxs;
@property (strong, nonatomic) NSString *mails;
@property (strong, nonatomic) NSString *company;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *zipCode;
@property (strong, nonatomic) NSString *web;
@property (strong, nonatomic) NSString *qq;
@property (strong, nonatomic) NSString *depart;
@property (strong, nonatomic) NSString *msn;
@property (strong, nonatomic) NSString *wangwang;

@end

@implementation TCard
@synthesize name;
@synthesize job;
@synthesize group;
@synthesize mobiles;
@synthesize tels;
@synthesize faxs;
@synthesize mails;
@synthesize company;
@synthesize address;
@synthesize zipCode;
@synthesize web;
@synthesize qq;
@synthesize depart;
@synthesize msn;
@synthesize wangwang;

@end
//////////////////////////////////////////////////////////////////
@interface Edit_eCardViewController ()<PickViewControllerDelegate>
@property (strong, nonatomic) XLPageControl *xlPage;
@property (strong, nonatomic) UITextField   *beginEditField;
@property (strong, nonatomic) UILabel       *beginEditLabel;
@property (strong, nonatomic) Card          *card;
@property (strong, nonatomic) TCard         *glCard;
@property (assign, nonatomic) NSInteger     offset;
@property (assign, nonatomic) NSInteger      indexAll;

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
@synthesize card;
@synthesize glCard = _glCard;
@synthesize offset = _offset;
@synthesize indexAll = _indexAll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"详细内容";
        [self.rightBtn setTitle:@"保存" forState:UIControlStateNormal];

    }
    return self;
}
#pragma mark -
#pragma mark UIButton Click
- (void)saveToConcBtn:(id)sender
{


}
- (void)delBtnClick:(id)sender
{

}

//save card info
- (void)rightBarButtonClick:(id)sender
{
    [self saveCardInfo];
}

#pragma mark -
#pragma mark UIViewController Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    KHHFrameCardView *cardView = [[KHHFrameCardView alloc] initWithFrame:CGRectMake(0, 0, 320, 220) isVer:NO];
    _theTable.tableHeaderView = cardView;


    //MODEL CARD
    _glCard = [[TCard alloc] init];
    _glCard.name = @"Jhon";
    _glCard.job = @"设计";
    _glCard.mobiles = @"15123568975";
    _glCard.tels = @"0751-222222";
    _glCard.faxs = @"0751-222222";
    _glCard.mails = @"87569458@qq.com";
    _glCard.company = @"浙江金汉弘技术有限公司";
    _glCard.address = @"杭州滨江区南环路元光德大厦501室";
    _glCard.zipCode = @"00000000";
    _glCard.web = @"www.baidu.com";
    _glCard.qq = @"875698754";
    [self initVCData];
    _theTable.editing = YES;
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
    _fieldValue = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",nil];
    _fieldExternOne = [[NSMutableArray alloc] initWithCapacity:0];
    _fieldExternTwo = [[NSMutableArray alloc] initWithCapacity:0];
    _fieldExternThree = [[NSMutableArray alloc] initWithCapacity:0];
    _fieldValueDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    //调用数据库接口，创建card模型
    KHHAppDelegate *app = (KHHAppDelegate *)[[UIApplication sharedApplication] delegate];
#warning 重写这一行
//    self.card = [Card createCard:app.managedObjectContext];
    [self updateFieldValue];
}

- (void)updateFieldValue
{
  // 获得卡片，判断卡片相应的属性是否有直，如果有直，就分别添加到 _fieldValue 或是扩展数组
    if (_glCard.name.length > 0) {
        [_fieldValue replaceObjectAtIndex:0 withObject:_glCard.name];
    }
    if (_glCard.job.length > 0) {
        [_fieldValue replaceObjectAtIndex:1 withObject:_glCard.job];
    }
    
    //手机，电话，传真，邮箱有多个，默认显示第一个

    NSArray *mobiels = [_glCard.mobiles componentsSeparatedByString:kECardListSeparator];
    for (int i = 0; i<mobiels.count; i++) {
        if (i == 0) {
            [_fieldValue replaceObjectAtIndex:3 withObject:[mobiels objectAtIndex:0]];
        }else{
            [_fieldExternOne addObject:[NSDictionary dictionaryWithObjectsAndKeys:[mobiels objectAtIndex:i],@"value",@"手机",@"key", nil]];
        }
    }
    
    NSArray *tels = [_glCard.tels componentsSeparatedByString:kECardListSeparator];
    for (int i = 0; i<tels.count; i++) {
        if (i == 0) {
            [_fieldValue replaceObjectAtIndex:4 withObject:[tels objectAtIndex:0]];
        }else{
            [_fieldExternOne addObject:[NSDictionary dictionaryWithObjectsAndKeys:[tels objectAtIndex:i],@"value",@"电话",@"key", nil]];
        }
    }
    
    NSArray *faxs = [_glCard.faxs componentsSeparatedByString:kECardListSeparator];
    for (int i = 0; i<faxs.count; i++) {
        if (i == 0) {
            [_fieldValue replaceObjectAtIndex:5 withObject:[faxs objectAtIndex:0]];
        }else{
            [_fieldExternOne addObject:[NSDictionary dictionaryWithObjectsAndKeys:[faxs objectAtIndex:i],@"value",@"传真",@"key", nil]];
        }
    }
    
    NSArray *mails = [_glCard.mails componentsSeparatedByString:kECardListSeparator];
    for (int i = 0; i<mails.count; i++) {
        if (i == 0) {
            [_fieldValue replaceObjectAtIndex:6 withObject:[mails objectAtIndex:0]];
        }else{
            [_fieldExternOne addObject:[NSDictionary dictionaryWithObjectsAndKeys:[mails objectAtIndex:i],@"value",@"邮箱",@"key", nil]];
        }
    }
    
    if (_glCard.company.length > 0) {
        [_fieldValue replaceObjectAtIndex:7 withObject:_glCard.company];
    }
    if (_glCard.address.length > 0) {
        [_fieldValue replaceObjectAtIndex:8 withObject:_glCard.address];
    }
    if (_glCard.zipCode.length > 0) {
        [_fieldValue replaceObjectAtIndex:9 withObject:_glCard.zipCode];
    }
    
    if (_glCard.web.length > 0) {
        //[_fieldExternThree addObject:[NSDictionary dictionaryWithObjectsAndKeys:_glCard.web,@"value",@"网页",@"key", nil]];
    }
    if (_glCard.qq.length > 0) {
        //[_fieldExternThree addObject:[NSDictionary dictionaryWithObjectsAndKeys:_glCard.qq,@"value",@"QQ",@"key", nil]];
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
    self.card = nil;
    _glCard = nil;
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
    }else if (indexPath.section == 4){
        return 60;
    }
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIDZero = @"cellIDZero";
    static NSString *cellIDOne = @"cellIDOne";
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
                //cell.value.enabled = NO;
                cell.value.text = [_fieldValue objectAtIndex:2];
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
            
        }
        return cell;
    
    }else if (indexPath.section == 2){
        Edit_eCardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDOne];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Edit_eCardViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:1];
        }
        if (indexPath.row < 3) {
            cell.name.text = [[_fieldName objectAtIndex:1] objectAtIndex:indexPath.row];
            cell.value.tag = indexPath.row + 7 + _fieldExternOne.count + kBaseTag;
            cell.value.text = [_fieldValue objectAtIndex:7 + indexPath.row];
        }else if (indexPath.row == _twoNums-1){
            cell.name.text = @"添加";
            cell.value.enabled = NO;
            cell.value.tag = kBaseTag -1;
        }else if (indexPath.row >= 3 && indexPath.row < _twoNums - 1){
            cell.name.text = [[_fieldExternTwo objectAtIndex:indexPath.row - 3] objectForKey:@"key"];
            cell.value.text = [[_fieldExternTwo objectAtIndex:indexPath.row - 3] objectForKey:@"value"];
            cell.value.tag = indexPath.row + kBaseTag + 7 + _fieldExternOne.count ;
        }
        return cell;
    
    }else if (indexPath.section == 3){
        Edit_eCardViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIDOne];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Edit_eCardViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:1];
        }
        if (indexPath.row >= 0 && indexPath.row < _threeNums -1) {
            cell.name.text = [[_fieldExternThree objectAtIndex:indexPath.row] objectForKey:@"key"];
            cell.value.tag = indexPath.row + kBaseTag + 10 + _fieldExternOne.count + _fieldExternTwo.count;
            cell.value.text = [[_fieldExternThree objectAtIndex:indexPath.row] objectForKey:@"value"];
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

- (void)addToExternArrayFromPick:(NSString *)str
{
    if (_whichexternIndex == 0) {
        [_fieldExternOne addObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"key",@"",@"value", nil]];
        ++_oneNums;
    }else if (_whichexternIndex == 1){
        [_fieldExternTwo addObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"key",@"",@"value", nil]];
        ++_twoNums;
    }else if (_whichexternIndex == 2){
        if ([str isEqualToString:@"银行信息"]) {
            [_fieldExternThree addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"开户行",@"key",@"",@"value", nil]];
            ++_threeNums;
            [_fieldExternThree addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"银行帐号",@"key",@"",@"value", nil]];
            ++_threeNums;
            [_fieldExternThree addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"户名",@"key",@"",@"value", nil]];
            ++ _threeNums;
        }else{
            [_fieldExternThree addObject:[NSDictionary dictionaryWithObjectsAndKeys:str,@"key",@"",@"value", nil]];
            ++_threeNums;
        }

    }else if (_whichexternIndex == -1){
        DLog(@"添加分组");
    }
    [_theTable reloadData];

}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [_theTable setEditing:editing animated:animated];
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
    [self tableAnimationDown];
//    if (textField.returnKeyType == UIReturnKeyDone) {
//        [self tableAnimationDown];
//        [textField resignFirstResponder];
//    }
    
    return NO;
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
    
    _glCard.name = name;
    _glCard.job = job;
    _glCard.group = group;
    
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
    NSString *zipCode = [_fieldValue objectAtIndex:9];
    
    for (NSDictionary *dic in _fieldExternTwo) {
        NSString *key = [dic objectForKey:@"key"];
        NSString *value = [dic objectForKey:@"value"];
        if ([key isEqualToString:@"部门"]) {
            _glCard.depart = value;
            DLog(@"depart=====save:%@",value);
        }else if ([key isEqualToString:@"公司邮箱"]){
            _glCard.mails = value;
            DLog(@"company mail=======save:%@",value);
        }
    }
    _glCard.company = company;
    _glCard.address = address;
    _glCard.zipCode = zipCode;
    
    // 对是否为空或格式进行判断，然后把手机，电话，传真，邮箱保存起来
    //    if (mobiles.length==0 && phones.length==0) {
    //        //[self showMessage:@"名片上的电话未空!请至少填写一个手机号码或者电话号码!" withTitile:nil];
    //        //[self warnAlertMessage:@"名片上的电话未空!请至少填写一个手机号码或者电话号码!"];
    //        return;
    //    }
    //
    //    if(company.length==0 && address.length==0){
    //        //[self showMessage:@"名片上的公司信息为空!请至少填写公司或地址中的一项!" withTitile:nil];
    //        //[self warnAlertMessage:@"名片上的公司信息为空!请至少填写公司或地址中的一项!"];
    //        return;
    //    }
    //
    //    //////////////////////validate//////////////////////
    //    //validate mobile
    //    for(NSString *str in [mobiles componentsSeparatedByString:kECardListSeparator]){
    //        if(str.length>0 && ![str isValidMobilePhoneNumber]){
    //            //[self showMessage:@"手机格式错误!" withTitile:nil];
    //
    //            return;
    //        }
    //    }
    //
    //    //validate phone
    //    for(NSString *str in [phones componentsSeparatedByString:kECardListSeparator]){
    //        if(str.length>0 && ![str isValidTelephoneNUmber]){
    //            //[self showMessage:@"电话格式错误!" withTitile:nil];
    //            return;
    //        }
    //    }
    //
    //    //validate fax
    //    for(NSString *str in [faxes componentsSeparatedByString:kECardListSeparator]){
    //        if(str.length>0 && ![str isValidTelephoneNUmber]){
    //            //[self showMessage:@"传真格式错误!" withTitile:nil];
    //            return;
    //        }
    //    }
    //
    //    //validate email
    //    for(NSString *str in [mails componentsSeparatedByString:kECardListSeparator]){
    //        if(str.length>0 && ![str isValidEmail]){
    //            //[self showMessage:@"邮箱格式错误!" withTitile:nil];
    //            return;
    //        }
    //    }
    _glCard.mobiles = mobiles;
    _glCard.tels = phones;
    _glCard.faxs = faxes;
    _glCard.mails = mails;
    
    //save externThree;
    for (NSDictionary *dic in _fieldExternThree) {
        NSString *key = [dic objectForKey:@"key"];
        DLog(@"key======%@",key);
        NSString *value = [dic objectForKey:@"value"];
        if ([key isEqualToString:@"网址"]) {
            _glCard.web = value;
            
        }else if ([key isEqualToString:@"QQ"]){
            _glCard.qq = value;
            
        }else if ([key isEqualToString:@"MSN"]){
            _glCard.msn = value;
            
        }else if ([key isEqualToString:@"旺旺"]){
            _glCard.wangwang = value;
            
        }else if ([key isEqualToString:@"业务范围"]){
            DLog(@"业务范围=====save:%@",value);
            
        }else if ([key isEqualToString:@"开户行"]){
            DLog(@"开户行=====save:%@",value);
            
        }else if ([key isEqualToString:@"银行帐号"]){
            DLog(@"银行帐号=====save:%@",value);
            
        }else if ([key isEqualToString:@"户名"]){
            DLog(@"户名======save:%@",value);
            
        }else if ([key isEqualToString:@"其它信息"]){
            DLog(@"其它信息======save:%@",value);
            
        }
    }
    // 保存到数据库或调用网络接口
    
    


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

