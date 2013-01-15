//
//  KHHNetAgentLoginDelegate.h
//  CardBook
//
//  Created by CJK on 13-1-14.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef CardBook_KHHNetAgentLoginDelegate_h
#define CardBook_KHHNetAgentLoginDelegate_h
@protocol KHHNetAgentLoginDelegate <NSObject>
@optional

- (void)loginSuccess:(NSDictionary *) dict;
- (void)loginFailed:(NSDictionary *) dict;

@end


#endif
