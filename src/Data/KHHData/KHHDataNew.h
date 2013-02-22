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
#import "SyncMark.h"
#import "NSManagedObject+KHH.h"


@interface KHHDataNew : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *context;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) KHHNetClinetAPIAgent *agent;

@property (strong,nonatomic) id delegate;
@property (strong,nonatomic) id delegateInSelf;
@property (strong,nonatomic) NSMutableDictionary *needDic;

//类别的同步类型
@property (assign,nonatomic) int syncType;

//标记，用来标记多网络接口时标记是否有失败的
@property (assign,nonatomic) BOOL hasFailed;

// create OR obtain the singleton instance
+ (id)sharedData;
//
- (void)saveContext;   // 保存更改。
- (void)cleanContext;  // 清除未保存的更改。
- (void)removeContext; // 删除Context。登出或登入时使用。

#pragma mark - format Util
- (NSString *)interval:(NSString *)timeStr;
@end
