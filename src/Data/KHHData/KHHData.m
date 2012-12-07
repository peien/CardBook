//
//  KHHData.m
//  CardBook
//
//  Created by 孙铭 on 12-9-17.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHDataAPI.h"
#import "KHHDefaults.h"
#import "KHHNotifications.h"


@implementation KHHData
@synthesize context = _context;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize agent = _agent;

- (id)initData
{
    self = [super init];
    if (self) {
        //
        _agent = [[KHHNetworkAPIAgent alloc] init];
        [self registerHandlersForNotifications];
    }
    return self;
}
- (void)dealloc
{
    [self stopObservingAllNotifications];
    _context = nil;
    _persistentStoreCoordinator = nil;
    _managedObjectModel = nil;
    _agent = nil;
}
+ (id)sharedData {
    static id _sharedObj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedObj = [[KHHData alloc] initData];
    });
    return _sharedObj;
}
#pragma mark - Core Data stack
- (void)removeContext // 删除Context。登出或登入时使用。
{
    _context = nil;
    _persistentStoreCoordinator = nil;
    _managedObjectModel = nil;
}
- (void)saveContext // 保存更改。
{
    if (self.context) {
        if (![self.context hasChanges]) {
            ALog(@"[II] context 无需保存！");
            return;
        }
        NSError *error = nil;
        if (![self.context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            if (error) {
                ALog(@"Unresolved error %@, %@", error, [error userInfo]);
            } else {
                ALog(@"[II] 保存 context 时发生了未知错误！");
            }
            abort();
        }
    }
}
- (void)cleanContext // 清除未保存的更改。
{
    [self.context reset];
}
- (NSManagedObjectContext *)context {
    if (_context != nil) {
        return _context;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _context = [[NSManagedObjectContext alloc] init];
        [_context setPersistentStoreCoordinator:coordinator];
    }
    return _context;
}
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CardBook" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // 登陆成功后以 “user_companyID.sqlite” 为文件名创建数据库文件。user取不到时使用默认的“CardBook.sqlite”。
    NSString *fileName = @"CardBook.sqlite";
    NSString *userID = [[KHHDefaults sharedDefaults] currentUser];
    if (userID.length) {
        NSNumber *companyID = [[KHHDefaults sharedDefaults] currentCompanyID];
        fileName = [NSString stringWithFormat:@"%@_%@.sqlite",userID, companyID];
    }
    NSURL *storeURL = [[KHHApp applicationDocumentsDirectory] URLByAppendingPathComponent:fileName];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        // 由于所有数据都在服务器端，一旦出错可直接删除本地数据，重新同步。
        ALog(@"[EE] ERROR!!删除 %@ 文件！", fileName);
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        _persistentStoreCoordinator = nil;
    }
    return self.persistentStoreCoordinator;
}

