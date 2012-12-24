//
//  KHHNetworkAPIAgent+Message.h
//  CardBook
//
//  Created by 孙铭 on 8/29/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgent.h"
#import "KHHMessage.h"

@interface KHHNetworkAPIAgent (KHHMessage)
/**
 收消息 customFsendService.list
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=184
 */
- (void)allMessages;
/**
 删除消息 customFsendService.delete
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=187
 */
- (void)deleteMessages:(NSArray *)messages;
/**
 通知印象名片用户活动 tellActiveService.getTellActive
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=188
 */
//- (void)promotionMessagesWithType:(NSString *)type;
/**
 删除消息通过组装好的id,用于删除通过消息发送过来的联系人时，没有KHHMessage array时直接删除
 */
- (void)deleteMessagesByIDs:(NSString *)messagesIDs sucessBlock:(KHHSuccessBlock) sucessBlock;

//parse a massage todo progress with userinfo
- (void)doProgressWithMessageDic:(NSDictionary *)responseDict;
@end
