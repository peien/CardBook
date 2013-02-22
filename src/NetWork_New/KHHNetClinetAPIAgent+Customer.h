//
//  KHHNetClinetAPIAgent+Customer.h
//  CardBook
//
//  Created by CJK on 13-1-26.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent.h"
#import "InterCustomer.h"
#import "KHHNetAgentCustomerDelegate.h"

@interface KHHNetClinetAPIAgent (Customer)
- (void)addUpdateCustomer:(InterCustomer *)iCustomer delegate:(id<KHHNetAgentCustomerDelegate>) delegate;
- (void)syncCustomer:(NSString *) lastDate delegate:(id<KHHNetAgentCustomerDelegate>) delegate;
@end
