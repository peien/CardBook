//
//  KHHDataNew+Account.m
//  CardBook
//
//  Created by CJK on 13-1-15.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew+Account.h"

@implementation KHHDataNew (Account)

- (void)doRegister:(NSDictionary*) info delegate:(id<KHHDataAccountDelegate>) delegate
{
    
    self.delegate = delegate;
    [self.agent createAccount:info delegate:self];    
}

- (void)doLogin:(NSString *)username password:(NSString *)password companyId:(NSString *)companyId delegate:(id<KHHDataAccountDelegate>)delegate
{
    self.delegate = delegate;
    [self.agent login:username password:password delegate:self];
    
}

#pragma mark - delegate
- (void)createAccountSuccess:(NSDictionary *)userInfo
{
    [(id<KHHDataAccountDelegate>)self.delegate createAccountForUISuccess:userInfo];
}

- (void)createAccountFailed:(NSDictionary *)userInfo
{
     [(id<KHHDataAccountDelegate>)self.delegate createAccountForUIFailed:userInfo];
}
@end
