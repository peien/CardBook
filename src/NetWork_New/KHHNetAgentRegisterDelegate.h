//
//  KHHNetAgentRegisterDelegate.h
//  CardBook
//
//  Created by CJK on 13-1-15.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef CardBook_KHHNetAgentRegisterDelegate_h
#define CardBook_KHHNetAgentRegisterDelegate_h

@protocol KHHNetAgentRegisterDelegate <NSObject>
@optional

- (void)registerSuccess:(NSDictionary *) dict;
- (void)registerFailed:(NSDictionary *) dict;

@end

#endif
