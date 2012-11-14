//
//  KHHTempVisitedVC.m
//  CardBook
//
//  Created by 王国辉 on 12-11-14.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHTempVisitedVC.h"
#import "KHHClasses.h"
#import "KHHAddImageCell.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "KHHLocationController.h"
#import "KHHFullFrameController.h"
#import "KHHData+UI.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#define TEXTFIELD_OBJECT_TAG  5550
#define TEXTFIELD_DATE_TAG    5551
#define TEXTFIELD_TIME_TAG    5552
#define NOTE_BTN_TAG          3312
#define NOTE_FIELD_TAG        3313
#define TEXTFIELD_ADDRESS_TAG 3314
#define TEXTFIELD_JOINER_TAG  3315

@interface KHHTempVisitedVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) NSArray *fieldName;
@property (strong, nonatomic) NSMutableArray *fieldValue;
@property (strong, nonatomic) UIImageView     *updateImageView;
@property (strong, nonatomic) UIButton        *warnBtn;
@property (strong, nonatomic) NSArray         *imageArray;
@property (strong, nonatomic) NSString        *address;
@property (strong, nonatomic) NSArray         *warnTitleArr;
@property (strong, nonatomic) NSMutableArray  *imgArray;
@property (strong, nonatomic) UIImageView     *imgview;
@property (assign, nonatomic) bool            isFirstLocation;
@property (assign, nonatomic) bool            isPickerShow;
@property (assign, nonatomic) bool            isShowDate;
@property (assign, nonatomic) bool            isNotePickShow;
@property (strong, nonatomic) NSNumber        *locationLatitude;
@property (strong, nonatomic) NSNumber        *locationLongitude;
@property (strong, nonatomic) CLPlacemark     *placeMark;
@property (strong, nonatomic) UIImageView     *tapImgview;
@property (assign, nonatomic) int             currentTag;
@property (strong, nonatomic) OSchedule       *oSched;
@property (strong, nonatomic) KHHData         *dataCtrl;
@property (strong, nonatomic) NSMutableString *defaultVisitedName;
@property (strong, nonatomic) NSMutableDictionary *objectDic;

@end

