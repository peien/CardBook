//
//  KHHVisitRecoardVC.m
//  tempPRO
//
//  Created by 王国辉 on 12-8-28.
//  Copyright (c) 2012年 ghWang. All rights reserved.
//

#import "KHHVisitRecoardVC.h"
#import "KHHHomeViewController.h"
#import "KHHShowHideTabBar.h"
#import "TSLocateView.h"
#import "KHHAddImageView.h"
#import "MapController.h"
#import "KHHAddImageCell.h"
#import "KHHFullFrameController.h"
#import "KHHVisitedPickVC.h"
#import "MBProgressHUD.h"
#import "KHHClasses.h"
#import "KHHData+UI.h"
#import "MBProgressHUD.h"
#import "KHHAppDelegate.h"
#import "NSString+SM.h"
#import "UIImageView+WebCache.h"
#import "KHHLocalNotificationUtil.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "KHHBMapLocationController.h"

#define TEXTFIELD_OBJECT_TAG  5550
#define TEXTFIELD_DATE_TAG    5551
#define TEXTFIELD_TIME_TAG    5552
#define NOTE_BTN_TAG          3312
#define NOTE_FIELD_TAG        3313
#define TEXTFIELD_ADDRESS_TAG 3314
#define TEXTFIELD_JOINER_TAG  3315
#define TEXTVISIT_ALERT_TITLE NSLocalizedString(@"拜访计划提醒",nil)

@interface KHHVisitRecoardVC ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,
                               UINavigationControllerDelegate>

@property (strong, nonatomic) UIImageView     *imgview;
@property (assign, nonatomic) int             currentTag;
@property (strong, nonatomic) UIImageView     *updateImageView;
@property (strong, nonatomic) NSArray         *imageArray;
@property (assign, nonatomic) bool            isFirstLocation;
//@property (strong, nonatomic) NSNumber        *locationLatitude;
//@property (strong, nonatomic) NSNumber        *locationLongitude;
//@property (strong, nonatomic) CLPlacemark     *placeMark;
@property (strong, nonatomic) NSString        *address;
@property (strong, nonatomic) OSchedule       *oSched;
@property (strong, nonatomic) KHHData         *dataCtrl;
@property (strong, nonatomic) MBProgressHUD   *hud;
@property (assign, nonatomic) int             warnMinus;
@property (assign, nonatomic) bool            isDateSelected;
@property (strong, nonatomic) NSDate          *selectDate;
@property (strong, nonatomic) NSMutableDictionary *objectDic;
@property (strong, nonatomic) UIButton        *warnBtn;
@property (assign, nonatomic) bool            isPickerShow;
@property (assign, nonatomic) bool            isNotePickShow;
@property (strong, nonatomic) NSString        *showInfoStr;
@end

@implementation KHHVisitRecoardVC
@synthesize noteArray = _noteArray;
@synthesize datePicker = _datePicker;
@synthesize dateStr = _dateStr;
@synthesize timeStr = _timeStr;
@synthesize isShowDate = _isShowDate;
@synthesize pick = _pick;
@synthesize warnTitleArr = _warnTitleArr;
@synthesize style = _style;
@synthesize isFinishTask = _isFinishTask;
@synthesize isNeedWarn = _isNeedWarn;
@synthesize tempPickArr = _tempPickArr;
@synthesize isWarnBtnClick = _isWarnBtnClick;
@synthesize isAddress = _isAddress;
@synthesize isHaveImage = _isHaveImage;
@synthesize fieldValue = _fieldValue;
@synthesize editLabel = _editLabel;
@synthesize fieldName = _fieldName;
@synthesize imgview = _imgview;
@synthesize index = _index;
@synthesize currentTag = _currentTag;
@synthesize imgArray = _imgArray;
@synthesize timeArr = _timeArr;
@synthesize timeInterval = _timeInterval;
@synthesize tapImgview = _tapImgview;
@synthesize objectNameArr;
@synthesize updateImageView;
@synthesize imageArray;
@synthesize isFirstLocation;
//@synthesize locationLatitude;
//@synthesize locationLongitude;
//@synthesize placeMark;
@synthesize address;
@synthesize visitInfoCard;
@synthesize schedu;
@synthesize oSched;
@synthesize dataCtrl;
@synthesize hud;
@synthesize warnMinus;
@synthesize isDateSelected;
@synthesize selectDate;
@synthesize selectedDateFromCal;
@synthesize isFromCalVC;
@synthesize objectDic;
@synthesize warnBtn;
@synthesize isPickerShow;
@synthesize isNotePickShow;
@synthesize searchCard;
@synthesize showInfoStr;

