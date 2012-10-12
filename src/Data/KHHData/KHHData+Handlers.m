//
//  KHHData+Handlers.m
//  CardBook
//
//  Created by 孙铭 on 12-9-19.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHDataAPI.h"
#import "NSNumber+SM.h"

@implementation KHHData (Handlers)
- (void)registerHandlersForNotifications {
    
    //[self observeNotificationName:KHHNetwork selector:@"handle"];
    [self observeNotificationName:KHHNetworkAllDataAfterDateSucceeded
                         selector:@"handleAllDataAfterDateSucceeded:"];
    [self observeNotificationName:KHHNetworkAllDataAfterDateFailed
                         selector:@"handleAllDataAfterDateFailed:"];
    // Card - Create, Update, Delete.
    [self observeNotificationName:KHHNetworkCreateCardSucceeded
                         selector:@"handleCreateCardSucceeded:"];
    [self observeNotificationName:KHHNetworkCreateCardFailed
                         selector:@"handleCreateCardFailed:"];
    [self observeNotificationName:KHHNetworkUpdateCardSucceeded
                         selector:@"handleUpdateCardSucceeded:"];
    [self observeNotificationName:KHHNetworkUpdateCardFailed
                         selector:@"handleUpdateCardFailed:"];
    [self observeNotificationName:KHHNetworkDeleteCardSucceeded
                         selector:@"handleDeleteCardSucceeded:"];
    [self observeNotificationName:KHHNetworkDeleteCardFailed
                         selector:@"handleDeleteCardFailed:"];
    [self observeNotificationName:KHHNetworkDeleteReceivedCardsSucceeded
                         selector:@"handleDeleteReceivedCardsSucceeded:"];
    [self observeNotificationName:KHHNetworkDeleteReceivedCardsFailed
                         selector:@"handleDeleteReceivedCardsFailed:"];
    // ReceivedCard 联系人
    //        [self observeNotificationName:KHHNetworkReceivedCardCountAfterDateLastCardSucceeded
    //                             selector:@"handleReceivedCardCountAfterDateLastCardSucceeded:"];
    //        [self observeNotificationName:KHHNetworkReceivedCardCountAfterDateLastCardFailed
    //                             selector:@"handleReceivedCardCountAfterDateLastCardFailed:"];
    [self observeNotificationName:KHHNetworkReceivedCardsAfterDateLastCardExpectedCountSucceeded
                         selector:@"handleReceivedCardsAfterDateLastCardExpectedCountSucceeded:"];
    [self observeNotificationName:KHHNetworkReceivedCardsAfterDateLastCardExpectedCountFailed
                         selector:@"handleReceivedCardsAfterDateLastCardExpectedCountFailed:"];
    [self observeNotificationName:KHHNetworkLatestReceivedCardSucceeded
                         selector:@"handleLatestReceivedCardSucceeded:"];
    [self observeNotificationName:KHHNetworkLatestReceivedCardFailed
                         selector:@"handleLatestReceivedCardFailed:"];
    // 模板
    [self observeNotificationName:KHHNetworkTemplatesAfterDateSucceeded
                         selector:@"handleTemplatesAfterDateSucceeded:"];
    [self observeNotificationName:KHHNetworkTemplatesAfterDateFailed
                         selector:@"handleTemplatesAfterDateFailed:"];
    
    // 拜访计划
    [self observeNotificationName:KHHNetworkVisitSchedulesAfterDateSucceeded
                         selector:@"handleVisitSchedulesAfterDateSucceeded:"];
    [self observeNotificationName:KHHNetworkVisitSchedulesAfterDateFailed
                         selector:@"handleVisitSchedulesAfterDateFailed:"];
    // 客户评估
    [self observeNotificationName:KHHNetworkCustomerEvaluationListAfterDateSucceeded
                         selector:@"handleCustomerEvaluationListAfterDateSucceeded:"];
    [self observeNotificationName:KHHNetworkCustomerEvaluationListAfterDateFailed
                         selector:@"handleCustomerEvaluationListAfterDateFailed:"];
}

