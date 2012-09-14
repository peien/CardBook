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

@interface KHHDefaults : NSObject
+ (KHHDefaults *)sharedDefaults;
@end

@interface KHHDefaults (KHH)

// 登录或注册成功后，
// 保存user,password,authorizationID,userID,companyID,departmentID,permission
- (void)saveLoginOrRegisterResult:(NSDictionary *)dict;
// 登出时清理设置
- (void)clearSettingsAfterLogout;
#pragma mark - User settings
- (BOOL)firstLaunch; // 是否为初次启动
- (void)setFirstLaunch:(BOOL)value;
- (NSString *)lastUser; // 最后登录的用户名，登录成功后应设新值。
- (NSString *)currentUser;  // 当前用户名（手机号），在点击“登录”或“注册”按钮后，以及登录成功后应设新值。
- (void)setCurrentUser:(NSString *)value;
- (NSString *)currentPassword; // 当前密码，在点击“登录”或“注册”按钮后，以及登录成功后应设新值。
- (void)setCurrentPassword:(NSString *)value;
- (NSNumber *)currentAuthorizationID; // 当前用户鉴权ID，登录成功后应设新值。
- (NSNumber *)currentUserID; // 当前用户真实ID，登录成功后应设新值。
- (NSNumber *)currentCompanyID; // 当前用户公司ID，登录成功后应设新值。
- (NSNumber *)currentDepartmentID; // 当前用户部门ID，登录成功后应设新值。
- (NSString *)currentPermission; // 当前用户权限，登录成功后应设新值。
- (BOOL)autoLogin; // 自动登录
- (void)setAutoLogin:(BOOL)value;
- (BOOL)autoReceive; // 自动接受名片
- (void)setAutoReceive:(BOOL)value;
- (BOOL)loggedIn; // 已登录：登录成功和注册成功设为YES，登录失败和已登出为NO
- (void)setLoggedIn:(BOOL)value;
- (BOOL)rememberPassword; // 记住密码
- (void)setRememberPassword:(BOOL)value;
- (BOOL)showCompanyLogo; // 是否显示公司logo
- (void)setShowCompanyLogo:(BOOL)value;

@end