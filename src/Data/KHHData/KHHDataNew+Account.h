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

- (void)doLogin:(NSString *)username password:(NSString *)password companyId:(NSString *)companyId delegate:(id<KHHDataAccountDelegate>) delegate;

@end
