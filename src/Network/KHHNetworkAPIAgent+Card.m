//
//  KHHNetworkAPIAgent+Card.m
//  CardBook
//
//  Created by 孙铭 on 8/29/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgent+Card.h"
#import "NSObject+Notification.h"

/*!
 @fuctiongroup Card参数整理函数
 */
BOOL CardHasRequiredAttributes(Card *card,
                               KHHCardAttributes attributes) {
    if (attributes & KHHCardAttributeID) {
        NSString *ID = [[card valueForKeyPath:kAttributeKeyID] stringValue];
        if (![ID length]) {
            return NO;
        }
    }
    if (attributes & KHHCardAttributeVersion) {
        NSString *version = [[card valueForKeyPath:kAttributeKeyVersion] stringValue];
        if (![version length]) {
            return NO;
        }
    }
    if (attributes & KHHCardAttributeUserID) {
        NSString *userID = [[card valueForKeyPath:kAttributeKeyUserID] stringValue];
        if (![userID length]) {
            return NO;
        }
    }
    if (attributes & KHHCardAttributeTemplateID) {
        NSString *templateID = [[card valueForKeyPath:kAttributeKeyPathTemplateID] stringValue];
        if (![templateID length]) {
            return NO;
        }
    }
    if (attributes & KHHCardAttributeName) {
        NSString *name = [card valueForKeyPath:kAttributeKeyName];
        if (![name length]) {
            return NO;
        }
    }
    return YES;
}

/*
 card.templateId    模板ID
 logoImage(无card前缀) 用户头像
 detail.name        姓名
 detail.jobTitle    职称
 detail.email       邮箱
 detail.companyName 公司名称
 detail.country     国家
 detail.province    省
 detail.city        城市
 detail.address     地址
 detail.zipcode     邮编
 detail.telephone   固定电话
 detail.mobilephone 手机
 detail.fax 传真
 detail.qq  QQ
 detail.msn MSN
 detail.web 主页
 detail.moreInfo 其他
 detail.col1 公司邮箱
 detail.col2 部门
 detail.col3 备注（名片中可看到）
 detail.col4 厂址
 detail.col5 客服电话
 detail.microBlog 微博
 detail.wangwang 旺旺
 detail.businessScope 业务范围
 detail.openBank 开户行
 detail.bankNO 银行账号
 */
NSMutableDictionary * ParametersToCreateOrUpdateCard(Card *card) {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:10];
    NSString *obj;
    // card.templateId
    obj = [[card valueForKeyPath:kAttributeKeyPathTemplateID] stringValue];
    if (obj) {
        [result setObject:obj forKey:@"card.templateId"];
    }
    // logoImage
