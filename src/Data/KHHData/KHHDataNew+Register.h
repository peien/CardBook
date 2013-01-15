//
//  KHHDataNew+Register.h
//  CardBook
//
//  Created by CJK on 13-1-15.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew.h"
#import "KHHNetAgentRegisterDelegate.h"
#import "KHHDataRegisterDelegate.h"

@interface KHHDataNew (Register)<KHHNetAgentRegisterDelegate>

- (void)doRegister:(NSDictionary*) info delegate:(id<KHHDataRegisterDelegate>) delegate;

@end
