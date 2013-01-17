//
//  KHHDataExchangeDelegate.h
//  CardBook
//
//  Created by 王定方 on 13-1-15.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef CardBook_KHHDataExchangeDelegate_h
#define CardBook_KHHDataExchangeDelegate_h
@protocol KHHDataExchangeDelegate <NSObject>
@optional
//交换名片
-(void) exchangeCardForUISuccess:(NSDictionary *) dict;
-(void) exchangeCardForUIFailed:(NSDictionary *) dict;

//发送到手机
-(void) sendCardToMobileForUISuccess;
-(void) sendCardToMobileForUIFailed:(NSDictionary *) dict;

//发送给用户
-(void) sendCardToUserForUISuccess;
-(void) sendCardToUserForUIFailed:(NSDictionary *) dict;
@end


#endif
