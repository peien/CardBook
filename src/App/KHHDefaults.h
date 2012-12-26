//
//  KHHDefaults.h
//  CardBook
//
//  Created by 孙铭 on 9/11/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

/*!
 实际在UserDefaults中存储的结构
 --autoLogin
 |-autoReceive
 |-currentUser
 |-currentUserID
 |-currentAuthorizationID
 |-currentPassword
 |-currentCompanyID
 |-currentDepartmentID
 |-currentPermission
 |-firstLaunch
 |-lastLoggedInUser
 |-loggedIn
 |-rememberPassword
 |-showCompanyLogo
 |-UserList----user0----id
 ............|        |-user
 ............|        |-password
 ............|        |-companyList----company0----id
 ............|                        |           |-departmentID
 ............|                        |           |-permission
 ............|                        |
 ............|                        |-company1
 ............|                        |
 ............|-user1
 ............|
 */

#import <Foundation/Foundation.h>
#import "AppStartController.h"


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
static NSString * const KHHDefaultsKeyAuthorizationID = @"khh_userList";

@interface KHHDefaults : NSObject 
+ (KHHDefaults *)sharedDefaults;
@end

@interface KHHDefaults (KHH) <AppStartUserDefaults>
// 登录或注册成功后，
// 保存user,password,authorizationID,userID,companyID,departmentID,permission
- (void)saveLoginOrRegisterResult:(NSDictionary *)dict;
// 登出时清理设置
- (void)clearSettingsAfterLogout;
//获取登录过的userList
- (NSArray *) historyUserList;

#pragma mark - User settings
@property (nonatomic, strong) NSString *lastUser;// 最后登录的用户名，登录成功后应设新值。
@property (nonatomic, strong) NSString *currentUser;// 当前用户名（手机号），在点击“登录”或“注册”按钮后，以及登录成功后应设新值。
@property (nonatomic, strong) NSNumber *currentUserID;// 当前用户真实ID，登录成功后应设新值。
@property (nonatomic, strong) NSString *currentPassword;// 当前密码，在点击“登录”或“注册”按钮后，以及登录成功后应设新值。
@property (nonatomic, strong) NSNumber *currentAuthorizationID;// 当前用户鉴权ID，登录成功后应设新值。
@property (nonatomic, strong) NSNumber *currentCompanyID;// 当前用户公司ID，登录成功后应设新值。
@property (nonatomic, strong) NSNumber *currentDepartmentID;// 当前用户部门ID，登录成功后应设新值。
@property (nonatomic, strong) NSString *currentPermission;// 当前用户权限，登录成功后应设新值。
@property (nonatomic, getter = isFirstLaunch) BOOL firstLaunch;// 是否为初次启动
@property (nonatomic, getter = isAutoLogin)   BOOL autoLogin;// 自动登录
@property (nonatomic) BOOL autoReceive;// 自动接受名片
@property (nonatomic, getter = isLoggedIn)    BOOL loggedIn;// 已登录：登录成功和注册成功设为YES，登录失败和已登出为NO
@property (nonatomic) BOOL rememberPassword;// 记住密码
@property (nonatomic) BOOL showCompanyLogo;// 是否显示公司logo
@property (nonatomic) BOOL isAddMobPhoneGroup;// 是否添加手机分组
//user login token;
@property (nonatomic,strong)NSString *token;
#pragma mark - App - MainUI
@property (nonatomic) NSInteger selectedMainTabIndex;
@property (nonatomic) NSInteger defaultMainUIIndex;
@end