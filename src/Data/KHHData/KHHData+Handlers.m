//
//  KHHData+Handlers.m
//  CardBook
//
//  Created by 孙铭 on 12-9-19.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHDataAPI.h"
#import "KHHLog.h"
#import "KHHNotifications.h"
#import "NSNumber+SM.h"
#import "NSObject+SM.h"
#import "NSManagedObject+KHH.h"

@implementation KHHData (Handlers)
- (void)registerHandlersForNotifications {
    [self observeNotificationName:KHHNetworkAllDataAfterDateSucceeded
                         selector:@"handleAllDataAfterDateSucceeded:"];
    [self observeNotificationName:KHHNetworkAllDataAfterDateFailed
                         selector:@"handleNetworkActionQueueFailed:"];
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
                         selector:@"handleNetworkActionQueueFailed:"];
    [self observeNotificationName:KHHNetworkLatestReceivedCardSucceeded
                         selector:@"handleLatestReceivedCardSucceeded:"];
    [self observeNotificationName:KHHNetworkLatestReceivedCardFailed
                         selector:@"handleLatestReceivedCardFailed:"];
    [self observeNotificationName:KHHNetworkMarkReadReceivedCardSucceeded
                         selector:@"handleNetworkMarkReadReceivedCardSucceeded:"];
    [self observeNotificationName:KHHNetworkMarkReadReceivedCardFailed
                         selector:@"handleNetworkMarkReadReceivedCardFailed:"];
    // 分组
    [self observeNotificationName:KHHNetworkCreateGroupSucceeded
                         selector:@"handleNetworkCreateGroupSucceeded:"];
    [self observeNotificationName:KHHNetworkCreateGroupFailed
                         selector:@"handleNetworkCreateGroupFailed:"];
    [self observeNotificationName:KHHNetworkUpdateGroupSucceeded
                         selector:@"handleNetworkUpdateGroupSucceeded:"];
    [self observeNotificationName:KHHNetworkUpdateGroupFailed
                         selector:@"handleNetworkUpdateGroupFailed:"];
    [self observeNotificationName:KHHNetworkDeleteGroupSucceeded
                         selector:@"handleNetworkDeleteGroupSucceeded:"];
    [self observeNotificationName:KHHNetworkDeleteGroupFailed
                         selector:@"handleNetworkDeleteGroupFailed:"];
    [self observeNotificationName:KHHNetworkChildGroupsOfGroupIDSucceeded
                         selector:@"handleNetworkChildGroupsOfGroupIDSucceeded:"];
    [self observeNotificationName:KHHNetworkChildGroupsOfGroupIDFailed
                         selector:@"handleNetworkActionQueueFailed:"];
    [self observeNotificationName:KHHNetworkCardIDsInAllGroupSucceeded
                         selector:@"handleNetworkCardIDsInAllGroupSucceeded:"];
    [self observeNotificationName:KHHNetworkCardIDsInAllGroupFailed
                         selector:@"handleNetworkActionQueueFailed:"];
    [self observeNotificationName:KHHNetworkMoveCardsSucceeded
                         selector:@"handleNetworkMoveCardsSucceeded:"];
    [self observeNotificationName:KHHNetworkMoveCardsFailed
                         selector:@"handleNetworkMoveCardsFailed:"];
    // 模板
    [self observeNotificationName:KHHNetworkTemplatesAfterDateSucceeded
                         selector:@"handleTemplatesAfterDateSucceeded:"];
    [self observeNotificationName:KHHNetworkTemplatesAfterDateFailed
                         selector:@"handleNetworkActionQueueFailed:"];
    
    // 拜访计划
    [self observeNotificationName:KHHNetworkVisitSchedulesAfterDateSucceeded
                         selector:@"handleVisitSchedulesAfterDateSucceeded:"];
    [self observeNotificationName:KHHNetworkVisitSchedulesAfterDateFailed
                         selector:@"handleNetworkActionQueueFailed:"];
    // 客户评估
    [self observeNotificationName:KHHNetworkCustomerEvaluationListAfterDateSucceeded
                         selector:@"handleCustomerEvaluationListAfterDateSucceeded:"];
    [self observeNotificationName:KHHNetworkCustomerEvaluationListAfterDateFailed
                         selector:@"handleNetworkActionQueueFailed:"];
    [self observeNotificationName:KHHNetworkCreateOrUpdateEvaluationSucceeded
                         selector:@"handleNetworkCreateOrUpdateEvaluationSucceeded:"];
    [self observeNotificationName:KHHNetworkCreateOrUpdateEvaluationFailed
                         selector:@"handleNetworkCreateOrUpdateEvaluationFailed:"];
}