#pragma mark - Notification handlers
- (void)handleAllDataAfterDateSucceeded:(NSNotification *)noti {
    DLog(@"[II] noti userInfo keys = %@", [noti.userInfo allKeys]);
    NSDictionary *info = noti.userInfo;
    // 处理返回的数据
#warning TODO
    // 1. companyPromotionLinkList
    // 2. ICPPromotionLinkList
    // template List {
    NSArray *templateList = info[kInfoKeyTemplateList];
    if (templateList.count) {
        [self processCardTemplateList:templateList];
    }
    // }
    
    // privateCard List {
//    NSArray *privateCardList = info[kInfoKeyPrivateCardList];
//    if (privateCardList.count) {
//        [self processPrivateCardList:privateCardList];
//    }
    // }
    
    // MyCard List {
    NSArray *myCardList = info[kInfoKeyMyCardList];
    if (myCardList.count) {
        [self processMyCardList:myCardList];
    }
    // }
    
    // Sync Time {
    NSString *syncTime = info[kInfoKeySyncTime];
    if (syncTime.length) {
        SyncMark *thisMark = [self syncMarkByKey:kSyncMarkKeySyncAllLastTime];
        thisMark.value = syncTime;
    }
    // }
    [self saveContext];
    // 处理结束
    NSDictionary *extra = info[kInfoKeyExtra];
    // 根据 queue 采取不同措施
    NSMutableArray *queue = extra[kExtraKeySyncQueue];
    if (queue) {
        [self startNextSync:queue];
    } else {
        ALog(@"[EE] ERROR!! 怎么会走到这里？");
    }
}
- (void)handleAllDataAfterDateFailed:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    NSDictionary *extra = info[kInfoKeyExtra];
    BOOL isChained = extra? [extra[kExtraKeyChainedInvocation] boolValue]: NO;
    if (isChained) {
        // 接下来，同步联系人
        SyncMark *lastTime = [self syncMarkByKey:kSyncMarkKeyReceviedCardLastTime];
        SyncMark *lastCardID = [self syncMarkByKey:kSyncMarkKeyReceviedCardLastID];
        [self.agent receivedCardsAfterDate:lastTime.value
                                  lastCard:lastCardID.value
                             expectedCount:@"50"
                                     extra:extra];
    } else {
        ALog(@"[EE] ERROR!! 怎么会走到这里？");
    }
}
@end

@implementation KHHData (Handlers_Card)
- (void)handleCreateCardSucceeded:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    NSDictionary *extra = info[kInfoKeyExtra];
    ALog(@"[II] extra = %@", extra);
    InterCard *iCard = extra[kExtraKeyInterCard];
    KHHCardModelType cardType = [extra[kExtraKeyCardModelType] integerValue];
    // 填入数据库
    [self processCard:iCard cardType:cardType];
    // 保存数据库
    [self saveContext];
    // 发送成功消息
    [self postASAPNotificationName:KHHUICreateCardSucceeded];
}
- (void)handleCreateCardFailed:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    ALog(@"[II] info = %@", info);
    // 发送消息
    [self postASAPNotificationName:KHHUICreateCardFailed
                              info:info];
}
- (void)handleUpdateCardSucceeded:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    NSDictionary *extra = info[kInfoKeyExtra];
    ALog(@"[II] extra = %@", extra);
    InterCard *iCard = extra[kExtraKeyInterCard];
    KHHCardModelType cardType = [extra[kExtraKeyCardModelType] integerValue];
    // 填入数据库
    [self processCard:iCard cardType:cardType];
    // 保存数据库
    [self saveContext];
    // 发送成功消息
    [self postASAPNotificationName:KHHUIModifyCardSucceeded];
}
- (void)handleUpdateCardFailed:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    ALog(@"[II] info = %@", info);
    // 发送消息
    [self postASAPNotificationName:KHHUIModifyCardFailed
                              info:info];
}
- (void)handleDeleteCardSucceeded:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    NSDictionary *extra = info[kInfoKeyExtra];
    ALog(@"[II] extra = %@", extra);
    // 从数据库中删除它
    NSNumber *cardID = extra[kExtraKeyCardID];
    KHHCardModelType cardType = [extra[kExtraKeyCardModelType] integerValue];
    Card *card = [self cardOfType:cardType byID:cardID];
    [self.context deleteObject:card];
    // 保存数据库
    [self saveContext];
    // 发送成功消息
    [self postASAPNotificationName:KHHUIDeleteCardSucceeded];
}
- (void)handleDeleteCardFailed:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    ALog(@"[II] info = %@", info);
    // 发送消息
    [self postASAPNotificationName:KHHUIDeleteCardFailed info:info];
}
- (void)handleDeleteReceivedCardsSucceeded:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    NSDictionary *extra = info[kInfoKeyExtra];
    ALog(@"[II] extra = %@", extra);
    // 从数据库中删除它
    NSArray *cardList = extra[kExtraKeyCardList];
    for (id aCard in cardList) {
        [self.context deleteObject:aCard];
    }
    // 保存数据库
    [self saveContext];
    // 发送成功消息
    [self postASAPNotificationName:KHHUIDeleteCardSucceeded];
}
- (void)handleDeleteReceivedCardsFailed:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    ALog(@"[II] info = %@", info);
    // 发送消息
    [self postASAPNotificationName:KHHUIDeleteCardFailed info:info];
}
- (void)handleReceivedCardsAfterDateLastCardExpectedCountSucceeded:(NSNotification *)noti {
    DLog(@"[II] handleReceivedCardsAfterDateLastCardExpectedCountSucceeded:%@", noti);
    NSDictionary *info = noti.userInfo;
    //1.receivedCardList {
    NSArray *receivedCardList = info[kInfoKeyReceivedCardList];
    if (receivedCardList.count) {
        [self processReceivedCardList:receivedCardList];
    }
    // }
    //2.syncTime
    NSString *syncTime = info[kInfoKeySyncTime];
    if (syncTime.length) {
        SyncMark *timeMark = [self syncMarkByKey:kSyncMarkKeyReceviedCardLastTime];
        timeMark.value = syncTime;
    }
    //3.lastID
    NSString *lastID = info[kInfoKeyLastID];
    if (lastID.length) {
        SyncMark *IDMark = [self syncMarkByKey:kSyncMarkKeyReceviedCardLastID];
        IDMark.value = lastID;
    }
    // 4.保存
    ALog(@"[II] 同步联系人 save context!");
    [self saveContext];
    
    // 本次同步的数量
    NSInteger count = [info[kInfoKeyCount] integerValue];
    NSDictionary *extra= info[kInfoKeyExtra];
    if (count > 1) { // count > 1
        // 继续同步
        ALog(@"[II] 继续同步联系人！");
        [self.agent receivedCardsAfterDate:syncTime
                                  lastCard:lastID
                             expectedCount:@"50"
                                     extra:extra];
    } else { // count <= 1
        // 根据 queue 采取不同措施
        NSMutableArray *queue = extra[kExtraKeySyncQueue];
        if (queue) {
            [self startNextSync:queue];
        }
        // 发送完成消息
#warning TODO
        else {
            ALog(@"[EE] ERROR!! 怎么会走到这里？");
        }
    }
    
}
- (void)handleReceivedCardsAfterDateLastCardExpectedCountFailed:(NSNotification *)noti {
    ALog(@"[II] handleReceivedCardsAfterDateLastCardExpectedCountFailed = %@", noti);
    [self syncAllDataEnded:NO];
}
- (void)handleLatestReceivedCardSucceeded:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    DLog(@"[II] info = %@", info);
    InterCard *iCard = info[kInfoKeyInterCard];
    KHHCardModelType cardType = KHHCardModelTypeReceivedCard;
    // 填入数据库
    ReceivedCard *rCard = (ReceivedCard *)[self processCard:iCard cardType:cardType];
    [self saveContext];
    // 发送消息
    if (rCard) {
        // 数据库操作成功
        [self postASAPNotificationName:KHHUIPullLatestReceivedCardSucceeded
                                  info:@{
                 kInfoKeyReceivedCard : rCard
         }];
    } else {
        // 虽然服务器返回成功，但本地数据库操作失败
        [self postASAPNotificationName:KHHUIPullLatestReceivedCardFailed
                                  info:@{
                    kInfoKeyErrorCode : @(KHHStatusCodeLocalDataOperationFailed)
         }];
    }

}
- (void)handleLatestReceivedCardFailed:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    ALog(@"[II] info = %@", info);
    // 发送消息
    [self postASAPNotificationName:KHHUIPullLatestReceivedCardFailed
                              info:info];
}
@end
@implementation KHHData (Handlers_Template)

