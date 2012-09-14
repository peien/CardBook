//
//  KHHNetworkAPIAgent+Exchange.h
//  CardBook
//
//  Created by 孙铭 on 8/29/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgent.h"
@class Card;

//交换
static NSString * const KHHNotificationExchangeCardSucceeded = @"ExchangeCardSucceeded";
static NSString * const KHHNotificationExchangeCardFailed = @"ExchangeCardFailed";
//发送
static NSString * const KHHNotificationSendCardToPhoneSucceeded = @"SendCardToPhoneSucceeded";
static NSString * const KHHNotificationSendCardToPhoneFailed = @"SendCardToPhoneFailed";
static NSString * const KHHNotificationSendCardToUserSucceeded = @"SendCardToUserSucceeded";
static NSString * const KHHNotificationSendCardToUserFailed = @"SendCardToUserFailed";

@interface KHHNetworkAPIAgent (Exchange)
/**
 摇手机交换名片 shakeExchangeCardService.shakeExchangeCardNew
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=171
 */
- (BOOL)exchangeCard:(Card *)card
      withCoordinate:(CLLocationCoordinate2D)coordinate;
/**
 发送名片到手机 sendCardService.sendCard
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=177
 */
- (BOOL)sendCard:(Card *)card
        toPhones:(NSArray *)phoneNumbers;
/**
 回赠名片 sendCardService.sendCardByReceiverId
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=191
 */
- (BOOL)sendCard:(Card *)card
          toUser:(NSString *)userID;
@end