//    NSString *url = [[card valueForKeyPath:kAttributeKeyPathLogoURL] stringValue];
//    UIImage *img = [UIImage imageWithContentsOfFile:url];
//    if (img) {
//        [result setObject:img forKey:@"logoImage"];
//    }
    // detail.name
    obj = [[card valueForKey:kAttributeKeyName] stringValue];
    if (obj) {
        [result setObject:obj forKey:@"detail.name"];
    }
    // detail.jobTitle
    obj = [[card valueForKey:kAttributeKeyTitle] stringValue];
    if (obj) {
        [result setObject:obj forKey:@"detail.jobTitle"];
    }
    // detail.email
    obj = [[card valueForKey:kAttributeKeyEmail] stringValue];
    if (obj) {
        [result setObject:obj forKey:@"detail.email"];
    }
    // detail.companyName
    obj = [[card valueForKeyPath:kAttributeKeyPathCompanyName] stringValue];
    if (obj) {
        [result setObject:obj forKey:@"detail.companyName"];
    }
    // detail.country
    obj = [[card valueForKeyPath:kAttributeKeyPathAddressCountry] stringValue];
    if (obj) {
        [result setObject:obj forKey:@"detail.country"];
    }
    // detail.province
    obj = [[card valueForKeyPath:kAttributeKeyPathAddressProvince] stringValue];
    if (obj) {
        [result setObject:obj forKey:@"detail.province"];
    }
    // detail.city
    obj = [[card valueForKeyPath:kAttributeKeyPathAddressCity] stringValue];
    if (obj) {
        [result setObject:obj forKey:@"detail.city"];
    }
    // detail.address
    obj = [[card valueForKeyPath:kAttributeKeyPathAddressOther] stringValue];
    if (obj) {
        [result setObject:obj forKey:@"detail.address"];
    }
    // detail.zipcode 邮编
    obj = [[card valueForKeyPath:kAttributeKeyPathAddressZip] stringValue];
    if (obj) {
        [result setObject:obj forKey:@"detail.zipcode"];
    }
    // detail.telephone 固定电话
    obj = [[card valueForKeyPath:kAttributeKeyTelephone] stringValue];
    if (obj) {
        [result setObject:obj forKey:@"detail.telephone"];
    }
    // detail.mobilephone 手机
    obj = [[card valueForKeyPath:kAttributeKeyMobilePhone] stringValue];
    if (obj) {
        [result setObject:obj forKey:@"detail.mobilephone"];
    }
    // detail.fax
    obj = [[card valueForKey:kAttributeKeyFax] stringValue];
    if (obj) {
        [result setObject:obj forKey:@"detail.fax"];
    }
    // detail.qq
    obj = [[card valueForKey:kAttributeKeyQQ] stringValue];
    if (obj) {
        [result setObject:obj forKey:@"detail.qq"];
    }
    // detail.msn
    obj = [[card valueForKey:kAttributeKeyMSN] stringValue];
    if (obj) {
        [result setObject:obj forKey:@"detail.msn"];
    }
    // detail.web
    obj = [[card valueForKey:kAttributeKeyWeb] stringValue];
    if (obj) {
        [result setObject:obj forKey:@"detail.web"];
    }
    // detail.moreInfo 其他
    obj = [[card valueForKey:kAttributeKeyMoreInfo] stringValue];
    if (obj) {
        [result setObject:obj forKey:@"detail.moreInfo"];
    }
    // detail.col1 公司邮箱
    obj = [[card valueForKey:kAttributeKeyOfficeEmail] stringValue];
    if (obj) {
        [result setObject:obj forKey:@"detail.col1"];
    }
    // detail.col2 部门
    obj = [[card valueForKey:kAttributeKeyDepartment] stringValue];
    if (obj) {
        [result setObject:obj forKey:@"detail.col2"];
    }
    // detail.col3 备注（名片中可看到）
    obj = [[card valueForKey:kAttributeKeyRemarks] stringValue];
    if (obj) {
        [result setObject:obj forKey:@"detail.col3"];
    }
    // detail.col4 厂址
    obj = [[card valueForKey:kAttributeKeyFactoryAddress] stringValue];
    if (obj) {
        [result setObject:obj forKey:@"detail.col4"];
    }
    // detail.col5 客服电话
    obj = [[card valueForKey:kAttributeKeyCustomerServiceTel] stringValue];
    if (obj) {
        [result setObject:obj forKey:@"detail.col5"];
    }
    // detail.microBlog 微博
    obj = [[card valueForKey:kAttributeKeyMicroblog] stringValue];
    if (obj) {
        [result setObject:obj forKey:@"detail.microBlog"];
    }
    // detail.wangwang 旺旺
    obj = [[card valueForKey:kAttributeKeyAliWangWang] stringValue];
    if (obj) {
        [result setObject:obj forKey:@"detail.wangwang"];
    }
    // detail.businessScope 业务范围
    obj = [[card valueForKey:kAttributeKeyBusinessScope] stringValue];
    if (obj) {
        [result setObject:obj forKey:@"detail.businessScope"];
    }
    // detail.openBank 开户行
    obj = [[card valueForKeyPath:kAttributeKeyPathBankAccountBranch] stringValue];
    if (obj) {
        [result setObject:obj forKey:@"detail.openBank"];
    }
    // detail.bankNO 银行账号
    obj = [[card valueForKeyPath:kAttributeKeyPathBankAccountNumber] stringValue];
    if (obj) {
        [result setObject:obj forKey:@"detail.bankNO"];
    }
    return result;
}
@implementation KHHNetworkAPIAgent (MyCard)
/**
 新增名片 kinghhCardService.create
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=202
 */
