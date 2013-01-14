//
//  InterCard.h
//  CardBook
//
//  Created by Sun Ming on 12-9-26.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KHHTypes.h"
#import "SMObject.h"

@interface InterCard : SMObject
// 内部数据
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic) BOOL isDeleted;
@property (nonatomic, strong) NSNumber *isRead; // 已读 cardbook col3? // received Card
@property (nonatomic) KHHCardModelType modelType;// KHHCardModelType
@property (nonatomic, strong) NSNumber *roleType;
@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, strong) NSNumber *version;
@property (nonatomic, strong) NSNumber *templateID;
//取值如下： 个人名片、公司名片、客服名片
@property (nonatomic, strong) NSString *cardType;
//名片来源：共有下面几种来源，即取值如下：导入名片、客户端自建名片、服务端自建名片、个人用户创建名片
@property (nonatomic, strong) NSString *cardSource;

// 个人重要信息
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *logoURL;
@property (nonatomic, strong) NSString *department; // card col2
@property (nonatomic, strong) NSString *mobilePhone;
@property (nonatomic, strong) NSString *telephone;

// 个人其他联系方式
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *fax;
@property (nonatomic, strong) NSString *aliWangWang;
@property (nonatomic, strong) NSString *microblog;
@property (nonatomic, strong) NSString *msn;
@property (nonatomic, strong) NSString *qq;
@property (nonatomic, strong) NSString *web;

// 个人其他信息
@property (nonatomic, strong) NSString *moreInfo;
@property (nonatomic, strong) NSString *remarks; // card col3?
@property (nonatomic, strong) NSString *memo; // received Card

// 公司其他信息
@property (nonatomic, strong) NSString *businessScope;

// 公司信息
@property (nonatomic, strong) NSNumber *companyID;
@property (nonatomic, strong) NSString *companyName;
@property (nonatomic, strong) NSString *companyEmail; // card col1

// 地址信息
@property (nonatomic, strong) NSString *addressCity;
@property (nonatomic, strong) NSString *addressCountry;
@property (nonatomic, strong) NSString *addressDistrict;
@property (nonatomic, strong) NSString *addressProvince;
@property (nonatomic, strong) NSString *addressStreet;
@property (nonatomic, strong) NSString *addressOther;
@property (nonatomic, strong) NSString *addressZip;

// 银行帐户
@property (nonatomic, strong) NSString *bankAccountBank;
@property (nonatomic, strong) NSString *bankAccountBranch;
@property (nonatomic, strong) NSString *bankAccountName;
@property (nonatomic, strong) NSString *bankAccountNumber;

// 第 2～n frame
@property (nonatomic, strong) NSArray  *frames;// IImage数组
@end

@interface InterCard (KHHTransformation)
+ (InterCard *)interCardWithMyCardJSON:(NSDictionary *)json;
+ (InterCard *)interCardWithPrivateCardJSON:(NSDictionary *)json;
+ (InterCard *)interCardWithReceivedCardJSON:(NSDictionary *)json;
//解析联系人，通过其它方式获取(json接点名不是card时用)
+ (InterCard *)interCardWithReceivedCardJSON:(NSDictionary *)json nodeName:(NSString *) nodeName;
@end
