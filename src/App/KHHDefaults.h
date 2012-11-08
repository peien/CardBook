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

@interface KHHDefaults : NSObject 
+ (KHHDefaults *)sharedDefaults;
@end

@interface KHHDefaults (KHH) <AppStartUserDefaults>
// 登录或注册成功后，
// 保存user,password,authorizationID,userID,companyID,departmentID,permission
- (void)saveLoginOrRegisterResult:(NSDictionary *)dict;
// 登出时清理设置
- (void)clearSettingsAfterLogout;

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

#pragma mark - App - MainUI
@property (nonatomic) NSInteger selectedMainTabIndex;
@property (nonatomic) NSInteger defaultMainUIIndex;
@end