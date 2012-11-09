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
#import "Card.h"
#import "KHHLocationController.h"
#import "MBProgressHUD.h"
#import "KHHClasses.h"
#import "KHHData.h"
#import "OSchedule.h"
#import "KHHData+UI.h"
#import "MBProgressHUD.h"
#import "KHHAppDelegate.h"
#import "NSString+SM.h"
#import "UIImageView+WebCache.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#define TEXTFIELD_OBJECT_TAG  5550
#define TEXTFIELD_DATE_TAG    5551
#define TEXTFIELD_TIME_TAG    5552
#define NOTE_BTN_TAG          3312
#define NOTE_FIELD_TAG        3313
#define TEXTFIELD_ADDRESS_TAG 3314
#define TEXTFIELD_JOINER_TAG  3315

@interface KHHVisitRecoardVC ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic) UIImageView     *imgview;
@property (assign, nonatomic) int             currentTag;
@property (assign, nonatomic) double          timeInterval;
@property (strong, nonatomic) NSTimer         *timer;
@property (strong, nonatomic) UIImageView     *updateImageView;
@property (strong, nonatomic) NSArray         *imageArray;
@property (assign, nonatomic) bool            isFirstLocation;
@property (strong, nonatomic) NSNumber        *locationLatitude;
@property (strong, nonatomic) NSNumber        *locationLongitude;
@property (strong, nonatomic) NSString        *address;
@property (strong, nonatomic) CLPlacemark     *placeMark;
@property (strong, nonatomic) OSchedule       *oSched;
@property (strong, nonatomic) KHHData         *dataCtrl;
@property (strong, nonatomic) MBProgressHUD   *hud;
@property (assign, nonatomic) int             warnMinus;
@property (assign, nonatomic) bool            isDateSelected;
@property (strong, nonatomic) NSDate          *selectDate;
@property (strong, nonatomic) NSMutableString *defaultVisitedName;
@property (strong, nonatomic) NSMutableDictionary *objectDic;
@property (strong, nonatomic) UIButton        *warnBtn;
@property (assign, nonatomic) bool            isPickerShow;
@property (assign, nonatomic) bool            isNotePickShow;
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
@synthesize locationLatitude;
@synthesize locationLongitude;
@synthesize address;
@synthesize placeMark;
@synthesize visitInfoCard;
@synthesize schedu;
@synthesize oSched;
@synthesize dataCtrl;
@synthesize hud;
@synthesize warnMinus;
@synthesize isDateSelected;
@synthesize selectDate;
@synthesize defaultVisitedName;
@synthesize selectedDateFromCal;
@synthesize isFromCalVC;
@synthesize objectDic;
@synthesize warnBtn;
@synthesize isPickerShow;
@synthesize isNotePickShow;
@synthesize searchCard;

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
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    NSDate *now = [NSDate date];
    NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
    [dateForm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *showDAte = [dateForm stringFromDate:now];
    NSLog(@"%@",showDAte);
    NSArray *dateArr = [showDAte componentsSeparatedByString:@" "];
    _dateStr = [dateArr objectAtIndex:0];
    _timeStr = [dateArr objectAtIndex:1];
    [_datePicker setDate:now animated:YES];
    [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
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
    if (self.visitInfoCard) {
        [self.objectDic setObject:self.visitInfoCard forKey:self.visitInfoCard.name];
    }
    //如果不是新建，就获取数据让其显示
    if (_style == KVisitRecoardVCStyleShowInfo) {
        [self initViewData];
        self.title = NSLocalizedString(@"编辑详情", nil);
    }else if (_style == KVisitRecoardVCStyleNewBuild){
        self.title = NSLocalizedString(@"新建拜访日志", nil);
        self.isFirstLocation = YES;
        [self getLocalAddress];
        if (self.visitInfoCard) {
            self.defaultVisitedName = [NSMutableString stringWithFormat:@"%@(%@),",self.visitInfoCard.name,self.visitInfoCard.company.name];
        }
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [KHHShowHideTabBar hideTabbar];
    //[_theTable reloadData];
    [self getVisitObjects];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    

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
    _imgview = nil;
    _imgArray = nil;
    self.objectNameArr = nil;
    self.updateImageView = nil;
    self.imageArray = nil;
    self.locationLongitude = nil;
    self.locationLatitude = nil;
    self.address = nil;
    self.placeMark = nil;
    self.visitInfoCard = nil;
    self.schedu = nil;
    self.oSched = nil;
    self.dataCtrl = nil;
    self.hud = nil;
    self.selectDate = nil;
    self.defaultVisitedName = nil;
    self.selectedDateFromCal = nil;
    self.objectDic = nil;
    self.searchCard = nil;
}
#pragma mark -
//选择多个拜访对象
- (void)getVisitObjects{
    if (self.objectNameArr.count > 0 || self.visitInfoCard.name.length > 0) {
        DLog(@"self.objectNameArr ====== %@",self.objectNameArr);
        NSMutableString *nameObj = [[NSMutableString alloc] init];

        for (int i = 0; i < self.objectNameArr.count; i++) {
            Card *card = [self.objectNameArr objectAtIndex:i];
            if (card.name.length > 0) {
                [nameObj appendString:[NSString stringWithFormat:@"%@(%@),",card.name,card.company.name]];
                [self.objectDic setObject:card forKey:card.name];
            }
        }
        UITextField *objectTf = (UITextField *)[self.view viewWithTag:TEXTFIELD_OBJECT_TAG];
        if (self.searchCard) {
            [self.defaultVisitedName appendString:[NSString stringWithFormat:@"%@(%@),",searchCard.name,self.searchCard.company.name]];
            [self.objectDic setObject:self.searchCard forKey:self.searchCard.name];
        }
        if (self.defaultVisitedName.length > 0) {
            [nameObj insertString:self.defaultVisitedName atIndex:0];
        }
        objectTf.text = nameObj;
        self.defaultVisitedName = nameObj;
        [self.objectNameArr removeAllObjects];
    }
//    if ([self.schedu.isFinished isEqualToNumber:[NSNumber numberWithBool:NO]]) {
//        NSArray *objs = [self.objectDic allValues];
//        NSMutableString *names = [[NSMutableString alloc] initWithCapacity:0];
//        for (Card *card in objs) {
//            [names appendString:[NSString stringWithFormat:@"%@ ",card.name]];
//        }
//         UITextField *objectTf = (UITextField *)[self.view viewWithTag:TEXTFIELD_OBJECT_TAG];
//        objectTf.text = names;
//        self.defaultVisitedName = names;
//    }
}
//动态显示时间
- (void)updateTime
{
    if (_style == KVisitRecoardVCStyleNewBuild) {
        NSDate *dt = [NSDate date];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"HH:mm:ss"];
        UITextField *tf = (UITextField *)[self.view viewWithTag:TEXTFIELD_TIME_TAG];
        tf.text = [df stringFromDate:dt];
    }
}
// 闹钟设置
- (void)setAlerm:(double)timeInterval
{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil)
    {
        NSDate *now=[NSDate new];
        notification.fireDate = [now dateByAddingTimeInterval:timeInterval];
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.alertBody=@"TIME";
        notification.alertBody = [NSString stringWithFormat:@"时间到了!"];
        NSDictionary* info = [NSDictionary dictionaryWithObject:@""forKey:@""];
        notification.userInfo = info;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
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
- (void)rightBarButtonClick:(id)sender
{
    //注册新建或修改拜访计划消息
    [self observeNotificationName:KHHUICreateVisitScheduleSucceeded selector:@"handleCreateVisitScheduleSucceeded:"];
    [self observeNotificationName:KHHUICreateVisitScheduleFailed selector:@"handleCreateVisitScheduleFailed:"];
    [self observeNotificationName:KHHUIUpdateVisitScheduleSucceeded selector:@"handleUpdateVisitScheduleSucceeded:"];
    [self observeNotificationName:KHHUIUpdateVisitScheduleFailed selector:@"handleUpdateVisitScheduleFailed:"];
    [self saveVisitRecordInfo];
}
// 保存
- (void)saveVisitRecordInfo
{
//    UITextField *objects = (UITextField *)[self.view viewWithTag:TEXTFIELD_OBJECT_TAG];
//    UITextField *date = (UITextField *)[self.view viewWithTag:TEXTFIELD_DATE_TAG];
//    UITextField *time = (UITextField *)[self.view viewWithTag:TEXTFIELD_TIME_TAG];
    UITextField *note = (UITextField *)[self.view viewWithTag:NOTE_FIELD_TAG];
    //UIButton *noteBtn = (UIButton *)[self.view viewWithTag:2277];
    //UITextField *addressIn = (UITextField *)[self.view viewWithTag:TEXTFIELD_ADDRESS_TAG];
    UITextField *joiner = (UITextField *)[self.view viewWithTag:TEXTFIELD_JOINER_TAG];

    //调用数据库接口，或者是网络接口
    self.oSched.id = self.schedu.id;
    self.oSched.minutesToRemind = [NSNumber numberWithInt:warnMinus];
    self.oSched.customer = nil;
    self.oSched.companion = joiner.text;
    self.oSched.content = note.text;
    
    self.oSched.minutesToRemind = [NSNumber numberWithDouble:_timeInterval/60];
    
    NSArray *nameArr = [self.objectDic allValues];
    self.oSched.targetCardList = [[NSMutableArray alloc] initWithArray:nameArr];
    
    self.oSched.imageList = self.imgArray;
    self.oSched.addressProvince = [NSString stringWithFormat:@"%@",
                                   [NSString stringFromObject:self.placeMark.administrativeArea]];
    self.oSched.addressCity = [NSString stringWithFormat:@"%@",
                               [NSString stringFromObject:self.placeMark.locality]];
    self.oSched.addressOther = [NSString stringWithFormat:@"%@",
                                [NSString stringFromObject:self.placeMark.thoroughfare]];
    
    if (self.isDateSelected) {
        [self timeIntervalFromDateToNow:self.selectDate];
    }else{
        if (self.selectedDateFromCal != nil) {
            UITextField *timeTf = (UITextField *)[self.view viewWithTag:TEXTFIELD_TIME_TAG];
            NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
            [dateForm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *showDAte = [dateForm stringFromDate:self.selectedDateFromCal];
            NSArray *dateArr = [showDAte componentsSeparatedByString:@" "];
            NSString *dateS = [NSString stringWithFormat:@"%@ %@",[dateArr objectAtIndex:0],timeTf.text];
            NSDate *selectDateUn = [dateForm dateFromString:dateS];
            [self timeIntervalFromDateToNow:selectDateUn];
        }else{
            self.oSched.plannedDate = [NSDate date];
            self.oSched.isFinished = [NSNumber numberWithBool:YES];
        }
    }
    if (self.isFinishTask) {
        self.oSched.isFinished = [NSNumber numberWithBool:YES];
    }
    if (self.isFromCalVC) {
        self.oSched.plannedDate = [self dateFromString];
    }
    KHHAppDelegate *app = (KHHAppDelegate *)[UIApplication sharedApplication].delegate;
    self.hud = [MBProgressHUD showHUDAddedTo:app.window animated:YES];
    
    if (_style == KVisitRecoardVCStyleNewBuild) {
        MyCard *mycard = [[self.dataCtrl allMyCards] lastObject];
        [self.dataCtrl createSchedule:self.oSched withMyCard:mycard];
    }else if (_style == KVisitRecoardVCStyleShowInfo){
        [self.dataCtrl updateSchedule:self.oSched];
    }
}
//将来过去的五分钟之内，拜访完成
- (void)timeIntervalFromDateToNow:(NSDate *)date{
    double selectMs = [date timeIntervalSince1970];
    double nowS = [[NSDate date] timeIntervalSince1970];
    self.oSched.plannedDate = date;
    if (selectMs - nowS > 5*60.000) {
        self.oSched.isFinished = [NSNumber numberWithBool:NO];
    }else if (selectMs - nowS > -5*60.000){
        self.oSched.isFinished = [NSNumber numberWithBool:YES];
    }

}
- (void)handleCreateVisitScheduleSucceeded:(NSNotification *)info{
    DLog(@"handleCreateVisitScheduleSucceeded! ====== %@",info);
    [self.hud hide:YES];
    [self stopObservingForCreateVisitedSch];
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)handleCreateVisitScheduleFailed:(NSNotification *)info{
    DLog(@"KHHUICreateVisitScheduleFailed! ====== %@",info);
    [self.hud hide:YES];
    [self stopObservingForCreateVisitedSch];
    [[[UIAlertView alloc] initWithTitle:nil
                                message:@"拜访内容不能为空"
                               delegate:nil
                      cancelButtonTitle:@"确定"
                      otherButtonTitles:nil] show];
}
- (void)handleUpdateVisitScheduleSucceeded:(NSNotification *)info{
    DLog(@"handleUpdateVisitScheduleSucceeded! ====== %@",info);
    [self.hud hide:YES];
    [self stopObservingForUpdateVisitedSch];
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)handleUpdateVisitScheduleFailed:(NSNotification *)info{
    DLog(@"handleUpdateVisitScheduleFailed! ====== %@",info);
    [self.hud hide:YES];
    [self stopObservingForUpdateVisitedSch];
    [[[UIAlertView alloc] initWithTitle:nil
                                message:@"保存失败"
                               delegate:nil
                      cancelButtonTitle:@"确定"
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
- (void)datePickerValueChanged:(id)sender
{
    self.isDateSelected = YES;
    self.isPickerShow = NO;
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    NSDate *date = datePicker.date;
    double intervalOne = [date timeIntervalSince1970];
    double intervalTwo = [[NSDate date] timeIntervalSince1970];
    if (intervalOne - intervalTwo < -5*60) {
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"选择的拜访时间有误！"
                                   delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles: nil] show];
        [self animationForDatePickerDown];
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
        [self.timer invalidate];
        self.timer = nil;
        
    }
    [self animationForDatePickerDown];

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
        UITextField *detail = (UITextField *)[cell.contentView viewWithTag:9694];
        if (indexPath.row == 0) {
            UIButton *objectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            objectBtn.frame = CGRectMake(280, 0, 35, 35);
            [objectBtn addTarget:self action:@selector(objectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [objectBtn setBackgroundImage:[UIImage imageNamed:@"contact_select.png"] forState:UIControlStateNormal];
            [cell.contentView addSubview:objectBtn];
            textField.tag = TEXTFIELD_OBJECT_TAG;
            if (_style == KVisitRecoardVCStyleNewBuild) {
                textField.placeholder = @"请输入拜访对象";
                textField.text = self.defaultVisitedName;

            }else if (_style == KVisitRecoardVCStyleShowInfo){
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
            detail.hidden = NO;
            if (_style == KVisitRecoardVCStyleNewBuild || [self.schedu.isFinished isEqualToNumber:[NSNumber numberWithBool:NO]]) {
                textField.text = [_fieldValue objectAtIndex:indexPath.row];
                textField.text = self.address;
                self.updateImageView = [[UIImageView alloc] initWithImage:[self.imageArray objectAtIndex:0]];
                self.updateImageView.userInteractionEnabled = YES;
                self.updateImageView.frame = CGRectMake(280, 5, 35, 35);
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateLocation:)];
                tap.numberOfTapsRequired = 1;
                tap.numberOfTouchesRequired = 1;
                [self.updateImageView addGestureRecognizer:tap];
                [cell addSubview:self.updateImageView];
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
    //还要改
    if ((indexPath.row == 1 || indexPath.row == 2) && (_style == KVisitRecoardVCStyleNewBuild||[self.schedu.isFinished isEqualToNumber:[NSNumber numberWithBool:NO]])) {
        if (self.isPickerShow) {
            [self animationForDatePickerDown];
        }else{
            [self timerPickerViewAnimation];
        }
        
    }
    
    if ((indexPath.row == 2 && _style == KVisitRecoardVCStyleNewBuild)||[self.schedu.isFinished isEqualToNumber:[NSNumber numberWithBool:NO]]) {
        NSLog(@"显示时间");
        _isShowDate = NO;
        //[self timerPickerViewAnimation];
    }else if ((indexPath.row == 1 && _style == KVisitRecoardVCStyleNewBuild)||[self.schedu.isFinished isEqualToNumber:[NSNumber numberWithBool:NO]]){
        NSLog(@"显示日期xx");
        _isShowDate = YES;
        //[self timerPickerViewAnimation];
    }else if (indexPath.row == 4 && _style == KVisitRecoardVCStyleNewBuild){
        //弹出地址插件；
        _isAddress = YES;
    }
    self.isPickerShow = !self.isPickerShow;
}
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
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect rect = _theTable.frame;
    rect.origin.y = 0;
    _theTable.frame = rect;
    [UIView commitAnimations];
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
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UITableViewCell *cell = (UITableViewCell *)[[textField superview] superview];
    DLog(@"cell.text======%@",cell.textLabel.text);
    if ([cell.textLabel.text isEqualToString:@"对象"]) {
        if (textField.text.length == 0) {
            self.defaultVisitedName = nil;
            if (self.visitInfoCard) {
                [self.objectDic removeObjectForKey:self.visitInfoCard.name];
            }
        }
        [_fieldValue replaceObjectAtIndex:0 withObject:textField.text];
    }else if ([cell.textLabel.text isEqualToString:@"备注"]){
        [_fieldValue replaceObjectAtIndex:3 withObject:textField.text];
    
    }else if ([cell.textLabel.text isEqualToString:@"参与者"]){
        [_fieldValue replaceObjectAtIndex:6 withObject:textField.text];
    }else if ([cell.textLabel.text isEqualToString:@"位置"]){
        UITextField *tf = (UITextField *)[self.view viewWithTag:TEXTFIELD_ADDRESS_TAG];
        NSString *s = [NSString stringWithFormat:@"%@|",tf.text];
        NSString *addressStr = [NSString stringWithFormat:@"%@%@",s,textField.text];
        DLog(@"address>>>>>>>>%@",addressStr);
    }else if ([cell.textLabel.text isEqualToString:@"参与者"]){
        [_fieldValue replaceObjectAtIndex:6 withObject:textField.text];
    
    }
}
#pragma mark -
- (void)warnBtnClick:(id)sender
{
    _isWarnBtnClick = YES;
    _tempPickArr = _warnTitleArr;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect rect = _pick.frame;
    rect.origin.y = 200;
    _pick.frame = rect;
    [UIView commitAnimations];
    [_pick reloadAllComponents];


}
- (void)showMap:(id)sender
{
    UITextField *addressMap = (UITextField *)[self.view viewWithTag:TEXTFIELD_ADDRESS_TAG];
    MapController *mapVC = [[MapController alloc] initWithNibName:nil bundle:nil];
    mapVC.companyAddr = addressMap.text;
    //mapVC.companyName = @"浙江金汉弘";
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
- (void)tapFull:(UITapGestureRecognizer *)sender
{
    self.tapImgview = (UIImageView *)[sender view];
    KHHFullFrameController *fullVC = [[KHHFullFrameController alloc] initWithNibName:nil bundle:nil];
    fullVC.image = self.tapImgview.image;
    [self.navigationController pushViewController:fullVC animated:YES];
    
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
    self.isNotePickShow = !self.isNotePickShow;
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
        if (_isAddress) {
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
    if (_style == KVisitRecoardVCStyleShowInfo) {
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
                      cancelButtonTitle:@"确定"
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
                      cancelButtonTitle:@"确定"
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
#pragma mark UIPickViewDelegates
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    return [_tempPickArr count];
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [_tempPickArr objectAtIndex:row];
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_isWarnBtnClick) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:2277];
        [btn setTitle:[_tempPickArr objectAtIndex:row] forState:UIControlStateNormal];
        //获取当前时间
        if (row == 0) {
            _timeInterval = MAXFLOAT;
        }else if (row == 1){
            _timeInterval = 30*60;
        }else if (row == 2){
            _timeInterval = 60*60;
        }else if (row == 3){
            _timeInterval = 2*60*60;
        }else if (row == 4){
            _timeInterval = 3*60*60;
        }else if (row == 5){
            _timeInterval = 12*60*60;
        }else if (row == 6){
            _timeInterval = 24*60*60;
        }else if (row == 7){
            _timeInterval = 2*24*60*60;
        }else if (row == 8){
            _timeInterval = 3*24*60*60;
        }else if (row == 9){
            _timeInterval = 7*24*60*60;
        }
        [self setAlerm:_timeInterval];

    }else{
        UITextField *noteTf = (UITextField *)[self.view viewWithTag:NOTE_FIELD_TAG];
        noteTf.text = [_tempPickArr objectAtIndex:row];
    }
    [self animationPickDown];
    self.isNotePickShow = NO;
}

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
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
