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

//- (NSMutableArray *)processList:(NSArray *)list
//                 ofClass:(NSString *)className {
//    NSMutableArray *result = [NSMutableArray array];
//    if (0 == list.count || 0 == className.length) {
//        return result;
//    }
//    id obj;
//    for (obj in list) {
//        if (nil == obj) {
//            continue;
//        }
//        
//        NSString *selName = [NSString stringWithFormat:@"process%@:", className];
//        DLog(@"[II] 尝试 seletcor = %@", selName);
//        SEL selector = NSSelectorFromString(selName);
//        if (![self respondsToSelector:selector]) {
//            DLog(@"[EE] KHHData 缺少 seletcor = %@", selName);
//            break;
//        }
//        NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
//        [inv setTarget:self];
//        [inv setSelector:selector];
//        [inv setArgument:&obj atIndex:2];
//        [inv retainArguments];
//        [inv invoke];
//        id invResult = nil;
//        [inv getReturnValue:&invResult];
//        if ([invResult isKindOfClass:NSClassFromString(className)]) {
//            [result addObject:invResult];
//        }
//    }
//
//    return result;
//}

// 解析一个对象
// 以下情况会返回nil
// 1.objDict为空或nil
// 2.className为空或nil
// 3.ID为空或nil，或者查不到对象
- (NSManagedObject *)processObject:(NSDictionary *)dict
                           ofClass:(NSString *)className
                            withID:(NSNumber *)ID {
    NSManagedObject *result = nil;
    if (dict) {
        // ID 不存在就不操作
        if (nil == ID) {
            return result;
        }
        
        BOOL isDeleted = [[NSNumber numberFromObject:dict[JSONDataKeyIsDelete] zeroIfUnresolvable:YES] boolValue];
        // 按ID从数据库里查询
        if (isDeleted) { // 若标记为已删除
            // 无不新建
            result = [self objectByID:ID ofClass:className createIfNone:NO];
            // 有则删除
            if (result) {
                [self.context deleteObject:result];
                result = nil;
            }
            return result;
        }
        
        // 无则新建。
        result = [self objectByID:ID ofClass:className createIfNone:YES];
        if (nil == result) {
            return result;
        }
        // 填充数据
        NSString *selName = [NSString stringWithFormat:@"fill%@:withJSON:", className];
        DLog(@"[II] 调用 seletcor = %@", selName);
        SEL selector = NSSelectorFromString(selName);
        if (![self respondsToSelector:selector]) {
            DLog(@"[EE] KHHData 缺少 seletcor = %@", selName);
        }
        
        NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
        [inv setTarget:self];
        [inv setSelector:selector];
        [inv setArgument:&result atIndex:2];
        [inv setArgument:&dict atIndex:3];
        [inv retainArguments];
        [inv invoke];
        // 保存
        // [self saveContext];
    }
//    DLog(@"[II] 填充完数据后 obj = %@", result);
    return result;
}
@end
@implementation KHHData (Processors_List)
// card {
- (NSMutableArray *)processCardList:(NSArray *)list cardType:(KHHCardModelType)type {
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
- (NSMutableArray *)processMyCardList:(NSArray *)list {
    return [self processCardList:list cardType:KHHCardModelTypeMyCard];
}
- (NSMutableArray *)processPrivateCardList:(NSArray *)list {
    return [self processCardList:list cardType:KHHCardModelTypePrivateCard];
}
- (NSMutableArray *)processReceivedCardList:(NSArray *)list {
    return [self processCardList:list cardType:KHHCardModelTypeReceivedCard];
}
// }
- (NSMutableArray *)processCardTemplateList:(NSArray *)list {
    NSMutableArray *result = [NSMutableArray array];
    if (0 == list.count) {
        return result;
    }
    for (id obj in list) {
        if (nil == obj) {
            continue;
        }
        
        CardTemplate *tmpl = [self processCardTemplate:obj];
        if (tmpl) {
            [result addObject:tmpl];
        }
    }
    return result;
}
- (NSMutableArray *)processCardTemplateItemList:(NSArray *)list {
    NSMutableArray *result = [NSMutableArray array];
    if (0 == list.count) {
        return result;
    }
    for (id obj in list) {
        if (nil == obj) {
            continue;
        }
        CardTemplateItem *item = [self processCardTemplateItem:obj];
        if (item) {
            [result addObject:item];
        }
    }
    return result;
}

@end
@implementation KHHData (Processors_Object)
- (Card *)processCard:(NSDictionary *)dict cardType:(KHHCardModelType)type {
    DLog(@"[II] a Card dict class= %@, data = %@", [dict class], dict);
    Card *result = nil;
    if (dict) {
        NSNumber *ID = [NSNumber numberFromObject:dict[JSONDataKeyCardId]
                               zeroIfUnresolvable:NO];
        if (nil == ID) {
            // ID无法解析就不操作
            return result;
        }
        BOOL isDeleted = [[NSNumber numberFromObject:dict[JSONDataKeyIsDelete] zeroIfUnresolvable:YES] boolValue];
        // 按ID从数据库里查询
        if (isDeleted) {
            // 无不新建
            result = [self cardOfType:type byID:ID createIfNone:NO];
            // 有则删除
            if (result) {
                [self.context deleteObject:result];
                result = nil;
            }
        } else {
            // 无则新建。
            result = [self cardOfType:type byID:ID createIfNone:YES];
            // 填充数据
            [self fillCard:result ofType:type withJSON:dict];
        }
    }
    DLog(@"[II] card = %@", result);
    return result;
}
- (CardTemplate *)processCardTemplate:(NSDictionary *)dict {
    NSString *className = [CardTemplate entityName];
    NSNumber *ID = [NSNumber numberFromObject:dict[JSONDataKeyID]
                           zeroIfUnresolvable:NO];
    return (CardTemplate *)[self processObject:dict ofClass:className withID:ID];
}
- (CardTemplateItem *)processCardTemplateItem:(NSDictionary *)dict {
    NSString *className = [CardTemplateItem entityName];
    NSNumber *ID = [NSNumber numberFromObject:dict[JSONDataKeyID]
                           zeroIfUnresolvable:NO];
    return (CardTemplateItem *)[self processObject:dict ofClass:className withID:ID];
}
- (Company *)processCompany:(NSDictionary *)dict {
    DLog(@"[II] a Company dict class= %@, data = %@", [dict class], dict);
    DLog(@"[II] a Company keys = %@", [dict allKeys]);
#warning company ID?
    NSString *className = [Company entityName];
    NSNumber *ID = [NSNumber numberFromObject:dict[JSONDataKeyID]
                           zeroIfUnresolvable:NO];
    return (Company *)[self processObject:dict ofClass:className withID:ID];
}
//
- (void)processSyncTime:(NSString *)syncTime {
    DLog(@"[II] syncTime = %@", syncTime);
#warning TODO
}
@end
@implementation KHHData (Processors_FillContent)
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

- (BankAccount *)fillBankAccount:(BankAccount *)bankAccount withJSON:(NSDictionary *)json {
    NSString *branch = [NSString stringFromObject:json[JSONDataKeyOpenBank]];
    NSString *number = [NSString stringFromObject:json[JSONDataKeyBankNO]];
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
// JSON data -> Card
- (Card *)fillCard:(Card *)card ofType:(KHHCardModelType)type withJSON:(NSDictionary *)json {
    if (card && json) {
        // id 已经有了，填剩下的数据。
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
        card.msn = [NSString stringFromObject:json[JSONDataKeyMSN]];
        card.qq = [NSString stringFromObject:json[JSONDataKeyQQ]];
        card.web = [NSString stringFromObject:json[JSONDataKeyWeb]];
        
        // 杂项
        card.moreInfo = [NSString stringFromObject:json[JSONDataKeyMoreInfo]];
        
        // 模板 {
        // 根据ID查，不存在则新建
        NSNumber *templateID = [NSNumber numberFromObject:json[JSONDataKeyTemplateId]
                                             defaultValue:KHHDefaultTemplateID
                                    defaultIfUnresolvable:YES];
        card.template = (CardTemplate *)[self objectByID:templateID ofClass:[CardTemplate entityName] createIfNone:YES];
        // }
        
        // 公司 {
#warning 需确认是否有无ID的情况
        NSNumber *companyID = [NSNumber numberFromObject:json[JSONDataKeyCompanyId]
                                            defaultValue:0 defaultIfUnresolvable:YES];
        NSString *companyName = [NSString stringFromObject:json[JSONDataKeyCompanyName]];
        if (companyID.integerValue) { // 有公司ID则查询
            card.company = (Company *)[self objectByID:companyID ofClass:[Company entityName] createIfNone:YES];
        } else { // 如果无公司ID或ID为0，则company为nil时新建
            if (nil == card.company) {
                card.company = (Company *)[self objectOfClass:[Company entityName]];
                card.company.idValue = 0;
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
            card.address = (Address *)[self objectOfClass:[Address entityName]];
        }
        [self fillAddress:card.address withJSON:json];
        // }
        
        // 银行帐户 {
        if (nil == card.bankAccount) {
            card.bankAccount = (BankAccount *)[self objectOfClass:[BankAccount entityName]];
        }
        [self fillBankAccount:card.bankAccount withJSON:json];
        // }
#warning TODO
        // 第2～n祯
        /*
         col1 = "";              ?
         col2 = "";              ?
         col3 = "";              Received isRead
         col4 = "";              ?
         col5 = "";              ?
         */
    }
    return card;
}

// JSON data -> Template
- (CardTemplate *)fillCardTemplate:(CardTemplate *)tmpl withJSON:(NSDictionary *)json {
    DLog(@"[II] json = %@", json);
    if (tmpl && json) {
        // id应该已经有了，填剩下的数据。
        // version,       y version
        tmpl.version = [NSNumber numberFromObject:json[JSONDataKeyVersion] defaultValue:1 defaultIfUnresolvable:YES];
        // userId,        y ownerID
        tmpl.ownerID = [NSNumber numberFromObject:json[JSONDataKeyUserId] zeroIfUnresolvable:YES];
        // templateType,  y domainType
        NSString *dtString = [[NSString stringFromObject:json[JSONDataKeyTemplateType]] lowercaseString];
        if ([dtString isEqualToString:@"public"]) {
            tmpl.domainType = [NSNumber numberWithInteger:KHHTemplateDomainTypePublic];
        } else {
            tmpl.domainType = [NSNumber numberWithInteger:KHHTemplateDomainTypePrivate];
        }
        // description,   y descriptionInfo
        tmpl.descriptionInfo = [NSString stringFromObject:json[JSONDataKeyDescription]];
        // templateStyle, y style
        tmpl.style = [NSString stringFromObject:json[JSONDataKeyTemplateStyle]];
        // gmtCreateTime, y ctimeUTC
        tmpl.cTimeUTC = [NSString stringFromObject:json[JSONDataKeyGmtCreateTime]];
        // gmtModTime,    y mtimeUTC
        tmpl.mTimeUTC = [NSString stringFromObject:json[JSONDataKeyGmtModTime]];
        
        // item列表 {
        NSArray *items = [self processCardTemplateItemList:json[JSONDataKeyDetails]];
        if (items.count) {
            tmpl.items = [NSSet setWithArray:items];
        }
        // }
        
        // imageUrl,      y bgImage->url {
        NSString *imageUrl = [NSString stringFromObject:json[JSONDataKeyImageUrl]];
        if (nil == tmpl.bgImage) { // 不存在则新建
            tmpl.bgImage = [self imageByID:nil];
        }
        tmpl.bgImage.url = imageUrl;
        // }
#warning TODO
        /*
         col1,
         col2,
         col3,
         col4,
         col5,
         */
    }
    DLog(@"[II] tmpl = %@", tmpl);
    return tmpl;
}

// JSON data -> TemplateItem
- (CardTemplateItem *)fillCardTemplateItem:(CardTemplateItem *)item withJSON:(NSDictionary *)json {
    DLog(@"[II] json = %@",  json);
    if (item && json) {
        //templateId, x
        //id,
        item.id = [NSNumber numberFromObject:json[JSONDataKeyID] zeroIfUnresolvable:NO];
        //item, - name
        item.name = [NSString stringFromObject:json[JSONDataKeyItem]];
        //style
        item.style = [NSString stringFromObject:json[JSONDataKeyStyle]];
        
        // style to attributes "top: 32 px; left: 25 px; font-size: 22 px; color: #0; fontWeight: normal"
        NSDictionary *styleAttrDict = @{
        @"left":@"originX", @"top":@"originY", @"width":@"rectWidth", @"height":@"rectHeight",
        @"color":@"fontColor", @"font-size":@"fontSize", @"fontWeight":@"fontWeight",
        };
        NSArray *styleAttrList = [item.style componentsSeparatedByString:@";"];
        for (NSString *styleAttr in styleAttrList) {
            NSArray *keyValuePair = [styleAttr componentsSeparatedByString:@":"];
            if (keyValuePair.count != 2) {
                continue;
            }
            NSString *theKey = [(NSString *)keyValuePair[0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *theValue = [(NSString *)keyValuePair[1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *attrKey = styleAttrDict[theKey];
            if (0 == attrKey.length) {
                continue;
            }
            if ([theKey isEqualToString:@"color"] || [theKey isEqualToString:@"fontWeight"]) { // 这两个属性直接保存为string
                [item setValue:theValue forKey:attrKey];
            } else { // 其他属性是number
                [item setValue:[NSNumber numberFromString:theValue] forKey:attrKey];
            }
        }
    }
    DLog(@"[II] item = %@", item);
    return item;
}
@end

