//
//  KHHExchangeViewController.m
//  CardBook
//
//  Created by 王国辉 on 12-8-20.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "KHHExchangeViewController.h"
#import "KHHSendToViewController.h"
#import "KHHShowHideTabBar.h"
#import "Edit_eCardViewController.h"
#import "XLPageControl.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "KHHFrameCardView.h"
#import "MBProgressHUD.h"
#import "DetailInfoViewController.h"
#import "MBProgressHUD.h"
#import "KHHAppDelegate.h"
#import "KHHMyDetailController.h"

#import <CoreLocation/CoreLocation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "KHHDataAPI.h"
#import "KHHNetworkAPI.h"
#import "KHHNotifications.h"
#import "KHHDefaults.h"
#import "KHHSendRecordViewController.h"
#import "KHHDataNew+Card.h"
#import "KHHNewEdit_ecardViewController.h"

#import "KHHUser.h"

@interface KHHExchangeViewController ()<UIScrollViewDelegate,CLLocationManagerDelegate>
@property (strong, nonatomic) XLPageControl *xlPage;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) CLLocationManager *localM;

@property (strong, nonatomic) Card               *card;
@property (strong, nonatomic) MBProgressHUD      *mbHUD;
@property (strong, nonatomic) NSTimer            *timer;
@property (assign, nonatomic) int                countDownNum;
@property (assign, nonatomic) CFAbsoluteTime     exchangeStartTime;
@property (strong, nonatomic) Card               *latestCard;
@property (strong, nonatomic) KHHFrameCardView   *cardView;
@property (strong, nonatomic) KHHAppDelegate     *app;
@property (assign, nonatomic) bool               isHandleReceive;

@end

@implementation KHHExchangeViewController
@synthesize scrView = _scrView;
@synthesize isVer = _isVer;
@synthesize xlPage;
@synthesize currentLocation = _currentLocation;
@synthesize localM = _localM;

