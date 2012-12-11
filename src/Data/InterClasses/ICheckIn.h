//
//  ICheckIn.h
//  CardBook
//
//  Created by Sun Ming on 12-10-10.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <CoreLocation/CoreLocation.h>
#import "SMObject.h"
#import "Card.h"
#import "IAddress.h"
#import "BMapKit.h"

/*!
 签到 kinghhEmployeeVisitCustomService.signInNew
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=218
 bean.cardId      Long 	 是 	 名片ID
 bean.deviceToken 	 String 	 否 	 手机设备号
 bean.country 	 String 	 否 	 国家
 bean.province 	 String 	 否 	 省
 bean.city 	 String 	 否 	 城市
 bean.address 	 String 	 否 	 地址
 bean.longitude 	 Double 	 否 	 经度
 bean.latitude 	 Double 	 否 	 纬度
 bean.col1 	 String 	 否 	 备忘录
 imgFiles 	 File 	 否 	 签到图片(可传多张，名称相同即可)
 bean.col3 	 String 	 否 	 备注
 bean.col4 	 String 	 否 	 备注
 bean.col5 	 String 	 否 	 备注
 */
@interface ICheckIn : SMObject
@property (nonatomic, strong) NSNumber    *cardID; // bean.cardId 是 名片ID
@property (nonatomic, strong) NSString    *deviceToken; // bean.deviceToken 否 手机设备号
@property (nonatomic, strong) NSNumber    *latitude;// bean.latitude
@property (nonatomic, strong) NSNumber    *longitude;// bean.longitude
//@property (nonatomic, strong) CLPlacemark *placemark;// 详细的地址信息（默认定位的）
@property (nonatomic, strong) BMKGeocoderAddressComponent *addressComponent;
@property (nonatomic, strong) NSString    *memo; //bean.col1 否 备忘录
@property (nonatomic, strong) NSArray     *imageArray;//UIImage数组
@end

@interface ICheckIn (Methods)
- (id)initWithCard:(Card *)card; // 因为cardID是必传的
@end
