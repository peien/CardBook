//
//  KHHBMapLocationController.m
//  CardBook
//
//  Created by 王定方 on 12-12-11.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHBMapLocationController.h"
#import <CoreLocation/CoreLocation.h>
#import "KHHClasses.h"
#import "KHHNotifications.h"
#import "KHHStatusCodes.h"
#import "KHHTypes.h"
#import "KHHLocationController.h"

//两次定位间的时间
const NSTimeInterval KHH_LOCATION_REFRESH_INTERVAL = 30 * 60; // 30 min.

//用百度地图获取地址的超时时间
const NSInteger KHH_LOCATION_REFRESH_TIMEOUT = 30; // 30 second.

@interface KHHBMapLocationController ()
@property (nonatomic, strong) BMKUserLocation *userLocation;
@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, strong) BMKAddrInfo *addrInfo;
@property (strong, nonatomic) NSTimer            *timer;
@property (strong, nonatomic) KHHLocationController *systemLC;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;

//MARK: - 用于保存信息
//@property (nonatomic, strong) CLPlacemark *placemark;
@end

@implementation KHHBMapLocationController

- (id)init
{
    self = [super init];
    if (self) {
        //mapView
        _mapView = [[BMKMapView alloc] init];
        _mapView.delegate = self;
        //search
        _search = [[BMKSearch alloc] init];
        _search.delegate = self;
        // timestamp
        _timestamp = [NSDate distantPast];
        //系统的定位
        _systemLC = [[KHHLocationController alloc] init];
    }
    return self;
}

- (void)dealloc
{
    self.userLocation = nil;
    self.timestamp = nil;
}

#pragma mark - Interface methods
+ (id)sharedController {
    static id _sharedObj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedObj = [[KHHBMapLocationController alloc] init];
    });
    return _sharedObj;
}

- (void)updateLocation // 更新当前位置信息
{
    //old 30分钟内的定位不去真定位
//    NSDate *now = [NSDate date];
//    if (nil == _userLocation || // 之前未获取过
//        [now timeIntervalSinceDate:self.timestamp] > KHH_LOCATION_REFRESH_INTERVAL)
//    {   // 两次刷新之间的时间间隔
//        // 刷新位置
//        [self.mapView setShowsUserLocation:NO];
//        [self.mapView setShowsUserLocation:YES];
//    } else {
//        // 间隔太短，立即返回之前的位置
//        // 当作更新成功处理
//        if (!_userLocation) {
//            _userLocation = self.mapView.userLocation;
//        }
//        
//        //解析一下地址
//        [self reverseGeocode];
////        [self updateSucceeded];
//    }
    
    //20121213 只要调更新就去取一次，定位时也用系统默认的开始定位，如果30s后百度还没有定到，就用系统定到的经纬度，用百度解析
    //启动定位超时timer
    ALog(@"[I_1_2] 启动定位超时timer。");
    [self startTimer:@"BMapLocateTimeOut:"];
    //开始定位
     DLog(@"开始定位%@", [NSDate date]);
    //百度的定位
    [self.mapView setShowsUserLocation:NO];
    [self.mapView setShowsUserLocation:YES];
    //系统的定位
    [_systemLC updateLocation:NO];
}

//启动30s的超时timer
-(void) startTimer:(NSString *) selector {
    //停止上次未完成的timer  NSSelectorFromString
    [self stopTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:KHH_LOCATION_REFRESH_TIMEOUT target:self selector:NSSelectorFromString(selector) userInfo:nil repeats:NO];
}
#pragma mark - Utils
//可能来自百度或者系统
- (void)updateSucceeded {
    if (!_addrInfo) {
        [self postASAPNotificationName:KHHLocationUpdateFailed];
        return;
    }
    
    self.timestamp = [NSDate date];// 时间戳
    [self postASAPNotificationName:KHHLocationUpdateSucceeded];
}
- (void)updateFailedWithError:(NSError *)err {
    NSDictionary *info = @{ kInfoKeyErrorObject : err };
    [self postASAPNotificationName:KHHLocationUpdateFailed
                              info:info];
}
- (void)processUpdatedLocation {
    ALog(@"[I_1_2] 获取到位置 location = %@", _userLocation);
    [self.mapView setShowsUserLocation:NO];
    // 用baiduMap的BMKSearch进行解析
    [self reverseGeocode];
    
}