@synthesize card;
@synthesize mbHUD;
@synthesize timer;
@synthesize countDownNum;
@synthesize exchangeStartTime;
@synthesize latestCard;
@synthesize cardView;
@synthesize app;
@synthesize isHandleReceive;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"交换名片", nil);
        //[self.leftBtn setTitle:NSLocalizedString(@"切换名片", nil) forState:UIControlStateNormal];        
        self.app  = (KHHAppDelegate *)[UIApplication sharedApplication].delegate;
        
    }
    return self;
}
- (void)rightBarButtonClick:(id)sender{
    
//    Edit_eCardViewController *editeCardVC = [[Edit_eCardViewController alloc] initWithNibName:@"Edit_eCardViewController" bundle:nil];
//    editeCardVC.type = KCardViewControllerTypeShowInfo;
//    
//    editeCardVC.glCard = self.card;
    KHHNewEdit_ecardViewController *editeCardVC = [[KHHNewEdit_ecardViewController alloc]init];
    editeCardVC.toEditCard = self.card;
    [self.navigationController pushViewController:editeCardVC animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *cards = [[KHHDataNew sharedData] allMyCards];
    if (cards && cards.count > 0) {
        self.card = [cards objectAtIndex:0];
    }
    
    //检查是否要提示同步alert
    [self checkNeedShowSyncAlert];
    // Do any additional setup after loading the view from its nib.
    //设置背景
    [self.view setBackgroundColor:[UIColor colorWithRed:241.0f green:238.0f blue:231.0f alpha:1.0f]];
    //竖屏
    if (NO) {
        self.cardView = [[KHHFrameCardView alloc] initWithFrame:CGRectMake(0, 0, 320, 260) delegate:self isVer:YES callbackAction:nil];
        [self.view addSubview:cardView];
    }else{
        self.cardView = [[KHHFrameCardView alloc] initWithFrame:CGRectMake(0, 0, 320, 220) delegate:self isVer:NO callbackAction:nil];
    }
    //在viewWillApear时会再画一次，所以这里不画了
//    self.cardView.card = self.card;
//    [self.cardView showView];
    [self.view addSubview:self.cardView];
    for (int i = 0; i<3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        NSString *imgStr = [NSString stringWithFormat:@"exch_%d.png",i];
        [btn setBackgroundImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
        btn.tag = i + 111;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(25+i*(80 + 15), 245, 79, 75);
        [self.view insertSubview:btn atIndex:10];
    }
    // 获取经度，纬度
    [self getLocationForExChange];
}

//显示数据未同步完全的alert
-(BOOL) checkNeedShowSyncAlert {
    if (self.card) {
        return NO;
    }else{
        //提示用户数据没有同步下来，先同步一下数据
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:KhhMessageDataErrorTitle
                                                        message:KhhMessageDataErrorNotice
                                                       delegate:self
                                              cancelButtonTitle:KHHMessageSure
                                              otherButtonTitles:nil, nil];
        [alert show];
        return YES;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [KHHShowHideTabBar showTabbar];
    DLog(@"becomeFirstResponder ====== %i",[self becomeFirstResponder]);
    //判断是否要显示编辑按钮
    if ([self inShowEditButton]) {
        [self.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
    }else {
        self.rightBtn.hidden = YES;
    }
    
    [self updateCardTempInfo];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _scrView = nil;
    xlPage = nil;
   
    self.card = nil;
    self.mbHUD = nil;
    self.timer = nil;
    self.latestCard = nil;
    self.cardView = nil;
    self.app = nil;
}

#pragma mark 根据用户权限判断是否要显示编辑按钮
/**
 * 判断是否显示编辑按钮
 * 个人名片及公司董事长能编辑名片
 * 其它的用户不能编辑名片
 * 默认返回NO
 */
-(BOOL) inShowEditButton
{
//    if (!self.myDefault) {
//        return NO;
//    }
    
    NSString *permission = [KHHUser shareInstance].permissionName;
    NSNumber *companyID = [NSNumber numberFromString:[KHHUser shareInstance].companyId];
    if (![self.card isKindOfClass:[MyCard class]]) {
        return NO;
    }
    
    //有公司id，但权限不为老板
    if (companyID.longValue > 0 && ![permission isEqualToString:kPERMISSION_BOSS]) {
        return NO;
    }
    
    //剩下的就只有私人或公司老板的，返回YES
    return YES;
}

- (void)btnClick:(id)sender
{
    if ([self checkNeedShowSyncAlert]) {
        return;
    }
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 111:
        {
            KHHSendToViewController *sendToVC = [[KHHSendToViewController alloc] initWithNibName:nil bundle:nil];
            sendToVC.theCard = self.card;
            [self.navigationController pushViewController:sendToVC animated:YES];
        }            
            break;
        case 112:
            [self exchangeCard];
            break;
        case 113:
        {
            KHHSendRecordViewController *sendRecordVC = [[KHHSendRecordViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:sendRecordVC animated:YES];
            break;
        }
        default:
            break;
    }

}
// 刷新卡片信息
- (void)updateCardTempInfo{
    NSArray *cards = [[KHHDataNew sharedData] allMyCards];
    if (cards && cards.count > 0) {
        self.card = [cards objectAtIndex:0];
    }
    self.cardView.card = self.card;
    [self.cardView.scrView removeFromSuperview];
    [self.cardView.xlPage removeFromSuperview];
    [self.cardView.shadowCard removeFromSuperview];
    [self.cardView showView];
}
// 摇摇交换
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"shake......");
    }
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"开始交换");
        [self exchangeCard];
    }
}
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{

}
//获取地理位置
- (void)getLocationForExChange
{
    _localM = [[CLLocationManager alloc] init];
    if (_localM && [CLLocationManager locationServicesEnabled]) {
        _localM.delegate = self;
        _localM.distanceFilter = 100;
        _localM.desiredAccuracy = kCLLocationAccuracyBest;
        [_localM startUpdatingLocation];
    }else {
        _localM = nil;
    }

}
//交换名片
- (void)exchangeCard
{
    //注册交换成功，失败的消息
    [self getLocationForExChange];
    [self observeNotificationName:KHHNetworkExchangeCardSucceeded selector:@"handleExchangeCardSucceeded:"];
    [self observeNotificationName:KHHNetworkExchangeCardFailed selector:@"handleExchangeCardFailed:"];
    if (!self.localM) {
        NSLog(@"你的设备未开启定位服务");
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"设备未开启定位服务", nil)
                                   message:NSLocalizedString(@"请在系统设置里开启定位服务。", nil)
                                  delegate:nil
                         cancelButtonTitle:NSLocalizedString(KHHMessageSure, nil)
                         otherButtonTitles:nil] show];
        return;
    }
    if (self.currentLocation == nil) {
        NSLog(@"正在获取位置，请稍等");
        MBProgressHUD *progess = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        progess.labelText = NSLocalizedString(@"正在获取位置，请稍等", nil);
        [progess hide:YES afterDelay:3];
        return;
    }
    NSLog(@"everything is ok !!");
    NSString *longitude = [NSString stringWithFormat:@"%f",self.currentLocation.coordinate.longitude];
    NSString *latitude = [NSString stringWithFormat:@"%f",self.currentLocation.coordinate.latitude];
    NSLog(@"%@++++++++%@",longitude,latitude);
    CFAbsoluteTime interValTime = CFAbsoluteTimeGetCurrent() - self.exchangeStartTime;
    if (interValTime < 2.0f) {
        return;
    }else if (interValTime < 20.0f){
        [self warnNetWork:@"请不要频繁交换名片"];
        return;
    }
    self.mbHUD = [MBProgressHUD showHUDAddedTo:self.app.window animated:YES];
    self.mbHUD.labelText = @"请稍后,正在交换名片...";
  //  [[KHHDataNew sharedData] exchangeCard:self.card withCoordinate:self.currentLocation.coordinate delegate:self];
