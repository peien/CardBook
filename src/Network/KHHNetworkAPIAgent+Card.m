//
//  KHHNetworkAPIAgent+Card.m
//  CardBook
//
//  Created by 孙铭 on 8/29/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgent+Card.h"
#import "KHHNotifications.h"
#import "InterCard.h"
#import "NSNumber+SM.h"

/*!
 @fuctiongroup Card参数整理函数
 */
BOOL CardHasRequiredAttributes(InterCard *iCard,
                               KHHCardAttributeType attributes) {
    if (attributes & KHHCardAttributeID) {
        NSString *ID = [iCard.id stringValue];
        if (![ID length]) {
            return NO;
        }
    }
    if (attributes & KHHCardAttributeVersion) {
        NSString *version = [iCard.version stringValue];
        if (![version length]) {
            return NO;
        }
    }
    if (attributes & KHHCardAttributeUserID) {
        NSString *userID = [iCard.userID stringValue];
        if (![userID length]) {
            return NO;
        }
    }
    if (attributes & KHHCardAttributeTemplateID) {
        NSString *templateID = [iCard.templateID stringValue];
        if (![templateID length]) {
            return NO;
        }
    }
    if (attributes & KHHCardAttributeName) {
        NSString *name = iCard.name;
        if (![name length]) {
            return NO;
        }
    }
    return YES;
}

/*
 card.templateId    模板ID
 logoImage(无card前缀) 用户头像???
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
NSMutableDictionary * ParametersToCreateOrUpdateCard(InterCard *iCard) {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:10];
    // card.templateId
    [result setObject:(iCard.templateID? iCard.templateID.stringValue: @"")
               forKey:@"card.templateId"];
    // detail.name
    [result setObject:(iCard.name? iCard.name:  @"")
               forKey:@"detail.name"];
    // detail.jobTitle
    [result setObject:(iCard.title? iCard.title: @"")
               forKey:@"detail.jobTitle"];
    // detail.email
    [result setObject:(iCard.email? iCard.email: @"")
               forKey:@"detail.email"];
    // detail.companyName
    [result setObject:(iCard.companyName? iCard.companyName: @"")
               forKey:@"detail.companyName"];
    // detail.country
    [result setObject:(iCard.addressCountry? iCard.addressCountry: @"")
               forKey:@"detail.country"];
    // detail.province
    [result setObject:(iCard.addressProvince? iCard.addressProvince: @"")
               forKey:@"detail.province"];
    // detail.city
    [result setObject:(iCard.addressCity? iCard.addressCity: @"")
               forKey:@"detail.city"];
    // detail.address
    [result setObject:(iCard.addressOther? iCard.addressOther: @"")
               forKey:@"detail.address"];
    // detail.zipcode 邮编
    [result setObject:(iCard.addressZip? iCard.addressZip: @"")
               forKey:@"detail.zipcode"];
    // detail.telephone 固定电话
    [result setObject:(iCard.telephone? iCard.telephone: @"")
               forKey:@"detail.telephone"];
    // detail.mobilephone 手机
    [result setObject:(iCard.mobilePhone? iCard.mobilePhone: @"")
               forKey:@"detail.mobilephone"];
    // detail.fax
    [result setObject:(iCard.fax? iCard.fax: @"")
               forKey:@"detail.fax"];
    // detail.qq
    [result setObject:(iCard.qq? iCard.qq: @"")
               forKey:@"detail.qq"];
    // detail.msn
    [result setObject:(iCard.msn? iCard.msn: @"")
               forKey:@"detail.msn"];
    // detail.web
    [result setObject:(iCard.web? iCard.web: @"")
               forKey:@"detail.web"];
    // detail.moreInfo 其他
    [result setObject:(iCard.moreInfo? iCard.moreInfo: @"")
               forKey:@"detail.moreInfo"];
    // detail.col1 公司邮箱
    [result setObject:(iCard.companyEmail? iCard.companyEmail: @"")
               forKey:@"detail.col1"];
    // detail.col2 部门
    [result setObject:(iCard.department? iCard.department: @"")
               forKey:@"detail.col2"];
    // detail.col3 备注（名片中可看到）
    [result setObject:(iCard.remarks? iCard.remarks: @"")
               forKey:@"detail.col3"];
    // detail.microblog 微博
    [result setObject:(iCard.microblog? iCard.microblog: @"")
               forKey:@"detail.microBlog"];
    // detail.wangwang 旺旺
    [result setObject:(iCard.aliWangWang? iCard.aliWangWang: @"")
               forKey:@"detail.wangwang"];
    // detail.businessScope 业务范围
    [result setObject:(iCard.businessScope? iCard.businessScope: @"")
               forKey:@"detail.businessScope"];
    // detail.openBank 开户行
    [result setObject:(iCard.bankAccountBranch? iCard.bankAccountBranch: @"")
               forKey:@"detail.openBank"];
    // detail.bankNO 银行账号
    [result setObject:(iCard.bankAccountNumber? iCard.bankAccountNumber: @"")
               forKey:@"detail.bankNO"];
    return result;
}
@implementation KHHNetworkAPIAgent (Card)
/**
 新增我的名片 kinghhCardService.create
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=202
 新增私有名片 kinghhPrivateCardService.create
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=179
 */
