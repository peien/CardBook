//
//  KHHBMapLocationController.h
//  CardBook
//
//  Created by 王定方 on 12-12-11.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "SMObject.h"
#import "BMapKit.h"
#import <CoreLocation/CoreLocation.h>

@interface KHHBMapLocationController : SMObject<BMKMapViewDelegate, BMKSearchDelegate>

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKSearch *search;

+ (id)sharedController;

/*!
 更新当前位置信息:
 更新成功与否通过 notification KHHLocationUpdateSucceeded 和 KHHLocationUpdateFailed 返回。
 调用前注册监听这两个notification。
 在notification的处理方法里取消监听。
 */
- (void)updateLocation;

/*
 用户的详细地址
 */
-(NSString *) userDetailLocation;

/*
 用户地址分层信息（省、市、县、详细地址）
 */
-(BMKGeocoderAddressComponent *) userAddressCompenent;

/*
 获取用户当前位置的经纬度
 */
-(CLLocationCoordinate2D) userLocationCoordinate2D;

- (void)doGetLocation:(void(^)(BMKAddrInfo *_addrInfo)) done fail:(void(^)())fail;
@end
