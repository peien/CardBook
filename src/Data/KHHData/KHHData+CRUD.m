//
//  KHHData+CRUD.m
//  CardBook
//
//  Created by Sun Ming on 12-9-22.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHData+CRUD.h"

@implementation KHHData (CRUD)

// 没有符合条件的返回空数组，出错返回nil。
- (NSArray *)fetchEntityName:(NSString *)entityName {
    NSArray *result = nil;
    result = [self fetchEntityName:entityName
                         predicate:nil
                   sortDescriptors:nil];
    return result;
}
// 没有符合条件的返回空数组，出错返回nil。
- (NSArray *)fetchEntityName:(NSString *)entityName
                   predicate:(NSPredicate *)predicate
             sortDescriptors:(NSArray *)sortDescriptors {
    
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:entityName];
    if (predicate) {
        req.predicate = predicate;
    }
    if ([sortDescriptors count]) {
        req.sortDescriptors = sortDescriptors;
    }
    NSError *error = nil;
    NSArray *result = [self.context executeFetchRequest:req error:&error];
    if (nil == result) {
        NSString *errorMessage = (error)?error.localizedDescription:@"未知错误!!!";
        ALog(@"[EE] fetchEntityName 出错：%@", errorMessage);
        return result;
    }
    return result;
}

// 出错的返回值是NSNotFound。
- (NSUInteger)countOfEntityName:(NSString *)entityName {
    NSUInteger result = NSNotFound;
    result = [self countOfEntityName:entityName
                           predicate:nil
                     sortDescriptors:nil];
    return result;
}
// 出错的返回值是NSNotFound。
- (NSUInteger)countOfEntityName:(NSString *)entityName
                      predicate:(NSPredicate *)predicate
                sortDescriptors:(NSArray *)sortDescriptors {
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:entityName];
    if (predicate) {
        req.predicate = predicate;
    }
    if ([sortDescriptors count]) {
        req.sortDescriptors = sortDescriptors;
    }
    NSError *error = nil;
    NSUInteger result = [self.context countForFetchRequest:req error:&error];
    if (NSNotFound == result) {
        NSString *errorMessage = (error)?error.localizedDescription:@"未知错误!!!";
        ALog(@"[EE] fetchEntityName 出错：%@", errorMessage);
        return result;
    }
    return result;
}
// 根据 ID 和 类名 查数据库。此 ID 不是CoreData OBjectID，而至cardID，companyID等等。
// 无则返回nil；
- (NSManagedObject *)objectByID:(NSNumber *)ID ofClass:(NSString *)className {
    return [self objectByID:ID ofClass:className createIfNone:NO];
}

// 根据 ID 和 类名 查数据库。此 ID 不是CoreData OBjectID，而至cardID，companyID等等。
// createIfNone==YES，无则新建
// createIfNone==NO， 无则返回nil；
- (NSManagedObject *)objectByID:(NSNumber *)ID
         ofClass:(NSString *)className
    createIfNone:(BOOL)createIfNone {
    NSManagedObject *result = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", ID];
    NSError *error;
    NSArray *matches = [self fetchEntityName:className
                                   predicate:predicate
                             sortDescriptors:nil];
    if (nil == matches) {
        ALog(@"[EE] fetchEntityName 出错：%@", error?error.localizedDescription:@"未知错误!!!");
        return result;
    }
    if ([matches count] > 1) {
        ALog(@"[EE] fetchEntityName 出错：返回的对象多于一个!");
        //        return result;
    }
    result = [matches lastObject];
    if (nil == result && createIfNone) {
        result = [NSEntityDescription insertNewObjectForEntityForName:className
                                               inManagedObjectContext:self.context];
        [result setValue:ID forKey:kAttributeKeyID];
    }
    return result;
}
// 新建一个对象。无预设ID之类的属性。
- (NSManagedObject *)objectOfClass:(NSString *)className {
    NSManagedObject *result = nil;
    result = [NSEntityDescription insertNewObjectForEntityForName:className
                                                    inManagedObjectContext:self.context];
    return result;
}

@end

@implementation KHHData (CRUD_Card)

// cardType -> entityName: 出错返回nil。
- (NSString *)entityNameWithCardType:(KHHCardModelType)cardType {
    NSString *result = nil;
    switch (cardType) {
        case KHHCardModelTypeMyCard:
            result = [MyCard entityName];
            break;
        case KHHCardModelTypePrivateCard:
            result = [PrivateCard entityName];
            break;
        case KHHCardModelTypeReceivedCard:
            result = [ReceivedCard entityName];
            break;
    }
    return result;
}

/*!
 Card: 通用接口，不要直接调这些接口！！！
 */
// 无为空数组，出错为nil。
- (NSArray *)allCardsOfType:(KHHCardModelType)cardType {
    NSArray *result = nil;
    NSString *entityName = [self entityNameWithCardType:cardType];
    if (entityName) {
        result = [self fetchEntityName:entityName];
    } else {
        ALog(@"[EE] entityName = nil!!!");
    }
    return result;
}
// 根据ID读取。// 如果多于一个返回最后一个。不存在或出错都是nil.
- (NSManagedObject *)cardOfType:(KHHCardModelType)cardType
            byID:(NSNumber *)cardID {
    NSManagedObject * result = nil;
    result = [self cardOfType:cardType
                         byID:cardID
                 createIfNone:NO];
    return result;
}
- (Card *)cardOfType:(KHHCardModelType)cardType
            byID:(NSNumber *)cardID
    createIfNone:(BOOL)createIfNone {
    Card *result = nil;
    NSString *entityName = [self entityNameWithCardType:cardType];
    if (0 == [entityName length]) {
        ALog(@"[EE] entityName = nil 或 @\"\"!!!");
        return result;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", cardID];
    NSArray *matches = [self fetchEntityName:entityName
                                   predicate:predicate
                             sortDescriptors:nil];
    if (nil == matches) { // 出错
#warning TO REVIEW
        return result;
    }
    if ([matches count] > 1) {
        ALog(@"[EE] fetchEntityName 出错：返回的对象多于一个!");
    }
    result = [matches lastObject];
    if (nil == result && createIfNone) {
        result = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                               inManagedObjectContext:self.context];
        result.id = cardID;
    }
    return result;
}

// 创建
- (void)createCardOfType:(KHHCardModelType)cardType
          withDictionary:(NSDictionary *)dict {
#warning TODO
}
// 修改
- (void)modifyCardOfType:(KHHCardModelType)cardType
          withDictionary:(NSDictionary *)dict {
#warning TODO
}
// 删除
- (void)deleteCardOfType:(KHHCardModelType)cardType
                    byID:(NSNumber *)cardID {
#warning TODO
}

@end

@implementation KHHData (CRUD_Company)
// 根据公司ID查数据库。
// 无则返回nil；
- (Company *)companyByID:(NSNumber *)companyID {
    return (Company *)[self objectByID:companyID ofClass:[Company entityName]];
}
@end

@implementation KHHData (CRUD_Image)
// 根据图片ID查数据库，无则新建。
// 注意id==0或nil，亦新建；
- (Image *)imageByID:(NSNumber *)imageID {
    
    Image *result = nil;
    NSString *entityName = [Image entityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", imageID];
    
    // imageID 不为nil，且不等于0；
    if (imageID && (0 != imageID.integerValue)) {
        NSArray *matches =  [self fetchEntityName:entityName
                                        predicate:predicate
                                  sortDescriptors:nil];
        result = [matches lastObject];
    }
    
    if (result) {
        return result;
    }
    result = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                           inManagedObjectContext:self.context];
    return result;
}
@end