- (BOOL)createCard:(InterCard *)iCard ofType:(KHHCardModelType)cardType {
    if (!CardHasRequiredAttributes(iCard, KHHCardAttributeTemplateID)) {
        DLog(@"[II] 参数错误！");
        return NO;
    }
    NSString *action = @"createCard";
    NSString *query;
    if (KHHCardModelTypeMyCard == cardType) {
        query = @"kinghhCardService.create";
        iCard.modelType = KHHCardModelTypeMyCard;
    } else if (KHHCardModelTypePrivateCard == cardType) {
        query = @"kinghhPrivateCardService.create";
        iCard.modelType = KHHCardModelTypePrivateCard;
    }
    NSDictionary *parameters = ParametersToCreateOrUpdateCard(iCard);
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *op, id response) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:response];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
        KHHNetworkStatusCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        // 把返回的数据转成本地数据
        // 返回的CardID
        iCard.id = [NSNumber numberFromObject:responseDict[JSONDataKeyID] zeroIfUnresolvable:NO];
        dict[kInfoKeyExtra] = @{
        kExtraKeyInterCard : iCard,
        kExtraKeyCardModelType : [NSNumber numberWithInteger:cardType],
        };
        dict[kInfoKeyErrorCode] = @(code);
        NSString *name = NameWithActionAndCode(action, code);
        DLog(@"[II] 发送 Notification Name = %@", name);
        [self postASAPNotificationName:name info:dict];
    };
    DLog(@"[II] 发送请求！");
    [self postAction:action
               query:query
          parameters:parameters
             success:success];
    return YES;
}
/**
 修改我的名片 kinghhCardService.update
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=203
 修改私有名片 kinghhPrivateCardService.update
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=180
 */
- (BOOL)updateCard:(InterCard *)iCard ofType:(KHHCardModelType)cardType {
    if (!CardHasRequiredAttributes(iCard, KHHCardAttributeID)) {
        ALog(@"[EE] ERROR!!参数错误！");
        return NO;
    }
    NSString *action = @"updateCard";
    NSString *query;
    NSMutableDictionary *parameters = ParametersToCreateOrUpdateCard(iCard);
    if (KHHCardModelTypeMyCard == cardType) {
        query = @"kinghhCardService.update";
        parameters[@"card.cardId"] = iCard.id;
        iCard.modelType = KHHCardModelTypeMyCard;
    } else if (KHHCardModelTypePrivateCard == cardType) {
        query = @"kinghhPrivateCardService.update";
        parameters[@"card.id"] = iCard.id;
        iCard.modelType = KHHCardModelTypePrivateCard;
    }
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *op, id response) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:response];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
        KHHNetworkStatusCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        dict[kInfoKeyExtra] = @{
        kExtraKeyInterCard : iCard,
        kExtraKeyCardModelType : [NSNumber numberWithInteger:cardType],
        };
        dict[kInfoKeyErrorCode] = @(code);
        NSString *name = NameWithActionAndCode(action, code);
        ALog(@"[II] 发送 Notification Name = %@", name);
        [self postASAPNotificationName:name info:dict];
    };
    ALog(@"[II] 发送请求！");
    [self postAction:action
               query:query
          parameters:parameters
             success:success];
    return YES;
}
/**
 删除我的名片 kinghhCardService.delete
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=204
 删除私有名片 kinghhPrivateCardService.delete
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=181
 */
- (BOOL)deleteCardByID:(NSNumber *)cardID ofType:(KHHCardModelType)cardType {
    if (!(cardID.integerValue > 0)) {
        DLog(@"[II] 参数错误！");
        return NO;
    }
    NSString *action = @"deleteCard";
    NSString *query;
    NSString *IDKey;
    if (KHHCardModelTypeMyCard == cardType) {
        query = @"kinghhCardService.delete";
        IDKey = @"card.cardId";
    } else if (KHHCardModelTypePrivateCard == cardType) {
        query = @"kinghhPrivateCardService.delete";
        IDKey = @"card.id";
    }
    NSString *ID = [cardID stringValue];
    NSDictionary *parameters = @{
    IDKey : ID? ID: @"",
    };
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *op, id response) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:response];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
        KHHNetworkStatusCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        dict[kInfoKeyExtra] = @{
        kExtraKeyCardID : cardID,
        kExtraKeyCardModelType : [NSNumber numberWithInteger:cardType],
        };
        dict[kInfoKeyErrorCode] = @(code);
        NSString *name = NameWithActionAndCode(action, code);
        DLog(@"[II] 发送 Notification Name = %@", name);
        [self postASAPNotificationName:name info:dict];
    };
    DLog(@"[II] 发送请求！");
    [self postAction:action
               query:query
          parameters:parameters
             success:success];
    return YES;
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
          parameters:parameters
             success:nil
               extra:@{ kExtraKeyCardList : cards }];
    return YES;
}

/**
 我的联系人中最后一个名片 exchangeCardService.getReceiverCardBookLast
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=196
 */
