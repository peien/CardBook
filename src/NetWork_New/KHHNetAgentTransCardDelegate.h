//
//  KHHNetAgentTransCard.h
//  CardBook
//
//  Created by CJK on 13-1-31.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef CardBook_KHHNetAgentTransCardDelegate_h
#define CardBook_KHHNetAgentTransCardDelegate_h

@protocol KHHNetAgentTransCardDelegate <NSObject>
@optional

- (void)rebateCardSuccess:(NSDictionary *) dict;
- (void)rebateCardFailed:(NSDictionary *) dict;

- (void)sendByPhoneSuccess:(NSDictionary *)dict;
- (void)sendByPhoneFailed:(NSDictionary *)dict;

- (void)exchangeSuccess:(NSDictionary *)dict;
- (void)exchangeFailed:(NSDictionary *)dict;
- (void)receiveLastCostomerSuccess:(NSDictionary *)dict;
- (void)receiveLastCostomerFailed:(NSDictionary *)dict;

@end

#endif
