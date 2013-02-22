//
//  KHHUser.m
//  CardBook
//
//  Created by CJK on 13-1-14.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHUser.h"

@implementation KHHUser
@synthesize sessionId = _sessionId;
@synthesize companyId = _companyId;
@synthesize username = _username;
@synthesize password = _password;
@synthesize userId = _userId;
@synthesize isAutoReceive = _isAutoReceive;
@synthesize companyName = _companyName;
@synthesize orgId = _orgId;
@synthesize permissionName = _permissionName;
@synthesize deviceToken = _deviceToken;

+ (KHHUser *)shareInstance
{
    static KHHUser *_shareInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _shareInstance = [[self alloc] init];
    });
    
    return _shareInstance;
}

- (void)fromJsonData:(NSDictionary *)dic
{
    self.sessionId = dic[@"sessionId"];
    self.companyId = dic[@"companyId"];
    self.username = dic[@"username"];
    self.password = dic[@"password"];
    self.userId = dic[@"userId"];
    self.isAutoReceive = dic[@"isAutoReceive"];
    self.companyName = dic[@"companyName"];
    self.orgId = dic[@"orgId"];
    self.permissionName = dic[@"permissionName"];
    
    
}

- (NSString *)sessionId
{
    if (!_sessionId) {
        _sessionId = [[NSUserDefaults standardUserDefaults]valueForKey:@"kSessionId"];
        
    }
    return _sessionId;
}

- (void)setSessionId:(NSString *)sessionId
{
    if (![_sessionId isEqualToString:sessionId]) {
        
        [[NSUserDefaults standardUserDefaults] setValue:sessionId forKey:@"kSessionId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _sessionId = sessionId;
    }
}


- (NSString *)companyId
{
    if (!_companyId) {
        _companyId = [[NSUserDefaults standardUserDefaults]valueForKey:@"kCompanyId"];
        
    }
    return _companyId;
}

- (void)setCompanyId:(NSString *)companyId
{
    if (![_companyId isEqualToString:companyId]) {
        if ([companyId isKindOfClass:[NSNumber class]]) {
            companyId = [NSString stringWithFormat:@"%@",companyId];
        }
        [[NSUserDefaults standardUserDefaults] setValue:companyId forKey:@"kCompanyId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _companyId = companyId;
    }
}

- (void)setIsFinishLogin:(Boolean)isFinishLogin
{
    [[NSUserDefaults standardUserDefaults] setBool:isFinishLogin forKey:@"KIsFinishLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (Boolean)isFinishLogin
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"KIsFinishLogin"];
}



- (NSString *)username
{
    if (!_username) {
        _username = [[NSUserDefaults standardUserDefaults]valueForKey:@"kUsername"];       
        
    }
    return _username;
}

- (void)setUsername:(NSString *)username
{
    if (![_username isEqualToString:username]) {
        [[NSUserDefaults standardUserDefaults] setValue:username forKey:@"kUsername"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _username = username;
    }
}

- (NSString *)password
{
    if (!_password) {
        _password = [[NSUserDefaults standardUserDefaults]valueForKey:@"kPassword"];
        
    }
    return _password;
}

- (void)setPassword:(NSString *)password
{
    if (![_password isEqualToString:password]) {        
        [[NSUserDefaults standardUserDefaults] setValue:password forKey:@"kPassword"];
        [[NSUserDefaults standardUserDefaults] synchronize];        
        _password = password;
    }
}

- (NSString *)userId
{
    if (!_userId) {
        _userId = [[NSUserDefaults standardUserDefaults]valueForKey:@"kUserId"];
        
    }
    return _userId;
}

- (void)setUserId:(NSString *)userId
{
    if (![_userId isEqualToString:userId]) {
        [[NSUserDefaults standardUserDefaults] setValue:userId forKey:@"kUserId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _userId = userId;
    }
}

- (NSString *)isAutoReceive
{
    if (!_isAutoReceive) {
        _isAutoReceive = [[NSUserDefaults standardUserDefaults]valueForKey:@"kIsAutoReceive"];
        
    }
    return _isAutoReceive;
}

- (void)setIsAutoReceive:(NSString *)isAutoReceive
{
    if (![_isAutoReceive isEqualToString:isAutoReceive]) {
        [[NSUserDefaults standardUserDefaults] setValue:isAutoReceive forKey:@"kIsAutoReceive"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _isAutoReceive = isAutoReceive;
    }
}

- (NSString *)companyName
{
    if (!_companyName) {
        _companyName = [[NSUserDefaults standardUserDefaults]valueForKey:@"kCompanyName"];
        
    }
    return _companyName;
}

- (void)setCompanyName:(NSString *)companyName
{
    if (![_companyName isEqualToString:companyName]) {
        [[NSUserDefaults standardUserDefaults] setValue:companyName forKey:@"kCompanyName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _companyName = companyName;
    }
}

- (NSString *)orgId
{
    if (!_orgId) {
        _orgId = [[NSUserDefaults standardUserDefaults]valueForKey:@"kOrgId"];
        
    }
    return _orgId;
}


- (void)setOrgId:(NSString *)orgId
{
    if (![_orgId isEqualToString:orgId]) {
        [[NSUserDefaults standardUserDefaults] setValue:orgId forKey:@"kOrgId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _orgId = orgId;
    }
}


- (NSString *)permissionName
{
    if (!_permissionName) {
        _permissionName = [[NSUserDefaults standardUserDefaults]valueForKey:@"kPermissionName"];
        
    }
    return _permissionName;
}


- (void)setPermissionName:(NSString *)permissionName
{
    if (![_permissionName isEqualToString:permissionName]) {
        [[NSUserDefaults standardUserDefaults] setValue:permissionName forKey:@"kPermissionName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _permissionName = permissionName;
    }
}

- (NSString *)deviceToken
{
    if (!_deviceToken) {
        _deviceToken = [[NSUserDefaults standardUserDefaults]valueForKey:@"kDeviceToken"];
        
    }
    return _deviceToken;
}

- (void)setDeviceToken:(NSString *)deviceToken
{
    if (![_deviceToken isEqualToString:deviceToken]) {
        [[NSUserDefaults standardUserDefaults] setValue:deviceToken forKey:@"kDeviceToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        _permissionName = deviceToken;
    }
}

- (void)clear
{
    self.sessionId = @"";
    self.companyId = @"";
    self.isFinishLogin = NO;
    self.companyName = @"";
    self.userId = @"";
    self.isAutoReceive = @"";
    self.orgId = @"";
    self.permissionName = @"";
    self.isAddMobPhoneGroup = NO;
   
}

#pragma mark - settings

- (void)setIsAddMobPhoneGroup:(Boolean)isAddMobPhoneGroup
{
    [[NSUserDefaults standardUserDefaults] setBool:isAddMobPhoneGroup forKey:@"KIsAddMob"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (Boolean)isAddMobPhoneGroup
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"KIsAddMob"];
}

- (void)setIsFirstLaunch:(Boolean)isFirstLaunch
{
    [[NSUserDefaults standardUserDefaults] setBool:isFirstLaunch forKey:@"KIsFirst"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (Boolean)isFirstLaunch
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"KIsFirst"];
}

@end
