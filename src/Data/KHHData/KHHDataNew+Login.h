//
//  KHHDataNew+Login.h
//  CardBook
//
//  Created by CJK on 13-1-14.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//


#import "KHHDataNew.h"
#import "KHHNetClinetAPIAgent+Login.h"
#import "KHHDataLoginDelegate.h"
#import "KHHNetAgentLoginDelegate.h"


@interface KHHDataNew (Login) <KHHNetAgentLoginDelegate>

- (void)doLogin:(NSString *)username password:(NSString *)password delegate:(id<KHHDataLoginDelegate>) delegate;

@end