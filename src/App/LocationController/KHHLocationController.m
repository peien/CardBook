//
//  KHHLocationController.m
//  CardBook
//
//  Created by Sun Ming on 12-10-10.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHLocationController.h"
#import <CoreLocation/CoreLocation.h>

@interface KHHLocationController () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
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

- (void)refreshCurrentLocation //更新当前位置信息
{
    if (nil == self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.locationManager.distanceFilter = 500;
    [self.locationManager startUpdatingLocation];
}
@end
