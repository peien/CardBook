//
//  KHHData+Handlers.m
//  CardBook
//
//  Created by 孙铭 on 12-9-19.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHData+Handlers.h"
#import "KHHData+Utils.h"
#import "NSNumber+SM.h"
#import "NSObject+Notification.h"

@interface KHHData (DataProcessors)
- (void)processCompanyList:(NSArray *)list;
- (void)processCard:(NSDictionary *)aCard cardType:(KHHCardModelType)type;
- (void)processCardList:(NSArray *)list cardType:(KHHCardModelType)type;
- (void)processMyCardList:(NSArray *)list;
- (void)processPrivateCardList:(NSArray *)list;
- (void)processReceivedCardList:(NSArray *)list;
- (void)processSyncTime:(NSString *)syncTime;
- (void)processTemplateList:(NSArray *)list;
@end

@implementation KHHData (Handlers)
- (void)syncAllDataEnded:(BOOL)succeed {
    if (succeed) {
        [self postNotification:KHHNotificationSyncAfterLoginSucceeded info:nil];
    } else {
        [self postNotification:KHHNotificationSyncAfterLoginFailed info:nil];
    }
}
#pragma mark - Notification handlers
- (void)handleAllDataAfterDateSucceeded:(NSNotification *)noti {
    DLog(@"[II] noti userInfo keys = %@", [noti.userInfo allKeys]);
    NSDictionary *info = noti.userInfo;
    // 处理返回的数据
    // 1.
    // 2.
    // 3.
    // 4.
    // MyCard List
    NSArray *myCardList = info[kInfoKeyMyCardList];
    if (myCardList) {
        [self processMyCardList:myCardList];
    }
    // Sync Time
    NSString *syncTime = info[kInfoKeySyncTime];
    if (syncTime.length) {
        [self processSyncTime:syncTime];
    }
    
    // 处理结束
    BOOL isChained = NO;
    NSDictionary *extra= info[kInfoKeyExtra];
    if (extra) {
        isChained = [extra[kExtraKeyChainedInvocation] boolValue];
    }
    if (isChained) {
        // 接下来，同步联系人
        // 先获取要同步的数量
        [self.agent receivedCardCountAfterDate:nil
                                      lastCard:nil
                                         extra:@{
                   kExtraKeyChainedInvocation : [NSNumber numberWithBool:YES]
         }];
    } else {
        
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
    BOOL isChained = NO;
    NSDictionary *info = noti.userInfo;
    DLog(@"[II] 新名片数量%@。", info[kInfoKeyCount]);
    NSDictionary *extra= info[kInfoKeyExtra];
    if (extra) {
        isChained = [extra[kExtraKeyChainedInvocation] boolValue];
    }
#warning TODO
    if (isChained) {
        [self syncAllDataEnded:YES];
    } else {
        
    }
}
- (void)handleReceivedCardCountAfterDateLastCardFailed:(NSNotification *)noti {
    
}
@end
@implementation KHHData (DataProcessors)
- (void)processCompanyList:(NSDictionary *)list {
    
}
- (void)processTemplateList:(NSDictionary *)list {
    
}
- (void)processCard:(NSDictionary *)dict cardType:(KHHCardModelType)type {
    DLog(@"[II] a Card dict class= %@, data = %@", [dict class], dict);
    if (dict) {
        Card *card = nil;
        NSNumber *ID = [NSNumber numberFromObject:dict[JSONDataKeyCardId]
                               zeroIfUnresolvable:NO];
        if (nil == ID) {
            // ID无法解析就不操作
            return;
        }
        BOOL isDeleted = [dict[JSONDataKeyIsDelete] boolValue];
        // 按cardID从数据库里查询名片
        if (isDeleted) {
            // 无不新建
            card = [self cardOfType:type byID:ID createIfNone:NO];
            // 有则删除
            if (card) {
                [self.managedObjectContext deleteObject:card];
            }
        } else {
            // 无则新建。
            card = [self cardOfType:type byID:ID createIfNone:YES];
            // 填充数据
            [self FillCard:card ofType:type withJSON:dict];
            DLog(@"[II] card = %@", card);
        }
        // 保存
        [self saveContext];
    }
}
- (void)processCardList:(NSArray *)list cardType:(KHHCardModelType)type {
    if ([list count]) {
        for (NSDictionary *aCard in list) {
            if (aCard) {
                [self processCard:aCard cardType:type];
            }
        }
    }
}
- (void)processMyCardList:(NSArray *)list {
    [self processCardList:list cardType:KHHCardModelTypeMyCard];
}
- (void)processPrivateCardList:(NSArray *)list {
    [self processCardList:list cardType:KHHCardModelTypePrivateCard];
}
- (void)processReceivedCardList:(NSArray *)list {
    [self processCardList:list cardType:KHHCardModelTypeReceivedCard];
}
- (void)processSyncTime:(NSString *)syncTime {
    DLog(@"[II] syncTime = %@", syncTime);
#warning TODO
}
@end
