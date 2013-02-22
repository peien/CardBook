//
//  KHHDataNew+Evaluation.h
//  CardBook
//
//  Created by CJK on 13-1-24.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew.h"
#import "ICustomerEvaluation.h"
#import "MyCard.h"
#import "InterCustomer.h"
#import "KHHDataCustomerDelegate.h"
#import "KHHNetAgentCustomerDelegate.h"
typedef enum {
    KHHCustomerSyncTypeAddUpdate = 3,    
    KHHCustomerSyncTypeSync,
 
} KHHCustomerSyncType;

@interface KHHDataNew (Customer)<KHHNetAgentCustomerDelegate>

- (void)doAddUpdateCustomer:(InterCustomer *)iCustomer delegate:(id<KHHDataCustomerDelegate>)delegate;

- (void)doSyncCustomer:(id<KHHDataCustomerDelegate>)delegate;

@end