//解析地址，地址可能是系统或百度获取所得
- (void)reverseGeocode // 解析位置信息为地址
{
    //百度有时候解析老久不返回数据，这里再加个timer如果15秒解析不出就返回解析失败
    ALog(@"[I_1_2] 启动解析超时timer。");
    [self startTimer:@"BMapReverseGeocodeTimeOut:"];
    ALog(@"[II] 开始解析经纬度");
    BOOL rect = [_search reverseGeocode:_coordinate];
    if (!rect) {
        NSError *err = [NSError errorWithDomain:KHHErrorDomain
                                           code:KHHErrorCodeBusy
                                       userInfo:@{
                          kInfoKeyErrorMessage : NSLocalizedString(@"解析失败，无法识别地址！", nil)
                        }];
        [self updateFailedWithError:err];
        DLog(@"解析失败");
    }
}

//百度地图定位超时时
-(void) BMapLocateTimeOut:(NSTimer *)timer {
    //百度地图超时，取系统定位的数据
    DLog(@"[I_2]百度定位超时! %@", [NSDate date]);
    _mapView.showsUserLocation = NO;
    [self stopTimer];
    _coordinate = [_systemLC userLocationCoordinate2D];
    [self reverseGeocode];
}

//百度地图解析超时时
-(void) BMapReverseGeocodeTimeOut:(NSTimer *)timer {
    //百度地图超时，取系统定位的数据
    DLog(@"[III_2]百度解析地址超时! %@", [NSDate date]);
    [self stopTimer];
    //发送更新失败广播
    [self postASAPNotificationName:KHHLocationUpdateFailed];
}

-(void) stopTimer {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma 获取用户的地址信息
//用户详细地址 例:浙江省杭州市滨江区南环路4280号
-(NSString *) userDetailLocation {
    if (!_addrInfo) {
        return nil;
    }
    
    return _addrInfo.strAddr;
}

//用户地址分层地址信息
-(BMKGeocoderAddressComponent *) userAddressCompenent {
    if (!_addrInfo) {
        return nil;
    }
    
    return _addrInfo.addressComponent;
}

//用户当前位置的经纬度信息
-(CLLocationCoordinate2D) userLocationCoordinate2D {
    return _coordinate;
}



#pragma BMKSearchDelegate
- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error
{
    //停止计数timer
    [self stopTimer];
    DLog(@"[III_1]解析地址完成,是否成功 = %d",error == 0);
	if (error == 0) {
        _addrInfo = result;
        //发送解析地址成功
        [self updateSucceeded];
        ALog(@"[III_1] 解析地址数据为地址...%@",_addrInfo.strAddr);
        ALog(@"[III_2] 经纬度 ... long = %.16g,lati = %.16g",_coordinate.longitude,_coordinate.latitude);
	}else {
        NSError *err = [NSError errorWithDomain:KHHErrorDomain
                                           code:KHHErrorCodeBusy
                                       userInfo:@{
                          kInfoKeyErrorMessage : NSLocalizedString(@"解析失败，无法识别地址！", nil)
                        }];
        [self updateFailedWithError:err];
    }
}

#pragma bmkmapviewDelegate
- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    DLog(@"[I_1_1]百度地图定位完成! %@",[NSDate date]);
    //停止计数timer
    [self stopTimer];
    _userLocation = userLocation;
    _coordinate = _userLocation.coordinate;
    if (_systemLC) {
        [_systemLC stopUpdateLocation];
    }
    //解析地址
    [self processUpdatedLocation];
	if (userLocation != nil) {
		DLog(@"%f %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
	}
}

- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
	if (error != nil) {
		DLog(@"locate failed: %@", [error localizedDescription]);
        [self updateFailedWithError:error];
    } else {
		DLog(@"locate failed");
	}
}

- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
	DLog(@"start locate");
}

-(void) mapViewDidStopLocatingUser:(BMKMapView *)mapView {
    DLog(@"stop locate");
}

@end
