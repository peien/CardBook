//
//  KHHData+Processors.m
//  CardBook
//
//  Created by Sun Ming on 12-9-22.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHDataAPI.h"
#import "NSNumber+SM.h"
#import "NSString+SM.h"

@implementation KHHData (Processors)

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
    for (InterCard *iCard in list) {
        if (iCard) {
            id card = [self processCard:iCard cardType:type];
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
- (Card *)processCard:(InterCard *)interCard cardType:(KHHCardModelType)type {
    Card *result = nil;
    if (interCard) {
        if (nil == interCard.id) {
            // ID无法解析就不操作
            return result;
        }
        BOOL isDeleted = [interCard.isDeleted boolValue];
        // 按ID从数据库里查询
        if (isDeleted) {
            // 无不新建
            result = [self cardOfType:type byID:interCard.id createIfNone:NO];
            // 有则删除
            if (result) {
                [self.context deleteObject:result];
                result = nil;
            }
        } else {
            // 无则新建。
            result = [self cardOfType:type byID:interCard.id createIfNone:YES];
            // 填充数据
            [self fillCard:result ofType:type withInterCard:interCard];
        }
    }
//    DLog(@"[II] card = %@", result);
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
@end
@implementation KHHData (Processors_FillContent)
- (Card *)fillCard:(Card *)card ofType:(KHHCardModelType)type withInterCard:(InterCard *)interCard {
    if (card && interCard) {
        card.name = interCard.name;
        card.userID = interCard.userID;
        card.version = interCard.version;
        card.roleType = interCard.roleType;
        // 工作相关
        card.title = interCard.title;
        card.businessScope = interCard.businessScope;
        
        // 联系方式
        card.fax   = interCard.fax;
        card.mobilePhone = interCard.mobilePhone;
        card.telephone = interCard.telephone;
        card.aliWangWang = interCard.aliWangWang;
        card.email = interCard.email;
        card.microblog = interCard.microblog;
        card.msn = interCard.msn;
        card.qq = interCard.qq;
        card.web = interCard.web;
        
        // 杂项
        card.moreInfo = interCard.moreInfo;
        
        // 模板 {
        // 根据ID查，不存在则新建
        NSNumber *templateID = interCard.templateID;
        card.template = (CardTemplate *)[self objectByID:templateID
                                                 ofClass:[CardTemplate entityName]
                                            createIfNone:YES];
        // }
        
        // 公司 {
        NSNumber *companyID = interCard.companyID;
        NSString *companyName = interCard.companyName;
        if (companyID.integerValue) { // 有公司ID则查询
            card.company = (Company *)[self objectByID:companyID
                                               ofClass:[Company entityName]
                                          createIfNone:YES];
        } else { // 如果无公司ID或ID为0，则company为nil时新建
            if (nil == card.company) {
                card.company = (Company *)[self objectOfClass:[Company entityName]];
                card.company.idValue = 0;
            }
        }
        card.company.name = companyName;
        // }
        
        // logo {
        NSString *logoURL = interCard.logoURL;
        if (nil == card.logo) { // card.logo不存在则新建
            card.logo = [self imageByID:nil];
        }
        card.logo.url = logoURL;
        // }
        
        // 地址 {
        if (nil == card.address) { // 无则新建
            card.address = (Address *)[self objectOfClass:[Address entityName]];
        }
        card.address.city = interCard.addressCity;
        card.address.country = interCard.addressCountry;
        card.address.district = interCard.addressDistrict;
        card.address.other = interCard.addressOther;
        card.address.province = interCard.addressProvince;
        card.address.street = interCard.addressStreet;
        card.address.zip = interCard.addressZip;
        // }
        
        // 银行帐户 {
        if (nil == card.bankAccount) {
            card.bankAccount = (BankAccount *)[self objectOfClass:[BankAccount entityName]];
        }
        card.bankAccount.bank = interCard.bankAccountBank;
        card.bankAccount.branch = interCard.bankAccountBranch;
        card.bankAccount.name = interCard.bankAccountName;
        card.bankAccount.number = interCard.bankAccountNumber;
        // }
        
        // 其他名片类型的数据 {
        if (KHHCardModelTypeReceivedCard == type) {
            [(ReceivedCard *)card setValue:interCard.isRead forKey:kAttributeKeyIsRead];
            [(ReceivedCard *)card setValue:interCard.memo forKey:kAttributeKeyMemo];
        }
        // }
        
#warning TODO
        // 第2～n祯
    }
    return card;
}
// JSON data -> Template
- (CardTemplate *)fillCardTemplate:(CardTemplate *)tmpl withJSON:(NSDictionary *)json {
//    DLog(@"[II] json = %@", json);
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
    }
//    DLog(@"[II] tmpl = %@", tmpl);
    return tmpl;
}

// JSON data -> TemplateItem
- (CardTemplateItem *)fillCardTemplateItem:(CardTemplateItem *)item withJSON:(NSDictionary *)json {
//    DLog(@"[II] json = %@",  json);
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
//    DLog(@"[II] item = %@", item);
    return item;
}
@end

