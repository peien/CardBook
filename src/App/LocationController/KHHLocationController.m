//
//  KHHLocationController.m
//  CardBook
//
//  Created by Sun Ming on 12-10-10.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHLocationController.h"
#import <CoreLocation/CoreLocation.h>
const NSTimeInterval KHH_LOCATION_REFRESH_INTERVAL = 30 * 60; // 30 min.

@interface KHHLocationController () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *lastLocation;
@end

@implementation KHHLocationController
+ (id)sharedController {
    static id _sharedObj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedObj = [[KHHLocationController alloc] init];
    });
    return _sharedObj;
}

- (void)refreshCurrentLocation // 更新当前位置信息
{
    if (nil == self.locationManager) { // 保证locationManager非nil
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.locationManager.distanceFilter = 500;
    }
    self.lastLocation = self.locationManager.location;
    NSDate *now = [NSDate date];
    if ([now timeIntervalSinceDate:self.lastLocation.timestamp] > KHH_LOCATION_REFRESH_INTERVAL) { // 两次刷新之间的时间间隔
        // 刷新位置
        [self.locationManager startUpdatingLocation];
    } else { // 间隔太短，立即返回之前的位置
        // 当作更新成功处理
        [self processUpdatedLocation:self.locationManager];
    }
    
}

#pragma mark - CLLocationManagerDelegate methods
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [manager stopUpdatingLocation];
    NSDictionary *info = @{ kInfoKeyError : error };
    [self postASAPNotificationName:KHHLocationUpdateFailed
                              info:info];
}
//MARK: - ios 5
- (void)locationManager:(CLLocationManager *)manager
didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    [manager stopUpdatingLocation];
    [self processUpdatedLocation:manager];
}
//MARK: - ios 6
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    [manager stopUpdatingLocation];
    [self processUpdatedLocation:manager];
}
- (void)processUpdatedLocation:(CLLocationManager *)manager {
    self.lastLocation = manager.location;
    NSString *lastAddress = @"";
    NSNumber *lastLatitude = [NSNumber numberWithDouble:self.lastLocation.coordinate.latitude];
    NSNumber *lastLongitude = [NSNumber numberWithDouble:self.lastLocation.coordinate.longitude];
    NSDictionary *info = @{
    kInfoKeyLocationAddress   : lastAddress,
    kInfoKeyLocationLatitude  : lastLatitude,
    kInfoKeyLocationLongitude : lastLongitude,
    };
    [self postASAPNotificationName:KHHLocationUpdateSucceeded
                              info:info];
}
@end
