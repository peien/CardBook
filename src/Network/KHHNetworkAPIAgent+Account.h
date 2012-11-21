//
//  KHHNetworkAPIAgent+Account.h
//  CardBook
//
//  Created by 孙铭 on 8/29/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgent.h"


@interface KHHNetworkAPIAgent (Account) <AppStartNetworkAgent>
/**
 用户登录: "accountService.login"
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=173
 */
- (BOOL)login:(NSString *)user
     password:(NSString *)password;
/**
 用户注册: "accountService.registerAccountNew"
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=172
 */
- (void)createAccount:(NSDictionary *)account;
/**
 修改密码: "userPasswordService.updatePwd"
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=176
 */
- (BOOL)changePassword:(NSString *)oldPassword
         toNewPassword:(NSString *)newPassword;
/**
 重置密码: "userPasswordService.resetPwd"
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=175
 */
- (BOOL)resetPassword:(NSString *)mobile;
/**
 设置是否自动接收名片 userPasswordService.autoReceive
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=186
 */
- (void)markAutoReceive:(BOOL)autoReceive;

@end