#pragma mark - Handlers
- (void)handleNetworkActionQueueFailed:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    ALog(@"[II] info = %@", info);
    // 根据 queue 采取不同措施
    NSDictionary *extra= info[kInfoKeyExtra];
    [self startNextSync:extra[kExtraKeySyncQueue]];
}
- (void)handleAllDataAfterDateSucceeded:(NSNotification *)noti {
    DLog(@"[II] noti userInfo keys = %@", [noti.userInfo allKeys]);
    NSDictionary *info = noti.userInfo;
    // 处理返回的数据
#warning TODO
    // 1. companyPromotionLinkList
    // 2. ICPPromotionLinkList
    // template List {
    NSArray *templateList = info[kInfoKeyTemplateList];
    [CardTemplate processJSONList:templateList];
    // }
    
    // privateCard List {
    NSArray *privateCardList = info[kInfoKeyPrivateCardList];
    [PrivateCard processIObjectList:privateCardList];
    // }
    
    // MyCard List {
    NSArray *myCardList = info[kInfoKeyMyCardList];
    [MyCard processIObjectList:myCardList];
    // }
    
    // Sync Time {
    [SyncMark UpdateKey:kSyncMarkKeySyncAllLastTime
                  value:info[kInfoKeySyncTime]];
    // }
    [self saveContext];
    // 处理结束
    // 根据 queue 采取不同措施
    NSDictionary *extra= info[kInfoKeyExtra];
    [self startNextSync:extra[kExtraKeySyncQueue]];
}
#pragma mark - Handlers_Card
- (void)handleCreateCardSucceeded:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    NSDictionary *extra = info[kInfoKeyExtra];
    DLog(@"[II] extra = %@", extra);
    InterCard *iCard = extra[kExtraKeyInterCard];
    // 填入数据库
    switch (iCard.modelType) {
        case KHHCardModelTypeMyCard:
            [MyCard objectWithIObject:iCard];
            break;
        case KHHCardModelTypePrivateCard:
            [PrivateCard objectWithIObject:iCard];
            break;
        default:
            break;
    }
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
    DLog(@"[II] extra = %@", extra);
    InterCard *iCard = extra[kExtraKeyInterCard];
    // 填入数据库
    switch (iCard.modelType) {
        case KHHCardModelTypeMyCard:
            [MyCard objectWithIObject:iCard];
            break;
        case KHHCardModelTypePrivateCard:
            [PrivateCard objectWithIObject:iCard];
            break;
        default:
            break;
    }
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
    DLog(@"[II] extra = %@", extra);
    // 从数据库中删除它
    NSNumber *cardID = extra[kExtraKeyCardID];
    KHHCardModelType modelType = [extra[kExtraKeyCardModelType] integerValue];
    Card *card;
    switch (modelType) {
        case KHHCardModelTypeMyCard:
            card = [MyCard objectByID:cardID createIfNone:NO];
            break;
        case KHHCardModelTypePrivateCard:
            card = [PrivateCard objectByID:cardID createIfNone:NO];
            break;
        default:
            break;
    }
    
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
    DLog(@"[II] extra = %@", extra);
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
    DLog(@"[II] info = %@", noti);
    NSDictionary *info = noti.userInfo;
    //1.receivedCardList {
    NSArray *receivedCardList = info[kInfoKeyReceivedCardList];
    if (receivedCardList.count) {
//        [self processReceivedCardList:receivedCardList];
        [ReceivedCard processIObjectList:receivedCardList];
    }
    // }
    //2.syncTime
    [SyncMark UpdateKey:kSyncMarkKeyReceviedCardLastTime
                  value:info[kInfoKeySyncTime]];
    //3.lastID
    [SyncMark UpdateKey:kSyncMarkKeyReceviedCardLastID
                  value:info[kInfoKeyLastID]];
    // 4.保存
    ALog(@"[II] 同步联系人 save context!");
    [self saveContext];
    
    // 本次同步的数量
    NSInteger count = [info[kInfoKeyCount] integerValue];
    NSDictionary *extra= info[kInfoKeyExtra];
    if (count > 1) { // count > 1
        // 继续同步
        ALog(@"[II] 继续同步联系人！");
        SyncMark *lastTime = [SyncMark syncMarkByKey:kSyncMarkKeyReceviedCardLastTime];
        SyncMark *lastID   = [SyncMark syncMarkByKey:kSyncMarkKeyReceviedCardLastID];
        [self.agent receivedCardsAfterDate:lastTime.value
                                  lastCard:lastID.value
                             expectedCount:@"50"
                                     extra:extra];
    } else { // count <= 1
        // 根据 queue 采取不同措施
        [self startNextSync:extra[kExtraKeySyncQueue]];
    }
    
}
- (void)handleLatestReceivedCardSucceeded:(NSNotification *)noti {
    NSDictionary *userInfo = noti.userInfo;
    DLog(@"[II] info = %@", userInfo);
    InterCard *iCard = userInfo[kInfoKeyInterCard];
    // 填入数据库
//    ReceivedCard *rCard = (ReceivedCard *)[self processCard:iCard cardType:cardType];
    ReceivedCard *rCard = [ReceivedCard objectWithIObject:iCard];
    [self saveContext];
    // 发送消息
    if (rCard) {
        // 数据库操作成功
        NSDictionary *info = @{ kInfoKeyReceivedCard : rCard };
        [self postASAPNotificationName:KHHUIPullLatestReceivedCardSucceeded
                                  info:info];
    } else {
        // 虽然服务器返回成功，但本地数据库操作失败
        NSDictionary *info = @{ kInfoKeyErrorCode : @(KHHStatusCodeLocalDataOperationFailed) };
        [self postASAPNotificationName:KHHUIPullLatestReceivedCardFailed
                                  info:info];
    }

}
- (void)handleLatestReceivedCardFailed:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    ALog(@"[II] info = %@", info);
    // 发送消息
    [self postASAPNotificationName:KHHUIPullLatestReceivedCardFailed
                              info:info];
}
- (void)handleNetworkMarkReadReceivedCardSucceeded:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    ReceivedCard *rCard = info[kInfoKeyObject];
    // 填入数据库
    rCard.isReadValue = YES;
    // 保存数据库
    [self saveContext];
    // 发送成功消息
    [self postASAPNotificationName:KHHUIMarkCardIsReadSucceeded];
}
- (void)handleNetworkMarkReadReceivedCardFailed:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    ALog(@"[II] info = %@", info);
    // 发送消息
    [self postASAPNotificationName:KHHUIMarkCardIsReadFailed
                              info:info];
}

