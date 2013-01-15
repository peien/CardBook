//
//  KHHNetClinetAPIAgent+Register.h
//  CardBook
//
//  Created by CJK on 13-1-15.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent.h"
#import "KHHNetAgentRegisterDelegate.h"

@interface KHHNetClinetAPIAgent (Register)

- (void)regist:(NSString *)username password:(NSString *)password delegate:(id<KHHNetAgentRegisterDelegate>)delegate;

@end
