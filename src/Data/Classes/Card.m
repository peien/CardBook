#import "Card.h"
#import "MyCard.h"
#import "PrivateCard.h"
#import "ReceivedCard.h"
#import "KHHLog.h"
#import "NSManagedObject+KHH.h"
#import "InterCard.h"
#import "CardTemplate.h"
#import "CardTemplateItem.h"
#import "Address.h"
#import "BankAccount.h"
#import "Company.h"
#import "Image.h"

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
        default:
            break;
    }
    return card;
}
@end

@implementation Card (Type_And_Name)
- (NSString *)nameForServer {
    if ([self isKindOfClass:[MyCard class]]) {
        return @"private";
    }
    if ([self isKindOfClass:[PrivateCard class]]) {
        return @"me";
    }
    if ([self isKindOfClass:[ReceivedCard class]]) {
        return @"linkman";
    }
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
    return [name isEqualToString:@"linkman"]? KHHCardModelTypeReceivedCard
    :([name isEqualToString:@"me"]? KHHCardModelTypePrivateCard
      :KHHCardModelTypeMyCard);
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

@implementation Card (Transformation)
+ (id)objectWithIObject:(InterCard *)iCard {
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
        self.name      = iCard.name;
        if (self.name.length) {
            self.isFull = @(YES);
        }
        self.userID    = iCard.userID;
        self.version   = iCard.version;
        self.modelType = @(KHHCardModelTypeCard);
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
        self.template    = [CardTemplate objectByID:iCard.templateID createIfNone:YES];
        // }
        
        // 公司 {
        NSString *companyName = iCard.companyName;
        if (companyName.length) {
            // 公司名字存在才值得修改。
            NSNumber *companyID = iCard.companyID;
            if (companyID) {
                self.company = [Company objectByID:companyID createIfNone:YES];
            } else {
                // 公司有名字却无ID，通常是PrivateCard。
                self.company = [Company newObject];
            }
            self.company.name = companyName;
        }
        // }
        
        // logo {
        self.logo = [Image objectByKey:@"url" value:iCard.logoURL createIfNone:YES];
        // }
        
        // 地址 {
        if (nil == self.address) { // 无则新建
            self.address = [Address newObject];
        }
        self.address.city     = iCard.addressCity;
        self.address.country  = iCard.addressCountry;
        self.address.district = iCard.addressDistrict;
        self.address.other    = iCard.addressOther;
        self.address.province = iCard.addressProvince;
        self.address.street   = iCard.addressStreet;
        self.address.zip      = iCard.addressZip;
        // }
        
        // 银行帐户 {
        if (iCard.bankAccountNumber.length) {
            if (nil == self.bankAccount) {
                self.bankAccount = [BankAccount newObject];
            }
            self.bankAccount.bank   = iCard.bankAccountBank;
            self.bankAccount.branch = iCard.bankAccountBranch;
            self.bankAccount.name   = iCard.bankAccountName;
            self.bankAccount.number = iCard.bankAccountNumber;
        }
        // }
        
#warning TODO
        // 第2～n祯
    }
    return self;
}
@end