#pragma mark - Handlers_Group
- (void)handleNetworkCreateGroupSucceeded:(NSNotification *)noti {
    NSDictionary *oldInfo = noti.userInfo;
    DLog(@"[II] info = %@", oldInfo);
    IGroup *igrp = oldInfo[kInfoKeyObject];
    // 插入数据库
    [Group objectWithIObject:igrp];
    [self saveContext];
    // 发成功消息
    [self postASAPNotificationName:KHHUICreateGroupSucceeded];
}
- (void)handleNetworkCreateGroupFailed:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    ALog(@"[II] info = %@", info);
    [self postASAPNotificationName:KHHUICreateGroupFailed info:info];
}
- (void)handleNetworkUpdateGroupSucceeded:(NSNotification *)noti {
    NSDictionary *oldInfo = noti.userInfo;
    DLog(@"[II] info = %@", oldInfo);
    IGroup *igrp = oldInfo[kInfoKeyObject];
    // 插入数据库
    [Group objectWithIObject:igrp];
    [self saveContext];
    // 发成功消息
    [self postASAPNotificationName:KHHUIUpdateGroupSucceeded];
}
- (void)handleNetworkUpdateGroupFailed:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    ALog(@"[II] info = %@", info);
    [self postASAPNotificationName:KHHUIUpdateGroupFailed info:info];
}
- (void)handleNetworkDeleteGroupSucceeded:(NSNotification *)noti {
    NSDictionary *oldInfo = noti.userInfo;
    DLog(@"[II] info = %@", oldInfo);
    Group *grp = oldInfo[kInfoKeyObject];
    // 从数据库中删除
    [self.context deleteObject:grp];
    [self saveContext];
    // 发送成功消息
    [self postASAPNotificationName:KHHUIDeleteGroupSucceeded];
}
- (void)handleNetworkDeleteGroupFailed:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    ALog(@"[II] info = %@", info);
    [self postASAPNotificationName:KHHUIDeleteGroupFailed info:info];
}
- (void)handleNetworkChildGroupsOfGroupIDSucceeded:(NSNotification *)noti {
    NSDictionary *oldInfo = noti.userInfo;
    DLog(@"[II] info = %@", oldInfo);
    NSArray *iGroupList = oldInfo[kInfoKeyGroupList];
    // 插入数据库
    for (id igrp in iGroupList) {
        [Group objectWithIObject:igrp];
    }
    [self saveContext];
    // 根据 queue 采取不同措施
    NSDictionary *extra= oldInfo[kInfoKeyExtra];
    [self startNextSync:extra[kExtraKeySyncQueue]];
}
- (void)handleNetworkCardIDsInAllGroupSucceeded:(NSNotification *)noti {
    NSDictionary *oldInfo = noti.userInfo;
    DLog(@"[II] info = %@", oldInfo);
    NSArray *iCardGroupMapList = oldInfo[kInfoKeyICardGroupMapList];
    // 插入数据库
    for (id obj in iCardGroupMapList) {
        [Group processICardGroupMap:obj];
    }
    [self saveContext];
    // 发成功消息
    // 根据 queue 采取不同措施
    NSDictionary *extra= oldInfo[kInfoKeyExtra];
    [self startNextSync:extra[kExtraKeySyncQueue]];
}
- (void)handleNetworkMoveCardsSucceeded:(NSNotification *)noti {
    NSDictionary *oldInfo = noti.userInfo;
    ALog(@"[II] info = %@", oldInfo);
    Group *fromGroup = oldInfo[kInfoKeyFromGroup];
    Group *toGroup   = oldInfo[kInfoKeyToGroup];
    NSArray *cards = oldInfo[kInfoKeyObjectList];
    for (Card *card in cards) {
        if (fromGroup) {
            [card.groupsSet removeObject:fromGroup];
        }
        if (toGroup) {
            [card.groupsSet addObject:toGroup];
        }
    }
    [self saveContext];
    // 发送成功消息
    [self postASAPNotificationName:KHHUIMoveCardsSucceeded];
}
- (void)handleNetworkMoveCardsFailed:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    ALog(@"[II] info = %@", info);
    [self postASAPNotificationName:KHHUIMoveCardsFailed info:info];
}

