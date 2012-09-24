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
    NSArray *privateCardList = info[kInfoKeyPrivateCardList];
    if (privateCardList.count) {
        [self processPrivateCardList:privateCardList];
    }
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
        [self processSyncTime:syncTime];
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
//        [self.agent receivedCardCountAfterDate:nil
//                                      lastCard:nil
//                                         extra:@{
//                   kExtraKeyChainedInvocation : [NSNumber numberWithBool:YES]
//         }];
        [self syncAllDataEnded:YES];
    } else {
        // 暂时没有什么要做的
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
