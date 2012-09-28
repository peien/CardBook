//
//  KHHData+Handlers.m
//  CardBook
//
//  Created by 孙铭 on 12-9-19.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHData+Handlers.h"
#import "NSNumber+SM.h"

@implementation KHHData (Handlers)
- (void)syncAllDataEnded:(BOOL)succeed {
    if (succeed) {
        [self postASAPNotificationName:KHHUISyncAfterLoginSucceeded];
    } else {
        [self postASAPNotificationName:KHHUISyncAfterLoginFailed];
    }
}
#pragma mark - Notification handlers
- (void)handleAllDataAfterDateSucceeded:(NSNotification *)noti {
    DLog(@"[II] noti userInfo keys = %@", [noti.userInfo allKeys]);
    NSDictionary *info = noti.userInfo;
    // 处理返回的数据
#warning TODO
    // 1.
    // 2.
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
    BOOL isChained = NO;
    NSDictionary *extra= info[kInfoKeyExtra];
    if (extra) {
        isChained = [extra[kExtraKeyChainedInvocation] boolValue];
    }
    if (isChained) {
        // 接下来，同步联系人
        // 先获取要同步的数量
        SyncMark *lastTime = [self syncMarkByKey:kSyncMarkKeyReceviedCardLastTime];
        SyncMark *lastCardID = [self syncMarkByKey:kSyncMarkKeyReceviedCardLastID];
        [self.agent receivedCardCountAfterDate:lastTime.value
                                      lastCard:lastCardID.value
                                         extra:@{
                   kExtraKeyChainedInvocation : [NSNumber numberWithBool:YES]
         }];
    } else {
#warning TODO
        // 发消息？
    }
}
- (void)handleAllDataAfterDateFailed:(NSNotification *)noti {
    BOOL isChained = NO;
    NSDictionary *info = noti.userInfo;
    if (info) {
        isChained = [info[kExtraKeyChainedInvocation] boolValue];
    }
#warning TODO
}
- (void)handleReceivedCardCountAfterDateLastCardSucceeded:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    NSNumber *count = info[kInfoKeyCount];
    DLog(@"[II] 新名片数量%@。", count);
    NSDictionary *extra= info[kInfoKeyExtra];
    BOOL isChained = NO;
    if (extra) {
        isChained = [extra[kExtraKeyChainedInvocation] boolValue];
    }
    if (isChained) {
        SyncMark *lastTime = [self syncMarkByKey:kSyncMarkKeyReceviedCardLastTime];
        SyncMark *lastCardID = [self syncMarkByKey:kSyncMarkKeyReceviedCardLastID];
        [self.agent receivedCardsAfterDate:lastTime.value
                                  lastCard:lastCardID.value
                             expectedCount:count.stringValue
                                     extra:extra];
    } else {
#warning TODO
        // 发消息？
    }
}
- (void)handleReceivedCardCountAfterDateLastCardFailed:(NSNotification *)noti {
    DLog(@"[II] handleReceivedCardCountAfterDateLastCardFailed:%@", noti);
#warning TODO
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
    [self saveContext];
    // extra:
    BOOL isChained = NO;
    NSDictionary *extra= info[kInfoKeyExtra];
    if (extra) {
        isChained = [extra[kExtraKeyChainedInvocation] boolValue];
    }
    if (isChained) {
        [self syncAllDataEnded:YES];
    } else {
#warning TODO
        // 发消息？
    }
}
- (void)handleReceivedCardsAfterDateLastCardExpectedCountFailed:(NSNotification *)noti {
    DLog(@"[II] handleReceivedCardsAfterDateLastCardExpectedCountFailed:%@", noti);
#warning TODO
}
@end