//    [self.httpAgent exchangeCard:self.card withCoordinate:self.currentLocation.coordinate];
    self.exchangeStartTime = CFAbsoluteTimeGetCurrent();
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    self.countDownNum = 16;
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:self.mbHUD,@"Hud",self.mbHUD.labelText,@"label", nil];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdownForMBHUD:) userInfo:info repeats:YES];
}
#pragma mark -
//交换成功
- (void)handleExchangeCardSucceeded:(NSNotification *)info{
    DLog(@"ExchangeCardSucceeded!");
    [self stopObservingNotificationName:KHHNetworkExchangeCardSucceeded];
    [self stopObservingNotificationName:KHHNetworkExchangeCardFailed];
    //注册取最新的一张卡片消息
    [self observeNotificationName:KHHUIPullLatestReceivedCardSucceeded selector:@"handlePullLatestReceivedCardSucceeded:"];
    [self observeNotificationName:KHHUIPullLatestReceivedCardFailed selector:@"handlePullLatestReceivedCardFailed:"];
    [self.timer invalidate];
    self.timer = nil;
//    [self.mbHUD hide:YES];
    //交换成功后在收取名片中间的空隙添加文字提示
    self.mbHUD.labelText = @"名片交换成功，正在为您收取名片";
   
    [[KHHDataNew sharedData] pullLatestReceivedCard];
}
//交换失败
- (void)handleExchangeCardFailed:(NSNotification *)info{
    DLog(@"ExchangeCardFailed! =======info is %@",info.userInfo);
     [self.mbHUD hide:YES];
    if ([[info.userInfo objectForKey:@"errorCode"]intValue] == -21) {
        DLog(@"没有相对应的卡片要交换");
        [self exchangeFailed:@"没有匹配的名片可交换"];
    }else if ([[info.userInfo objectForKey:@"errorCode"]intValue] == KHHErrorCodeConnectionOffline){
        [self exchangeFailed:@"网络错误"];
    }

}
//收到最新card成功
- (void)handlePullLatestReceivedCardSucceeded:(NSNotification *)info{
    DLog(@"handlePullLatestReceivedCardSucceeded! =======info is %@",info.userInfo);
    [self stopObservingNotificationName:KHHUIPullLatestReceivedCardSucceeded];
    [self stopObservingNotificationName:KHHUIPullLatestReceivedCardFailed];
    self.latestCard = [info.userInfo objectForKey:@"receivedCard"];
    [self warnNetWork:@"交换结束"];
    [self performSelector:@selector(showNewCardInfo) withObject:nil afterDelay:2];
    
    if (self.isHandleReceive) {
     [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];   
    }
}
- (void)showNewCardInfo{
    //通过交换获取的名片时，提示名片前把提示用户正在收名片的对话框隐藏
    if (self.mbHUD && !self.mbHUD.isHidden) {
        [self.mbHUD hide:YES];
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"收到新到名片"
                                                    message:self.latestCard.name
                                                   delegate:self
                                          cancelButtonTitle:@"查看详情"
                                          otherButtonTitles:@"取消", nil];
    alert.tag = KHHAlertNewContact;
    [alert show];
}
//收到最新card失败
- (void)handlePullLatestReceivedCardFailed:(NSNotification *)info{
    DLog(@"handlePullLatestReceivedCardFailed! =======info is %@",info.userInfo);
    [self stopObservingNotificationName:KHHUIPullLatestReceivedCardSucceeded];
    [self stopObservingNotificationName:KHHUIPullLatestReceivedCardFailed];
    if (self.isHandleReceive) {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    }
    
    //通过交换获取的名片时，提示错误前把提示用户正在收名片的对话框隐藏
    if (self.mbHUD && !self.mbHUD.isHidden) {
        [self.mbHUD hide:YES];
    }
    
    NSString *message = nil;
    if ([[info.userInfo objectForKey:@"errorCode"]intValue] == KHHErrorCodeConnectionOffline){
        message = KHHMessageNetworkEorror;
    }
    //提示没有收到新名片
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"没有新到名片"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:KHHMessageSure
                                          otherButtonTitles:nil, nil];
    [alert show];
    
}
//定位委托方法
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    _currentLocation = newLocation;
    [manager stopUpdatingLocation];
    
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (error.code == kCLErrorDenied) {
        [manager stopUpdatingHeading];
        [manager stopUpdatingLocation];
    }else if (error.code == kCLErrorHeadingFailure) {
        
    }
    
}
//网络提示
- (void)warnNetWork:(NSString *)warnString{
    
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.app.aTabBarController.view animated:YES];
    progress.labelText = NSLocalizedString(warnString, nil);
    [progress hide:YES afterDelay:2.0];
    
}
- (void)countdownForMBHUD:(NSTimer *)timerr {
    --self.countDownNum;
    if (self.countDownNum <= 0) {
        //超时处理；
        DLog(@"exchange failed because time out!!");
        self.mbHUD.hidden = YES;
        [self exchangeFailed:@"网络超时"];
    }else{
        self.mbHUD = [timerr.userInfo objectForKey:@"Hud"];
        NSString *label = [timerr.userInfo objectForKey:@"label"];
        self.mbHUD.labelText = [NSString stringWithFormat:@"%@ %d",label,self.countDownNum];
    }
}
//交换失败处理
- (void)exchangeFailed:(NSString *)message{
    [self stopObservingNotificationName:KHHNetworkExchangeCardSucceeded];
    [self stopObservingNotificationName:KHHNetworkExchangeCardFailed];
    [self.timer invalidate];
    self.timer = nil;
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"交换失败"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:KHHMessageSure
                                          otherButtonTitles:nil, nil];
    [alert show];
}
//收到新的名片，跳转到详细界面
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    KHHAlertType type = alertView.tag;
    switch (type) {
        case KHHAlertNewContact:
        {
            if (buttonIndex == 0) {
                DetailInfoViewController *detail = [[DetailInfoViewController alloc] initWithNibName:nil bundle:nil];
                if ([self.latestCard isKindOfClass:[ReceivedCard class]]) {
                    ReceivedCard *lastCard = (ReceivedCard *)self.latestCard;
                    lastCard.isReadValue = YES;
                }
                detail.card = self.latestCard;
                [self.navigationController pushViewController:detail animated:YES];
            }
        }
            break;
        default:
            break;
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - exchange delegate

- (void)exchangeCardForUISuccess:(NSDictionary *)dict
{

}

- (void)exchangeCardForUIFailed:(NSDictionary *)dict
{

}

@end
