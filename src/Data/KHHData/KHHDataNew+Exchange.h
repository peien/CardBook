//
//  KHHDataNew+Exchange.h
//  CardBook
//
//  Created by 王定方 on 13-1-15.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew.h"
#import "KHHDataExchangeDelegate.h"
#import "KHHDataCardDelegate.h"
#import "KHHNetClinetAPIAgent+Exchange.h"
@interface KHHDataNew (Exchange) <KHHNetAgentExchangeDelegates,KHHDataCardDelegate>
#pragma mark - 发送名片到手机
- (void)sendCard:(long) cardID version:(int) version toPhones:(NSString *) phoneNumbers delegate:(id<KHHDataExchangeDelegate>) delegate;

#pragma mark - 摇摇交换名片
- (void)exchangeCard:(Card *)card withCoordinate:(CLLocationCoordinate2D)coordinate delegate:(id<KHHDataExchangeDelegate>) delegate;

#pragma mark - 发送名片到指定用户
- (void)sendCard:(long) cardID version:(int) version toUser:(NSString *)userID delegate:(id<KHHDataExchangeDelegate>) delegate;

#pragma mark - 获取最后获取的名片
- (void)pullLatestReceivedCard;
@end
