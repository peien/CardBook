//
//  KHHNetworkAPIAgent+Message.m
//  CardBook
//
//  Created by 孙铭 on 8/29/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPI.h"
#import "KHHActions.h"
#import "KHHLog.h"
#import "KHHNotifications.h"
#import "InMessage.h"

//#pragma mark - Message参数整理函数
//typedef enum {
//    KHHMessageAttributeNone = 0UL,
//    KHHMessageAttributeID = 1UL << 0,
//    //    KHHMessageAttribute
//} KHHMessageAttributes;
//BOOL MessageHasRequiredAttributes(Message *message,
//                                  KHHMessageAttributes attributes) {
//    NSString *ID = [[message valueForKey:kAttributeKeyID] stringValue];
//    if ((attributes & KHHMessageAttributeID) && ID.length == 0) {
//        return NO;
//    }
//    return YES;
//}
@implementation KHHNetworkAPIAgent (KHHMessage)
/**
 收消息 customFsendService.list
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=184
 */
- (void)allMessages {
    NSString *action = kActionNetworkAllMessages;
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        DLog(@"[II] responseDict = %@", responseDict);
        //获取消息列表
        NSArray *fsendList = responseDict[@"fsendList"];
        NSMutableArray *messageList = [NSMutableArray arrayWithCapacity:fsendList.count];
        for (id obj in fsendList) {
            InMessage *im = [[[InMessage alloc] init] updateWithJSON:obj];
            [messageList addObject:im];
        }
        
        //获取联系人列表
        NSArray *cardBookList = responseDict[@"cardBookList"];
        NSMutableArray *contactList = [NSMutableArray arrayWithCapacity:cardBookList.count];
        for (id obj in cardBookList) {
            InterCard * iCard = [InterCard interCardWithReceivedCardJSON:obj nodeName:nil];
            if (iCard) {
                [contactList addObject:iCard];
            }
        }
        //名片发送者,客户端对这些名片做过处理后把id传给服务器把标记置掉后，下次就不会再拿到这些数据
        NSString *senderIDs = responseDict[@"fsendIds"];
        if (senderIDs) {
            [self deleteMessagesByIDs:senderIDs sucessBlock:nil];   
        }
        
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        NSDictionary *dict = @{
        kInfoKeyErrorCode  : @(code),
        kInfoKeyObjectList : messageList,
        kInfoKeyReceivedCard: contactList,
        };
        [self postASAPNotificationName:NameWithActionAndCode(action, code)
                                  info:dict];
    };
    [self postAction:action
               query:@"customFsendService.list"
          parameters:nil
             success:success];
}
/**
 删除消息 customFsendService.delete
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=187
 */
- (void)deleteMessages:(NSArray *)messages {
    NSString *action = kActionNetworkDeleteMessages;
    if (0 == messages.count) {
        WarnParametersNotMeetRequirement(action);
    }
    NSMutableArray *messageIDs = [NSMutableArray arrayWithCapacity:[messages count]];
    for (id message in messages) {
        [messageIDs addObject:[[message valueForKey:kAttributeKeyID]
                               stringValue]];
    }
    
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        DLog(@"[II] responseDict = %@", responseDict);
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        NSDictionary *dict = @{
        kInfoKeyErrorCode  : @(code),
        kInfoKeyObjectList : messages,
        };
        [self postASAPNotificationName:NameWithActionAndCode(action, code)
                                  info:dict];
    };
    
    [self deleteMessagesByIDs:[messageIDs componentsJoinedByString:KHH_COMMA] sucessBlock:success];
}

//删除消息(通过组装好的ids)
- (void)deleteMessagesByIDs:(NSString *)messagesIDs sucessBlock:(KHHSuccessBlock) sucessBlock{
    NSString *action = kActionNetworkDeleteMessages;
    if (!messagesIDs) {
        WarnParametersNotMeetRequirement(action);
    }
    NSDictionary *parameters = @{
    @"ids" : messagesIDs
    };
    
    [self postAction:action
               query:@"customFsendService.delete"
          parameters:parameters
             success:sucessBlock];
}
///**
// 通知印象名片用户活动 tellActiveService.getTellActive
// http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=188
// */
//- (void)promotionMessagesWithType:(NSString *)type {
//    NSDictionary *parameters = @{ @"activeType" : type?type:@"" };
//    [self postAction:@"promotionMessagesWithType"
//               query:@"tellActiveService.getTellActive"
//          parameters:parameters
//             success:nil];
//}
@end
