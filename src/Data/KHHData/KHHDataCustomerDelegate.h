//
//  KHHDataEvaluationDelegate.h
//  CardBook
//
//  Created by CJK on 13-1-26.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef CardBook_KHHDataCustomerDelegate_h
#define CardBook_KHHDataCustomerDelegate_h
@protocol KHHDataCustomerDelegate <NSObject>
- (void)syncCustomerForUISuccess;
- (void)syncCustomerForUIFailed:(NSDictionary *) dict;

- (void)addUpdateCustomerForUISuccess;
- (void)addUpdateCustomerForUIFailed:(NSDictionary *) dict;

@end

#endif
