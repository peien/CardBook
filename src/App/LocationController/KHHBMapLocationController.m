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

const NSTimeInterval KHH_LOCATION_REFRESH_INTERVAL = 30 * 60; // 30 min.

@interface KHHBMapLocationController ()
@property (nonatomic, strong) BMKUserLocation *userLocation;
@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, strong) BMKAddrInfo *addrInfo;

//MARK: - 用于保存信息
//@property (nonatomic, strong) CLPlacemark *placemark;
@end

@implementation KHHBMapLocationController
@synthesize mapView = _mapView;
@synthesize search = _search;
@synthesize timestamp = _timestamp;
@synthesize userLocation = _userLocation;
@synthesize addrInfo = _addrInfo;

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
    NSDate *now = [NSDate date];
    if (nil == _userLocation || // 之前未获取过
        [now timeIntervalSinceDate:self.timestamp] > KHH_LOCATION_REFRESH_INTERVAL)
    {   // 两次刷新之间的时间间隔
        // 刷新位置
        [self.mapView setShowsUserLocation:NO];
        [self.mapView setShowsUserLocation:YES];
    } else {
        // 间隔太短，立即返回之前的位置
        // 当作更新成功处理
        if (!_userLocation) {
            _userLocation = self.mapView.userLocation;
        }
        
        //解析一下地址
        [self reverseGeocode];
//        [self updateSucceeded];
    }
}
#pragma mark - Utils
- (void)updateSucceeded {
    if (!_userLocation) {
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
    ALog(@"[II] 获取到位置 location = %@", _userLocation);
    [self.mapView setShowsUserLocation:NO];
    // 用baiduMap的BMKSearch进行解析
    [self reverseGeocode];
}
- (void)reverseGeocode // 解析位置信息为地址
{
    ALog(@"[II] 解析地址数据为地址...");
    BOOL rect = [_search reverseGeocode:_userLocation.coordinate];
    if (!rect) {
        DLog(@"解析失败");
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
    if (!_userLocation) {
        return CLLocationCoordinate2DMake(0, 0);
    }
    
    return _userLocation.coordinate;
}



#pragma BMKSearchDelegate
- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error
{
	if (error == 0) {
        DLog(@"user location detail = %@",result);
        _addrInfo = result;
        //test
        [self updateSucceeded];
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
    _userLocation = userLocation;
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