@implementation KHHTempVisitedVC
@synthesize style = _style;
@synthesize fieldName = _fieldName;
@synthesize fieldValue = _fieldValue;
@synthesize dateStr = _dateStr;
@synthesize timeStr = _timeStr;
@synthesize isNeedWarn = _isNeedWarn;
@synthesize warnTitleArr = _warnTitleArr;
@synthesize imgview = _imgview;
@synthesize isAddress = _isAddress;
@synthesize isHaveImage = _isHaveImage;
@synthesize index = _index;
@synthesize currentTag = _currentTag;
@synthesize isShowDate = _isShowDate;
@synthesize datePicker = _datePicker;
@synthesize pick = _pick;
@synthesize isWarnBtnClick = _isWarnBtnClick;
@synthesize noteArray = _noteArray;
@synthesize tempPickArr = _tempPickArr;
@synthesize schedu;
@synthesize isFromCalVC;
@synthesize isFinishTask;
@synthesize updateImageView;
@synthesize warnBtn;
@synthesize selectedDateFromCal;
@synthesize imageArray;
@synthesize address;
@synthesize imgArray;
@synthesize visitInfoCard;
@synthesize isFirstLocation;
@synthesize locationLatitude;
@synthesize locationLongitude;
@synthesize placeMark;
@synthesize tapImgview;
@synthesize oSched;
@synthesize dataCtrl;
@synthesize defaultVisitedName;
@synthesize objectDic;
@synthesize isPickerShow;
@synthesize isNotePickShow;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
        self.oSched = [[OSchedule alloc] init];
        self.dataCtrl = [KHHData sharedData];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSDate *now = [NSDate date];
    NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
    [dateForm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *showDAte = [dateForm stringFromDate:now];
    NSLog(@"%@",showDAte);
    NSArray *dateArr = [showDAte componentsSeparatedByString:@" "];
    _dateStr = [dateArr objectAtIndex:0];
    _timeStr = [dateArr objectAtIndex:1];
    
    _fieldName = [[NSArray alloc] initWithObjects:@"对象",@"日期",@"时间",@"备注",@"位置",@"提醒",@"参与者",@"", nil];
    _fieldValue = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"",@"", nil];
    _warnTitleArr = [[NSArray alloc] initWithObjects:@"不提醒", @"30分钟",@"1小时",@"2小时",@"3小时",@"12小时",@"24小时",@"2天",@"3天",@"一周",nil];
    _tempPickArr = [[NSArray alloc] init];
    _noteArray = [[NSArray alloc] initWithObjects:@"初次见面",@"商务洽谈",@"一起吃饭",@"一起喝茶",@"回访客户",@"签订合同", nil];
    self.imageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"ic_shuaxin1.png"],
                       [UIImage imageNamed:@"ic_shuaxin2.png"],
                       [UIImage imageNamed:@"ic_shuaxin3.png"],
                       [UIImage imageNamed:@"ic_shuaxin4.png"],
                       [UIImage imageNamed:@"ic_shuaxin5.png"],
                       [UIImage imageNamed:@"ic_shuaxin6.png"],
                       nil];
     self.imgArray = [[NSMutableArray alloc] init];
     self.objectDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    //如果不是新建，就获取数据让其显示
    if (_style == KVisitRecoardVCStyleShowInfo1) {
        [self initViewData];
        self.title = NSLocalizedString(@"编辑详情", nil);
    }else if (_style == KVisitRecoardVCStyleNewBuild1){
        self.title = NSLocalizedString(@"新建拜访日志", nil);
        self.isFirstLocation = YES;
        [self getLocalAddress];
        if (![self.visitInfoCard isKindOfClass:[MyCard class]] && self.visitInfoCard) {
            self.defaultVisitedName = [NSMutableString stringWithFormat:@"%@(%@),",self.visitInfoCard.name,self.visitInfoCard.company.name];
            [self.objectDic setObject:self.visitInfoCard forKey:self.visitInfoCard.name];
        }else{
            self.defaultVisitedName = [NSMutableString stringWithCapacity:0];
        }
    }
}
//从网络或数据库获得数据
- (void)initViewData
{
    //获取对象模型，填充fieldvalue
    if (self.schedu.targets != nil) {
        NSMutableString *names = [[NSMutableString alloc] init];
        NSArray *objects = [self.schedu.targets allObjects];
        for (int i = 0; i < objects.count; i++) {
            Card *cardObj = [objects objectAtIndex:i];
            NSString *name = [NSString stringByFilterNilFromString:cardObj.name];
            NSString *companyName = [NSString stringByFilterNilFromString:cardObj.company.name];
            if (name.length > 0) {
                [names appendString:[NSString stringWithFormat:@"%@(%@),",name,companyName]];
            }
        }
        [_fieldValue replaceObjectAtIndex:0 withObject:names];
    }
    if (self.schedu.plannedDate != nil) {
        if (self.isFinishTask) {
            [_fieldValue replaceObjectAtIndex:1 withObject:_dateStr];
            [_fieldValue replaceObjectAtIndex:2 withObject:_timeStr];
        }else{
            NSDateFormatter *form = [[NSDateFormatter alloc] init];
            [form setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *date = [form stringFromDate:self.schedu.plannedDate];
            NSArray *timeArr = [date componentsSeparatedByString:@" "];
            [_fieldValue replaceObjectAtIndex:1 withObject:[timeArr objectAtIndex:0]];
            [_fieldValue replaceObjectAtIndex:2 withObject:[timeArr objectAtIndex:1]];
        }
    }
    if (self.schedu.content.length > 0) {
        [_fieldValue replaceObjectAtIndex:3 withObject:self.schedu.content];
    }
    if (self.schedu.address.other.length > 0) {//地址
        NSString *p = [NSString stringByFilterNilFromString:self.schedu.address.province];
        NSString *c = [NSString stringByFilterNilFromString:self.schedu.address.city];
        NSString *o = [NSString stringByFilterNilFromString:self.schedu.address.other];
        NSString *allAddress = [NSString stringWithFormat:@"%@%@%@",p,c,o];
        [_fieldValue replaceObjectAtIndex:4 withObject:allAddress];
    }
    if (self.schedu.minutesToRemind) {
        NSString *warnTitle;
        DLog(@"self.schedu.minutesToRemind: %d",self.schedu.minutesToRemindValue);
        int32_t minutes = self.schedu.minutesToRemindValue;
        if (minutes == 0) {
            warnTitle = @"不提醒";
        }else if (minutes == 30){
            warnTitle = @"30分钟";
        }else if (minutes/60 == 1){
            warnTitle = @"1小时";
        }else if (minutes/60 == 2){
            warnTitle = @"2小时";
        }else if (minutes/60 == 3){
            warnTitle = @"3小时";
        }else if (minutes/60 == 12){
            warnTitle = @"12小时";
        }else if (minutes/60 == 24){
            warnTitle = @"24小时";
        }else if (minutes/24*60 == 2){
            warnTitle = @"2天";
        }else if (minutes/24*60 == 3){
            warnTitle = @"3天";
        }else if (minutes/7*24*60){
            warnTitle = @"一周";
        }
        [_fieldValue replaceObjectAtIndex:5 withObject:warnTitle];
        
    }
    if (self.schedu.companions.length > 0) {
        [_fieldValue replaceObjectAtIndex:6 withObject:self.schedu.companions];
    }
    if (self.schedu.images.count > 0) {
        //[self updateImageArray];
    }
}
#pragma mark -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4) {
        return 44;
    }else if (indexPath.row == 7){
        return 75;
    }
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 7) {
        static NSString *cellID = @"cellID";
        UITableViewCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = [_fieldName objectAtIndex:indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(65, 0, 220, 37)];
            [tf setBackgroundColor:[UIColor clearColor]];
            tf.leftViewMode = UITextFieldViewModeAlways;
            tf.tag = 9693;
            tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            tf.font = [UIFont systemFontOfSize:13];
            tf.delegate = self;
            [cell.contentView addSubview:tf];
        }
        UITextField *textField = (UITextField *)[cell.contentView viewWithTag:9693];
        UITextField *detail = (UITextField *)[cell.contentView viewWithTag:9694];
        if (indexPath.row == 0) {
            UIButton *objectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            objectBtn.frame = CGRectMake(280, 0, 35, 35);
            [objectBtn addTarget:self action:@selector(objectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [objectBtn setBackgroundImage:[UIImage imageNamed:@"contact_select.png"] forState:UIControlStateNormal];
            [cell.contentView addSubview:objectBtn];
            textField.tag = TEXTFIELD_OBJECT_TAG;
            if (_style == KVisitRecoardVCStyleNewBuild1) {
                textField.placeholder = @"请输入拜访对象";
                //textField.text = self.defaultVisitedName;
            }else if (_style == KVisitRecoardVCStyleShowInfo1){
                textField.text = [_fieldValue objectAtIndex:indexPath.row];
                objectBtn.hidden = YES;
                textField.enabled = NO;
            }
            if (self.isFinishTask || [self.schedu.isFinished isEqualToNumber:[NSNumber numberWithBool:NO]]) {
                objectBtn.hidden = NO;
                textField.enabled = YES;
            }
            
        }else if (indexPath.row == 1){
            textField.enabled = NO;
            textField.tag = TEXTFIELD_DATE_TAG;
            if (_style == KVisitRecoardVCStyleNewBuild1) {
                textField.text = _dateStr;
                if (self.isFromCalVC && self.selectedDateFromCal != nil) {
                    NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
                    [dateForm setDateFormat:@"yyyy-MM-dd HH:mm"];
                    NSString *showDAte = [dateForm stringFromDate:self.selectedDateFromCal];
                    NSArray *dateArr = [showDAte componentsSeparatedByString:@" "];
                    textField.text = [dateArr objectAtIndex:0];
                }else{
                    textField.text = _dateStr;
                }
            }else if (_style == KVisitRecoardVCStyleShowInfo1){
                textField.text = [_fieldValue objectAtIndex:1];
            }
            
        }else if (indexPath.row == 2){
            textField.enabled = NO;
            textField.tag = TEXTFIELD_TIME_TAG;
            if (_style == KVisitRecoardVCStyleNewBuild1) {
                textField.text = _timeStr;
            }else if (_style == KVisitRecoardVCStyleShowInfo1){
                textField.text = [_fieldValue objectAtIndex:2];
            }
        }else if (indexPath.row == 3){
            textField.placeholder = @"请输入备注信息（限制400字内）";
            textField.tag = NOTE_FIELD_TAG;
            if (_style == KVisitRecoardVCStyleNewBuild1) {
            }else if (_style == KVisitRecoardVCStyleShowInfo1){
                textField.text = [_fieldValue objectAtIndex:indexPath.row];
            }
            if (YES) {
                UIButton *noteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                noteBtn.frame = CGRectMake(280, 5, 30, 30);
                [noteBtn setBackgroundImage:[UIImage imageNamed:@"beizhu_btn.png"] forState:UIControlStateNormal];
                noteBtn.tag = NOTE_BTN_TAG;
                [noteBtn addTarget:self action:@selector(noteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:noteBtn];
            }
            
        }else if (indexPath.row == 4){
            textField.enabled = NO;
            textField.tag = TEXTFIELD_ADDRESS_TAG;
            detail.hidden = NO;
            if (_style == KVisitRecoardVCStyleNewBuild1 || [self.schedu.isFinished isEqualToNumber:[NSNumber numberWithBool:NO]]) {
                textField.text = [_fieldValue objectAtIndex:indexPath.row];
                textField.text = self.address;
                if (self.updateImageView == nil) {
                    self.updateImageView = [[UIImageView alloc] initWithImage:[self.imageArray objectAtIndex:0]];
                    self.updateImageView.userInteractionEnabled = YES;
                    self.updateImageView.frame = CGRectMake(280, 5, 35, 35);
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateLocation:)];
                    tap.numberOfTapsRequired = 1;
                    tap.numberOfTouchesRequired = 1;
                    [self.updateImageView addGestureRecognizer:tap];
                    [cell addSubview:self.updateImageView];
                }
                
            }else if(_style == KVisitRecoardVCStyleShowInfo1 && [self.schedu.isFinished isEqualToNumber:[NSNumber numberWithBool:YES]]){
                textField.text = [_fieldValue objectAtIndex:indexPath.row];
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setBackgroundImage:[UIImage imageNamed:@"dingwei_green.png"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(showMap:) forControlEvents:UIControlEventTouchUpInside];
                btn.frame = CGRectMake(280, 5, 35, 35);
                [cell.contentView addSubview:btn];
            }
            
        }else if (indexPath.row == 5){
            [textField removeFromSuperview];
            if (self.warnBtn == nil) {
                warnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [warnBtn setBackgroundImage:[[UIImage imageNamed:@"tongbu_normal.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 8, 0, 8)] forState:UIControlStateNormal];
                warnBtn.tag = 2277;
                warnBtn.frame = CGRectMake(80, 8, 180, 37);
                warnBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [warnBtn addTarget:self action:@selector(warnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:warnBtn];
            }
            if (_style == KVisitRecoardVCStyleShowInfo1) {
                [warnBtn setTitle:[_fieldValue objectAtIndex:5] forState:UIControlStateNormal];
            }else if(_style == KVisitRecoardVCStyleNewBuild1){
                [warnBtn setTitle:[_warnTitleArr objectAtIndex:0] forState:UIControlStateNormal];
            }
            if (_isNeedWarn) {
                [warnBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }else{
                [warnBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                warnBtn.enabled = NO;
            }
            
        }else if (indexPath.row == 6){
            textField.placeholder = @"请输入参与者姓名";
            textField.tag = TEXTFIELD_JOINER_TAG;
            if (_style == KVisitRecoardVCStyleShowInfo1) {
                textField.text = [_fieldValue objectAtIndex:indexPath.row];
            }
        }
        return cell;
    }else if (indexPath.row == 7){
        static NSString *cellID1 = @"CELLID1";
        KHHAddImageCell *cell = nil;
        cell = [tableView dequeueReusableCellWithIdentifier:cellID1];
        if (cell == nil) {
            cell = (KHHAddImageCell *)[[[NSBundle mainBundle] loadNibNamed:@"KHHAddImageCell" owner:self options:nil] objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [cell.addBtn addTarget:self action:@selector(addImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (_style == KVisitRecoardVCStyleShowInfo1) {
            NSArray *arr = [self.schedu.images allObjects];
            self.imgArray = [NSMutableArray arrayWithArray:arr];
        }
        for (int i = 0; i<[self.imgArray count]; i++) {
            _imgview = [[UIImageView alloc] init];
            _imgview.userInteractionEnabled = YES;
            if (![self.schedu.isFinished isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFunctionOne:)];
                longpress.allowableMovement = NO;
                longpress.numberOfTouchesRequired = 1;
                longpress.minimumPressDuration = 0.5;
                [_imgview addGestureRecognizer:longpress];
            }
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFull:)];
            tap.numberOfTapsRequired = 1;
            tap.numberOfTouchesRequired = 1;
            [_imgview addGestureRecognizer:tap];
            _imgview.tag = i + 100;
            _imgview.frame = CGRectMake(5+i*(10 + 60), 5, 60, 60);
            
            if (_style == KVisitRecoardVCStyleNewBuild1) {
                _imgview.image = [self.imgArray objectAtIndex:i];
            }
            if (_style == KVisitRecoardVCStyleShowInfo1) {
                Image *img = [self.imgArray objectAtIndex:i];
                [_imgview setImageWithURL:[NSURL URLWithString:img.url] placeholderImage:[UIImage imageNamed:@"logopic.png"]];
            }
            [cell addSubview:_imgview];
            CGRect moveAddRect = cell.moveView.frame;
            moveAddRect.origin.x = (i+1)*(10+60);
            cell.moveView.frame = moveAddRect;
        }
        
        if (self.imgArray.count == 4) {
            cell.moveView.hidden = YES;
        }
        if (self.imgArray.count < 4) {
            cell.moveView.hidden = NO;
        }
        return cell;
    }
    
    return nil;


}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //还要改
    if (self.isFinishTask || [self.schedu.isFinished isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        return;
    }
    
    if ((indexPath.row == 1 || indexPath.row == 2) && (_style == KVisitRecoardVCStyleNewBuild1||[self.schedu.isFinished isEqualToNumber:[NSNumber numberWithBool:NO]])) {
        if (self.isPickerShow) {
            [self animationForDatePickerDown];
        }else{
            [self timerPickerViewAnimation];
        }
        
    }
    if (indexPath.row == 2) {
        NSLog(@"显示时间");
        _isShowDate = NO;
        
    }else if (indexPath.row == 1){
        NSLog(@"显示日期xx");
        _isShowDate = YES;
        
    }else if (indexPath.row == 4){
        _isAddress = YES;
    }
    self.isPickerShow = !self.isPickerShow;
}
#pragma mark -
- (void)updateLocation:(UITapGestureRecognizer *)sender
{
    self.isFirstLocation = NO;
    [self locaIconAnimationIsEnd:NO];
    [self getLocalAddress];
}
//动画
- (void)locaIconAnimationIsEnd:(BOOL)endAnimation{
    self.updateImageView.animationImages = self.imageArray;
    self.updateImageView.animationDuration = 0.3;
    if (endAnimation) {
        [self.updateImageView stopAnimating];
    }else{
        [self.updateImageView startAnimating];
    }
}
//得到地址
- (void)getLocalAddress{
    
    MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud1.labelText = NSLocalizedString(@"正在获取地址...", nil);
    [self observeNotificationName:KHHLocationUpdateSucceeded selector:@"handleLocationUpdateSucceeded:"];
    [self observeNotificationName:KHHLocationUpdateFailed selector:@"handleLocationUpdateFailed:"];
    KHHLocationController *locaVC = [KHHLocationController sharedController];
    [locaVC updateLocation];
}
- (void)handleLocationUpdateSucceeded:(NSNotification *)info{
    DLog(@"handleLocationUpdateSucceeded! ====== info is %@",info.userInfo);
    [self stopObservingForUpdateLocation];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    [self performSelector:@selector(stopAnimatingForUPdateLoca) withObject:nil afterDelay:0.5];
    
    self.locationLatitude = [info.userInfo objectForKey:@"locationLatitude"];
    self.locationLongitude = [info.userInfo objectForKey:@"locationLongitude"];
    self.placeMark = [info.userInfo objectForKey:@"placemark"];
    NSString *province = [NSString stringWithFormat:@"%@",
                          [NSString stringFromObject:self.placeMark.administrativeArea]];
    
    NSString *city = [NSString stringWithFormat:@"%@",
                      [NSString stringFromObject:self.placeMark.locality]];
    NSString *other = [NSString stringWithFormat:@"%@",
                       [NSString stringFromObject:self.placeMark.thoroughfare]];
    NSString *other1 = [NSString stringWithFormat:@"%@",
                        [NSString stringFromObject:self.placeMark.subThoroughfare]];
    
    NSString *detailAddress = [NSString stringWithFormat:@"%@%@%@%@",province,city,other,other1];
    UITextField *addressTf = (UITextField *)[self.view viewWithTag:TEXTFIELD_ADDRESS_TAG];
    //    NSString *addressString = ABCreateStringWithAddressDictionary(self.placeMark.addressDictionary, NO);
    if (detailAddress.length > 0) {
        addressTf.text = detailAddress;
    }
    
    if (self.isFirstLocation) {
        self.address = detailAddress;
        [_theTable reloadData];
    }
}
- (void)handleLocationUpdateFailed:(NSNotification *)info{
    DLog(@"handleLocationUpdateFailed! ====== info is %@",info.userInfo);
    [self stopObservingForUpdateLocation];
    //更新失败还显示原来的位置.
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    [self performSelector:@selector(stopAnimatingForUPdateLoca) withObject:nil afterDelay:0.5];
}
- (void)stopObservingForUpdateLocation{
    [self stopObservingNotificationName:KHHLocationUpdateSucceeded];
    [self stopObservingNotificationName:KHHLocationUpdateFailed];
}
- (void)stopAnimatingForUPdateLoca{
    [self locaIconAnimationIsEnd:YES];
}
#pragma mark -
- (void)addImageBtnClick:(UIButton *)sender
{
    _isHaveImage = YES;
    _isAddress = NO;
    _index = 0;
    UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    [actSheet addButtonWithTitle:@"本地相册"];
    [actSheet addButtonWithTitle:@"拍照"];
    [actSheet showInView:self.view];
    
}
- (void)longPressFunctionOne:(UILongPressGestureRecognizer*)sender
{
    _index = 1;
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
        //[actSheet addButtonWithTitle:@"设为头像"];
        [actSheet addButtonWithTitle:@"删除图片"];
        [actSheet showInView:self.view];
        UIImageView *imgview = (UIImageView *)[sender view];
        _currentTag = imgview.tag;
    }
}
- (void)noteBtnClick:(id)sender
{
    _isWarnBtnClick = NO;
    _tempPickArr = _noteArray;
    [self animationForDatePickerDown];
    if (self.isNotePickShow) {
        [self animationPickDown];
    }else{
        [self animationPickUp];
    }
    [self theTableAnimationDown];
    self.isNotePickShow = !self.isNotePickShow;
}
- (void)tapFull:(UITapGestureRecognizer *)sender
{
    self.tapImgview = (UIImageView *)[sender view];
    KHHFullFrameController *fullVC = [[KHHFullFrameController alloc] initWithNibName:nil bundle:nil];
    fullVC.image = self.tapImgview.image;
    [self.navigationController pushViewController:fullVC animated:YES];
    
}
#pragma mark - ACTIONSHEET_DELEGATE
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 && _index == 0) {
        NSLog(@"Cancel");
        return;
    }else if (buttonIndex == 1 && _index == 0){
        //地址
        if (_isAddress) {
//            TSLocateView *locateView = (TSLocateView *)actionSheet;
//            TSLocation *location = locateView.locate;
//            NSLog(@"country:%@ city:%@ lat:%f lon:%f", location.state,location.city, location.latitude, location.longitude);
//            UITextField *tf = (UITextField *)[self.view viewWithTag:TEXTFIELD_ADDRESS_TAG];
//            NSString *addStr = [NSString stringWithFormat:@"%@ %@",location.state,location.city];
//            tf.text = addStr;
            //You can uses location to your application
        }else{
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                UIImagePickerController *imagePickCtrl = [[UIImagePickerController alloc] init];
                imagePickCtrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePickCtrl.delegate = self;
                [self presentModalViewController:imagePickCtrl animated:YES];
            }
        }
        
    }else if (buttonIndex == 2 && _index == 0){
        //照相机
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePickCtrl = [[UIImagePickerController alloc] init];
            imagePickCtrl.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickCtrl.delegate = self;
            imagePickCtrl.allowsEditing = YES;
            [self presentModalViewController:imagePickCtrl animated:YES];
        }
    }
    if (_index == 1) {
        //长按小图片
        if (buttonIndex == 2) {
            //设为头像
        }else if (buttonIndex == 1){
            DLog(@"注册删除图片消息");
            if (_style == KVisitRecoardVCStyleShowInfo1) {
                [self observeNotificationName:KHHUIDeleteImageFromVisitScheduleSucceeded selector:@"handleDeleteImageFromVisitScheduleSucceeded:"];
                [self observeNotificationName:KHHUIDeleteImageFromVisitScheduleFailed selector:@"handleDeleteImageFromVisitScheduleFailed:"];
                [self netWorkWarnShow];
                NSArray *images = [self.schedu.images allObjects];
                Image *img = [images objectAtIndex:_currentTag - 100];
                [self.dataCtrl deleteImage:img fromSchedule:self.schedu];
            }else if (_style == KVisitRecoardVCStyleNewBuild1){
                [self.imgArray removeObjectAtIndex:_currentTag - 100];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:7 inSection:0];
                [_theTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }
}
#pragma mark -
- (void)handlePickedImage:(UIImage *)image
{
    //注册添加图片消息
    if (_style == KVisitRecoardVCStyleShowInfo1) {
        DLog(@"调用添加拜访计划图片");
        [self observeNotificationName:KHHUIUploadImageForVisitScheduleSucceeded selector:@"handleUploadImageForVisitScheduleSucceeded:"];
        [self observeNotificationName:KHHUIUploadImageForVisitScheduleFailed selector:@"handleKHHUIUploadImageForVisitScheduleFailed:"];
        [self netWorkWarnShow];
        [self.dataCtrl uploadImage:image forSchedule:self.schedu];
    }else if (_style == KVisitRecoardVCStyleNewBuild1){
        [self.imgArray addObject:image];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:7 inSection:0];
        [_theTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    
    //    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
    //        UIImage *oriImage = [editingInfo objectForKey:UIImagePickerControllerOriginalImage];
    //        UIImageWriteToSavedPhotosAlbum(oriImage, nil, nil,nil);
    //    }
    [self performSelector:@selector(handlePickedImage:) withObject:image afterDelay:0.1];
    [self dismissModalViewControllerAnimated:YES];
    
}
- (void)netWorkWarnShow{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}
- (void)netWorkWarnHide{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
}
#pragma mark -
- (void)timerPickerViewAnimation{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect rect = _datePicker.frame;
    rect.origin.y = 200;
    _datePicker.frame = rect;
    [UIView commitAnimations];
}
- (void)animationForDatePickerDown{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect rect = _datePicker.frame;
    rect.origin.y = 430;
    _datePicker.frame = rect;
    [UIView commitAnimations];
}
- (void)animationPickUp{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect rect = _pick.frame;
    rect.origin.y = 200;
    _pick.frame = rect;
    [UIView commitAnimations];
    [_pick reloadAllComponents];
}
- (void)animationPickDown{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect rect = _pick.frame;
    rect.origin.y = 500;
    _pick.frame = rect;
    [UIView commitAnimations];
}
- (void)theTableAnimationUp{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect rect = _theTable.frame;
    rect.origin.y = -100;
    _theTable.frame = rect;
    [UIView commitAnimations];
}
- (void)theTableAnimationDown{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect rect = _theTable.frame;
    rect.origin.y = 0;
    _theTable.frame = rect;
    [UIView commitAnimations];
    
}
#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
