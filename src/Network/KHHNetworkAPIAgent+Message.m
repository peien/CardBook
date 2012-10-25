////
////  KHHNetworkAPIAgent+Message.m
////  CardBook
////
////  Created by 孙铭 on 8/29/12.
////  Copyright (c) 2012 KingHanHong. All rights reserved.
////
//
//#import "KHHNetworkAPIAgent+Message.h"
//
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
//@implementation KHHNetworkAPIAgent (KHHMessage)
///**
// 收消息 customFsendService.list
// http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=184
// */
//- (void)allMessages {
//    [self postAction:@"allMessages"
//               query:@"customFsendService.list"
//          parameters:nil
//             success:nil];
//}
///**
// 删除消息 customFsendService.delete
// http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=187
// */
//- (BOOL)deleteMessages:(NSArray *)messages {
//    if (0 == messages.count) {
//        return NO;
//    }
//    NSMutableArray *messageIDs = [NSMutableArray arrayWithCapacity:[messages count]];
//    for (id message in messages) {
//        if (![message isKindOfClass:[Message class]]) {
//            // 不是message
//            return NO;
//        }
//        if (!MessageHasRequiredAttributes(message,
//                                          KHHMessageAttributeID)) {
//            // message无id
//            return NO;
//        }
//        [messageIDs addObject:[[message valueForKey:kAttributeKeyID] stringValue]];
//    }
//    NSDictionary *parameters = @{
//    @"ids" : [messageIDs componentsJoinedByString:@","]
//    };
//    [self postAction:@"deleteMessages"
//               query:@"customFsendService.delete"
//          parameters:parameters
//             success:nil];
//    return YES;
//}
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
//@end