- (BOOL)createCard:(Card *)card {
    if (!CardHasRequiredAttributes(card, KHHCardAttributeTemplateID)) {
        return NO;
    }
    NSString *action = @"createCard";
    NSString *query;
    BOOL result = NO;
    
    if ([card isKindOfClass:[MyCard class]]) {
        query = @"kinghhCardService.create";
        result = YES;
    } else if ([card isKindOfClass:[PrivateCard class]]) {
        query = @"kinghhPrivateCardService.create";
        result = YES;
    }
    NSDictionary *parameters = ParametersToCreateOrUpdateCard(card);
    if (result) {
        [self postAction:action
                   query:query
              parameters:parameters];
    }
    return result;
}
/**
 修改名片 kinghhCardService.update
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=203
 */
- (BOOL)updateCard:(Card *)card {
    if (!CardHasRequiredAttributes(card, KHHCardAttributeID)) {
        return NO;
    }
    NSString *action = @"updateCard";
    NSString *query;
    BOOL result = NO;
    
    if ([card isKindOfClass:[MyCard class]]) {
        query = @"kinghhCardService.update";
        result = YES;
    } else if ([card isKindOfClass:[PrivateCard class]]) {
        query = @"kinghhPrivateCardService.update";
        result = YES;
    }
    NSDictionary *parameters = ParametersToCreateOrUpdateCard(card);
    if (result) {
        [self postAction:action
                   query:query
              parameters:parameters];
    }
    return result;
}
/**
 删除名片 kinghhCardService.delete
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=204
 */
- (BOOL)deleteCard:(Card *)card {
    if (![card isKindOfClass:[Card class]]) {
        return NO;
    }
    if (!CardHasRequiredAttributes(card, KHHCardAttributeID)) {
        return NO;
    }
    NSString *IDKey;
    NSString *action = @"deleteCard";
    NSString *query;
    BOOL result = NO;
    
    if ([card isKindOfClass:[MyCard class]]) {
        IDKey = @"card.cardId";
        query = @"kinghhCardService.delete";
        result = YES;
    } else if ([card isKindOfClass:[PrivateCard class]]) {
        IDKey = @"card.id";
        query = @"kinghhPrivateCardService.delete";
        result = YES;
    }
    NSString *ID = [[card valueForKey:kAttributeKeyID] stringValue];
    NSDictionary *parameters = @{
            IDKey : ID? ID: @"",
    };
    if (result) {
        [self postAction:action
                   query:query
              parameters:parameters];
    }
    return result;
}
@end
#pragma mark - ReceivedCard 联系人，即收到的他人名片
@implementation KHHNetworkAPIAgent (ReceivedCard)
/**
 删除联系人 relationGroupService.deleteCardBook
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=192
 */
- (BOOL)deleteReceivedCards:(NSArray *)cards {
    if (0 == [cards count]) {
        return NO;
    }
    NSMutableArray *cardIDs = [NSMutableArray arrayWithCapacity:[cards count]];
    for (id card in cards) {
        if (![card isKindOfClass:[ReceivedCard class]]) {
            return NO;
        }
        [cardIDs addObject:[[card valueForKey:kAttributeKeyID] stringValue]];
    }
    NSDictionary *parameters = @{
            @"cardBookVo.cardIds" : [cardIDs componentsJoinedByString:@"|"]
    };
    [self postAction:@"deleteReceivedCards"
               query:@"relationGroupService.deleteCardBook"
          parameters:parameters];
    return YES;
}

