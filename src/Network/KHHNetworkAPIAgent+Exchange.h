//
//  KHHNetworkAPIAgent+Exchange.h
//  CardBook
//
//  Created by 孙铭 on 8/29/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgent.h"
#import "Card.h"

@interface KHHNetworkAPIAgent (Exchange)
/**
 摇手机交换名片 shakeExchangeCardService.shakeExchangeCardNew
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=171
 */
- (void)exchangeCard:(Card *)card
      withCoordinate:(CLLocationCoordinate2D)coordinate;
/**
 发送名片到手机 sendCardService.sendCard
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=177
 */
- (void)sendCard:(Card *)card
        toPhones:(NSArray *)phoneNumbers;
/**
 回赠名片 sendCardService.sendCardByReceiverId
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=191
 */
- (void)sendCard:(Card *)card
          toUser:(NSString *)userID;
@end
