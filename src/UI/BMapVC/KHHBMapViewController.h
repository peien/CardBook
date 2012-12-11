//
//  KHHBMapViewController.h
//  CardBook
//
//  Created by 王国辉 on 12-9-21.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
#import "SuperViewController.h"

@interface KHHBMapViewController : SuperViewController<BMKSearchDelegate, BMKMapViewDelegate,BMKGeneralDelegate>
{
    BMKMapView* _mapView;
    BMKSearch* _search;
}
@property (nonatomic, strong) NSString *companyName;
//百度地图解析需要城市及详细地址
@property (nonatomic, strong) NSString *companyCity;
@property (nonatomic, strong) NSString *companyDetailAddr;
//地址全部地址如果百度解析不出时用第三方的解析，第三方解析失败时用苹果自带的解析
@property (nonatomic, strong) NSString *companyAllAddr;
@end
