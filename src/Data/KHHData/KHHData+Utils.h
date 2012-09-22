//
//  KHHData+Utils.h
//  CardBook
//
//  Created by 孙铭 on 12-9-20.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHData.h"
/*
 用于 KHHData 内部使用，外部不需要调用。
 */
@interface KHHData (Utils)
// 没有符合条件的返回空数组，出错返回nil。
- (NSArray *)fetchEntityName:(NSString *)entityName
                       error:(NSError **)error;
// 没有符合条件的返回空数组，出错返回nil。
- (NSArray *)fetchEntityName:(NSString *)entityName
                   predicate:(NSPredicate *)predicate
             sortDescriptors:(NSArray *)sortDescriptors
                       error:(NSError **)error;

// 出错的返回值是NSNotFound，且error指向一个 NSError 实例。
- (NSUInteger)countOfEntityName:(NSString *)entityName
                          error:(NSError **)error;
// 出错的返回值是NSNotFound，且error指向一个 NSError 实例。
- (NSUInteger)countOfEntityName:(NSString *)entityName
                     predicate:(NSPredicate *)predicate
             sortDescriptors:(NSArray *)sortDescriptors
                       error:(NSError **)error;
// 根据 ID 和 类名 查数据库。此 ID 不是CoreData OBjectID，而至cardID，companyID等等。
// 无则返回nil；
- (id)objectByID:(NSNumber *)ID ofClass:(NSString *)className;

// 根据 ID 和 类名 查数据库。此 ID 不是CoreData OBjectID，而至cardID，companyID等等。
// createIfNone==YES，无则新建
// createIfNone==NO， 无则返回nil；
- (id)objectByID:(NSNumber *)ID ofClass:(NSString *)className createIfNone:(BOOL)createIfNone;

#pragma mark - Address utils
// 新建一个地址，失败返回nil；
- (Address *)addressWithCountry:(NSString *)country   // 国，
                       province:(NSString *)province  // 省，
                           city:(NSString *)city      // 市
                       district:(NSString *)district  // 区，现在可能未使用
                         street:(NSString *)street    // 街，现在可能为使用
                          other:(NSString *)other     // 剩下的全部写在这里，对应于address
                            zip:(NSString *)zip;      // 邮编

#pragma mark - Bank utils
// 新建一个银行帐户
- (BankAccount *)bankAccountWithBank:(NSString *)bank   // 银行
                              branch:(NSString *)branch // 开户行
                              number:(NSString *)number; // 帐户

#pragma mark - Card utils
// JSON data -> Card
- (void)FillCard:(Card *)card ofType:(KHHCardModelType)type withJSON:(NSDictionary *)dict;

// cardType -> entityName: 出错返回nil。
- (NSString *)entityNameWithCardType:(KHHCardModelType)cardType;
- (NSArray *)allCardsOfType:(KHHCardModelType)cardType;
// 如果多于一个返回最后一个。不存在或出错都是nil.
- (id)cardOfType:(KHHCardModelType)cardType byID:(NSNumber *)cardID;//本地
// 如果多于一个返回最后一个。
// createIfNone==NO：不存在或出错都是nil；createIfNone==YES：不存在会创建一个id==ID的新名片，出错为nil。
- (id)cardOfType:(KHHCardModelType)cardType byID:(NSNumber *)cardID createIfNone:(BOOL)createIfNone;//本地
- (void)createCardOfType:(KHHCardModelType)cardType withDictionary:(NSDictionary *)dict;//联网
- (void)modifyCardOfType:(KHHCardModelType)cardType withDictionary:(NSDictionary *)dict;//联网
- (void)deleteCardOfType:(KHHCardModelType)cardType byID:(NSNumber *)cardID;//联网

#pragma mark - Company utils
// 根据公司ID查数据库。
// 无则返回nil；
- (Company *)companyByID:(NSNumber *)companyID;

// 根据公司ID查数据库。
// createIfNone==YES，无则新建
// createIfNone==NO， 无则返回nil；
- (Company *)companyByID:(NSNumber *)companyID createIfNone:(BOOL)createIfNone;

#pragma mark - Image utils
// 根据图片ID查数据库，无则新建。
// 注意id==0或nil，亦新建；
- (Image *)imageByID:(NSNumber *)imageID;

#pragma mark - Template utils
// JSON data -> Template
- (void)FillCardTemplate:(CardTemplate *)cardTemplate withJSON:(NSDictionary *)dict;
@end


