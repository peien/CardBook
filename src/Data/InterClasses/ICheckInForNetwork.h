//
//  ICheckInForNetWork.h
//  CardBook
// 主要是用在与服务器进行同步时解析数据的
//  Created by 王定方 on 13-1-13.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "SMObject.h"

@interface ICheckInForNetwork : SMObject
@property (nonatomic, strong) NSNumber    *userID;      // uid
@property (nonatomic, strong) NSNumber    *cardID;      // cid
@property (nonatomic, strong) NSString    *version;     // version
@property (nonatomic, strong) NSString    *deviceToken; //device_token 手机设备号
@property (nonatomic, strong) NSNumber    *latitude;    // latitude
@property (nonatomic, strong) NSNumber    *longitude;   // longitude
@property (nonatomic, strong) NSString    *memo;        // col1 备忘录
@property (nonatomic, strong) NSArray     *imageUrls;   //col2 片网址多个时用的“|”分开的
@property (nonatomic, strong) NSString    *leaveTime;   // leave_time
@property (nonatomic, strong) NSString    *userName;    // userName
@property (nonatomic, strong) NSString    *country;     // country
@property (nonatomic, strong) NSString    *province;    // province
@property (nonatomic, strong) NSString    *city;        // city
@property (nonatomic, strong) NSString    *address;     // address

@end

@interface ICheckInForNetwork (KHHTransformation)
//从json解析成ICheckInForNetWork 对象
- (id)updateWithJSON:(NSDictionary *)json;
@end