//
//  KHHData.m
//  CardBook
//
//  Created by 孙铭 on 12-9-17.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHData.h"
#import "NSObject+Notification.h"

@implementation KHHData
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize agent = _agent;

- (id)initData
{
    self = [super init];
    if (self) {
        //
        _agent = [[KHHNetworkAPIAgent alloc] init];
        [self observeNotification:KHHNotificationAllDataAfterDateSucceeded
                           object:_agent selector:@"handleAllDataAfterDateSucceeded:"];
        [self observeNotification:KHHNotificationAllDataAfterDateFailed
                           object:_agent selector:@"handleAllDataAfterDateFailed:"];
        [self observeNotification:KHHNotificationReceivedCardCountAfterDateLastCardSucceeded
                           object:_agent selector:@"handleReceivedCardCountAfterDateLastCardSucceeded:"];
        [self observeNotification:KHHNotificationReceivedCardCountAfterDateLastCardFailed
                           object:_agent selector:@"handleReceivedCardCountAfterDateLastCardFailed:"];
    }
    return self;
}
- (void)dealloc
{
    [self removeContext];
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
    _managedObjectContext = nil;
    _persistentStoreCoordinator = nil;
    _managedObjectModel = nil;
}
- (void)saveContext // 保存更改。
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
- (void)cleanContext // 清除未保存的更改。
{
    [self.managedObjectContext reset];
}
- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
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
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}
#pragma mark - Sync
// 开始批量同步所有信息
- (void)startSyncAllData {
    // 启动调用链！
    NSDictionary *extra = @{kExtraKeyChainedInvocation : [NSNumber numberWithBool:YES]};
#warning 需要填上时间
    [self.agent allDataAfterDate:nil extra:extra];
}

@end
