//
//  KHHData.h
//  CardBook
//
//  Created by 孙铭 on 12-9-17.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "KHHApp.h"
#import "KHHClasses.h"
#import "KHHNetworkAPI.h"


@interface KHHData : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *context;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) KHHNetworkAPIAgent *agent;
// create OR obtain the singleton instance
+ (id)sharedData;
//
- (void)saveContext;   // 保存更改。
- (void)cleanContext;  // 清除未保存的更改。
- (void)removeContext; // 删除Context。登出或登入时使用。
@end

@interface KHHData (Syncs)
// 开始批量同步所有信息
- (void)startSyncAllData;
- (void)syncAllDataEnded:(BOOL)succeed;
- (void)startNextSync:(NSMutableArray *)queue;
//
- (void)syncPartly:(NSMutableArray *)queue; // 所谓的syncAll接口
- (void)syncReceivedCards:(NSMutableArray *)queue;
- (void)syncGroups:(NSMutableArray *)queue;
- (void)syncCardGroupMaps:(NSMutableArray *)queue;
- (void)syncTemplates:(NSMutableArray *)queue;
@end
