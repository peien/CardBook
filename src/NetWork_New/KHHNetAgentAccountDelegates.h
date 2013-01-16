//
//  KHHNetAgentAccountDelegates.h
//  CardBook
//
//  Created by 王定方 on 13-1-9.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//


#ifndef KHH_NetAgent_Account_Delegates
#define KHH_NetAgent_Account_Delegates
@protocol KHHNetAgentAccountDelegates <NSObject>
@optional
//登录
- (void)loginSuccess:           (NSDictionary *) userInfo;
- (void)loginFailed:            (NSDictionary *) userInfo;

//选择公司登录
- (void)loginSuccessStep2:           (NSDictionary *) userInfo;
- (void)loginFailedStep2:            (NSDictionary *) userInfo;
//注册
- (void)createAccountSuccess:   (NSDictionary *) userInfo;
- (void)createAccountFailed:    (NSDictionary *) userInfo;
//修改密码
- (void)changePasswordSuccess;
- (void)changePasswordFailed:    (NSDictionary *) userInfo;
//重置密码
- (void)resetPasswordSuccess;
- (void)resetPasswordFailed:    (NSDictionary *) userInfo;

@end

#endif