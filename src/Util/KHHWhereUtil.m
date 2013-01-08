//
//  KHHWhereUtil.m
//  CardBook
//
//  Created by CJK on 13-1-7.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHWhereUtil.h"

#import <MapKit/MapKit.h>

@implementation KHHWhereUtil
{
    CLLocationManager *locationManager;
    void(^_done)(NSString *where);
    void(^_fail)();
}

+ (KHHWhereUtil *)sharedInstance{
    static KHHWhereUtil *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[KHHWhereUtil alloc] init];
        
    });
    
    return _sharedInstance;
}

- (void)getWhere2:(void(^)(NSString *where)) done fail:(void(^)()) fail
{
    _done = done;
    _fail = fail;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter=1000.0f;
    MKCoordinateSpan theSpan; 
    theSpan.latitudeDelta=0.05;
    theSpan.longitudeDelta=0.05;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    MKCoordinateRegion theRegion;
    theRegion.center=[[locationManager location] coordinate];
    theRegion.span=theSpan;
   // [mapView setRegion:theRegion];
}

- (void)getWhere:(void(^)(NSString *where)) done fail:(void(^)()) fail
{
    _done = done;
    _fail = fail;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter=10.0f;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation: newLocation completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            CLPlacemark *placemark = [array objectAtIndex:0];
            NSLog(@"%@",placemark);
           
        }
    }];
}

- (UIImage*)imgForIndex:(int)index
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"ic_shuaxin%d",index+1]];
}

@end
