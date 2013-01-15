//
//  InterCard.m
//  CardBook
//
//  Created by Sun Ming on 12-9-26.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHClasses.h"
#import "NSNumber+SM.h"
#import "NSString+SM.h"

@implementation InterCard
@end

@implementation InterCard (KHHTransformation)
+ (InterCard *)interCardWithJSON:(NSDictionary *)json {
    InterCard *iCard = [[InterCard alloc] init];
    
    iCard.id = [NSNumber numberFromObject:json[JSONDataKeyCardId] zeroIfUnresolvable:NO];// 解不出为nil
    iCard.isDeleted = [NSNumber numberFromObject:json[JSONDataKeyIsDelete] zeroIfUnresolvable:YES].boolValue;
    iCard.modelType = KHHCardModelTypeCard;
    iCard.roleType = [NSNumber numberFromObject:json[JSONDataKeyCardTypeId] defaultValue:1 defaultIfUnresolvable:YES];// 默认1
    iCard.userID = [NSNumber numberFromObject:json[JSONDataKeyUserId] zeroIfUnresolvable:NO];// 解不出为nil
    iCard.version = [NSNumber numberFromObject:json[JSONDataKeyVersion] defaultValue:1 defaultIfUnresolvable:YES];// 默认1
    iCard.templateID = [NSNumber numberFromObject:json[JSONDataKeyTemplateId] zeroIfUnresolvable:NO];// 解不出为nil
    //名片类型
    iCard.cardType = [NSString stringFromObject:[json valueForKey:JSONDataKeyCardType]];
    //名片来源
    iCard.cardSource = [NSString stringFromObject:[json valueForKey:JSONDataKeyCardSource]];
    
    // 个人重要信息
    iCard.name = [NSString stringFromObject:json[JSONDataKeyName]];
    iCard.title = [NSString stringFromObject:json[JSONDataKeyJobTitle]];
    iCard.department = KHHPlaceholderForEmptyString;
    iCard.mobilePhone = [NSString stringFromObject:json[JSONDataKeyMobilePhone]];
    iCard.telephone = [NSString stringFromObject:json[JSONDataKeyTelephone]];
    iCard.logoURL = [NSString stringFromObject:json[JSONDataKeyLogoImage]];
    
    // 个人其他联系方式
    iCard.email = [NSString stringFromObject:json[JSONDataKeyEmail]];
    iCard.fax = [NSString stringFromObject:json[JSONDataKeyFax]];
    iCard.aliWangWang = [NSString stringFromObject:json[JSONDataKeyWangWang]];
    iCard.microblog = [NSString stringFromObject:json[JSONDataKeyMicroBlog]];
    iCard.msn = [NSString stringFromObject:json[JSONDataKeyMSN]];
    iCard.qq = [NSString stringFromObject:json[JSONDataKeyQQ]];
    iCard.web = [NSString stringFromObject:json[JSONDataKeyWeb]];
    
    // 个人其他信息
    iCard.moreInfo = [NSString stringFromObject:json[JSONDataKeyMoreInfo]];
    iCard.remarks = [NSString stringFromObject:json[JSONDataKeyCol3]]; // card col3?
    
    // 公司其他信息
    iCard.businessScope = [NSString stringFromObject:json[JSONDataKeyBusinessScope]];
    
    // 公司信息
    iCard.companyID  = json[JSONDataKeyCompanyId];
    iCard.companyName  = [NSString stringFromObject:json[JSONDataKeyCompanyName]];
    
    // 地址信息
    iCard.addressCity  = [NSString stringFromObject:json[JSONDataKeyCity]];
    iCard.addressCountry = [NSString stringFromObject:json[JSONDataKeyCountry]];
    iCard.addressDistrict = KHHPlaceholderForEmptyString;
    iCard.addressProvince  = [NSString stringFromObject:json[JSONDataKeyProvince]];
    iCard.addressStreet = KHHPlaceholderForEmptyString;
    iCard.addressOther  = [NSString stringFromObject:json[JSONDataKeyAddress]];
    iCard.addressZip  = [NSString stringFromObject:json[JSONDataKeyZipcode]];
    
    // 银行帐户
    iCard.bankAccountBank = KHHPlaceholderForEmptyString;
    iCard.bankAccountBranch = [NSString stringFromObject:json[JSONDataKeyOpenBank]];
    iCard.bankAccountName = KHHPlaceholderForEmptyString;
    iCard.bankAccountNumber = [NSString stringFromObject:json[JSONDataKeyBankNO]];
    
    // 第 2～n frames
    NSArray *linkList = json[JSONDataKeyCardLinkList];
    NSMutableArray *newList = [NSMutableArray arrayWithCapacity:linkList.count];
    for (id link in linkList) {
        IImage *ii = [[[IImage alloc] init] updateWithJSON:link];
        [newList addObject:ii];
    }
    iCard.frames = newList;
    
    // 处理完毕，返回。
    return iCard;
}
+ (InterCard *)interCardWithMyCardJSON:(NSDictionary *)json {
    // 先填入普通名片
    InterCard *iCard = [self interCardWithJSON:json];
    // 再填MyCard相关的数据
    iCard.modelType = KHHCardModelTypeMyCard;
    return iCard;
}
+ (InterCard *)interCardWithPrivateCardJSON:(NSDictionary *)json {
    // 先填入普通名片
    InterCard * iCard = [self interCardWithJSON:json];
    // 再填PrivateCard相关的数据
    iCard.modelType = KHHCardModelTypePrivateCard;
    iCard.id = [NSNumber numberFromObject:json[JSONDataKeyID]
                       zeroIfUnresolvable:NO];// 解不出为nil
    return iCard;
}
+ (InterCard *)interCardWithReceivedCardJSON:(NSDictionary *)json {
    // 先填入普通名片
//    NSDictionary *card = json[@"card"];
//    InterCard * iCard = [self interCardWithJSON:card];
//    // 再填ReceivedCard相关的数据
//    // isRead(col3),(col1?),memo
//    iCard.modelType = KHHCardModelTypeReceivedCard;
//    iCard.isDeleted = iCard.isDeleted || [NSNumber numberFromObject:json[JSONDataKeyIsDelete] zeroIfUnresolvable:YES].boolValue;
//    iCard.isRead = [NSNumber numberFromObject:json[JSONDataKeyCol3] zeroIfUnresolvable:YES];
//    iCard.memo = [NSString stringFromObject:json[JSONDataKeyMemo]];
//    // 处理完毕，返回。
//    return iCard;
    return [self interCardWithReceivedCardJSON:json nodeName:@"card"];
}
//解析联系人，通过其它方式获取(json接点名不是card时用)
+ (InterCard *)interCardWithReceivedCardJSON:(NSDictionary *)json nodeName:(NSString *) nodeName {
    //获取结点下的数据,有结点名就取此结点名下的，没有就不取
    NSDictionary *card;
    if (nodeName) {
        card = json[nodeName];
    }else {
        card = [[NSDictionary alloc] initWithDictionary:json];
    }
    
    // 先填入普通名片
    InterCard * iCard = [self interCardWithJSON:card];
    // 再填ReceivedCard相关的数据
    // isRead(col3),(col1?),memo
    iCard.modelType = KHHCardModelTypeReceivedCard;
    iCard.isDeleted = iCard.isDeleted || [NSNumber numberFromObject:json[JSONDataKeyIsDelete] zeroIfUnresolvable:YES].boolValue;
    iCard.isRead = [NSNumber numberFromObject:json[JSONDataKeyCol3] zeroIfUnresolvable:YES];
    iCard.memo = [NSString stringFromObject:json[JSONDataKeyMemo]];
    // 处理完毕，返回。
    return iCard;
}
@end