#pragma mark -
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
    _tempPickArr = [[NSArray alloc] init];
    self.objectNameArr = [[NSMutableArray alloc] init];
    _warnTitleArr = [[NSArray alloc] initWithObjects:@"不提醒", @"30分钟",@"1小时",@"2小时",@"3小时",@"12小时",@"24小时",@"2天",@"3天",@"一周",nil];
    _timeArr = [[NSArray alloc] initWithObjects:@"",@"30",@"1",@"2",@"3",@"12",@"24",@"2",@"3",@"7",nil];
    _noteArray = [[NSArray alloc] initWithObjects:@"初次见面",@"商务洽谈",@"一起吃饭",@"一起喝茶",@"回访客户",@"签订合同", nil];
    _fieldName = [[NSArray alloc] initWithObjects:@"对象",@"日期",@"时间",@"备注",@"位置",@"提醒",@"参与者",@"", nil];
    _imgArray = [[NSMutableArray alloc] init];
    _fieldValue = [[NSMutableArray alloc] initWithObjects:@"",@"",@"",@"",@"",@"",@"", nil];
    self.imageArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"ic_shuaxin1.png"],
                       [UIImage imageNamed:@"ic_shuaxin2.png"],
                       [UIImage imageNamed:@"ic_shuaxin3.png"],
                       [UIImage imageNamed:@"ic_shuaxin4.png"],
                       [UIImage imageNamed:@"ic_shuaxin5.png"],
                       [UIImage imageNamed:@"ic_shuaxin6.png"],
                       nil];
    
    self.objectDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    //如果不是新建，就获取数据让其显示
    if (_style == KVisitRecoardVCStyleShowInfo) {
        [self initViewData];
        self.title = NSLocalizedString(@"编辑详情", nil);
        //是签到就获取当前位置
        if (self.isFinishTask) {
            [self getLocalAddress];
        }
    }else if (_style == KVisitRecoardVCStyleNewBuild){
        self.title = NSLocalizedString(@"新建拜访日志", nil);
        self.isFirstLocation = YES;
        [self getLocalAddress];
        if (![self.visitInfoCard isKindOfClass:[MyCard class]] && self.visitInfoCard) {
           [self.objectDic setObject:self.visitInfoCard forKey:self.visitInfoCard.id.stringValue];
        }
    }

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getVisitObjects];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _theTable = nil;
    _noteArray = nil;
    _datePicker = nil;
    _dateStr = nil;
    _timeStr = nil;
    _pick = nil;
    _warnTitleArr = nil;
    _tempPickArr = nil;
    _fieldValue = nil;
    _editLabel = nil;
    _fieldName = nil;
    self.objectNameArr = nil;
    self.updateImageView = nil;
    self.imageArray = nil;
//    self.locationLongitude = nil;
//    self.locationLatitude = nil;
//    self.placeMark = nil;
    self.address = nil;
    self.visitInfoCard = nil;
    self.schedu = nil;
    self.oSched = nil;
    self.hud = nil;
    self.selectDate = nil;
    self.selectedDateFromCal = nil;
    self.objectDic = nil;
    self.searchCard = nil;
    self.warnBtn = nil;
    self.showInfoStr = nil;
}
#pragma mark -
//选择多个拜访对象
- (void)getVisitObjects{
    if (self.objectNameArr.count > 0 || self.visitInfoCard.name.length > 0) {
        if (self.searchCard) {
            [self.objectNameArr addObject:self.searchCard];
        }
        DLog(@"self.objectNameArr ====== %@",self.objectNameArr);
        NSMutableString *nameObj = [[NSMutableString alloc] init];
        for (int i = 0; i < self.objectNameArr.count; i++) {
            Card *card = [self.objectNameArr objectAtIndex:i];
            
            NSString * nameWithCompany = [self combineNameAndCompany:card];
            if (!nameWithCompany) {
                continue;
            }
            
            //用分号与前一个分开
            if (nameObj.length > 0) {
                [nameObj appendString:KHH_SEMICOLON];
            }
            
            //添加名称项
            [nameObj appendString:nameWithCompany];
            
            [self.objectDic setObject:card forKey:card.id.stringValue];
        }
        
        UITextField *objectTf = (UITextField *)[self.view viewWithTag:TEXTFIELD_OBJECT_TAG];
        NSString * oldCustomer = objectTf.text;
        if (oldCustomer && oldCustomer.length > 0) {
            if ([oldCustomer hasSuffix:KHH_SEMICOLON]) {
                objectTf.text = [NSString stringWithFormat:@"%@%@",oldCustomer , nameObj];
            }else {
                objectTf.text = [NSString stringWithFormat:@"%@%@%@",oldCustomer , KHH_SEMICOLON, nameObj];
            }
        }else {
            objectTf.text = nameObj;
        }
        
        [self.objectNameArr removeAllObjects];
        self.searchCard = nil;
    }
}