- (void)latestReceivedCard {
    NSString *action = @"latestReceivedCard";
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *op, id response) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:response];
        DLog(@"[II] responseDict = %@", responseDict);
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
        KHHNetworkStatusCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        dict[kInfoKeyErrorCode] = @(code);
        
        // cardBookVO -> InterCard
        InterCard *iCard = [InterCard interCardWithReceivedCardJSON:responseDict[JSONDataKeyCardBookVO]];
        dict[kInfoKeyInterCard] = iCard;
        
        NSString *name = NameWithActionAndCode(action, code);
        DLog(@"[II] 发送 Notification Name = %@", name);
        [self postASAPNotificationName:name info:dict];
    };
    [self postAction:action
               query:@"exchangeCardService.getReceiverCardBookLast"
          parameters:nil
             success:success];
}

/**
 我的联系人增量总个数 exchangeCardService.getReceiverCardBookSynCount
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=195
 */
- (void)receivedCardCountAfterDate:(NSString *)lastDate
                          lastCard:(NSString *)lastCard
                             extra:(NSDictionary *)extra {
    NSString *lastID = [[lastCard valueForKey:kAttributeKeyID] stringValue];
    NSDictionary *parameters = @{
            @"lastUpdTime" : (lastDate.length > 0? lastDate: @""),
            @"lastCardbookId" : lastID? lastID: @"",
    };
    [self postAction:@"receivedCardCountAfterDateLastCard"
               query:@"exchangeCardService.getReceiverCardBookSynCount"
          parameters:parameters
             success:nil
               extra:extra];
}

/**
 我的联系人增量 exchangeCardService.getReceiverCardBookSyn
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=182
 */
- (void)receivedCardsAfterDate:(NSString *)lastDate
                      lastCard:(NSString *)lastCardID
                 expectedCount:(NSString *)count
                         extra:(NSDictionary *)extra {
    NSString *action = @"receivedCardsAfterDateLastCardExpectedCount";
    NSDictionary *parameters = @{
            @"lastUpdTime" : (lastDate.length > 0? lastDate: @""),
            @"lastCardbookId" : lastCardID? lastCardID: @"",
            @"number" : ([count integerValue]? count: @"100"),
            @"isGZip" : @"no"
    };
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *op, id response) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:response];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:8];
        
        // 把返回的数据转成本地数据
        KHHNetworkStatusCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        if (KHHNetworkStatusCodeSucceeded == code) {
            // count
            dict[kInfoKeyCount] = responseDict[JSONDataKeyCount];
            
            // synTime -> syncTime
            NSString *syncTime = responseDict[JSONDataKeySynTime];
            dict[kInfoKeySyncTime] = syncTime? syncTime: @"";
            
            // lastCardbookId -> lastID
            NSString *lastID = responseDict[JSONDataKeyLastCardbookId];
            dict[kInfoKeyLastID] = lastID? lastID: @"";
            
            // cardBookList -> receivedCardList
            NSArray *oldList = responseDict[JSONDataKeyCardBookList];
            NSMutableArray *receivedCardList = [NSMutableArray arrayWithCapacity:oldList.count];
            for (NSDictionary *oldDict in oldList) {
                InterCard *iCard = [InterCard interCardWithReceivedCardJSON:oldDict];
                [receivedCardList addObject:iCard];
            }
            dict[kInfoKeyReceivedCardList] = receivedCardList;
        }
        
        // errorCode 和 extra
        dict[kInfoKeyErrorCode] = @(code);
        dict[kInfoKeyExtra] = extra;
        // 把处理完的数据发出去。
        [self postASAPNotificationName:NameWithActionAndCode(action, code)
                                  info:dict];
    };
    [self postAction:action
               query:@"exchangeCardService.getReceiverCardBookSyn"
          parameters:parameters
             success:success
               extra:extra];
}
/**
 设置联系人的状态为已查看 sendCardService.updateReadState
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=208
 */
- (void)markReadReceivedCard:(ReceivedCard *)aCard {
    if (aCard.isRead.integerValue) { // 已经读过的就不用继续执行了
        [self postASAPNotificationName:KHHNetworkMarkReadReceivedCardSucceeded
                                  info:@{
                    kInfoKeyErrorCode : @(KHHNetworkStatusCodeSucceeded),
                       kInfoKeyObject : aCard,
         }];
        return;
    }
    NSString *ID = [aCard.id stringValue];
    NSString *version = [aCard.version stringValue];
    NSString *userID = [aCard.userID stringValue];
    NSString *action = @"markReadReceivedCard";
    NSDictionary *parameters = @{
            @"senderId" : (userID? userID: @""),
            @"cardId"   : (ID? ID: @""),
            @"version"  : (version? version: @"")
    };
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *op, id response) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:response];
        KHHNetworkStatusCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        NSDictionary *dict = @{
        kInfoKeyErrorCode : @(code),
        kInfoKeyObject : aCard, };
        [self postASAPNotificationName:NameWithActionAndCode(action, code) info:dict];
    };
    [self postAction:action
               query:@"sendCardService.updateReadState"
          parameters:parameters
             success:success];
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
          parameters:parameters
             success:nil];
}
@end
