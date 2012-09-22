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
- (NSArray *)fetchEntityName:(NSString *)entityName
                       error:(NSError **)error {
    NSArray *result = nil;
    result = [self fetchEntityName:entityName
                         predicate:nil
                   sortDescriptors:nil
                             error:error];
    return result;
}
// 没有符合条件的返回空数组，出错返回nil。
- (NSArray *)fetchEntityName:(NSString *)entityName
                   predicate:(NSPredicate *)predicate
             sortDescriptors:(NSArray *)sortDescriptors
                       error:(NSError **)error {
    
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:entityName];
    if (predicate) {
        req.predicate = predicate;
    }
    if ([sortDescriptors count]) {
        req.sortDescriptors = sortDescriptors;
    }
    NSArray *result = [self.managedObjectContext executeFetchRequest:req
                                                               error:error];
    return result;
}

// 出错的返回值是NSNotFound，且error指向一个 NSError 实例。
- (NSUInteger)countOfEntityName:(NSString *)entityName
                          error:(NSError **)error {
    NSUInteger result = NSNotFound;
    result = [self countOfEntityName:entityName
                           predicate:nil
                     sortDescriptors:nil
                               error:error];
    return result;
}
// 出错的返回值是NSNotFound，且error指向一个 NSError 实例。
- (NSUInteger)countOfEntityName:(NSString *)entityName
                      predicate:(NSPredicate *)predicate
                sortDescriptors:(NSArray *)sortDescriptors
                          error:(NSError **)error {
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:entityName];
    if (predicate) {
        req.predicate = predicate;
    }
    if ([sortDescriptors count]) {
        req.sortDescriptors = sortDescriptors;
    }
    NSUInteger result = [self.managedObjectContext countForFetchRequest:req
                                                                  error:error];
    return result;
}
// 根据 ID 和 类名 查数据库。此 ID 不是CoreData OBjectID，而至cardID，companyID等等。
// 无则返回nil；
- (id)objectByID:(NSNumber *)ID ofClass:(NSString *)className {
    return [self objectByID:ID ofClass:className createIfNone:NO];
}

// 根据 ID 和 类名 查数据库。此 ID 不是CoreData OBjectID，而至cardID，companyID等等。
// createIfNone==YES，无则新建
// createIfNone==NO， 无则返回nil；
- (id)objectByID:(NSNumber *)ID
         ofClass:(NSString *)className
    createIfNone:(BOOL)createIfNone {
    id result = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", ID];
    NSError *error;
    NSArray *matches = [self fetchEntityName:className
                                   predicate:predicate
                             sortDescriptors:nil
                                       error:&error];
    if (nil == matches) {
        ALog(@"[EE] fetchEntityName 出错：%@", error.localizedDescription);
        return result;
    }
    if ([matches count] > 1) {
        ALog(@"[EE] fetchEntityName 出错：返回的对象多于一个!");
        //        return result;
    }
    result = [matches lastObject];
    if (nil == result && createIfNone) {
        result = [NSEntityDescription insertNewObjectForEntityForName:className
                                               inManagedObjectContext:self.managedObjectContext];
        [result setValue:ID forKey:kAttributeKeyID];
    }
    return result;
}
// 新建一个对象。无预设ID之类的属性。
- (id)objectOfClass:(NSString *)className {
    id result = nil;
    result = result = [NSEntityDescription insertNewObjectForEntityForName:className
                                                    inManagedObjectContext:self.managedObjectContext];
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
        result = [self fetchEntityName:entityName
                                 error:nil];
    } else {
        ALog(@"[EE] entityName = nil!!!");
    }
    return result;
}
// 根据ID读取。// 如果多于一个返回最后一个。不存在或出错都是nil.
- (id)cardOfType:(KHHCardModelType)cardType
            byID:(NSNumber *)cardID {
    id result = nil;
    result = [self cardOfType:cardType
                         byID:cardID
                 createIfNone:NO];
    return result;
}
- (id)cardOfType:(KHHCardModelType)cardType
            byID:(NSNumber *)cardID
    createIfNone:(BOOL)createIfNone {
    Card *result = nil;
    NSString *entityName = [self entityNameWithCardType:cardType];
    if (0 == [entityName length]) {
        ALog(@"[EE] entityName = nil 或 @\"\"!!!");
        return result;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", cardID];
    NSError *error;
    NSArray *matches = [self fetchEntityName:entityName
                                   predicate:predicate
                             sortDescriptors:nil
                                       error:&error];
    if (nil == matches) {
        ALog(@"[EE] fetchEntityName 出错：%@", error.localizedDescription);
        return result;
    }
    if ([matches count] > 1) {
        ALog(@"[EE] fetchEntityName 出错：返回的对象多于一个!");
        //        return result;
    }
    result = [matches lastObject];
    if (nil == result && createIfNone) {
        result = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                               inManagedObjectContext:self.managedObjectContext];
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
    return [self objectByID:companyID ofClass:[Company entityName]];
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
        NSError *error;
        NSArray *matches =  [self fetchEntityName:entityName
                                        predicate:predicate
                                  sortDescriptors:nil
                                            error:&error];
        result = [matches lastObject];
    }
    
    if (result) {
        return result;
    }
    result = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                           inManagedObjectContext:self.managedObjectContext];
    return result;
}
@end
