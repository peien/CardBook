//
//  KHHData+Processors.m
//  CardBook
//
//  Created by Sun Ming on 12-9-22.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHData+Processors.h"
#import "NSNumber+SM.h"
#import "NSString+SM.h"

@implementation KHHData (Processors)

- (NSArray *)processList:(NSArray *)list
                 ofClass:(NSString *)className {
    NSMutableArray *result = [NSMutableArray array];
    if (list.count && className.length) {
        for (NSDictionary *objDict in list) {
            if (objDict) {
                SEL selector = NSSelectorFromString([NSString stringWithFormat:@"process%@:", className]);
                if ([self respondsToSelector:selector]) {
                    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
                    [inv setTarget:self];
                    [inv setSelector:selector];
                    NSDictionary *arg = objDict;
                    [inv setArgument:&arg atIndex:2];
                    [inv invoke];
                    id invResult = nil;
                    [inv getReturnValue:&invResult];
                    if (invResult) {
                        [result addObject:invResult];
                    }
                }
            }
        }
    }
    return result;
}
// ID 不存在就不操作
- (id)processObject:(NSDictionary *)dict
            ofClass:(NSString *)name
             withID:(NSNumber *)ID {
    id result = nil;
    if (dict) {
        id obj = nil;
        
        // ID 不存在就不操作
        if (nil == ID) {
            return result;
        }
        
        BOOL isDeleted = [dict[JSONDataKeyIsDelete] boolValue];
        // 按ID从数据库里查询
        if (isDeleted) {
            // 无不新建
            obj = [self objectByID:ID ofClass:name createIfNone:NO];
            // 有则删除
            if (obj) {
                [self.managedObjectContext deleteObject:obj];
            }
        } else {
            // 无则新建。
            obj = [self objectByID:ID ofClass:name createIfNone:YES];
            // 填充数据
            SEL selector = NSSelectorFromString([NSString stringWithFormat:@"fill%@:withJSON:", name]);
            if ([self respondsToSelector:selector]) {
                NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
                [inv setTarget:self];
                [inv setSelector:selector];
                [inv setArgument:&obj atIndex:2];
                [inv setArgument:&dict atIndex:3];
                [inv invoke];
                id invResult = nil;
                [inv getReturnValue:&invResult];
                if (invResult) {
                    result = invResult;
                }
            }
            DLog(@"[II] obj = %@", obj);
        }
        // 保存
        [self saveContext];
    }
    return result;
}

@end

@implementation KHHData (Processors_Address)

- (Address *)fillAddress:(Address *)address withJSON:(NSDictionary *)json {
    NSString *country = [NSString stringFromObject:json[JSONDataKeyCountry]];
    NSString *province = [NSString stringFromObject:json[JSONDataKeyProvince]];
    NSString *city = [NSString stringFromObject:json[JSONDataKeyCity]];
    NSString *district = nil;
    NSString *street = nil;
    NSString *other = [NSString stringFromObject:json[JSONDataKeyAddress]];
    NSString *zip = [NSString stringFromObject:json[JSONDataKeyZipcode]];
    if (country) { // 国
        address.country = country;
    }
    if (province) { // 省
        address.province = province;
    }
    if (city) { // 市
        address.city = city;
    }
    if (district) { // 区，现在可能未使用
        address.district = district;
    }
    if (street) { // 街，现在可能为使用
        address.street = street;
    }
    if (other) { // 剩下的全部写在这里，对应于address
        address.other = other;
    }
    if (zip) { // 邮编
        address.zip = zip;
    }
    return address;
}
@end
@implementation KHHData (Processors_BankAccount)
- (BankAccount *)fillBankAccount:(BankAccount *)bankAccount withJSON:(NSDictionary *)json {
    NSString *branch = [NSString stringFromObject:json[JSONDataKeyOpenBank]];
    NSString *number = [NSString stringFromObject:json[JSONDataKeyBankNO]];
#warning TO REVIEW
    NSString *bank = nil;
    NSString *name = nil;//[NSString stringFromObject:json[JSONDataKeyBankAccountName]];
    if (bank) { // 银行
        bankAccount.bank = bank;
    }
    if (branch) { // 开户行
        bankAccount.branch = branch;
    }
    if (name) { // 户名
        bankAccount.name = name;
    }
    if (number) { // 帐户
        bankAccount.number = number;
    }
    return bankAccount;
}

@end
@implementation KHHData (Processors_Card)
// card {
- (NSArray *)processMyCardList:(NSArray *)list {
    return [self processCardList:list cardType:KHHCardModelTypeMyCard];
}
- (NSArray *)processPrivateCardList:(NSArray *)list {
    return [self processCardList:list cardType:KHHCardModelTypePrivateCard];
}
- (NSArray *)processReceivedCardList:(NSArray *)list {
    return [self processCardList:list cardType:KHHCardModelTypeReceivedCard];
}
- (NSArray *)processCardList:(NSArray *)list cardType:(KHHCardModelType)type {
    NSMutableArray *result = [NSMutableArray array];
    if (0 == [list count]) {
        return result;
    }
    for (NSDictionary *dict in list) {
        if (dict) {
            id card = [self processCard:dict cardType:type];
            if (card) {
                [result addObject:card];
            }
        }
    }
    return result;
}
- (id)processCard:(NSDictionary *)dict cardType:(KHHCardModelType)type {
    DLog(@"[II] a Card dict class= %@, data = %@", [dict class], dict);
    id result = nil;
    if (dict) {
        NSNumber *ID = [NSNumber numberFromObject:dict[JSONDataKeyCardId]
                               zeroIfUnresolvable:NO];
        if (nil == ID) {
            // ID无法解析就不操作
            return result;
        }
        BOOL isDeleted = [dict[JSONDataKeyIsDelete] boolValue];
        // 按ID从数据库里查询
        if (isDeleted) {
            // 无不新建
            result = [self cardOfType:type byID:ID createIfNone:NO];
            // 有则删除
            if (result) {
                [self.managedObjectContext deleteObject:result];
            }
        } else {
            // 无则新建。
            result = [self cardOfType:type byID:ID createIfNone:YES];
            // 填充数据
            [self fillCard:result ofType:type withJSON:dict];
            DLog(@"[II] card = %@", result);
        }
        // 保存
        [self saveContext];
    }
    return result;
}

