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

#define TEXTFIELD_DATE_TAG 5551
#define TEXTFIELD_TIME_TAG 5552
#define NOTE_BTN_TAG       3312
#define NOTE_FIELD_TAG     3313
#define TEXTFIELD_ADDRESS_TAG 3314
@interface KHHVisitRecoardVC ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong, nonatomic)KHHAddImageView *addView;
@property (strong, nonatomic)UIImageView     *addImg1;
@property (strong, nonatomic)UIImageView     *addImg2;
@property (strong, nonatomic)UIImageView     *addImg3;
@property (strong, nonatomic)UIImageView     *addImg4;
@property (strong, nonatomic)UIImageView     *imgview;
@property (assign, nonatomic)int             currentTag;


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
@synthesize addImg4 = _addImg4;
@synthesize addImg3 = _addImg3;
@synthesize addImg2 = _addImg2;
@synthesize addImg1 = _addImg1;
@synthesize addView = _addView;
@synthesize num = _num;
@synthesize imgview = _imgview;
@synthesize index = _index;
@synthesize currentTag = _currentTag;
@synthesize isDelImg = _isDelImg;
@synthesize imgArray = _imgArray;
@synthesize timeArr = _timeArr;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"编辑详情";
        [self.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSDate *now = [NSDate date];
    NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
    [dateForm setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *showDAte = [dateForm stringFromDate:now];
    NSLog(@"%@",showDAte);
    NSArray *dateArr = [showDAte componentsSeparatedByString:@" "];
    _dateStr = [dateArr objectAtIndex:0];
    _timeStr = [dateArr objectAtIndex:1];
    
    [_datePicker setDate:now animated:YES];
    [_datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    _tempPickArr = [[NSArray alloc] init];
    _warnTitleArr = [[NSArray alloc] initWithObjects:@"不提醒", @"30分钟",@"1小时",@"2小时",@"3小时",@"12小时",@"24小时",@"2天",@"3天",@"一周",nil];
    _timeArr = [[NSArray alloc] initWithObjects:@"",@"30",@"1",@"2",@"3",@"12",@"24",@"2",@"3",@"7",nil];
    _noteArray = [[NSArray alloc] initWithObjects:@"初次见面",@"商务洽谈",@"一起吃饭",@"一起喝茶",@"回访客户",@"签订合同", nil];
    _fieldName = [[NSArray alloc] initWithObjects:@"对象",@"日期",@"时间",@"备注",@"位置",@"提醒",@"参与者",@"", nil];
    _imgArray = [[NSMutableArray alloc] initWithCapacity:0];
    _fieldValue = [[NSMutableArray alloc] initWithObjects:@"",_dateStr,_timeStr,@"",@"",@"",@"", nil];
    if (_isHaveImage) {
        [_imgArray addObject:[UIImage imageNamed:@"logopic.png"]];
    }

    

    //如果不是新建，就获取数据让其显示
    if (_style == KVisitRecoardVCStyleShowInfo) {
        [self initViewData];
    }


    
}
// 闹钟设置
- (void)setAlerm
{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil)
    {
        NSDate *now=[NSDate new];
        //notification.fireDate=[now addTimeInterval:period];
        notification.fireDate = [now dateByAddingTimeInterval:1];
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        //notification.alertBody=@"TIME！";
        notification.alertBody = [NSString stringWithFormat:@"时间到了!"];
        NSDictionary* info = [NSDictionary dictionaryWithObject:@""forKey:@""];
        notification.userInfo = info;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }

}
//-(void)schedulNotificationWithYear:(int)y andMonth:(int)m andDay:(int)d andHour:(int)h andMintu:(int)mi andMsg:(NSString *)msg{
//    
//    // Set up the fire time
//    NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
//    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
//    [dateComps setDay:d];
//    [dateComps setMonth:m];
//    [dateComps setYear:y];
//    [dateComps setHour:h];
//    // Notification will fire in one minute
//    [dateComps setMinute:mi];
//    [dateComps setSecond:0];
//    NSDate *itemDate = [calendar dateFromComponents:dateComps];
//    
//    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
//    if (localNotif == nil)
//        return;
//    localNotif.fireDate = itemDate;
//    localNotif.timeZone = [NSTimeZone defaultTimeZone];
//    
//    // Notification details
//    localNotif.alertBody = msg;
//    // Set the action button
//    localNotif.alertAction = @"查看";
//    
//    localNotif.soundName = UILocalNotificationDefaultSoundName;
//    //    localNotif.applicationIconBadgeNumber = 1;
//    
//    // Specify custom data for the notification
//    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"someValue" forKey:@"someKey"];
//    localNotif.userInfo = infoDict;
//    
//    // Schedule the notification
//    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
//   
//}
//从网络或数据库获得数据
- (void)initViewData
{
 
    //获取对象模型，填充fieldvalue
    if (YES) {
        [_fieldValue replaceObjectAtIndex:0 withObject:@"王文"];
    }
    if (YES) {
        [_fieldValue replaceObjectAtIndex:3 withObject:@"请客吃饭"];
    }
    if (YES) {
        [_fieldValue replaceObjectAtIndex:4 withObject:@"浙江省杭州市滨江区南环路111"];
    }
    if (YES) {
        [_fieldValue replaceObjectAtIndex:6 withObject:@"小刘"];
    }


}
- (void)rightBarButtonClick:(id)sender
{
    [self saveVisitRecordInfo];
}
// 保存
- (void)saveVisitRecordInfo
{
    UITextField *date = (UITextField *)[self.view viewWithTag:TEXTFIELD_DATE_TAG];
    UITextField *time = (UITextField *)[self.view viewWithTag:TEXTFIELD_TIME_TAG];
    UITextField *note = (UITextField *)[self.view viewWithTag:NOTE_FIELD_TAG];
    UIButton *noteBtn = (UIButton *)[self.view viewWithTag:2277];
    NSString *warnStr = noteBtn.titleLabel.text;
    UITextField *address = (UITextField *)[self.view viewWithTag:TEXTFIELD_ADDRESS_TAG];
    DLog(@"date>>>>>>>>>>%@",date.text);
    DLog(@"time>>>>>>>>>>%@",time.text);
    DLog(@"note>>>>>>>>>>%@",note.text);
    DLog(@"warnStr>>>>>>>>>>%@",warnStr);
    DLog(@"address>>>>>>>>>>%@",address.text);
    //调用数据库接口，或者是网络接口
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
    _addImg1 = nil;
    _addImg2 = nil;
    _addImg3 = nil;
    _addImg4 = nil;
    _addView = nil;
    _imgview = nil;
    _imgArray = nil;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [KHHShowHideTabBar hideTabbar];
    [_theTable reloadData];
}
- (void)datePickerValueChanged:(id)sender
{
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    NSDate *date = datePicker.date;
    NSDateFormatter *dateForm = [[NSDateFormatter alloc] init];
    [dateForm setDateFormat:@"yyyy-MM-dd HH:mm"];
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
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect rect = _datePicker.frame;
    rect.origin.y = 430;
    _datePicker.frame = rect;
    [UIView commitAnimations];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4) {
        return 75;
    }else if (indexPath.row == 7){
        return 75;
    }
    return 44;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = [_fieldName objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, 220, 37)];
        [tf setBackgroundColor:[UIColor clearColor]];
        tf.leftViewMode = UITextFieldViewModeAlways;
        tf.tag = 9693;
        tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        tf.font = [UIFont systemFontOfSize:13];
        tf.delegate = self;
        [cell.contentView addSubview:tf];
        
        UITextField *detailAddress = [[UITextField alloc] initWithFrame:CGRectMake(80, 35, 280, 37)];
        detailAddress.tag = 9694;
        detailAddress.hidden = YES;
        [detailAddress setBackgroundColor:[UIColor clearColor]];
        detailAddress.leftViewMode = UITextFieldViewModeAlways;
        detailAddress.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        detailAddress.font = [UIFont systemFontOfSize:13];
        detailAddress.delegate = self;
        detailAddress.placeholder = @"请输入详细地址";
        [cell.contentView addSubview:detailAddress];
        
    }
    UITextField *textField = (UITextField *)[cell.contentView viewWithTag:9693];
    UITextField *detail = (UITextField *)[cell.contentView viewWithTag:9694];
    if (indexPath.row == 0) {
        UIButton *objectBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        objectBtn.frame = CGRectMake(280, 2, 35, 35);
        [objectBtn addTarget:self action:@selector(objectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:objectBtn];
        if (_style == KVisitRecoardVCStyleNewBuild) {
            textField.placeholder = @"请输入拜访对象";
        }else if (_style == KVisitRecoardVCStyleShowInfo){
            textField.text = [_fieldValue objectAtIndex:indexPath.row];
        }
        
    }else if (indexPath.row == 1){
        textField.enabled = NO;
        textField.tag = TEXTFIELD_DATE_TAG;
        if (_style == KVisitRecoardVCStyleNewBuild) {
            textField.placeholder = @"请输入拜访日期";
            textField.text = _dateStr;
        }else if (_style == KVisitRecoardVCStyleShowInfo){
            textField.text = [_fieldValue objectAtIndex:indexPath.row];
        }
    }else if (indexPath.row == 2){
        textField.enabled = NO;
        textField.tag = TEXTFIELD_TIME_TAG;
        if (_style == KVisitRecoardVCStyleNewBuild) {
            textField.placeholder = @"请输入拜访时间";
            textField.text = _timeStr;
        }else if (_style == KVisitRecoardVCStyleShowInfo){
            textField.text = [_fieldValue objectAtIndex:indexPath.row];
        }
    }else if (indexPath.row == 3){
        textField.placeholder = @"限制400字内";
        textField.tag = NOTE_FIELD_TAG;
        if (_style == KVisitRecoardVCStyleNewBuild) {
            
        }else if (_style == KVisitRecoardVCStyleShowInfo){
            textField.text = [_fieldValue objectAtIndex:indexPath.row];
            if (_isFinishTask) {
                UIButton *noteBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                noteBtn.frame = CGRectMake(280, 5, 30, 30);
                noteBtn.tag = NOTE_BTN_TAG;
                [noteBtn addTarget:self action:@selector(noteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:noteBtn];
            }
            
        }
        
    }else if (indexPath.row == 4){
        textField.enabled = NO;
        textField.tag = TEXTFIELD_ADDRESS_TAG;
        if (_style == KVisitRecoardVCStyleNewBuild) {
            textField.placeholder = @"请输入城市名称";
            detail.hidden = NO;
        }else{
            textField.text = [_fieldValue objectAtIndex:indexPath.row];
            for (int i = 0; i<2; i++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                if (i== 0 || i == 1) {
                    [btn setBackgroundImage:[UIImage imageNamed:@"locationImg.png"] forState:UIControlStateNormal];
                }
                btn.frame = CGRectMake(280, 5+i*(8+30), 30, 30);
                btn.tag = i + 778;
                [cell.contentView addSubview:btn];
            }
        }
        
    }else if (indexPath.row == 5){
        [textField removeFromSuperview];
        UIButton *warnBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        warnBtn.tag = 2277;
        warnBtn.frame = CGRectMake(80, 8, 180, 30);
        [warnBtn setTitle:@"不提醒" forState:UIControlStateNormal];
        if (_isNeedWarn) {
            [warnBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else{
            [warnBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            warnBtn.enabled = NO;
        }
        warnBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [warnBtn addTarget:self action:@selector(warnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:warnBtn];
        
    }else if (indexPath.row == 6){
        textField.placeholder = @"请输入参与者人员";
        if (_style == KVisitRecoardVCStyleShowInfo) {
            textField.text = [_fieldValue objectAtIndex:indexPath.row];
        }
    }else if (indexPath.row == 7){
        [textField removeFromSuperview];
        
        if (_addView == nil) {
            _addView = [[[NSBundle mainBundle] loadNibNamed:@"KHHAddImageView" owner:self options:nil] objectAtIndex:0];
            _addView.tag = 9090;
            [_addView.addImageBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            _addView.addImageBtn.tag = 9091;
            
        }
        if (_imgArray.count > 0) {
            _addView.frame = CGRectMake(5+(_imgArray.count)*65, 5, 60, 60);
            [cell addSubview:_addView];
        }

        if (_isHaveImage) {
            if (_imgArray.count < 5 && _imgArray.count > 0) {
                for (int i = 0; i<[_imgArray count]; i++) {
                    _imgview = [[UIImageView alloc] init];
                    _imgview.userInteractionEnabled = YES;
                    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressFunctionOne:)];
                    longPress.minimumPressDuration = 0.5;
                    longPress.numberOfTouchesRequired = 1;
                    longPress.allowableMovement = NO;
                    [_imgview addGestureRecognizer:longPress];
                    _imgview.backgroundColor = [UIColor darkGrayColor];
                    _imgview.frame = CGRectMake(5+i*(60+5), 5, 60, 60);
                    _imgview.tag = i+101;
                    _imgview.image = [_imgArray objectAtIndex:i];
                    [cell addSubview:_imgview];
                }
            }
            if (_imgArray.count == 4) {
                [_addView removeFromSuperview];
            }
            
        }
        
        if (_isDelImg) {
            
            
        }
        if ([_imgArray count] == 0) {
            [_addView removeFromSuperview];
            UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [addBtn setBackgroundImage:[UIImage imageNamed:@"addBtnimg.png"] forState:UIControlStateNormal];
            addBtn.tag = 9092;
            addBtn.frame = CGRectMake(10, 3, 45, 45);
            [addBtn addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:addBtn];
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2 && _style == KVisitRecoardVCStyleNewBuild) {
        NSLog(@"显示时间");
        _isShowDate = NO;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        CGRect rect = _datePicker.frame;
        rect.origin.y = 200;
        _datePicker.frame = rect;
        [UIView commitAnimations];
        
    }else if (indexPath.row == 1 && _style == KVisitRecoardVCStyleNewBuild){
        NSLog(@"显示日期xx");
        _isShowDate = YES;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
        CGRect rect = _datePicker.frame;
        rect.origin.y = 200;
        _datePicker.frame = rect;
        [UIView commitAnimations];
    }else if (indexPath.row == 4 && _style == KVisitRecoardVCStyleNewBuild){
        //弹出地址插件；
        _isAddress = YES;
        TSLocateView *locateView = [[TSLocateView alloc] initWithTitle:@"定位城市" delegate:self];
        [locateView showInView:self.view];
    }
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
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect rect = _theTable.frame;
    rect.origin.y = -188;
    _theTable.frame = rect;
    [UIView commitAnimations];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UITableViewCell *cell = (UITableViewCell *)[[textField superview] superview];
    DLog(@"cell.text======%@",cell.textLabel.text);
    if ([cell.textLabel.text isEqualToString:@"对象"]) {
        [_fieldValue replaceObjectAtIndex:0 withObject:textField.text];
    }else if ([cell.textLabel.text isEqualToString:@"备注"]){
        [_fieldValue replaceObjectAtIndex:3 withObject:textField.text];
    
    }else if ([cell.textLabel.text isEqualToString:@"参与者"]){
        [_fieldValue replaceObjectAtIndex:6 withObject:textField.text];
    }else if ([cell.textLabel.text isEqualToString:@"位置"]){
        UITextField *tf = (UITextField *)[self.view viewWithTag:TEXTFIELD_ADDRESS_TAG];
        NSString *s = [NSString stringWithFormat:@"%@|",tf.text];
        NSString *address = [NSString stringWithFormat:@"%@%@",s,textField.text];
        DLog(@"address>>>>>>>>%@",address);
    
    }else if ([cell.textLabel.text isEqualToString:@"参与者"]){
        [_fieldValue replaceObjectAtIndex:6 withObject:textField.text];
    
    }
   
}
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
- (void)addBtnClick:(UIButton *)sender
{
    _isHaveImage = YES;
    _isDelImg = NO;
    _index = 0;
    if (_num == 4) {
        return;
    }
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
        [actSheet addButtonWithTitle:@"设为头像"];
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
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect rect = _pick.frame;
    rect.origin.y = 200;
    _pick.frame = rect;
    [UIView commitAnimations];
    [_pick reloadAllComponents];
  
}
- (void)objectBtnClick:(id)sender
{
    //拜访页面
    KHHHomeViewController *homeVC = [[KHHHomeViewController alloc] initWithNibName:nil bundle:nil];
    homeVC.isNormalSearchBar = YES;
    [self.navigationController pushViewController:homeVC animated:YES];
}
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
            [self presentModalViewController:imagePickCtrl animated:YES];
        }
        
    }
    
    if (_index == 1) {
       //长按小图片
        if (buttonIndex == 1) {
            //设为头像
        }else if (buttonIndex == 2){
            _isDelImg = YES;
            _isHaveImage = NO;
            if (_imgArray.count > 0) {
                [_imgArray removeObjectAtIndex:_currentTag-101];
                DLog(@"_imgArray.count=====%d",_imgArray.count);
            }
            [_theTable reloadData];


        }
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
  
    _isHaveImage = YES;
    [_imgArray addObject:image];
    
    [self dismissModalViewControllerAnimated:YES];

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
        if ([[_tempPickArr objectAtIndex:row] isEqualToString:@"不提醒"]) {
        }else{
            //获取当前时间
            //[self schedulNotificationWithYear:0 andMonth:0 andDay:0 andHour:0 andMintu:0 andMsg:@"时间到"];
        }
    }else{
        UITextField *noteTf = (UITextField *)[self.view viewWithTag:NOTE_FIELD_TAG];
        noteTf.text = [_tempPickArr objectAtIndex:row];
    }

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
