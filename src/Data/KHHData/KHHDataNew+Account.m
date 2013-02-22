//
//  KHHDataNew+Account.m
//  CardBook
//
//  Created by CJK on 13-1-15.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew+Account.h"
#import "KHHUser.h"

@implementation KHHDataNew (Account)

- (void)doRegister:(NSDictionary*) info delegate:(id<KHHDataAccountDelegate>) delegate
{
    
    self.delegate = delegate;
    [self.agent createAccount:info delegate:self];
}

- (void)doLogin:(NSString *)username password:(NSString *)password delegate:(id<KHHDataAccountDelegate>)delegate
{
    self.delegate = delegate;
    [self.agent login:username password:password delegate:self];
    
}

- (void)doLoginStep2:(NSString *)username password:(NSString *)password sessionId:(NSString *)sessionId companyId:(NSString *)companyId delegate:(id<KHHDataAccountDelegate>)delegate
{
    self.delegate = delegate;
    [self.agent loginStep2:username password:password  sessionId:sessionId companyId:companyId delegate:self];
    
}

- (void)doResetPassword:(NSString *)mobile  delegate:(id<KHHDataAccountDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent resetPassword:mobile delegate:self];
}


- (void)doChangePassword:(NSString *)oldPassword newPassword:(NSString *)newPassword delegate:(id<KHHDataAccountDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent changePassword:oldPassword toNewPassword:newPassword delegate:self];
}

- (void)saveToken
{
    [self.agent saveToken];
}

#pragma mark - delegate - createAccount
- (void)createAccountSuccess:(NSDictionary *)userInfo
{
    [(id<KHHDataAccountDelegate>)self.delegate createAccountForUISuccess:userInfo];
}

- (void)createAccountFailed:(NSDictionary *)userInfo
{
    [(id<KHHDataAccountDelegate>)self.delegate createAccountForUIFailed:userInfo];
}

#pragma mark - delegate - login
- (void)loginSuccess:(NSDictionary *) userInfo
{
    [(id<KHHDataAccountDelegate>)self.delegate loginForUISuccess:userInfo];
}
- (void)loginFailed:(NSDictionary *) userInfo
{
    [(id<KHHDataAccountDelegate>)self.delegate loginForUIFailed:userInfo];
}

- (void)loginFailedStep2:(NSDictionary *)userInfo
{
     [(id<KHHDataAccountDelegate>)self.delegate loginForUIFailed:userInfo];
}

- (void)loginSuccessStep2:(NSDictionary *)userInfo
{
    NSLog(@"%@",[userInfo objectForKey:@"sessionId"]);
    if ([userInfo objectForKey:@"id"]) {
        [self.agent loginStep2:[KHHUser shareInstance].username password:[KHHUser shareInstance].password sessionId:userInfo[@"sessionId"] companyId:userInfo[@"companyId"]?userInfo[@"companyId"]:@"0" delegate:self];
    }else{
        [(id<KHHDataAccountDelegate>)self.delegate loginForUISuccessStep2:userInfo];
    }
    
}

#pragma mark - delegate - resetPassword
- (void)resetPasswordSuccess
{
    [(id<KHHDataAccountDelegate>)self.delegate resetPasswordForUISuccess];
}
- (void)resetPasswordFailed:(NSDictionary *) userInfo
{
    [(id<KHHDataAccountDelegate>)self.delegate resetPasswordForUIFailed:userInfo];
}

#pragma mark - delegate - changePassword

-(void) changePasswordForUISuccess
{
    [(id<KHHDataAccountDelegate>)self.delegate changePasswordForUISuccess];
}
-(void) changePasswordForUIFailed:    (NSDictionary *) userInfo
{
    [(id<KHHDataAccountDelegate>)self.delegate changePasswordForUIFailed:userInfo];
}

#pragma mark - delegate - changePassword

-(void) changePasswordSuccess
{
    [(id<KHHDataAccountDelegate>)self.delegate changePasswordForUISuccess];
}
-(void) changePasswordFailed:    (NSDictionary *) userInfo
{
    [(id<KHHDataAccountDelegate>)self.delegate changePasswordForUIFailed:userInfo];
}

@end