- (void)initViewData
{
    //获取对象模型，填充fieldvalue
    if (self.schedu.targets != nil) {
        NSMutableString *names = [[NSMutableString alloc] init];
        //用户手动输入的拜访客户
        if (self.schedu.customer) {
            [names appendString:self.schedu.customer];
        }
        
        NSArray *objects = [self.schedu.targets allObjects];
        for (int i = 0; i < objects.count; i++) {
            Card *cardObj = [objects objectAtIndex:i];
            NSString *nameWithCompany = [self combineNameAndCompany:cardObj];
            if (nameWithCompany) {
                //用逗号与前一个分开
                if (names.length > 0) {
                    [names appendString:KHH_SEMICOLON];
                }
                
                [names appendString:nameWithCompany];
            }
            [self.objectDic setObject:cardObj forKey:cardObj.id.stringValue];
        }
        self.showInfoStr = names;
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
        self.address = allAddress;
    }
    if (self.schedu.minutesToRemind) {
        NSString *warnTitle;
        DLog(@"self.schedu.minutesToRemind: %d",self.schedu.minutesToRemindValue);
        int32_t minutes = self.schedu.minutesToRemindValue;
        if (minutes == 0) {
            warnTitle = @"不提醒";
        }else if (minutes == 30){
            warnTitle = @"30分钟";
            _timeInterval = 30*60;
        }else if (minutes/60 == 1){
            warnTitle = @"1小时";
            _timeInterval = 60*60;
        }else if (minutes/60 == 2){
            warnTitle = @"2小时";
            _timeInterval = 2*60*60;
        }else if (minutes/60 == 3){
            warnTitle = @"3小时";
            _timeInterval = 3*60*60;
        }else if (minutes/60 == 12){
            warnTitle = @"12小时";
            _timeInterval = 12*60*60;
        }else if (minutes/60 == 24){
            warnTitle = @"24小时";
            _timeInterval = 24*60*60;
        }else if (minutes/24*60 == 2){
            warnTitle = @"2天";
            _timeInterval = 2*24*60*60;
        }else if (minutes/24*60 == 3){
            warnTitle = @"3天";
            _timeInterval = 3*24*60*60;
        }else if (minutes/7*24*60){
           warnTitle = @"一周";
            _timeInterval = 7*24*60*60;
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
- (void)rightBarButtonClick:(id)sender
{
    //注册新建或修改拜访计划消息
    [self observeNotificationName:KHHUICreateVisitScheduleSucceeded selector:@"handleCreateVisitScheduleSucceeded:"];
    [self observeNotificationName:KHHUICreateVisitScheduleFailed selector:@"handleCreateVisitScheduleFailed:"];
    [self observeNotificationName:KHHUIUpdateVisitScheduleSucceeded selector:@"handleUpdateVisitScheduleSucceeded:"];
    [self observeNotificationName:KHHUIUpdateVisitScheduleFailed selector:@"handleUpdateVisitScheduleFailed:"];
    [self saveVisitRecordInfo];
}
// 保存或新建拜访计划
- (void)saveVisitRecordInfo
{
    UITextField *note = (UITextField *)[self.view viewWithTag:NOTE_FIELD_TAG];
    UITextField *joiner = (UITextField *)[self.view viewWithTag:TEXTFIELD_JOINER_TAG];

    //调用数据库接口，或者是网络接口
    self.oSched.id = self.schedu.id;
    
    NSArray *nameArr = [self.objectDic allValues];
    self.oSched.targetCardList = [[NSMutableArray alloc] initWithArray:nameArr];
    
//    self.oSched.minutesToRemind = [NSNumber numberWithInt:warnMinus];
    //保存用户手动输入的名称(若拜访对象是从联系人中选择的，就不用传这个参数，此参数只传用户手动输入的对象)
    self.oSched.customer = [self userInputCustomerName];
    self.oSched.companion = joiner.text;
    self.oSched.content = note.text;
    
    self.oSched.minutesToRemind = [NSNumber numberWithDouble:_timeInterval/60];
    self.oSched.imageList = self.imgArray;
//    //默认定位取省市信息的方法
//    self.oSched.addressProvince = [NSString stringWithFormat:@"%@",
//                                   [NSString stringFromObject:self.placeMark.administrativeArea]];
//    self.oSched.addressCity = [NSString stringWithFormat:@"%@",
//                               [NSString stringFromObject:self.placeMark.locality]];
//    self.oSched.addressOther = [NSString stringWithFormat:@"%@",
//                                [NSString stringFromObject:self.placeMark.thoroughfare]];
    KHHBMapLocationController *locaVC = [KHHBMapLocationController sharedController];
    BMKGeocoderAddressComponent * addrComp = locaVC.userAddressCompenent;
    if (addrComp) {
        self.oSched.addressProvince = [NSString stringWithFormat:@"%@" ,addrComp.province];
        self.oSched.addressCity = [NSString stringWithFormat:@"%@" ,addrComp.city];
        self.oSched.addressOther = [NSString stringWithFormat:@"%@%@%@" ,addrComp.district,addrComp.streetName,addrComp.streetNumber];
    }
    
    if (self.isDateSelected) {
        [self timeIntervalFromDateToNow:self.selectDate];
    }else{
        self.oSched.plannedDate = [self dateFromString];
        [self timeIntervalFromDateToNow:self.oSched.plannedDate];
    }
    if (self.isFinishTask) { //如果点签到，就拜访完成
        self.oSched.isFinished = [NSNumber numberWithBool:YES];
    }
    if (self.isFromCalVC) { //从日历界面选择的默认日期
        self.oSched.plannedDate = [self dateFromString];
    }
    KHHAppDelegate *app = (KHHAppDelegate *)[UIApplication sharedApplication].delegate;
    self.hud = [MBProgressHUD showHUDAddedTo:app.window animated:YES];
    
    if (_style == KVisitRecoardVCStyleNewBuild) {
        self.hud.labelText = KHHMessageCreateVisitPlant;
        NSArray *cards = [self.dataCtrl allMyCards];
        if (cards) {
            MyCard *mycard = [cards objectAtIndex:0];
            [self.dataCtrl createSchedule:self.oSched withMyCard:mycard];
        }
        
    }else if (_style == KVisitRecoardVCStyleShowInfo){
        self.hud.labelText = KHHMessageModifyVisitPlant;
        [self.dataCtrl updateSchedule:self.oSched];
    }
}
//将来过去的五分钟之内，拜访完成
//选择的时间如果是当前时间的前后5分钟之内都认为签到完成
- (void)timeIntervalFromDateToNow:(NSDate *)date{
    double selectMs = [date timeIntervalSince1970];
    double nowS = [[NSDate date] timeIntervalSince1970];
    self.oSched.plannedDate = date;
    if (selectMs - nowS > 5*60.000) {
        self.oSched.isFinished = [NSNumber numberWithBool:NO];
    }else if (selectMs - nowS > -5*60.000 || selectMs - nowS <= 5*60.000){
        self.oSched.isFinished = [NSNumber numberWithBool:YES];
    }
}
#pragma mark - 
- (void)handleCreateVisitScheduleSucceeded:(NSNotification *)info{
    DLog(@"handleCreateVisitScheduleSucceeded! ====== %@",info);
    [self.hud hide:YES];
    [self stopObservingForCreateVisitedSch];
    [self addEventForCalendar];
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)handleCreateVisitScheduleFailed:(NSNotification *)info{
    DLog(@"KHHUICreateVisitScheduleFailed! ====== %@",info);
    [self.hud hide:YES];
    [self stopObservingForCreateVisitedSch];
    NSString *message = nil;
    if ([[info.userInfo objectForKey:@"errorCode"]intValue] == KHHErrorCodeConnectionOffline){
        message = KHHMessageNetworkEorror;
    }
    [[[UIAlertView alloc] initWithTitle:nil
                                message:message
                               delegate:nil
                      cancelButtonTitle:KHHMessageSure
                      otherButtonTitles:nil] show];
}
- (void)handleUpdateVisitScheduleSucceeded:(NSNotification *)info{
    DLog(@"handleUpdateVisitScheduleSucceeded! ====== %@",info);
    [self.hud hide:YES];
    [self stopObservingForUpdateVisitedSch];
    [self addEventForCalendar];
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)handleUpdateVisitScheduleFailed:(NSNotification *)info{
    DLog(@"handleUpdateVisitScheduleFailed! ====== %@",info);
    [self.hud hide:YES];
    [self stopObservingForUpdateVisitedSch];
    [[[UIAlertView alloc] initWithTitle:nil
                                message:KHHMessageSaveFailed
                               delegate:nil
                      cancelButtonTitle:KHHMessageSure
                      otherButtonTitles:nil] show];

}
- (void)stopObservingForCreateVisitedSch{
    [self stopObservingNotificationName:KHHUICreateVisitScheduleSucceeded];
    [self stopObservingNotificationName:KHHUICreateVisitScheduleFailed];
}
- (void)stopObservingForUpdateVisitedSch{
    [self stopObservingNotificationName:KHHUIUpdateVisitScheduleSucceeded];
    [self stopObservingNotificationName:KHHUIUpdateVisitScheduleFailed];
}

#pragma mark -
- (void)datePickerValueChanged:(UIDatePicker *)sender
{
    self.isDateSelected = YES;
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    NSDate *date = datePicker.date;
    double intervalOne = [date timeIntervalSince1970];
    double intervalTwo = [[NSDate date] timeIntervalSince1970];
    //选择时间是当前时间前5分钟外认为无效时间
    if (intervalOne - intervalTwo < -5*60) {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"选择的拜访时间有误！"
                                   delegate:nil
                          cancelButtonTitle:KHHMessageSure
                          otherButtonTitles: nil] show];
        return;
    }
    self.selectDate = date;
    NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
    [dateForm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *showDAte = [dateForm stringFromDate:date];
    NSLog(@"%@",showDAte);
    NSArray *dateArr = [showDAte componentsSeparatedByString:@" "];
    _dateStr = [dateArr objectAtIndex:0];
    _timeStr = [dateArr objectAtIndex:1];
    if (_isShowDate) {
        UITextField *tf = (UITextField *)[self.view viewWithTag:TEXTFIELD_DATE_TAG];
        tf.text = _dateStr;
        
    }else{
        UITextField *tf = (UITextField *)[self.view viewWithTag:TEXTFIELD_TIME_TAG];
        tf.text = _timeStr;
    }
}
#pragma mark - TABLEVIEW_DELEGATE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4) {
        return 44;
    }else if (indexPath.row == 7){
        return 75;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        if (indexPath.row == 0) {
            UIButton *objectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            objectBtn.frame = CGRectMake(280, 0, 35, 35);
            [objectBtn addTarget:self action:@selector(objectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [objectBtn setBackgroundImage:[UIImage imageNamed:@"contact_select.png"] forState:UIControlStateNormal];
            [cell.contentView addSubview:objectBtn];
            textField.tag = TEXTFIELD_OBJECT_TAG;
            if (_style == KVisitRecoardVCStyleNewBuild) {
                textField.placeholder = @"请选择拜访对象";
                //设置默认值（每次出现cell的时候都会调，但只有第一次真正的会赋值，后面再调都被忽略了？？？？？？就不会把最新值存在临时变量中了）
                if (![self.visitInfoCard isKindOfClass:[MyCard class]] && self.visitInfoCard && (!textField.text || textField.text.length > 0)) {
                    NSString *defaultCustomer = [self combineNameAndCompany:self.visitInfoCard];
                    if (defaultCustomer) {
                        textField.text = defaultCustomer;
                    }
                }
            }else if (_style == KVisitRecoardVCStyleShowInfo){
                textField.text = [_fieldValue objectAtIndex:indexPath.row];
                objectBtn.hidden = YES;
                textField.enabled = NO;
            }
            if (self.isFinishTask || [self.schedu.isFinished isEqualToNumber:[NSNumber numberWithBool:NO]]) {
                textField.text = [_fieldValue objectAtIndex:indexPath.row];
                objectBtn.hidden = NO;
                textField.enabled = YES;
            }
            //20121123 wdf add 不让输入拜访客户，输入了也没有上传至服务器
//            textField.enabled = NO;
            
        }else if (indexPath.row == 1){
            textField.enabled = NO;
            textField.tag = TEXTFIELD_DATE_TAG;
            if (_style == KVisitRecoardVCStyleNewBuild) {
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
            }else if (_style == KVisitRecoardVCStyleShowInfo){
                textField.text = [_fieldValue objectAtIndex:1];
            }

        }else if (indexPath.row == 2){
            textField.enabled = NO;
            textField.tag = TEXTFIELD_TIME_TAG;
            if (_style == KVisitRecoardVCStyleNewBuild) {
                textField.text = _timeStr;
            }else if (_style == KVisitRecoardVCStyleShowInfo){
                textField.text = [_fieldValue objectAtIndex:2];
            }
        }else if (indexPath.row == 3){
            textField.placeholder = @"请输入备注信息（限制400字内）";
            textField.tag = NOTE_FIELD_TAG;
            if (_style == KVisitRecoardVCStyleNewBuild) {
            }else if (_style == KVisitRecoardVCStyleShowInfo){
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
            if (_style == KVisitRecoardVCStyleNewBuild || [self.schedu.isFinished isEqualToNumber:[NSNumber numberWithBool:NO]]) {
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

            }else if(_style == KVisitRecoardVCStyleShowInfo && [self.schedu.isFinished isEqualToNumber:[NSNumber numberWithBool:YES]]){
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
            if (_style == KVisitRecoardVCStyleShowInfo) {
               [warnBtn setTitle:[_fieldValue objectAtIndex:5] forState:UIControlStateNormal];
            }else if(_style == KVisitRecoardVCStyleNewBuild){
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
            if (_style == KVisitRecoardVCStyleShowInfo) {
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
        
        if (_style == KVisitRecoardVCStyleShowInfo) {
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
            
            if (_style == KVisitRecoardVCStyleNewBuild) {
                _imgview.image = [self.imgArray objectAtIndex:i];
            }
            if (_style == KVisitRecoardVCStyleShowInfo) {
                Image *img = [self.imgArray objectAtIndex:i];
                [_imgview setImageWithURL:[NSURL URLWithString:img.url] placeholderImage:[UIImage imageNamed:@"logopic.png"]];
            }
            [cell addSubview:_imgview];
            CGRect moveAddRect = cell.moveView.frame;
            moveAddRect.origin.x = (i+1)*(10+60);
            cell.moveView.frame = moveAddRect;
        }

        if (_imgArray.count == 4) {
            cell.moveView.hidden = YES;
        }
        if (_imgArray.count < 4) {
            cell.moveView.hidden = NO;
        }
        return cell;
    }
    
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (self.isFinishTask || [self.schedu.isFinished isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        return;
    }
    //修改日期和时间
    if ((indexPath.row == 1 || indexPath.row == 2) && (_style == KVisitRecoardVCStyleNewBuild||[self.schedu.isFinished isEqualToNumber:[NSNumber numberWithBool:NO]])) {
        
        KHHVisitedPickVC *pickVC = [[KHHVisitedPickVC alloc] initWithNibName:nil bundle:nil];
        pickVC.isShowTimeValue = YES;
        pickVC.visitVC = self;
        [self.navigationController pushViewController:pickVC animated:YES];
    }
    if (indexPath.row == 2) {
        NSLog(@"选择时间");
        _isShowDate = NO;
        
    }else if (indexPath.row == 1){
        NSLog(@"选择日期");
        _isShowDate = YES;
    }

}
// 保存时，获取用户修改的日期。
- (NSDate *)dateFromString{
    UITextField *dateTf = (UITextField *)[self.view viewWithTag:TEXTFIELD_DATE_TAG];
    UITextField *timeTf = (UITextField *)[self.view viewWithTag:TEXTFIELD_TIME_TAG];
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [NSString stringWithFormat:@"%@ %@",dateTf.text,timeTf.text];
    NSDate *result = [formater dateFromString:dateStr];
    return result;
}

#pragma mark -
#pragma mark TEXTFILD DELEGATES
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self theTableAnimationDown];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag == TEXTFIELD_JOINER_TAG) {
        [self theTableAnimationUp];
    }
    return YES;
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
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UITableViewCell *cell = (UITableViewCell *)[[textField superview] superview];
    DLog(@"cell.text======%@",cell.textLabel.text);
    if ([cell.textLabel.text isEqualToString:@"对象"]) {
        if (textField.text.length == 0) {
            if (self.visitInfoCard) {
                [self.objectDic removeObjectForKey:self.visitInfoCard.id.stringValue]; //移出默认的拜访对象。
            }
        }
        [_fieldValue replaceObjectAtIndex:0 withObject:textField.text];
    }else if ([cell.textLabel.text isEqualToString:@"备注"]){
        [_fieldValue replaceObjectAtIndex:3 withObject:textField.text];
    
    }else if ([cell.textLabel.text isEqualToString:@"参与者"]){
        [_fieldValue replaceObjectAtIndex:6 withObject:textField.text];
    }
}
#pragma mark -
- (void)warnBtnClick:(id)sender
{
    [self regsiFirstRespons];
    KHHVisitedPickVC *pickVC = [[KHHVisitedPickVC alloc] initWithNibName:nil bundle:nil];
    UIButton *btn = (UIButton *)[self.view viewWithTag:2277];
    pickVC.isShowWarnValue = YES;
    pickVC.tempPickArr = _warnTitleArr;
    pickVC.visitVC = self;
    pickVC.visitedUpdateVale = btn;
    [self.navigationController pushViewController:pickVC animated:YES];

}
//定位
- (void)showMap:(id)sender
{
    UITextField *addressMap = (UITextField *)[self.view viewWithTag:TEXTFIELD_ADDRESS_TAG];
    MapController *mapVC = [[MapController alloc] initWithNibName:nil bundle:nil];
    mapVC.companyAddr = addressMap.text;
    [self.navigationController pushViewController:mapVC animated:YES];
}

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
- (void)regsiFirstRespons{
    [(UITextField *)[self.view viewWithTag:NOTE_FIELD_TAG] resignFirstResponder];
    [(UITextField *)[self.view viewWithTag:TEXTFIELD_JOINER_TAG] resignFirstResponder];
    [self theTableAnimationDown];
}
//得到地址
- (void)getLocalAddress{
    
    MBProgressHUD *hud1 = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud1.labelText = NSLocalizedString(@"正在获取地址...", nil);
    [self observeNotificationName:KHHLocationUpdateSucceeded selector:@"handleLocationUpdateSucceeded:"];
    [self observeNotificationName:KHHLocationUpdateFailed selector:@"handleLocationUpdateFailed:"];
//    KHHLocationController *locaVC = [KHHLocationController sharedController];
    KHHBMapLocationController *locaVC = [KHHBMapLocationController sharedController];
    [locaVC updateLocation];
}

/*
 用苹果自带的定位的时候定位信息保存的通知的字典中，用百度map时就在KHHBMapLocationController里，
 KHHBMapLocationController提供了返回详细地址及返回分层地址的两个函数
 */
- (void)handleLocationUpdateSucceeded:(NSNotification *)info{
    DLog(@"handleLocationUpdateSucceeded! ====== info is %@",info.userInfo);
    [self stopObservingForUpdateLocation];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    [self performSelector:@selector(stopAnimatingForUPdateLoca) withObject:nil afterDelay:0.5];

    UITextField *addressTf = (UITextField *)[self.view viewWithTag:TEXTFIELD_ADDRESS_TAG];
    KHHBMapLocationController *locaVC = [KHHBMapLocationController sharedController];
    if (locaVC.userDetailLocation.length > 0) {
        addressTf.text = locaVC.userDetailLocation;
    }
    
    if (self.isFirstLocation) {
        self.address = locaVC.userDetailLocation;
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
    _isAddress = NO;//原来弹出地址插件的，现在没用
    _index = 0;
    UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:nil, nil];
    [actSheet addButtonWithTitle:@"本地相册"];
    [actSheet addButtonWithTitle:@"拍照"];
    [actSheet showInView:self.view];
}
//在添加的图片上，添加一个长按 GestureRecognizer
- (void)longPressFunctionOne:(UILongPressGestureRecognizer*)sender
{
    _index = 1;
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                              delegate:self
                                                     cancelButtonTitle:@"取消"
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:nil, nil];
        //[actSheet addButtonWithTitle:@"设为头像"];
        [actSheet addButtonWithTitle:@"删除图片"];
        [actSheet showInView:self.view];
        UIImageView *imgview = (UIImageView *)[sender view];
        _currentTag = imgview.tag;
    }
}
- (void)tapFull:(UITapGestureRecognizer *)sender
{
    self.tapImgview = (UIImageView *)[sender view];
    KHHFullFrameController *fullVC = [[KHHFullFrameController alloc] initWithNibName:nil bundle:nil];
    fullVC.image = self.tapImgview.image;
    [self.navigationController pushViewController:fullVC animated:YES];
}
//点击备注
- (void)noteBtnClick:(id)sender
{
    [self regsiFirstRespons];
    KHHVisitedPickVC *pickVC = [[KHHVisitedPickVC alloc] initWithNibName:nil bundle:nil];
    UITextField *noteTf = (UITextField *)[self.view viewWithTag:NOTE_FIELD_TAG];
    pickVC.isShowNoteValue = YES;
    pickVC.visitVC = self;
    pickVC.tempPickArr = _noteArray;
    pickVC.visitedUpdateVale = noteTf;
    [self.navigationController pushViewController:pickVC animated:YES];
}
- (void)objectBtnClick:(id)sender
{
    //拜访页面
    KHHHomeViewController *homeVC = [[KHHHomeViewController alloc] initWithNibName:nil bundle:nil];
    homeVC.isNormalSearchBar = YES;
    homeVC.visitVC = self;
    [self.navigationController pushViewController:homeVC animated:YES];
}
#pragma mark - ACTIONSHEET_DELEGATE
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0 && _index == 0) {
         NSLog(@"Cancel");
        return;
    }else if (buttonIndex == 1 && _index == 0){
        //地址
        if (_isAddress) { //弹出地址插件(现在直接定位显示位置)
            TSLocateView *locateView = (TSLocateView *)actionSheet;
            TSLocation *location = locateView.locate;
            NSLog(@"country:%@ city:%@ lat:%f lon:%f", location.state,location.city, location.latitude, location.longitude);
            UITextField *tf = (UITextField *)[self.view viewWithTag:TEXTFIELD_ADDRESS_TAG];
            NSString *addStr = [NSString stringWithFormat:@"%@ %@",location.state,location.city];
            tf.text = addStr;
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
            imagePickCtrl.allowsEditing = NO;
            [self presentModalViewController:imagePickCtrl animated:YES];
        }
    }
    if (_index == 1) {
       //长按小图片
        if (buttonIndex == 2) {
            //设为头像
        }else if (buttonIndex == 1){
            DLog(@"注册删除图片消息");
            if (_style == KVisitRecoardVCStyleShowInfo) {
                [self observeNotificationName:KHHUIDeleteImageFromVisitScheduleSucceeded selector:@"handleDeleteImageFromVisitScheduleSucceeded:"];
                [self observeNotificationName:KHHUIDeleteImageFromVisitScheduleFailed selector:@"handleDeleteImageFromVisitScheduleFailed:"];
                [self netWorkWarnShow];
                NSArray *images = [self.schedu.images allObjects];
                Image *img = [images objectAtIndex:_currentTag - 100];
                [self.dataCtrl deleteImage:img fromSchedule:self.schedu];
            }else if (_style == KVisitRecoardVCStyleNewBuild){
                [_imgArray removeObjectAtIndex:_currentTag - 100];
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
    if (_style == KVisitRecoardVCStyleShowInfo) { //当新建的时候，添加图片放在一个本地数组。当修改拜访计划的时候，添加一张或删除一张都立即调用了网络接口。
        DLog(@"调用添加拜访计划图片");
        [self observeNotificationName:KHHUIUploadImageForVisitScheduleSucceeded selector:@"handleUploadImageForVisitScheduleSucceeded:"];
        [self observeNotificationName:KHHUIUploadImageForVisitScheduleFailed selector:@"handleKHHUIUploadImageForVisitScheduleFailed:"];
        [self netWorkWarnShow];
        [self.dataCtrl uploadImage:image forSchedule:self.schedu];
    }else if (_style == KVisitRecoardVCStyleNewBuild){
        [_imgArray addObject:image];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:7 inSection:0];
        [_theTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}
//添加图片成功
- (void)handleUploadImageForVisitScheduleSucceeded:(NSNotification *)info{
    [self stopObservingForUploadImage];
    //上传成功以后，刷新单元格显示；
    DLog(@"handleUploadImageForVisitScheduleSucceeded!");
    [self netWorkWarnHide];
    //[self updateImageArray];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:7 inSection:0];
    [_theTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
//添加图片失败
- (void)handleKHHUIUploadImageForVisitScheduleFailed:(NSNotification *)info{
    [self stopObservingForDelImage];
    DLog(@"handleKHHUIUploadImageForVisitScheduleFailed!");
    [self netWorkWarnHide];
    [[[UIAlertView alloc] initWithTitle:nil
                                message:@"添加图片失败"
                               delegate:nil
                      cancelButtonTitle:KHHMessageSure
                      otherButtonTitles: nil] show];
}
//删除图片成功
- (void)handleDeleteImageFromVisitScheduleSucceeded:(NSNotification *)info{
    [self stopObservingForDelImage];
    [self netWorkWarnHide];
    //[self updateImageArray];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:7 inSection:0];
    [_theTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
//删除图片失败
- (void)handleDeleteImageFromVisitScheduleFailed:(NSNotification *)info{
    [self stopObservingForDelImage];
    [self netWorkWarnHide];
    [self netWorkWarnHide];
    [[[UIAlertView alloc] initWithTitle:nil
                                message:@"删除图片失败"
                               delegate:nil
                      cancelButtonTitle:KHHMessageSure
                      otherButtonTitles: nil] show];
}
- (void)stopObservingForUploadImage{
    
    [self stopObservingNotificationName:KHHUIUploadImageForVisitScheduleSucceeded];
    [self stopObservingNotificationName:KHHUIUploadImageForVisitScheduleFailed];
}
- (void)stopObservingForDelImage{
    [self stopObservingNotificationName:KHHUIDeleteImageFromVisitScheduleSucceeded];
    [self stopObservingNotificationName:KHHUIDeleteImageFromVisitScheduleFailed];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self performSelector:@selector(handlePickedImage:) withObject:image afterDelay:0.1];
    [self dismissModalViewControllerAnimated:YES];
}
- (void)netWorkWarnShow{
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}
- (void)netWorkWarnHide{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
}
//向日历中添加事件
- (void)addEventForCalendar{
    //已完成的事件不添加到提醒中
    if (self.oSched || self.oSched.isFinished > [NSNumber numberWithBool:YES]) {
        return;
    }
    UIButton *btn = (UIButton *)[self.view viewWithTag:2277];
    if ([btn.titleLabel.text isEqualToString:@"不提醒"]) {
        return;
    }
    
    //获取拜访客户名称
    NSString *customerName = nil;
    UITextField *objectTf = (UITextField *)[self.view viewWithTag:TEXTFIELD_OBJECT_TAG];
    if (objectTf) {
        customerName = objectTf.text;
    }
    
    //系统6.0以上时把事件存到系统日历事件中，6.0以下的用UIlocalNotification提醒
    if([self checkIsDeviceVersionHigherThanRequiredVersion:@"6.0"]) {
        EKEventStore *eventStore = [[EKEventStore alloc] init];
        EKEvent *event = [EKEvent eventWithEventStore:eventStore];    
    	[eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        	if (granted){
            	NSDate *endDate = [self dateFromString];
                NSDate *startDate = [endDate dateByAddingTimeInterval:-(_timeInterval)];
                if (customerName) {
                    event.title = [NSString stringWithFormat:@"%@[%@]",TEXTVISIT_ALERT_TITLE,customerName];
                }else {
                    event.title = TEXTVISIT_ALERT_TITLE;
                }
                event.startDate = startDate;
                event.endDate = endDate;
                if (_timeInterval != 0) {
                EKAlarm *alerm = [EKAlarm alarmWithAbsoluteDate:startDate];
                [event addAlarm:alerm];
                }
                [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                NSError *error;
                [eventStore saveEvent:event span:EKSpanThisEvent error:&error];
                if (error.code == noErr) {
                    DLog(@"事件保存成功！");
                }else{
                    DLog(@"事件保存失败！");
                }
            }
        }];
    }else{
        //----- codes here when user NOT allow your app to access the calendar.
//        [[[UIAlertView alloc] initWithTitle:nil
//                                    message:@"由于系统版本小于6.0,不能访问日历且添加拜访事件！"
//                                   delegate:nil
//                          cancelButtonTitle:KHHMessageSure
//                          otherButtonTitles:nil] show];
        [self localNotificationWithCustomerName:customerName];
    }
}
- (BOOL)checkIsDeviceVersionHigherThanRequiredVersion:(NSString *)requiredVersion
	{
    	NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    	if ([currSysVer compare:requiredVersion options:NSNumericSearch] != NSOrderedAscending)
        	{
            	return YES;
            }
    	        return NO;
    }
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//uilocalNotification
-(void) localNotificationWithCustomerName:(NSString *) customerName{
    NSString * alertBody = nil;
    if (customerName) {
        alertBody = [NSString stringWithFormat:@"%@[%@]",TEXTVISIT_ALERT_TITLE,customerName];
    }else {
        alertBody = TEXTVISIT_ALERT_TITLE;
    }
    NSDate *endDate = [self dateFromString];
    NSDate *startDate = [endDate dateByAddingTimeInterval:-(_timeInterval)];
    //添加到应用里
    [KHHLocalNotificationUtil addLocalNotifiCation:startDate alertBody:alertBody];
}

/*  从拜访对象中过滤出用户手动输入的对象
 *  非手动输入的只要在id里把联系人id传入，type中传入type就行了
 */
-(NSString *) userInputCustomerName{
    if (!self.oSched.targetCardList || self.oSched.targetCardList.count <= 0) {
        return nil;
    }

    UITextField *objectTf = (UITextField *)[self.view viewWithTag:TEXTFIELD_OBJECT_TAG];
    if (!objectTf) {
        return nil;
    }
    
    NSString *customerName = objectTf.text;
    //要过滤的客户名称
    NSArray *names = [customerName componentsSeparatedByString:KHH_SEMICOLON];
    //保留的客户名称
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:names];
    for (id subCard  in self.oSched.targetCardList) {
        if ([subCard isKindOfClass:[Card class]]) {
            Card *card = (Card *) subCard;
            NSString * nameWithCompany = [self combineNameAndCompany:card];
            if (!nameWithCompany) {
                continue;
            }
            //在目标array中找有就删除
            NSInteger index = [array indexOfObject:nameWithCompany];
            if (index >= 0) {
                [array removeObjectAtIndex:index];
            }
        }
    }
    
    //保存在服务器上时是用“|”隔开的
    return [array componentsJoinedByString:KHH_SEPARATOR];
}

-(NSString *) combineNameAndCompany:(Card *) card {
    if (!card) {
        return nil;
    }
    
    NSMutableString *nameObj = [[NSMutableString alloc] init];
    
    //姓名
    NSString *name = [NSString stringByFilterNilFromString:card.name];
    if (name.length) {
        [nameObj appendString:[NSString stringWithFormat:@"%@",name]];
    }else {
        //名称为空时添加一个空格作为标识
        [nameObj appendString:@" "];
    }
    
    //公司
    if (card.company && card.company.name && card.company.name.length > 0) {
        NSString *company = [NSString stringByFilterNilFromString:card.company.name];
        if (company.length > 0) {
            [nameObj appendString:[NSString stringWithFormat:@"(%@)",company]];
        }
    }
    
    return nameObj;
}


@end
