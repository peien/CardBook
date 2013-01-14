//
//  NSManagedObject+KHH.h
//  CardBook
//
//  Created by Sun Ming on 12-10-17.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "KHHLog.h"
#import "KHHTransformation.h"
#import "KHHDataNew.h"

@interface NSManagedObject (KHH)
// 当前应用的NSManagedObjectContext
+ (NSManagedObjectContext *)currentContext;

// 在context里创建一个新的object;
+ (id)newObject;

// 根据 ID 查数据库。此ID不是CoreData OBjectID，而至cardID，companyID等等。
// createIfNone==YES，无则新建
// createIfNone==NO， 无则返回nil；
+ (id)objectByID:(NSNumber *)ID createIfNone:(BOOL)createIfNone;

// 根据 Key-Value 查数据库。
// createIfNone==YES，无则新建
// createIfNone==NO， 无则返回nil；
+ (id)objectByKey:(NSString *)keyName value:(id)value createIfNone:(BOOL)createIfNone;

// 根据条件和排序规则查数据库。
// 没有符合条件的返回空数组，出错返回nil。
+ (NSArray *)objectArrayByPredicate:(NSPredicate *)predicate
                    sortDescriptors:(NSArray *)sortDescriptors;
@end
@interface NSManagedObject (KHHSort)
// 默认的对象名字排序规则
+ (NSSortDescriptor *)nameSortDescriptor;
+ (NSSortDescriptor *)newCardSortDescriptor;
+ (NSSortDescriptor *)companyCardSortDescriptor;
@end
@interface NSManagedObject (KHHTransformation) <KHHTransformation>
+ (void)processIObjectList:(NSArray *)list;
+ (void)processJSONList:(NSArray *)list;
@end