#pragma mark - Handlers_Template
- (void)handleTemplatesAfterDateSucceeded:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    DLog(@"[II] info = %@", [info allKeys]);
    
    //1.TemplateList {
    NSArray *list = info[kInfoKeyTemplateList];
    [CardTemplate processJSONList:list];
    // }
    //2.syncTime {
    [SyncMark UpdateKey:kSyncMarkKeyTemplatesLastTime
                  value:info[kInfoKeySyncTime]];
    // }
    // 3.保存
    [self saveContext];
    
    // 根据 queue 采取不同措施
    NSDictionary *extra= info[kInfoKeyExtra];
    [self startNextSync:extra[kExtraKeySyncQueue]];
}

#pragma mark - Handlers_Schedule
- (void)handleVisitSchedulesAfterDateSucceeded:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    DLog(@"[II] info = %@", info);
    // 1.List
    NSArray *list = info[kInfoKeyObjectList];
    [Schedule processIObjectList:list];
    // 2.Timestamp
    [SyncMark UpdateKey:kSyncMarkKeyVisitScheduleLastTime
                  value:info[kInfoKeySyncTime]];
    // 3.保存
    [self saveContext];
    // 根据 queue 采取不同措施
    NSDictionary *extra= info[kInfoKeyExtra];
    [self startNextSync:extra[kExtraKeySyncQueue]];
}

#pragma mark - Handlers_Evaluation
- (void)handleCustomerEvaluationListAfterDateSucceeded:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    DLog(@"[II] info = %@", info);
    // 1.List
    NSArray *list = info[kInfoKeyObjectList];
    for (ICustomerEvaluation *icv in list) {
        // 根据ID查，无则新建。
        CustomerEvaluation *ce = (CustomerEvaluation *)[CustomerEvaluation
                                                        objectByID:icv.id
                                                        createIfNone:YES];
        if (icv.isDeleted.integerValue) {
            // 已删除，则删除。
            [self.context deleteObject:ce];
        } else {
            // 未删除，则填数据。
            [ce updateWithIObject:icv];
        }
    }
    // 2.Timestamp
    [SyncMark UpdateKey:kSyncMarkKeyCustomerEvaluationLastTime
                  value:info[kInfoKeySyncTime]];
    // 3.保存
    [self saveContext];
    // 根据 queue 采取不同措施
    NSDictionary *extra= info[kInfoKeyExtra];
    [self startNextSync:extra[kExtraKeySyncQueue]];
}
- (void)handleNetworkCreateOrUpdateEvaluationSucceeded:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    ICustomerEvaluation *icv = info[kInfoKeyObject];
    // 填入数据库
    CustomerEvaluation *cv = [CustomerEvaluation objectByID:icv.id
                                               createIfNone:YES];
    [cv updateWithIObject:icv];
    // 保存数据库
    [self saveContext];
    // 发送成功消息
    [self postASAPNotificationName:KHHUISaveEvaluationSucceeded];
}
- (void)handleNetworkCreateOrUpdateEvaluationFailed:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    ALog(@"[II] info = %@", info);
    // 发送消息
    [self postASAPNotificationName:KHHUISaveEvaluationFailed
                              info:info];
}
@end

