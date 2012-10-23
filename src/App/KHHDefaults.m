//
//  KHHDefaults.m
//  CardBook
//
//  Created by 孙铭 on 9/11/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHDefaults.h"
#import "KHHKeys.h"
#import "KHHTypes.h"
#import "KHHNotifications.h"

static NSString * const SettingsFileName = @"KHHAppSettings";
static NSString * const SettingsFileType = @"plist";

static NSString * const KHHDefaultsKeyID = @"khh_ID";
static NSString * const KHHDefaultsKeyAutoLogin = @"khh_autoLogin";
static NSString * const KHHDefaultsKeyAutoReceive = @"khh_autoReceive";

static NSString * const KHHDefaultsKeyCurrentUser = @"khh_currentUser";
static NSString * const KHHDefaultsKeyCurrentPassword = @"khh_currentPassword";
static NSString * const KHHDefaultsKeyCurrentAuthorizationID = @"khh_currentAuthorizationID";
static NSString * const KHHDefaultsKeyCurrentUserID = @"khh_currentUserID";
static NSString * const KHHDefaultsKeyCurrentCompanyID = @"khh_currentCompanyID";
static NSString * const KHHDefaultsKeyCurrentDepartmentID = @"khh_currentdeDartmentID";
static NSString * const KHHDefaultsKeyCurrentPermission = @"khh_currentPermission";

static NSString * const KHHDefaultsKeyDepartmentID = @"khh_departmentID";
static NSString * const KHHDefaultsKeyFirstLaunch = @"khh_firstLaunch";
static NSString * const KHHDefaultsKeyLastUser = @"khh_lastUser";
static NSString * const KHHDefaultsKeyLoggedIn = @"khh_loggedIn";
static NSString * const KHHDefaultsKeyPassword = @"khh_password";
static NSString * const KHHDefaultsKeypermission = @"khh_permission";
static NSString * const KHHDefaultsKeyShowCompanyLogo = @"khh_showCompanyLogo";
static NSString * const KHHDefaultsKeyRememberPassword = @"khh_rememberPassword";
static NSString * const KHHDefaultsKeyUser = @"khh_user";

static NSString * const KHHDefaultsKeyCompanyList = @"khh_companyList";
static NSString * const KHHDefaultsKeyUserList = @"khh_userList";

// App - MainUI
static NSString * const KHHDefaultsKeySelectedMainTabIndex = @"khh_MainUI_selectedTabIndex";
static NSString * const KHHDefaultsKeyDefaultMainUIIndex = @"khh_MainUI_defaultIndex";

@interface KHHDefaults ()
@property (nonatomic, weak) NSUserDefaults *defaults;

// 导入设置
- (void)registerSettings;

// 获取值
- (BOOL)boolForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key;
- (NSNumber *)numberForKey:(NSString *)key;
- (NSArray *)arrayForKey:(NSString *)key;
- (NSDictionary *)dictionaryForKey:(NSString *)key;

// 更新值
- (void)setBool:(BOOL)value
         forKey:(NSString *)key;
- (void)setString:(NSString *)value
           forKey:(NSString *)key;
- (void)setNumber:(NSNumber *)value
           forKey:(NSString *)key;
- (void)setArray:(NSArray *)array
          forKey:(NSString *)key;
- (void)setDictionary:(NSDictionary *)dict
               forKey:(NSString *)key;
// Utils

@end

