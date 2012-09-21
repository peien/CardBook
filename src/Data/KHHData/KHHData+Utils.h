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

#pragma mark - Card utils
/*!
 Card: 通用接口，不要直接调这些接口！！！
 */
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

// 新建一个地址，失败返回nil；
- (Address *)addressWithCountry:(NSString *)country   // 国，
                       province:(NSString *)province  // 省，
                           city:(NSString *)city      // 市
                       district:(NSString *)district  // 区，现在可能未使用
                         street:(NSString *)street    // 街，现在可能为使用
                          other:(NSString *)other     // 剩下的全部写在这里，对应于address
                            zip:(NSString *)zip;      // 邮编

// 根据公司ID查数据库。
// 无则返回nil；
- (Company *)companyByID:(NSNumber *)companyID;

// 根据公司ID查数据库，并填上name；
// createIfNone==YES，无则新建
// createIfNone==NO， 无则返回nil；
- (Company *)companyByID:(NSNumber *)companyID createIfNone:(BOOL)createIfNone;

// 根据图片ID查数据库，无则新建。
// 注意id==0或nil，亦新建；
- (Image *)imageByID:(NSNumber *)imageID;

// 新建一个银行帐户
- (BankAccount *)bankAccountWithBank:(NSString *)bank   // 银行
                              branch:(NSString *)branch // 开户行
                              number:(NSString *)number; // 帐户
@end


