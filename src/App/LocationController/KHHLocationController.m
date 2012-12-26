//
//  KHHLocationController.m
//  CardBook
//
//  Created by Sun Ming on 12-10-10.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHLocationController.h"
#import "KHHClasses.h"
#import "KHHMacros.h"
#import "KHHNotifications.h"
#import "KHHStatusCodes.h"
#import "KHHTypes.h"

//const NSTimeInterval KHH_LOCATION_REFRESH_INTERVAL = 30 * 60; // 30 min.

@interface KHHLocationController () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, assign) BOOL isNeedNotify;

//MARK: - 用于保存信息
@property (nonatomic, strong) CLPlacemark *placemark;
@end

@implementation KHHLocationController
- (id)init
{
    self = [super init];
    if (self) {
        // locationManager
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        _locationManager.distanceFilter = 100;
        // geocoder
        _geocoder = [[CLGeocoder alloc] init];
        // timestamp
        _timestamp = [NSDate distantPast];
    }
    return self;
}
- (void)dealloc
{
    self.locationManager = nil;
    self.geocoder = nil;
    self.timestamp = nil;
}
#pragma mark - Interface methods
//+ (id)sharedController {
//    static id _sharedObj = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _sharedObj = [[KHHLocationController alloc] init];
//    });
//    return _sharedObj;
//}

- (void)updateLocation // 更新当前位置信息
{
    [self updateLocation:YES];
}

/*
 主要用于 百度地图定位超时时，用系统自带的定位获取经纬度
 不发送定位成功广播
 */
-(void) updateLocation:(BOOL) notify{
    //定位成功后是否要notify用户
    _isNeedNotify = notify;
    //    CLLocation *lastLocation = self.locationManager.location;
    //    NSDate *now = [NSDate date];
    //    if (nil == lastLocation || // 之前未获取过
    //        [now timeIntervalSinceDate:self.timestamp] > KHH_LOCATION_REFRESH_INTERVAL)
    //    {   // 两次刷新之间的时间间隔
    //        // 刷新位置
    [self.locationManager startUpdatingLocation];
    //    } else {
    //        // 间隔太短，立即返回之前的位置
    //        // 当作更新成功处理
    //        [self updateSucceeded];
    //    }
}

/**
 获取用户当前经纬度
 用之前一定要调过updateLocation 或updateLocation:bool
 */
-(CLLocationCoordinate2D) userLocationCoordinate2D {
    if (!_locationManager) {
        return KHH_DEFAULT_COORDINATE;
    }
    
    return _locationManager.location.coordinate;
}

/*
 外面强制关闭定位
 */
-(void) stopUpdateLocation {
    if (_locationManager) {
        [_locationManager stopUpdatingLocation];
    }
}
#pragma mark - Utils
/*
 地址更新成功把地址信息存入字典广播出去。解析方法
 //默认的定位解析后地址拼装
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
 NSString *addressString = ABCreateStringWithAddressDictionary(self.placeMark.addressDictionary, NO);
 */
- (void)updateSucceeded {
    CLLocationCoordinate2D coordinate = self.locationManager.location.coordinate;
    CLPlacemark *placemark = self.placemark;
    NSNumber *latitude = [NSNumber numberWithDouble:coordinate.latitude];
    NSNumber *longitude = [NSNumber numberWithDouble:coordinate.longitude];
    NSMutableDictionary *info = [NSMutableDictionary dictionaryWithCapacity:3];
    if (placemark) {
        info[kInfoKeyPlacemark] = placemark;
    }
    if (latitude) {
        info[kInfoKeyLocationLatitude] = latitude;
    }
    if (longitude) {
        info[kInfoKeyLocationLongitude] = longitude;
    }
    self.timestamp = [NSDate date];// 时间戳
    
    [self postASAPNotificationName:KHHLocationUpdateSucceeded info:info];
}
- (void)updateFailedWithError:(NSError *)err {
    NSDictionary *info = @{ kInfoKeyErrorObject : err };
    [self postASAPNotificationName:KHHLocationUpdateFailed
                              info:info];
}
- (void)processUpdatedLocation {
//    ALog(@"[II] 获取到位置 location = %@", self.locationManager.location);
    DLog(@"系统定位完成! %@", [NSDate date]);
    [self.locationManager stopUpdatingLocation];
    
    //要发送广播时就解析数据，不发送广播时就不解析
    if (_isNeedNotify) {
        if (self.geocoder.geocoding) {
            // geocoder 正在解析数据
            // 本次更新失败，返回“忙”
            NSError *err = [NSError errorWithDomain:KHHErrorDomain
                                               code:KHHErrorCodeBusy
                                           userInfo:@{
                              kInfoKeyErrorMessage : NSLocalizedString(@"正忙着！", nil)
                            }];
            [self updateFailedWithError:err];
            return;
        }
        // geocoder 空闲，则开始解析数据
        [self reverseGeocode];
    }
}
- (void)reverseGeocode // 解析位置信息为地址
{
    ALog(@"[II] 解析地址数据为地址...");
    CLLocation *location = self.locationManager.location;
    CLGeocodeCompletionHandler handler = ^(NSArray *placemarks, NSError *error) {
        if (error){
            // 更新失败了
            ALog(@"[EE] ERROR!! 解析失败! error = %@", error);
            [self updateFailedWithError:error];
            return;
        }
        // 更新成功了
        ALog(@"[II] 解析成功! placemarks = %@", placemarks);
        self.placemark = [placemarks lastObject];
        ALog(@"[II] place = %@", self.placemark);
        // 
        [self updateSucceeded];
    };
    [self.geocoder reverseGeocodeLocation:location
                        completionHandler:handler];
}
#pragma mark - CLLocationManagerDelegate methods
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [manager stopUpdatingLocation];
    [self updateFailedWithError:error];
}
//MARK: - ios 5
- (void)locationManager:(CLLocationManager *)manager
didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    [self processUpdatedLocation];
}
//MARK: - ios 6
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    [self processUpdatedLocation];
}

@end