@implementation KHHDefaults
+ (KHHDefaults *)sharedDefaults {
    static id _sharedObj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedObj = [[KHHDefaults alloc] initDefaults];
    });
    return _sharedObj;
}
- (id)initDefaults
{
    self = [super init];
    if (self) {
        _defaults = [NSUserDefaults standardUserDefaults];
        [self registerSettings];
    }
    return self;
}
// 程序启动时导入设置
- (void)registerSettings
{
    NSString *settingsFilePath = [[NSBundle mainBundle] pathForResource:SettingsFileName
                                                                  ofType:SettingsFileType];
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:settingsFilePath];
    [self.defaults registerDefaults:settings];
}
- (BOOL)boolForKey:(NSString *)key
{
    return [self.defaults boolForKey:key];
}
- (NSString *)stringForKey:(NSString *)key
{
    return [self.defaults stringForKey:key];
}
- (NSNumber *)numberForKey:(NSString *)key {
    return [self.defaults objectForKey:key];
}
- (NSArray *)arrayForKey:(NSString *)key {
    return [self.defaults arrayForKey:key];
}
- (NSDictionary *)dictionaryForKey:(NSString *)key {
    return [self.defaults dictionaryForKey:key];
}
- (void)setObject:(id)value
           forKey:(NSString *)key {
    [self.defaults setObject:value forKey:key];
    [self.defaults synchronize];
}
- (void)setBool:(BOOL)value
         forKey:(NSString *)key {
    [self.defaults setBool:value forKey:key];
    [self.defaults synchronize];
}
- (void)setString:(NSString *)value
           forKey:(NSString *)key {
    [self setObject:value forKey:key];
}
- (void)setNumber:(NSNumber *)value
           forKey:(NSString *)key {
    [self setObject:value forKey:key];
}
- (void)setArray:(NSArray *)value
          forKey:(NSString *)key {
    [self setObject:value forKey:key];
}
- (void)setDictionary:(NSDictionary *)value
               forKey:(NSString *)key {
    [self setObject:value forKey:key];
}