#pragma mark - Syncs
- (void)startNextQueuedOperation:(NSMutableArray *)queue {
    DLog(@"[II] 待同步的queue = %@", queue);
    if (0 == queue.count) {
        [self syncAllDataEnded:YES userInfo:nil];
        return;
    }
    KHHQueuedOperationSyncType syncAction = [queue[0] integerValue];
    [queue removeObjectAtIndex:0];
    switch (syncAction) {
        case KHHQueuedOperationSyncPartly: {
            [self syncPartly:queue];
            break;
        }
        case KHHQueuedOperationSyncReceivedCards: {
            [self syncReceivedCards:queue];
            break;
        }
        case KHHQueuedOperationSyncTemplates: {
            [self syncTemplates:queue];
            break;
        }
        case KHHQueuedOperationSyncGroups: {
            [self syncGroups:queue];
            break;
        }
        case KHHQueuedOperationSyncCardGroupMaps: {
            [self syncCardGroupMaps:queue];
            break;
        }
        case KHHQueuedOperationSyncCustomerEvaluations: {
            [self syncCustomerEvaluations:queue];
            break;
        }
        case KHHQueuedOperationSyncVisitSchedules: {
            [self syncVisitSchedules:queue];
            break;
        }
        case KHHQueuedOperationSyncVisitSchedulesAfterCreation: {
            // 创建拜访计划成功
            [self postASAPNotificationName:KHHUICreateVisitScheduleSucceeded];
            break;
        }
        case KHHQueuedOperationSyncVisitSchedulesAfterUpdate: {
            // 更新拜访计划成功
            [self postASAPNotificationName:KHHUIUpdateVisitScheduleSucceeded];
            break;
        }
        case KHHQueuedOperationSyncVisitSchedulesAfterUploadImage: {
            // 更新拜访计划成功
            [self postASAPNotificationName:KHHUIUploadImageForVisitScheduleSucceeded];
            break;
        }
    }
}
// 开始批量同步所有信息
- (void)startSyncAllData {
    // 启动调用链！
    NSMutableArray *queue = [NSMutableArray array];
    [queue addObject:@(KHHQueuedOperationSyncPartly)];
    [queue addObject:@(KHHQueuedOperationSyncReceivedCards)];
    [queue addObject:@(KHHQueuedOperationSyncTemplates)];
    [queue addObject:@(KHHQueuedOperationSyncGroups)];
    [queue addObject:@(KHHQueuedOperationSyncCardGroupMaps)];
    [queue addObject:@(KHHQueuedOperationSyncCustomerEvaluations)];
    [queue addObject:@(KHHQueuedOperationSyncVisitSchedules)];
    [self startNextQueuedOperation:queue];
}
- (void)syncAllDataEnded:(BOOL)succeed userInfo:(NSDictionary *) info {
    if (succeed) {
        [self postNowNotificationName:nDataSyncAllSucceeded];
    } else {
        [self postNowNotificationName:nDataSyncAllFailed info:info];
    }
}
//
- (void)syncPartly:(NSMutableArray *)queue // 所谓的syncAll接口
{
    NSDictionary *extra = @{ kExtraKeyQueue : queue };
    SyncMark *lastSyncTime = [SyncMark syncMarkByKey:kSyncMarkKeySyncAllLastTime];
    [self.agent allDataAfterDate:lastSyncTime.value
                           extra:extra];
}
- (void)syncReceivedCards:(NSMutableArray *)queue {
    // 同步联系人
    NSDictionary *extra = @{ kExtraKeyQueue : queue };
    SyncMark *lastTime = [SyncMark syncMarkByKey:kSyncMarkKeyReceviedCardLastTime];
    SyncMark *lastCardID = [SyncMark syncMarkByKey:kSyncMarkKeyReceviedCardLastID];
    [self.agent receivedCardsAfterDate:lastTime.value
                              lastCard:lastCardID.value
                         expectedCount:@"50"
                                 extra:extra];
}
- (void)syncCardGroupMaps:(NSMutableArray *)queue {
    //
    NSDictionary *extra = @{ kExtraKeyQueue : queue };
    [self.agent cardIDsInAllGroupWithExtra:extra];
}
- (void)syncTemplates:(NSMutableArray *)queue {
    NSDictionary *extra = @{ kExtraKeyQueue : queue };
    SyncMark *lastTime = [SyncMark syncMarkByKey:kSyncMarkKeyGroupsLastTime];
    [self.agent templatesAfterDate:lastTime.value
                             extra:extra];
}
- (void)syncGroups:(NSMutableArray *)queue {
    NSDictionary *extra = @{ kExtraKeyQueue : queue };
    [self.agent childGroupsOfGroupID:nil
                          withCardID:nil
                               extra:extra];
}
- (void)syncCustomerEvaluations:(NSMutableArray *)queue {
    NSDictionary *extra = @{ kExtraKeyQueue : queue };
    SyncMark *lastTime = [SyncMark syncMarkByKey:kSyncMarkKeyCustomerEvaluationLastTime];
    [self.agent customerEvaluationListAfterDate:lastTime.value
                                          extra:extra];
}
- (void)syncVisitSchedules:(NSMutableArray *)queue {
    // 同步拜访计划
    NSDictionary *extra = @{ kExtraKeyQueue : queue };
    SyncMark *lastTime = [SyncMark syncMarkByKey:kSyncMarkKeyVisitScheduleLastTime];
    [self.agent visitSchedulesAfterDate:lastTime.value
                                  extra:extra];
}
@end
