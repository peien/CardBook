#import "KHHClasses.h"

@implementation Card
// 根据ID和type查询。
// 无则新建
// 如果不是MyCard，PrivateCard，ReceivedCard则返回nil。
+ (id)cardByID:(NSNumber *)ID modelType:(KHHCardModelType)type {
    id card = nil;
    switch (type) {
        case KHHCardModelTypeMyCard:
            card = [MyCard objectByID:ID createIfNone:YES];
            break;
        case KHHCardModelTypePrivateCard:
            card = [PrivateCard objectByID:ID createIfNone:YES];
            break;
        case KHHCardModelTypeReceivedCard:
            card = [ReceivedCard objectByID:ID createIfNone:YES];
            break;
        case KHHCardModelTypeCard:
            break;
    }
    return card;
}
@end

@implementation Card (Type_And_Name)
- (NSString *)nameForServer {
    if ([self isKindOfClass:[MyCard class]])       return @"private";
    if ([self isKindOfClass:[PrivateCard class]])  return @"me";
    if ([self isKindOfClass:[ReceivedCard class]]) return @"linkman";
    return nil;
}
+ (NSString *)ServerNameForCardModelType:(KHHCardModelType)type {
    NSString *result = nil;
    switch (type) {
        case KHHCardModelTypeMyCard:
            result = @"private";
            break;
        case KHHCardModelTypePrivateCard:
            result = @"me";
            break;
        case KHHCardModelTypeReceivedCard:
            result = @"linkman";
            break;
        case KHHCardModelTypeCard:
            break;
    }
    return result;
}
+ (KHHCardModelType)CardModelTypeForServerName:(NSString *)name {
    if ([name isEqualToString:@"linkman"]) return KHHCardModelTypeReceivedCard;
    if ([name isEqualToString:@"me"])      return KHHCardModelTypePrivateCard;
    if ([name isEqualToString:@"private"]) return KHHCardModelTypeMyCard;
    return KHHCardModelTypeCard;
}

// cardType -> entityName: 出错返回nil。
+ (NSString *)EntityNameForCardModelType:(KHHCardModelType)type {
    NSString *name = nil;
    switch (type) {
        case KHHCardModelTypeMyCard:
            name = @"MyCard";
            break;
        case KHHCardModelTypePrivateCard:
            name = @"PrivateCard";
            break;
        case KHHCardModelTypeReceivedCard:
            name = @"ReceivedCard";
            break;
        case KHHCardModelTypeCard:
            break;
    }
    return name;
}
@end

@implementation Card (KHHTransformation)
+ (id)processIObject:(InterCard *)iCard {
    Card *card = nil;
    if (iCard.id) {
        // 按ID从数据库里查询，无则新建。
        Card *newCard = [Card objectByID:iCard.id createIfNone:YES];
        // 若已标记为删除则删除
        if (iCard.isDeleted.integerValue) {
            [[self currentContext] deleteObject:newCard];
        } else {
            card = newCard;
        }
        // 更新数据
        [card updateWithIObject:iCard];
    }
    DLog(@"[II] card = %@", card);
    return card;
}
- (id)updateWithIObject:(InterCard *)iCard {
    if (iCard) {
        self.name = iCard.name;
        if (iCard.name.length) {
            self.isFull = @(YES);
        }
        self.modelType = @(KHHCardModelTypeCard);
        
        self.userID    = iCard.userID;
        self.version   = iCard.version;
        self.roleType  = iCard.roleType;
        
        // 工作相关
        self.title         = iCard.title;
        self.businessScope = iCard.businessScope;
        
        // 联系方式
        self.fax         = iCard.fax;
        self.mobilePhone = iCard.mobilePhone;
        self.telephone   = iCard.telephone;
        self.aliWangWang = iCard.aliWangWang;
        self.email       = iCard.email;
        self.microblog   = iCard.microblog;
        self.msn         = iCard.msn;
        self.qq          = iCard.qq;
        self.web         = iCard.web;
        
        // 杂项
        self.moreInfo    = iCard.moreInfo;
        
        // 模板 {
        // 根据ID查，不存在则新建
        if (iCard.templateID.integerValue) {
            self.template = [CardTemplate objectByID:iCard.templateID createIfNone:YES];
        } else {
            self.template = nil;
        }
        // }
        
        // 公司 {
        NSNumber *companyID = iCard.companyID;
            // 保证公司对象存在
            if (companyID.integerValue) {
                self.company = [Company objectByID:companyID createIfNone:YES];
            } else {
                // 公司无ID，通常是PrivateCard。
                if (nil == self.company) self.company = [Company newObject];
            }
        self.company.name = iCard.companyName;
        // }
        
        // logo {
        self.logo = [Image objectByKey:@"url" value:iCard.logoURL createIfNone:YES];
        // }
        
        // 地址 {
        if (nil == self.address) self.address = [Address newObject];
//        if (iCard.addressCity.length)
        self.address.city     = iCard.addressCity;
//        if (iCard.addressCountry.length)
        self.address.country  = iCard.addressCountry;
//        if (iCard.addressDistrict.length)
        self.address.district = iCard.addressDistrict;
//        if (iCard.addressOther.length)
        self.address.other    = iCard.addressOther;
//        if (iCard.addressProvince.length)
        self.address.province = iCard.addressProvince;
//        if (iCard.addressStreet.length)
        self.address.street   = iCard.addressStreet;
//        if (iCard.addressZip.length)
        self.address.zip      = iCard.addressZip;
        // }
        
        // 银行帐户 {
        if (nil == self.bankAccount) self.bankAccount = [BankAccount newObject];
        self.bankAccount.bank   = iCard.bankAccountBank;
        self.bankAccount.branch = iCard.bankAccountBranch;
        self.bankAccount.name   = iCard.bankAccountName;
        self.bankAccount.number = iCard.bankAccountNumber;
        // }
        
        // 第2～n祯 {
        for (IImage *frame in iCard.frames) {
            Image *newFrame = [Image processIObject:frame];
            if (newFrame) [self.framesSet addObject:newFrame];
        }
        // }
    }
    return self;
}
@end
