//
//  KHHData+CRUD.h
//  CardBook
//
//  Created by Sun Ming on 12-9-22.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHData.h"
#import "KHHClasses.h"

@interface KHHData (CRUD)
// 没有符合条件的返回空数组，出错返回nil。
- (NSArray *)fetchEntityName:(NSString *)entityName;
// 没有符合条件的返回空数组，出错返回nil。
- (NSArray *)fetchEntityName:(NSString *)entityName
                   predicate:(NSPredicate *)predicate
             sortDescriptors:(NSArray *)sortDescriptors;

// 出错的返回值是NSNotFound。
- (NSUInteger)countOfEntityName:(NSString *)entityName;
// 出错的返回值是NSNotFound。
- (NSUInteger)countOfEntityName:(NSString *)entityName
                      predicate:(NSPredicate *)predicate
                sortDescriptors:(NSArray *)sortDescriptors;
// 根据 ID 和 类名 查数据库。此 ID 不是CoreData OBjectID，而至cardID，companyID等等。
// 无则返回nil；
- (NSManagedObject *)objectByID:(NSNumber *)ID ofClass:(NSString *)className;

// 根据 ID 和 类名 查数据库。此 ID 不是CoreData OBjectID，而至cardID，companyID等等。
// createIfNone==YES，无则新建
// createIfNone==NO， 无则返回nil；
- (NSManagedObject *)objectByID:(NSNumber *)ID ofClass:(NSString *)className createIfNone:(BOOL)createIfNone;
// 新建一个对象。无预设ID之类的属性。
- (NSManagedObject *)objectOfClass:(NSString *)className ;
@end

#pragma mark - Card
@interface KHHData (CRUD_Card)
// cardType -> entityName: 出错返回nil。
- (NSString *)entityNameWithCardType:(KHHCardModelType)cardType;
- (NSArray *)allCardsOfType:(KHHCardModelType)cardType;
// 如果多于一个返回最后一个。不存在或出错都是nil.
- (Card *)cardOfType:(KHHCardModelType)cardType byID:(NSNumber *)cardID;//本地
// 如果多于一个返回最后一个。
// createIfNone==NO：不存在或出错都是nil；createIfNone==YES：不存在会创建一个id==ID的新名片，出错为nil。
- (Card *)cardOfType:(KHHCardModelType)cardType byID:(NSNumber *)cardID createIfNone:(BOOL)createIfNone;//本地
- (void)createCardOfType:(KHHCardModelType)cardType withInterCard:(InterCard *)iCard;//联网
- (void)modifyCardOfType:(KHHCardModelType)cardType withInterCard:(InterCard *)iCard;//联网
- (void)deleteCardOfType:(KHHCardModelType)cardType byID:(NSNumber *)cardID;//联网
@end

#pragma mark - Company
@interface KHHData (CRUD_Company)
// 根据公司ID查数据库。
// 无则返回nil；
- (Company *)companyByID:(NSNumber *)companyID;
@end

#pragma mark - Image
@interface KHHData (CRUD_Image)
// 根据图片ID查数据库，无则新建。
// 注意id==0或nil，亦新建；
- (Image *)imageByID:(NSNumber *)imageID;
@end

#pragma mark - Sync Mark
@interface KHHData (CRUD_SyncMark)
// 根据key查数据库，无则新建。
// 注意key为@""或nil，亦新建；
- (SyncMark *)syncMarkByKey:(NSString *)key;
@end

#pragma mark - VisitSchedule
@interface KHHData (CRUD_Schedule)
// 根据拜访计划ID查数据库。
// 无则返回nil；
- (Schedule *)scheduleByID:(NSNumber *)scheduleID;
@end
