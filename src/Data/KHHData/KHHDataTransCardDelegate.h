//
//  KHHDataTransCardDelegate.h
//  CardBook
//
//  Created by CJK on 13-1-31.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef CardBook_KHHDataTransCardDelegate_h
#define CardBook_KHHDataTransCardDelegate_h

@protocol KHHDataTransCardDelegate <NSObject>

- (void)rebateCardForUISuccess;
- (void)rebateCardForUIFailed:(NSDictionary *) dict;

- (void)sendByPhoneForUISuccess;
- (void)sendByPhoneForUIFailed:(NSDictionary *) dict;

- (void)exchangeForUISuccess;
- (void)exchangeForUIFailed:(NSDictionary *) dict;
- (void)receiveLastCostomerForUISuccess:(NSDictionary *)dict;
- (void)receiveLastCostomerForUIFailed:(NSDictionary *)dict;


@end

#endif
