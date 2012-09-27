//
//  InterCard.m
//  CardBook
//
//  Created by Sun Ming on 12-9-26.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "InterCard.h"
#import "NSNumber+SM.h"
#import "NSString+SM.h"

@implementation InterCard
@end

@implementation InterCard (transformation)
+ (InterCard *)interCardWithMyCardJSON:(NSDictionary *)json {
    InterCard *result = [[InterCard alloc] init];

    result.id = [NSNumber numberFromObject:json[JSONDataKeyCardId] zeroIfUnresolvable:NO];// 解不出为nil
    result.isDeleted = [NSNumber numberFromObject:json[JSONDataKeyIsDelete] zeroIfUnresolvable:YES];
    result.roleType = [NSNumber numberFromObject:json[JSONDataKeyCardTypeId] defaultValue:1 defaultIfUnresolvable:YES];// 默认1
    result.userID = [NSNumber numberFromObject:json[JSONDataKeyUserId] zeroIfUnresolvable:NO];// 解不出为nil
    result.version = [NSNumber numberFromObject:json[JSONDataKeyVersion] defaultValue:1 defaultIfUnresolvable:YES];// 默认1
    result.templateID = [NSNumber numberFromObject:json[JSONDataKeyTemplateId] zeroIfUnresolvable:NO];// 解不出为nil
    
    // 个人重要信息
    result.name = [NSString stringFromObject:json[JSONDataKeyName]];
//    NSLog(@"%@", [NSString stringWithUTF8String:[json[JSONDataKeyName] cStringUsingEncoding:NSASCIIStringEncoding]]);
    result.title = [NSString stringFromObject:json[JSONDataKeyJobTitle]];
    result.department = KHHPlaceholderForEmptyString;
    result.mobilePhone = [NSString stringFromObject:json[JSONDataKeyMobilePhone]];
    result.telephone = [NSString stringFromObject:json[JSONDataKeyTelephone]];
    result.logoURL = [NSString stringFromObject:json[JSONDataKeyLogoImage]];
    
    // 个人其他联系方式
    result.email = [NSString stringFromObject:json[JSONDataKeyEmail]];
    result.fax = [NSString stringFromObject:json[JSONDataKeyFax]];
    result.aliWangWang = [NSString stringFromObject:json[JSONDataKeyWangWang]];
    result.microblog = [NSString stringFromObject:json[JSONDataKeyMicroBlog]];
    result.msn = [NSString stringFromObject:json[JSONDataKeyMSN]];
    result.qq = [NSString stringFromObject:json[JSONDataKeyQQ]];
    result.web = [NSString stringFromObject:json[JSONDataKeyWeb]];
    
    // 个人其他信息
    result.moreInfo = [NSString stringFromObject:json[JSONDataKeyMoreInfo]];
    result.remarks = [NSString stringFromObject:json[JSONDataKeyCol3]]; // card col3?
    
    // 公司其他信息
    result.businessScope = [NSString stringFromObject:json[JSONDataKeyBusinessScope]];
    
    // 公司信息
    result.companyID  = [NSNumber numberFromObject:json[JSONDataKeyCompanyId] defaultValue:0 defaultIfUnresolvable:YES];
    result.companyName  = [NSString stringFromObject:json[JSONDataKeyCompanyName]];
//    result.companyEmail;
//    result.companyLogoURL;
    
    // 地址信息
    result.addressCity  = [NSString stringFromObject:json[JSONDataKeyCity]];
    result.addressCountry = [NSString stringFromObject:json[JSONDataKeyCountry]];
    result.addressDistrict = KHHPlaceholderForEmptyString;
    result.addressProvince  = [NSString stringFromObject:json[JSONDataKeyProvince]];
    result.addressStreet = KHHPlaceholderForEmptyString;
    result.addressOther  = [NSString stringFromObject:json[JSONDataKeyAddress]];
    result.addressZip  = [NSString stringFromObject:json[JSONDataKeyZipcode]];
    
    // 银行帐户
    result.bankAccountBank = KHHPlaceholderForEmptyString;
    result.bankAccountBranch = [NSString stringFromObject:json[JSONDataKeyOpenBank]];
    result.bankAccountName = KHHPlaceholderForEmptyString;
    result.bankAccountNumber = [NSString stringFromObject:json[JSONDataKeyBankNO]];

    // 处理完毕，返回。
    return result;
}
+ (InterCard *)interCardWithPrivateCardJSON:(NSDictionary *)json {
    // 先填入普通名片
    NSDictionary *myCard = json[@"card"];
    InterCard * result = [self interCardWithMyCardJSON:myCard];
#warning TODO
    // 再填PrivateCard相关的数据
    return result;
}
+ (InterCard *)interCardWithReceivedCardJSON:(NSDictionary *)json {
    // 先填入普通名片
    NSDictionary *myCard = json[@"card"];
    InterCard * result = [self interCardWithMyCardJSON:myCard];
    // 再填ReceivedCard相关的数据
    // isRead(col3),(col1?),memo
    result.isDeleted = [NSNumber numberFromObject:json[JSONDataKeyIsDelete] zeroIfUnresolvable:YES];
    result.isRead = [NSNumber numberFromObject:json[JSONDataKeyCol3] zeroIfUnresolvable:YES];
    result.memo = [NSString stringFromObject:json[JSONDataKeyMemo]];
    // 处理完毕，返回。
    return result;
}
@end