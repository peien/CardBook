//
//  KHHNetClinetAPIAgent+Login.h
//  CardBook
//
//  Created by CJK on 13-1-14.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent.h"
#import "KHHNetAgentLoginDelegate.h"
@interface KHHNetClinetAPIAgent (Login)

- (void)login:(NSString *)username password:(NSString *)password delegate:(id<KHHNetAgentLoginDelegate>)delegate;

@end
