//
//  KHHNetClinetAPIAgent+Exchange.h
//  CardBook
//  所有交换用到的网络接口的deleagte(摇摇交换名片、回赠名片给联系人、发送名片到手机)
//  Created by 王定方 on 13-1-10.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent.h"
#import "KHHNetAgentExchangeDelegates.h"
#import "Card.h"
#import <CoreLocation/CoreLocation.h>
@interface KHHNetClinetAPIAgent (Exchange)

/**
 * 发送名片到手机 
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=235
 * 方法 put
 * 多个手机号时用";"隔开
 */
- (void)sendCard:(long) cardID version:(int) version toPhones:(NSString *) phoneNumbers delegate:(id<KHHNetAgentExchangeDelegates>) delegate;


/**
 * 摇摇交换名片
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=288
 * 方法 POST
 * url card/shakeInfo/{user_id} user_id表示谁摇手机是谁的user_id
 */
- (void)exchangeCard:(Card *)card withCoordinate:(CLLocationCoordinate2D)coordinate delegate:(id<KHHNetAgentExchangeDelegates>) delegate;

/**
 * 回赠名片
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=281
 * 方法 Put
 * url card/return/{receiverId}/{cardId}/{version}
 */
- (void)sendCard:(long) cardID version:(int) version toUser:(NSString *)userID delegate:(id<KHHNetAgentExchangeDelegates>) delegate;
@end