/**
 我的联系人中最后一个名片 exchangeCardService.getReceiverCardBookLast
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=196
 */
- (void)latestReceivedCard {
    [self postAction:@"latestReceivedCard"
               query:@"exchangeCardService.getReceiverCardBookLast"
          parameters:nil];
}

/**
 我的联系人增量总个数 exchangeCardService.getReceiverCardBookSynCount
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=195
 */
- (BOOL)receivedCardCountAfterDate:(NSString *)lastDate
                          lastCard:(ReceivedCard *)lastCard
                             extra:(NSDictionary *)extra {
    if (lastCard && !CardHasRequiredAttributes(lastCard, KHHCardAttributeID)) {
        return NO;
    }
    NSString *lastID = [[lastCard valueForKey:kAttributeKeyID] stringValue];
    NSDictionary *parameters = @{
            @"lastUpdTime" : (lastDate.length > 0? lastDate: @""),
            @"lastCardbookId" : lastID? lastID: @"",
    };
    [self postAction:@"receivedCardCountAfterDateLastCard"
               extra:extra
               query:@"exchangeCardService.getReceiverCardBookSynCount"
          parameters:parameters];
    return YES;
}

/**
 我的联系人增量 exchangeCardService.getReceiverCardBookSyn
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=182
 */
- (BOOL)receivedCardsAfterDate:(NSString *)lastDate
                      lastCard:(ReceivedCard *)lastCard
                 expectedCount:(NSString *)count
                         extra:(NSDictionary *)extra {
    if (lastCard && !CardHasRequiredAttributes(lastCard, KHHCardAttributeID)) {
        return NO;
    }
    NSString *lastID = [[lastCard valueForKey:kAttributeKeyID] stringValue];
    NSDictionary *parameters = @{
            @"lastUpdTime" : (lastDate.length > 0? lastDate: @""),
            @"lastCardbookId" : lastID? lastID: @"",
            @"number" : ([count integerValue]? count: @"50"),
            @"isGZip" : @"no"
    };
    [self postAction:@"receivedCardsAfterDateLastCardExpectedCount"
               extra:extra
               query:@"exchangeCardService.getReceiverCardBookSyn"
          parameters:parameters];
    return YES;
}

/**
 设置联系人的状态为已查看 sendCardService.updateReadState
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=208
 */
- (BOOL)markReadReceivedCard:(ReceivedCard *)card {
    if (![card isKindOfClass:[ReceivedCard class]]) {
        return NO;
    }
    if (card.isReadValue) { // 已经读过的就不用继续执行了
        return NO;
    }
    if (!CardHasRequiredAttributes(card, KHHCardAttributeID
                                | KHHCardAttributeVersion
                                | KHHCardAttributeUserID)) {
        return NO;
    }
    NSString *ID = [[card valueForKey:kAttributeKeyID] stringValue];
    NSString *version = [[card valueForKey:kAttributeKeyVersion] stringValue];
    NSString *userID = [[card valueForKey:kAttributeKeyUserID] stringValue];
    NSDictionary *parameters = @{
            @"senderId" : (userID? userID: @""),
            @"cardId" : (ID? ID: @""),
            @"version" : (version? version: @"")
    };
    [self postAction:@"markReadReceivedCard"
               query:@"sendCardService.updateReadState"
          parameters:parameters];
    return YES;
}

@end
#pragma mark - PrivateCard 私有名片，即自建的他人名片
@implementation KHHNetworkAPIAgent (PrivateCard)
/**
 增量查 kinghhPrivateCardService.synCard
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=178
 */
- (void)privateCardsAfterDate:(NSString *)lastDate {
    NSDictionary *parameters = @{
            @"lastUpdateDateStr" : [lastDate length] > 0? lastDate: @""
    };
    [self postAction:@"privateCardsAfterDate"
               query:@"kinghhPrivateCardService.synCard"
          parameters:parameters];
}
@end
