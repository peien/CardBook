//
//  KHHUser.h
//  CardBook
//
//  Created by CJK on 13-1-14.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHHUser : NSObject

@property (nonatomic,strong) NSString *sessionId;
@property (nonatomic,strong) NSString *companyId;

@property (nonatomic,assign) Boolean isFinishLogin;

@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *password;
@property (nonatomic,assign) NSString *userId;
@property (nonatomic,assign) NSString *isAutoReceive;
@property (nonatomic,strong) NSString *companyName;
@property (nonatomic,assign) NSString *orgId;
@property (nonatomic,strong) NSString *permissionName;
@property (nonatomic,strong) NSString *deviceToken;
//settings
@property (nonatomic,assign) Boolean isAddMobPhoneGroup;
@property (nonatomic,assign) Boolean isFirstLaunch;
+ (KHHUser *)shareInstance;
- (void)fromJsonData:(NSDictionary *)dic;

- (void)clear;

@end