- (void)handleTemplatesAfterDateSucceeded:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    DLog(@"[II] info = %@", [info allKeys]);
    
    //1.TemplateList {
    NSArray *list = info[kInfoKeyTemplateList];
    if (list.count) {
        [self processCardTemplateList:list];
    }
    // }
    //2.syncTime {
    NSString *syncTime = info[kInfoKeySyncTime];
    if (syncTime.length) {
        SyncMark *timeMark = [self syncMarkByKey:kSyncMarkKeyTemplatesLastTime];
        timeMark.value = syncTime;
    }
    // }
    // 3.保存
    ALog(@"[II] 同步联系人 save context!");
    [self saveContext];
    
    // 根据 queue 采取不同措施
    NSDictionary *extra= info[kInfoKeyExtra];
    NSMutableArray *queue = extra[kExtraKeySyncQueue];
    if (queue) {
        [self startNextSync:queue];
    }
}
- (void)handleTemplatesAfterDateFailed:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
#warning TODO
    ALog(@"[II] info = %@", info);
    [self syncAllDataEnded:NO];
}

@end
@implementation KHHData (Handlers_VisitSchedule)
- (void)handleVisitSchedulesAfterDateSucceeded:(NSNotification *)noti {
#warning TODO
    NSDictionary *info = noti.userInfo;
    NSDictionary *extra= info[kInfoKeyExtra];
//    [self syncAllDataEnded:YES];
    SyncMark *lastTime = [self syncMarkByKey:kSyncMarkKeyCustomerEvaluationLastTime];
    [self.agent customerEvaluationListAfterDate:lastTime.value
                                          extra:extra];
}
- (void)handleVisitSchedulesAfterDateFailed:(NSNotification *)noti {
#warning TODO
    DLog(@"[II] 失败啦！");
    [self syncAllDataEnded:YES];
}
@end
@implementation KHHData (Handlers_CustomerEvaluation)
- (void)handleCustomerEvaluationListAfterDateSucceeded:(NSNotification *)noti {
#warning TODO
    [self syncAllDataEnded:YES];
}
- (void)handleCustomerEvaluationListAfterDateFailed:(NSNotification *)noti {
#warning TODO
    DLog(@"[II] 失败啦！");
}
@end