@end
@implementation KHHDefaults (KHH)
- (void)saveLoginOrRegisterResult:(NSDictionary *)dict
// 保存user,userID,authorizationID,password,companyID,companyLogo,autoReceive
{
    NSString *user = self.currentUser;
    NSString *password = self.currentPassword;
    NSNumber *authorizationID = [dict objectForKey:kInfoKeyAuthorizationID];
    NSNumber *userID = [self UserIDFromAuthorizationID:authorizationID];
    BOOL autoReceive = [[dict objectForKey:kInfoKeyAutoReceive] integerValue];
    NSNumber *companyID = [dict objectForKey:kInfoKeyCompanyID];
    if (nil == companyID) {
        companyID = @0;
    }
    NSNumber *departmentID = [dict objectForKey:kInfoKeyDepartmentID];
    if (nil == departmentID) {
        departmentID = @0;
    }
    NSString *permission = [dict objectForKey:kInfoKeyPermission];
    if (nil == permission) {
        permission = @"";
    }
    
    // 保存数据：take 1
    self.loggedIn = YES;
    self.autoReceive = autoReceive;
    self.lastUser = user;
    self.currentAuthorizationID = authorizationID;
    self.currentUserID = userID;
    self.currentCompanyID = companyID;
    self.currentDepartmentID = departmentID;
    self.currentPermission = permission;
    
    // 保存数据：take 2，登陆过的用户列表
    // 获取登陆过的用户列表
    NSMutableArray *userList = [NSMutableArray arrayWithArray:[self userList]];
    // 遍历当前userID是否存在,不存在则创建新的userDict
    NSMutableDictionary *theUserDict = [self dictionaryWithID:userID offArray:userList];
    // 更新用户数据
    theUserDict[KHHDefaultsKeyUser] = user;
    if (self.rememberPassword) {
        theUserDict[KHHDefaultsKeyPassword] = password;
    }
    theUserDict[KHHDefaultsKeyID] = userID;
    
    // 保存数据：take 3，用户关联的公司列表
    // 从用户Dict里取出公司列表
    NSMutableArray *companyList = [self companyListFromUserDictionary:theUserDict];
    // 遍历当前companyID是否存在,不存在则创建新的companyDict
    NSMutableDictionary *theComDict = [self dictionaryWithID:companyID offArray:companyList];
    // 更新用户的公司数据
    [theComDict setValue:companyID forKey:KHHDefaultsKeyID];
    [theComDict setValue:departmentID forKey:KHHDefaultsKeyDepartmentID];
    [theComDict setValue:permission forKey:KHHDefaultsKeypermission];
    // 把companyDict插到列表头，并删除多余，目前只保留4个。
    [companyList insertObject:theComDict atIndex:0];
    if ([companyList count] > 4) {
        [companyList removeLastObject];
    }
    // 把companyList设回userDict
    [theUserDict setValue:companyList forKey:KHHDefaultsKeyCompanyList];
    
    // 把用户插到列表头，并删除多余用户，目前只保留4个。
    [userList insertObject:theUserDict atIndex:0];
    if ([userList count] > 4) {
        [userList removeLastObject];
    }
    
    // 保存数据：take 4，把全部修改结果存回UserDefaults
    [self setArray:userList forKey:KHHDefaultsKeyUserList];
    DLog(@"[II] UserDefaults = %@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
}
- (void)clearSettingsAfterLogout {
    self.loggedIn = NO;
    self.currentUser = @"";
    self.currentUserID = [NSNumber numberWithInteger:0];
    self.currentAuthorizationID = [NSNumber numberWithInteger:0];
    self.currentPassword = @"";
    self.currentCompanyID = [NSNumber numberWithInteger:0];
    self.currentDepartmentID = [NSNumber numberWithInteger:0];
    self.currentPermission = @"";
}
#pragma mark - User settings
- (BOOL)firstLaunch {
    return [self boolForKey:KHHDefaultsKeyFirstLaunch];
}
- (void)setFirstLaunch:(BOOL)value // 设置firstLaunch为NO。
{
    [self setBool:value
           forKey:KHHDefaultsKeyFirstLaunch];
}
- (NSString *)currentUser  // 当前用户名（手机号），在点击“登录”或“注册”按钮后，以及登录成功后应设新值。
{
    return [self stringForKey:KHHDefaultsKeyCurrentUser];
}
- (void)setCurrentUser:(NSString *)value {
    [self setString:value forKey:KHHDefaultsKeyCurrentUser];
}
- (NSString *)currentPassword // 当前密码，在点击“登录”或“注册”按钮后，以及登录成功后应设新值。
{
    return [self stringForKey:KHHDefaultsKeyCurrentPassword];
}
- (void)setCurrentPassword:(NSString *)value {
    [self setString:value forKey:KHHDefaultsKeyCurrentPassword];
}
- (NSNumber *)currentAuthorizationID // 当前用户鉴权ID，登录成功后应设新值。
{
    return [self numberForKey:KHHDefaultsKeyCurrentAuthorizationID];
}
- (void)setCurrentAuthorizationID:(NSNumber *)value {
    [self setNumber:value forKey:KHHDefaultsKeyCurrentAuthorizationID];
}
- (NSNumber *)currentUserID // 当前用户真实ID，登录成功后应设新值。
{
    return [self numberForKey:KHHDefaultsKeyCurrentUserID];
}
- (void)setCurrentUserID:(NSNumber *)value {
    [self setNumber:value forKey:KHHDefaultsKeyCurrentUserID];
}
- (NSNumber *)currentCompanyID // 当前用户公司ID，登录成功后应设新值。
{
    return [self numberForKey:KHHDefaultsKeyCurrentCompanyID];
}
- (void)setCurrentCompanyID:(NSNumber *)value {
    [self setNumber:value forKey:KHHDefaultsKeyCurrentCompanyID];
}
- (NSNumber *)currentDepartmentID // 当前用户部门ID，登录成功后应设新值。
{
    return [self numberForKey:KHHDefaultsKeyCurrentDepartmentID];
}
- (void)setCurrentDepartmentID:(NSNumber *)value {
    [self setNumber:value forKey:KHHDefaultsKeyCurrentDepartmentID];
}
- (NSString *)currentPermission // 当前用户权限，登录成功后应设新值。
{
    return [self stringForKey:KHHDefaultsKeyCurrentPermission];
}
- (void)setCurrentPermission:(NSString *)value {
    [self setString:value forKey:KHHDefaultsKeyCurrentPermission];
}
- (NSString *)lastUser // 最后登录的用户名。
{
    return [self stringForKey:KHHDefaultsKeyLastUser];
}
- (void)setLastUser:(NSString *)value {
    [self setString:value forKey:KHHDefaultsKeyLastUser];
}
- (BOOL)autoLogin {
    return [self boolForKey:KHHDefaultsKeyAutoLogin];
}
- (void)setAutoLogin:(BOOL)value {
    [self setBool:value
           forKey:KHHDefaultsKeyAutoLogin];
}
- (BOOL)autoReceive {
    return [self boolForKey:KHHDefaultsKeyAutoReceive];
}
- (void)setAutoReceive:(BOOL)value {
    [self setBool:value
           forKey:KHHDefaultsKeyAutoReceive];
}
- (BOOL)loggedIn // 已登录：登录成功为YES，登录失败和已登出为NO
{
    return [self boolForKey:KHHDefaultsKeyLoggedIn];
}
- (void)setLoggedIn:(BOOL)value // 登录成功和注册成功设为YES，登录失败和已登出设为NO
{
    [self setBool:value
           forKey:KHHDefaultsKeyLoggedIn];
}
- (BOOL)showCompanyLogo {
    return [self boolForKey:KHHDefaultsKeyShowCompanyLogo];
}
- (void)setShowCompanyLogo:(BOOL)value {
    [self setBool:value
           forKey:KHHDefaultsKeyShowCompanyLogo];
}
- (BOOL)rememberPassword {
    return [self boolForKey:KHHDefaultsKeyRememberPassword];
}
- (void)setRememberPassword:(BOOL)value {
    [self setBool:value
           forKey:KHHDefaultsKeyRememberPassword];
}
#pragma mark - App - MainUI
- (NSInteger)selectedMainTabIndex {
    return [[self numberForKey:KHHDefaultsKeySelectedMainTabIndex] integerValue];
}
- (void)setSelectedMainTabIndex:(NSInteger)index {
    [self setNumber:[NSNumber numberWithInteger:index]
             forKey:KHHDefaultsKeySelectedMainTabIndex];
}
- (NSInteger)defaultMainUIIndex
{
    return [[self numberForKey:KHHDefaultsKeyDefaultMainUIIndex] integerValue];
}
- (void)setDefaultMainUIIndex:(NSInteger)index{
    [self setNumber:[NSNumber numberWithInteger:index]
             forKey:KHHDefaultsKeyDefaultMainUIIndex];
}

#pragma mark - Utils
- (NSMutableArray *)userList {
    NSArray *array = [self arrayForKey:KHHDefaultsKeyUserList];
    return [NSMutableArray arrayWithArray:array];
}
- (NSMutableArray *)companyListFromUserDictionary:(NSDictionary *)dict {
    NSArray *array = [dict objectForKey:KHHDefaultsKeyCompanyList];
    return [NSMutableArray arrayWithArray:array];
}
- (NSNumber *)UserIDFromAuthorizationID:(NSNumber *)authID {
    NSString *original = [authID stringValue];
    NSString *numStr = [original substringWithRange:NSMakeRange(3, original.length - 6)];
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * result = [f numberFromString:numStr];
    return result;
}
// 把具有ID属性的dict从array中取出（从array删除）,无则新建
- (NSMutableDictionary *)dictionaryWithID:(NSNumber *)ID
                                 offArray:(NSMutableArray *)array {
    NSInteger idx = -1;// -1表示不存在。
    for (NSDictionary *aDict in array) {
        NSNumber *value = [aDict objectForKey:KHHDefaultsKeyID];
        if (value) {
            if ([ID isEqualToNumber:value]) {
                // 若存在，则取其index
                idx = [array indexOfObject:aDict];
                break;
            }
        }
    }
    NSMutableDictionary *result = nil;
    if (-1 == idx) {
        result = [NSMutableDictionary dictionary];
    } else {
        result = [NSMutableDictionary dictionaryWithDictionary:[array objectAtIndex:idx]];
        [array removeObjectAtIndex:idx];
    }
    return result;
}
@end