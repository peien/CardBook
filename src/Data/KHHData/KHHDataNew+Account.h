//
//  KHHDataNew+Account.h
//  CardBook
//
//  Created by CJK on 13-1-15.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew.h"
#import "KHHDataAccountDelegate.h"
#import "KHHNetClinetAPIAgent+Account.h"

@interface KHHDataNew (Account)<KHHNetAgentAccountDelegates>

- (void)doRegister:(NSDictionary*) info delegate:(id<KHHDataAccountDelegate>) delegate;

- (void)doLogin:(NSString *)username password:(NSString *)password delegate:(id<KHHDataAccountDelegate>) delegate;

- (void)doResetPassword:(NSString *)mobile  delegate:(id<KHHDataAccountDelegate>) delegate;

- (void)doLoginStep2:(NSString *)username password:(NSString *)password sessionId:(NSString *)sessionId companyId:(NSString *)companyId delegate:(id<KHHDataAccountDelegate>)delegate;

- (void)doChangePassword:(NSString *)oldPassword newPassword:(NSString *)newPassword delegate:(id<KHHDataAccountDelegate>) delegate;

- (void)saveToken;

@end
