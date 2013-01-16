//
//  KHHNetAgentExchangeDelegates.h
//  CardBook
//
//  Created by 王定方 on 13-1-10.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#pragma 所有交换用到的网络接口的deleagte(摇摇交换名片、回赠名片给联系人、发送名片到手机)

#ifndef KHH_NetAgent_Exchange_Delegates
#define KHH_NetAgent_Exchange_Delegates
@protocol KHHNetAgentExchangeDelegates <NSObject>
@optional
//交换名片
-(void) exchangeCardSuccess:(NSDictionary *) dict;
-(void) exchangeCardFailed:(NSDictionary *) dict;

//发送到手机
-(void) sendCardToMobileSuccess;
-(void) sendCardToMobileFailed:(NSDictionary *) dict;

//回赠
-(void) sendCardToUserSuccess;
-(void) sendCardToUserFailed:(NSDictionary *) dict;
@end
#endif