//
//  KHHNetClinetAPIAgent+Exchange.h
//  CardBook
//  所有交换用到的网络接口的deleagte(摇摇交换名片、回赠名片给联系人、发送名片到手机)
//  Created by 王定方 on 13-1-10.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent.h"
#import "KHHNetAgentExchangeDelegates.h"
@interface KHHNetClinetAPIAgent (Exchange)

/**
 * 发送名片到手机 sendCardService.sendCard
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=235
 * 方法 put
 * 多介手机号时用";"隔开
 */
- (void)sendCard:(long) cardID version:(int) version toPhones:(NSString *) phoneNumbers delegate:(id<KHHNetAgentExchangeDelegates>) delegate;
@end
