//
//  KHHDataAccountDelegate.h
//  CardBook
//
//  Created by 王定方 on 13-1-15.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef CardBook_KHHDataAccountDelegate_h
#define CardBook_KHHDataAccountDelegate_h
@protocol KHHDataAccountDelegate <NSObject>
@optional
//登录
- (void)loginForUISuccess:           (NSDictionary *) userInfo;
- (void)loginForUIFailed:            (NSDictionary *) userInfo;
//选择公司登录
- (void)loginForUISuccessStep2:(NSDictionary *)userInfo;
- (void)loginForUIFailedStep2:(NSDictionary *)userInfo;
//注册
-(void) createAccountForUISuccess:   (NSDictionary *) userInfo;
-(void) createAccountForUIFailed:    (NSDictionary *) userInfo;
//修改密码
-(void) changePasswordForUISuccess;
-(void) changePasswordForUIFailed:    (NSDictionary *) userInfo;
//重置密码
-(void) resetPasswordForUISuccess;
-(void) resetPasswordForUIFailed:    (NSDictionary *) userInfo;

@end


#endif
