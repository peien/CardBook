//
//  KHHDataNew.h
//  CardBook
//
//  Created by CJK on 13-1-14.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "KHHNetClinetAPIAgent.h"
#import "KHHApp.h"
#import "KHHDefaults.h"

@interface KHHDataNew : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *context;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) KHHNetClinetAPIAgent *agent;
// create OR obtain the singleton instance
@property (strong,nonatomic) id delegate;
+ (id)sharedData;
//
- (void)saveContext;   // 保存更改。
- (void)cleanContext;  // 清除未保存的更改。
- (void)removeContext; // 删除Context。登出或登入时使用。
@end
