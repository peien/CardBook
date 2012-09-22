//
//  KHHData+Utils.m
//  CardBook
//
//  Created by 孙铭 on 12-9-20.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHData+Utils.h"
#import "NSNumber+SM.h"
#import "NSString+SM.h"


@implementation KHHData (Utils)
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

#pragma mark - Address utils
// 新建一个地址
- (Address *)addressWithCountry:(NSString *)country   // 国，
                       province:(NSString *)province  // 省，
                           city:(NSString *)city      // 市
                       district:(NSString *)district  // 区，现在可能未使用
                         street:(NSString *)street    // 街，现在可能为使用
                          other:(NSString *)other     // 剩下的全部写在这里，对应于address
                            zip:(NSString *)zip       // 邮编
{
    Address *result = nil;
    result = [NSEntityDescription insertNewObjectForEntityForName:[Address entityName]
                                           inManagedObjectContext:self.managedObjectContext];
    if (nil == result) {
        return result;
    }
    
    // 插入数据
    if (country) {
        result.country = country;
    }
    if (province) {
        result.province = province;
    }
    if (city) {
        result.city = city;
    }
    if (district) {
        result.district = district;
    }
    if (street) {
        result.street = street;
    }
    if (other) {
        result.other = other;
    }
    if (zip) {
        result.zip = zip;
    }
    
    return result;
}
#pragma mark - Bank utils
// 新建一个银行帐户
- (BankAccount *)bankAccountWithBank:(NSString *)bank   // 银行
                              branch:(NSString *)branch // 开户行
                              number:(NSString *)number // 帐户
{
    BankAccount *result = nil;
    NSString *entityName = [BankAccount entityName];
    result = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                           inManagedObjectContext:self.managedObjectContext];
    if (nil == result) {
        return result;
    }
    if (bank) {
        result.bank = bank;
    }
    if (branch) {
        result.branch = branch;
    }
    if (number) {
        result.number = number;
    }
    return result;
}
#pragma mark - Card utils
// JSON data -> Card
- (void)FillCard:(Card *)card
          ofType:(KHHCardModelType)type
        withJSON:(NSDictionary *)json {
    if (card && json) {
//        [NSString stringFromObject:<#(id)#>]
//        [NSNumber numberFromObject:<#(id)#> defaultValue:<#(NSInteger)#> defaultIfUnresolvable:<#(BOOL)#>]
        card.id = [NSNumber numberFromObject:json[JSONDataKeyCardId]
                          zeroIfUnresolvable:0];
        card.userID = [NSNumber numberFromObject:json[JSONDataKeyUserId]
                              zeroIfUnresolvable:NO]; // 解不出为nil
        card.version = [NSNumber numberFromObject:json[JSONDataKeyVersion]
                                     defaultValue:1 defaultIfUnresolvable:YES];
        card.roleType = [NSNumber numberFromObject:json[JSONDataKeyCardTypeId]
                                      defaultValue:1 defaultIfUnresolvable:YES];
        card.cTimeUTC = [NSString stringFromObject:json[JSONDataKeyGmtCreateTime]];
        card.mTimeUTC = [NSString stringFromObject:json[JSONDataKeyGmtModTime]];
        
        // 工作相关
        card.title = [NSString stringFromObject:json[JSONDataKeyJobTitle]];
        card.businessScope = [NSString stringFromObject:json[JSONDataKeyBusinessScope]];
        
        // 联系方式
        card.fax   = [NSString stringFromObject:json[JSONDataKeyFax]];
        card.mobilePhone = [NSString stringFromObject:json[JSONDataKeyMobilePhone]];
        card.telephone = [NSString stringFromObject:json[JSONDataKeyTelephone]];
        card.aliWangWang = [NSString stringFromObject:json[JSONDataKeyWangWang]];
        card.email = [NSString stringFromObject:json[JSONDataKeyEmail]];
        card.microblog = [NSString stringFromObject:json[JSONDataKeyMicroBlog]];
        card.msn = [NSString stringFromObject:JSONDataKeyMSN];
        card.qq = [NSString stringFromObject:JSONDataKeyQQ];
        card.web = [NSString stringFromObject:json[JSONDataKeyWeb]];
        
        // 杂项
        card.moreInfo = [NSString stringFromObject:json[JSONDataKeyMoreInfo]];
#warning TODO
        /*
        col1 = "";              ?
        col2 = "";              ?
        col3 = "";              ?
        col4 = "";              ?
        col5 = "";              ?
         */
        
        // 模板
        // 根据ID查，不存在则新建
//        card.template = [self templateByID:templateID createIfNone:YES];

#warning TODO
        // logo
        NSString *logoURL = [NSString stringFromObject:json[JSONDataKeyLogoImage]];
        if (nil == card.logo) { // card.logo不存在则新建
            card.logo = [self imageByID:nil];
        }
        card.logo.url = logoURL;
        
        // 公司
        NSNumber *companyID = [NSNumber numberFromObject:json[JSONDataKeyCompanyId]
                                             defaultValue:0 defaultIfUnresolvable:YES];
        NSString *companyName = [NSString stringFromObject:json[JSONDataKeyCompanyName]];
        card.company = [self companyByID:companyID createIfNone:YES];
        card.company.name = companyName;
        
        // 地址
        NSString *addressCountry = [NSString stringFromObject:json[JSONDataKeyCountry]];
        NSString *addressProvince = [NSString stringFromObject:json[JSONDataKeyProvince]];
        NSString *addressCity = [NSString stringFromObject:json[JSONDataKeyCity]];
        NSString *addressOther = [NSString stringFromObject:json[JSONDataKeyAddress]];
        NSString *addressZip = [NSString stringFromObject:json[JSONDataKeyZipcode]];
        if (card.address) {
            card.address.country = addressCountry;
            card.address.province = addressProvince;
            card.address.city = addressCity;
            card.address.other = addressOther;
            card.address.zip = addressZip;
        } else {
            card.address = [self addressWithCountry:addressCountry
                                           province:addressProvince
                                               city:addressCity
                                           district:[NSString stringFromObject:nil]
                                             street:[NSString stringFromObject:nil]
                                              other:addressOther
                                                zip:addressZip];
        }
        
        // 银行帐户
        NSString *bankBranch = [NSString stringFromObject:json[JSONDataKeyOpenBank]];
        NSString *bankNumber = [NSString stringFromObject:json[JSONDataKeyBankNO]];
        if (card.bankAccount) {
            card.bankAccount.branch = bankBranch;
            card.bankAccount.number = bankNumber;
        } else {
            card.bankAccount = [self bankAccountWithBank:nil
                                                  branch:bankBranch
                                                  number:bankNumber];
        }
        // 第2～n祯
#warning TODO
    }
}
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

#pragma mark - Company utils
// 根据公司ID查数据库。
// 无则返回nil；
- (Company *)companyByID:(NSNumber *)companyID {
    return [self companyByID:companyID createIfNone:NO];
}

// 根据公司ID查数据库，并填上name；name为nil不修改；
// createIfNone==YES，无则新建
// createIfNone==NO， 无则返回nil；
- (Company *)companyByID:(NSNumber *)companyID
            createIfNone:(BOOL)createIfNone {
    return [self objectByID:companyID
                    ofClass:[Company entityName]
               createIfNone:createIfNone];
}

#pragma mark - Image utils
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
#pragma mark - Template utils
// JSON data -> Template
- (void)FillCardTemplate:(CardTemplate *)cardTemplate
                withJSON:(NSDictionary *)dict {
#warning TODO
}
// JSON data -> TemplateItem
- (void)FillCardTemplateItem:(CardTemplateItem *)CardTemplateItem
                    withJSON:(NSDictionary *)dict {
#warning TODO
}
@end
