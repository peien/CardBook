//
//  KHHNetClientAccountDelegates.h
//  CardBook
//
//  Created by 王定方 on 13-1-9.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//


#ifndef KHH_NetClient_Account_Delegates
#define KHH_NetClient_Account_Delegates
@protocol KHHNetClientAccountDelegates <NSObject>
@optional
//登录
-(void) loginSuccess:           (NSDictionary *) userInfo;
-(void) loginFailed:            (NSDictionary *) userInfo;
//注册
-(void) createAccountSuccess:   (NSDictionary *) userInfo;
-(void) createAccountFailed:    (NSDictionary *) userInfo;
//修改密码
-(void) changePasswordSuccess;
-(void) changePasswordFailed:    (NSDictionary *) userInfo;
//重置密码
-(void) resetPasswordSuccess;
-(void) resetPasswordFailed:    (NSDictionary *) userInfo;

@end

#endif