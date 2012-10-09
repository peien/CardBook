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
#import "XLPageControl.h"
#import "UIImageView+WebCache.h"
#import "KHHFrameCardView.h"
#import "KHHData.h"
#import "Card.h"

#import <CoreLocation/CoreLocation.h>
#import "KHHNetworkAPIAgent+Exchange.h"

@interface KHHExchangeViewController ()<UIScrollViewDelegate,CLLocationManagerDelegate>
@property (strong, nonatomic) XLPageControl *xlPage;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) CLLocationManager *localM;
@property (strong, nonatomic) KHHNetworkAPIAgent *httpAgent;
@property (strong, nonatomic) KHHData            *dataCtrl;
@property (strong, nonatomic) Card               *card;
@end

@implementation KHHExchangeViewController
@synthesize scrView = _scrView;
@synthesize isVer = _isVer;
@synthesize xlPage;
@synthesize currentLocation = _currentLocation;
@synthesize localM = _localM;
@synthesize httpAgent = _httpAgent;
@synthesize dataCtrl;
@synthesize card;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"交换名片", nil);
        [self.leftBtn setTitle:NSLocalizedString(@"切换名片", nil) forState:UIControlStateNormal];
        [self.rightBtn setTitle:@"发送纪录" forState:UIControlStateNormal];
        self.httpAgent = [[KHHNetworkAPIAgent alloc] init];
        self.dataCtrl = [KHHData sharedData];
        self.card = [[self.dataCtrl allMyCards] lastObject];
    }
    return self;
}
//切换名片
- (void)leftBarButtonClick:(id)sender
{

}
//发送纪录
- (void)rightBarButtonClick:(id)sender
{

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //设置背景
    [self.view setBackgroundColor:[UIColor colorWithRed:241.0f green:238.0f blue:231.0f alpha:1.0f]];
    //竖屏
    if (NO) {
        KHHFrameCardView *cardView = [[KHHFrameCardView alloc] initWithFrame:CGRectMake(0, 0, 320, 260) isVer:YES];
        [self.view addSubview:cardView];
    }else{
        KHHFrameCardView *cardView = [[KHHFrameCardView alloc] initWithFrame:CGRectMake(0, 0, 320, 220) isVer:NO];
        cardView.card = self.card;
        [cardView showView];
        [self.view addSubview:cardView];
    }
    //NSArray *titleArray = [[NSArray alloc] initWithObjects:@"交换名片",@"发送至手机",@"收名片", nil];
    for (int i = 0; i<3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        NSString *imgStr = [NSString stringWithFormat:@"exch_%d.png",i];
        [btn setBackgroundImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
        btn.tag = i + 111;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        //[btn setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        btn.frame = CGRectMake(25+i*(80 + 15), 245, 79, 75);
        [self.view insertSubview:btn atIndex:10];
    }
    // 获取经度，纬度
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
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [KHHShowHideTabBar showTabbar];
    [self becomeFirstResponder];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[KHHShowHideTabBar hideTabbar];
    [self resignFirstResponder];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _scrView = nil;
    xlPage = nil;
    self.dataCtrl = nil;
    self.card = nil;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_scrView]) {
        CGFloat scrollWidth = scrollView.frame.size.width;
        int page = ((scrollView.contentOffset.x-scrollWidth/2)/scrollWidth)+1;
        XLPageControl *pageCtrl = (XLPageControl *)[self.view viewWithTag:118];
        pageCtrl.currentPage = page;
    }
}

- (void)btnClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 111:
            [self exchangeCard];
            break;
        case 112:
        {
            KHHSendToViewController *sendToVC = [[KHHSendToViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:sendToVC animated:YES];
        }
            break;
        case 113:
            //同步所有，同步联系人，启动定位服务
            break;
        default:
            break;
    }

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
//交换名片
- (void)exchangeCard
{
    if (!self.localM) {
        NSLog(@"你的设备无法开启定位");
        return;
    }
    if (self.currentLocation == nil) {
        NSLog(@"正在获取位置，请稍等");
        return;
    }
    NSLog(@"everything is ok !!");
    NSString *longitude = [NSString stringWithFormat:@"%f",self.currentLocation.coordinate.longitude];
    NSString *latitude = [NSString stringWithFormat:@"%f",self.currentLocation.coordinate.latitude];
    NSLog(@"%@++++++++%@",longitude,latitude);
    [self.httpAgent exchangeCard:nil withCoordinate:self.currentLocation.coordinate];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
