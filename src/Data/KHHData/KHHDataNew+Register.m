//
//  KHHDataNew+Register.m
//  CardBook
//
//  Created by CJK on 13-1-15.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew+Register.h"
#import "KHHNetClinetAPIAgent+Register.h"

@implementation KHHDataNew (Register)

- (void)doRegister:(NSDictionary*) info delegate:(id<KHHDataRegisterDelegate>) delegate
{
//    info[kAccountKeyName]     = name;
//    info[kAccountKeyUser]     = user;
//    info[kAccountKeyPassword] = password;
//    if(companyText.text.length) info[kAccountKeyCompany]
    self.delegate = delegate;
    [self.agent regist:info[kAccountKeyUser] username:info[kAccountKeyName]   password:info[kAccountKeyPassword] companyName:info[kAccountKeyCompany]  delegate:self];
}

#pragma mark - delegate

- (void)registerSuccess:(NSDictionary *)dict
{
    
    [(id<KHHDataRegisterDelegate>)self.delegate registerForUISuccess:dict];
}

- (void)registerFailed:(NSDictionary *)dict
{
    [(id<KHHDataRegisterDelegate>)self.delegate registerForUIFailed:dict];
}

@end
