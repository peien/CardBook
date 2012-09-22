//
//  KHHData+Handlers.m
//  CardBook
//
//  Created by 孙铭 on 12-9-19.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHData+Handlers.h"
#import "NSNumber+SM.h"
#import "NSObject+Notification.h"

@interface KHHData (DataProcessors)
- (void)processList:(NSArray *)list ofClass:(NSString *)className;
- (void)processObject:(NSDictionary *)objDict ofClass:(NSString *)className withID:(NSNumber *)ID;// ID 不存在就不操作
// company
- (void)processCompanyList:(NSArray *)list;
- (void)processCompany:(NSDictionary *)company;
// card
- (void)processMyCardList:(NSArray *)list;
- (void)processPrivateCardList:(NSArray *)list;
- (void)processReceivedCardList:(NSArray *)list;
- (void)processCardList:(NSArray *)list cardType:(KHHCardModelType)type;
- (void)processCard:(NSDictionary *)aCard cardType:(KHHCardModelType)type;
// template
- (void)processCardTemplateList:(NSArray *)list;
- (void)processCardTemplate:(NSDictionary *)template;
- (void)processCardTemplateItemList:(NSArray *)list;
- (void)processCardTemplateItem:(NSDictionary *)templateItem;
//
- (void)processSyncTime:(NSString *)syncTime;
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
@implementation KHHData (DataProcessors)
- (void)processList:(NSArray *)list
            ofClass:(NSString *)className {
    if (list.count && className.length) {
        for (NSDictionary *objDict in list) {
            if (objDict) {
                SEL selector = NSSelectorFromString([NSString stringWithFormat:@"process%@:", className]);
                if ([self respondsToSelector:selector]) {
                    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
                    [inv setTarget:self];
                    [inv setSelector:selector];
                    NSDictionary *arg = objDict;
                    [inv setArgument:&arg atIndex:2];
                    [inv invoke];
                }
            }
        }
    }
}
// ID 不存在就不操作
- (void)processObject:(NSDictionary *)dict
              ofClass:(NSString *)name
               withID:(NSNumber *)ID {
    if (dict) {
        id obj = nil;

        // ID 不存在就不操作
        if (nil == ID) {
            return;
        }
        
        BOOL isDeleted = [dict[JSONDataKeyIsDelete] boolValue];
        // 按ID从数据库里查询
        if (isDeleted) {
            // 无不新建
            obj = [self objectByID:ID ofClass:name createIfNone:NO];
            // 有则删除
            if (obj) {
                [self.managedObjectContext deleteObject:obj];
            }
        } else {
            // 无则新建。
            obj = [self objectByID:ID ofClass:name createIfNone:YES];
            // 填充数据
            SEL selector = NSSelectorFromString([NSString stringWithFormat:@"Fill%@:withJSON:", name]);
            if ([self respondsToSelector:selector]) {
                NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
                [inv setTarget:self];
                [inv setSelector:selector];
                [inv setArgument:&obj atIndex:2];
                [inv setArgument:&dict atIndex:3];
                [inv invoke];
            }
            DLog(@"[II] obj = %@", obj);
        }
        // 保存
        [self saveContext];
    }
}
// company {
- (void)processCompanyList:(NSArray *)list {
    [self processList:list ofClass:@"Company"];
}
- (void)processCompany:(NSDictionary *)dict {
    DLog(@"[II] a Company dict class= %@, data = %@", [dict class], dict);
    DLog(@"[II] a Company keys = %@", [dict allKeys]);
#warning company ID?
    NSString *className = [Company entityName];
    NSNumber *ID = [NSNumber numberFromObject:dict[JSONDataKeyID]
                           zeroIfUnresolvable:NO];
    [self processObject:dict ofClass:className withID:ID];
}
// }

// card {
- (void)processMyCardList:(NSArray *)list {
    [self processCardList:list cardType:KHHCardModelTypeMyCard];
}
- (void)processPrivateCardList:(NSArray *)list {
    [self processCardList:list cardType:KHHCardModelTypePrivateCard];
}
- (void)processReceivedCardList:(NSArray *)list {
    [self processCardList:list cardType:KHHCardModelTypeReceivedCard];
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
        // 按ID从数据库里查询
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
// }

// template {
- (void)processCardTemplateList:(NSArray *)list {
    [self processList:list ofClass:@"Template"];
}
- (void)processCardTemplate:(NSDictionary *)dict {
    DLog(@"[II] a template dict class= %@, data = %@", [dict class], dict);
    DLog(@"[II] a template keys = %@", [dict allKeys]);
    
    NSString *className = [CardTemplate entityName];
    NSNumber *ID = [NSNumber numberFromObject:dict[JSONDataKeyID]
                           zeroIfUnresolvable:NO];
    [self processObject:dict ofClass:className withID:ID];
}
- (void)processCardTemplateItemList:(NSArray *)list {
    [self processList:list ofClass:@"TemplateItem"];
}
- (void)processCardTemplateItem:(NSDictionary *)dict {
    DLog(@"[II] a templateItem dict class= %@, data = %@", [dict class], dict);
    DLog(@"[II] a templateItem keys = %@", [dict allKeys]);
    NSString *className = [CardTemplateItem entityName];
    NSNumber *ID = [NSNumber numberFromObject:dict[JSONDataKeyID]
                           zeroIfUnresolvable:NO];
    [self processObject:dict ofClass:className withID:ID];
}
// }

//
- (void)processSyncTime:(NSString *)syncTime {
    DLog(@"[II] syncTime = %@", syncTime);
#warning TODO
}
@end