// JSON data -> Card
- (Card *)fillCard:(Card *)card
            ofType:(KHHCardModelType)type
          withJSON:(NSDictionary *)json {
    if (card && json) {
        
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
        
        // 模板 {
        // 根据ID查，不存在则新建
        NSNumber *templateID = [NSNumber numberFromObject:json[JSONDataKeyTemplateId]
                                             defaultValue:KHHDefaultTemplateID
                                    defaultIfUnresolvable:YES];
        card.template = [self objectByID:templateID ofClass:[CardTemplate entityName] createIfNone:YES];
        // }
        
        // 公司 {
#warning 需确认是否有无ID的情况
        NSNumber *companyID = [NSNumber numberFromObject:json[JSONDataKeyCompanyId]
                                            defaultValue:0 defaultIfUnresolvable:YES];
        NSString *companyName = [NSString stringFromObject:json[JSONDataKeyCompanyName]];
        if (companyID.integerValue) { // 有公司ID则查询
            card.company = [self objectByID:companyID ofClass:[Company entityName] createIfNone:YES];
        } else { // 如果无公司ID或ID为0，则company为nil时新建
            if (nil == card.company) {
                card.company = [self objectOfClass:[Company entityName]];
            }
        }
        card.company.name = companyName;
        // }
        
        // logo {
        NSString *logoURL = [NSString stringFromObject:json[JSONDataKeyLogoImage]];
        if (nil == card.logo) { // card.logo不存在则新建
            card.logo = [self imageByID:nil];
        }
        card.logo.url = logoURL;
        // }
        
        // 地址 {
        if (nil == card.address) { // 无则新建
            card.address = [self objectOfClass:[Address entityName]];
        }
        [self fillAddress:card.address withJSON:json];
        // }
        
        // 银行帐户 {
        if (nil == card.bankAccount) {
            card.bankAccount = [self objectOfClass:[BankAccount entityName]];
        }
        [self fillBankAccount:card.bankAccount withJSON:json];
        // }
#warning TODO
        // 第2～n祯
        /*
         col1 = "";              ?
         col2 = "";              ?
         col3 = "";              ?
         col4 = "";              ?
         col5 = "";              ?
         */
    }
    return card;
}

// }
@end
@implementation KHHData (Processors_Company)
// company {
- (NSArray *)processCompanyList:(NSArray *)list {
    return [self processList:list ofClass:@"Company"];
}
- (Company *)processCompany:(NSDictionary *)dict {
    DLog(@"[II] a Company dict class= %@, data = %@", [dict class], dict);
    DLog(@"[II] a Company keys = %@", [dict allKeys]);
#warning company ID?
    NSString *className = [Company entityName];
    NSNumber *ID = [NSNumber numberFromObject:dict[JSONDataKeyID]
                           zeroIfUnresolvable:NO];
    return [self processObject:dict ofClass:className withID:ID];
}
// }
@end

@implementation KHHData (Processors_Template)
// template {
- (NSArray *)processCardTemplateList:(NSArray *)list {
    return [self processList:list ofClass:@"CardTemplate"];
}
- (CardTemplate *)processCardTemplate:(NSDictionary *)dict {
    DLog(@"[II] a template dict class= %@, data = %@", [dict class], dict);
    DLog(@"[II] a template keys = %@", [dict allKeys]);
    
    NSString *className = [CardTemplate entityName];
    NSNumber *ID = [NSNumber numberFromObject:dict[JSONDataKeyID]
                           zeroIfUnresolvable:NO];
    return [self processObject:dict ofClass:className withID:ID];
}
// JSON data -> Template
- (CardTemplate *)fillCardTemplate:(CardTemplate *)cardTemplate
                          withJSON:(NSDictionary *)json {
#warning TODO
    
    // 处理item列表
    NSArray *items = [self processCardTemplateItemList:json[JSONDataKeyDetails]];
    // 保存item列表
    cardTemplate.items = [NSSet setWithArray:items];
    return cardTemplate;
}
- (NSArray *)processCardTemplateItemList:(NSArray *)list {
    return [self processList:list ofClass:@"CardTemplateItem"];
}
- (CardTemplateItem *)processCardTemplateItem:(NSDictionary *)dict {
    DLog(@"[II] a templateItem dict class= %@, data = %@", [dict class], dict);
    DLog(@"[II] a templateItem keys = %@", [dict allKeys]);
    NSString *className = [CardTemplateItem entityName];
    NSNumber *ID = [NSNumber numberFromObject:dict[JSONDataKeyID]
                           zeroIfUnresolvable:NO];
    return [self processObject:dict ofClass:className withID:ID];
}
// }

// JSON data -> TemplateItem
- (CardTemplateItem *)fillCardTemplateItem:(CardTemplateItem *)item
                                  withJSON:(NSDictionary *)json {
#warning TODO
    return item;
}
@end

@implementation KHHData (Processors_Zoo)
//
- (void)processSyncTime:(NSString *)syncTime {
    DLog(@"[II] syncTime = %@", syncTime);
#warning TODO
}
@end