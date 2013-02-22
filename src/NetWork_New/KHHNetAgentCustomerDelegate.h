//
//  KHHNetAgentCustomerDelegate.h
//  CardBook
//
//  Created by CJK on 13-1-26.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef CardBook_KHHNetAgentCustomerDelegate_h
#define CardBook_KHHNetAgentCustomerDelegate_h

@protocol KHHNetAgentCustomerDelegate <NSObject>
@optional

- (void)syncCustomerSuccess:(NSDictionary *) dict;
- (void)syncCustomerFailed:(NSDictionary *) dict;

- (void)addUpdateCustomerSuccess:(NSDictionary *) dict;
- (void)addUpdateCustomerFailed:(NSDictionary *) dict;


@end

#endif
