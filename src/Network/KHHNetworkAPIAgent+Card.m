//
//  KHHNetworkAPIAgent+Card.m
//  CardBook
//
//  Created by 孙铭 on 8/29/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgent+Card.h"
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
NSMutableDictionary * ParametersToCreateOrUpdateCard(InterCard *iCard) {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:10];
    // card.templateId
    NSString *templateID = [iCard.templateID stringValue];
    if (templateID) {
        [result setObject:templateID forKey:@"card.templateId"];
    }
    // logoImage
    NSString *logoFileURL = iCard.logoURL;
    UIImage *img = [UIImage imageWithContentsOfFile:logoFileURL];
    if (img) {
        [result setObject:img forKey:@"logoImage"];
    }
    // detail.name
    NSString *name = iCard.name;
    if (name) {
        [result setObject:name forKey:@"detail.name"];
    }
    // detail.jobTitle
    NSString *jobTitle = iCard.title;
    if (jobTitle) {
        [result setObject:jobTitle forKey:@"detail.jobTitle"];
    }
    // detail.email
    NSString *email = iCard.email;
    if (email) {
        [result setObject:email forKey:@"detail.email"];
    }
    // detail.companyName
    NSString *companyName = iCard.companyName;
    if (companyName) {
        [result setObject:companyName forKey:@"detail.companyName"];
    }
    // detail.country
    NSString *country = iCard.addressCountry;
    if (country) {
        [result setObject:country forKey:@"detail.country"];
    }
    // detail.province
    NSString *province = iCard.addressProvince;
    if (province) {
        [result setObject:province forKey:@"detail.province"];
    }
    // detail.city
    NSString *city = iCard.addressCity;
    if (city) {
        [result setObject:city forKey:@"detail.city"];
    }
    // detail.address
    NSString *addr = iCard.addressOther;
    if (addr) {
        [result setObject:addr forKey:@"detail.address"];
    }
    // detail.zipcode 邮编
    NSString *zip = iCard.addressZip;
    if (zip) {
        [result setObject:zip forKey:@"detail.zipcode"];
    }
    // detail.telephone 固定电话
    NSString *tel = iCard.telephone;
    if (tel) {
        [result setObject:tel forKey:@"detail.telephone"];
    }
    // detail.mobilephone 手机
    NSString *mobile = iCard.mobilePhone;
    if (mobile) {
        [result setObject:mobile forKey:@"detail.mobilephone"];
    }
    // detail.fax
    NSString *fax = iCard.fax;
    if (fax) {
        [result setObject:fax forKey:@"detail.fax"];
    }
    // detail.qq
    NSString *qq = iCard.qq;
    if (qq) {
        [result setObject:qq forKey:@"detail.qq"];
    }
    // detail.msn
    NSString *msn = iCard.msn;
    if (msn) {
        [result setObject:msn forKey:@"detail.msn"];
    }
    // detail.web
    NSString *web = iCard.web;
    if (web) {
        [result setObject:web forKey:@"detail.web"];
    }
    // detail.moreInfo 其他
    NSString *moreInfo = iCard.moreInfo;
    if (moreInfo) {
        [result setObject:moreInfo forKey:@"detail.moreInfo"];
    }
    // detail.col1 公司邮箱
    NSString *companyEmail = iCard.companyEmail;
    if (companyEmail) {
        [result setObject:companyEmail forKey:@"detail.col1"];
    }
    // detail.col2 部门
    NSString *department = iCard.department;
    if (department) {
        [result setObject:department forKey:@"detail.col2"];
    }
    // detail.col3 备注（名片中可看到）
    NSString *remarks = iCard.remarks;
    if (remarks) {
        [result setObject:remarks forKey:@"detail.col3"];
    }
    // detail.col4 厂址
//    NSString *factoryAddr = iCard.factoryAddress;
//    if (factoryAddr) {
//        [result setObject:factoryAddr forKey:@"detail.col4"];
//    }
    // detail.col5 客服电话
//    NSString *customServiceTel = iCard.customServiceTelephone;
//    if (customServiceTel) {
//        [result setObject:customServiceTel forKey:@"detail.col5"];
//    }
    // detail.microblog 微博
    NSString *microblog = iCard.microblog;
    if (microblog) {
        [result setObject:microblog forKey:@"detail.microBlog"];
    }
    // detail.wangwang 旺旺
    NSString *aliWangWang = iCard.aliWangWang;
    if (aliWangWang) {
        [result setObject:aliWangWang forKey:@"detail.wangwang"];
    }
    // detail.businessScope 业务范围
    NSString *businessScope = iCard.businessScope;
    if (businessScope) {
        [result setObject:businessScope forKey:@"detail.businessScope"];
    }
    // detail.openBank 开户行
    NSString *bankBranch = iCard.bankAccountBranch;
    if (bankBranch) {
        [result setObject:bankBranch forKey:@"detail.openBank"];
    }
    // detail.bankNO 银行账号
    NSString *bankNumber = iCard.bankAccountNumber;
    if (bankNumber) {
        [result setObject:bankNumber forKey:@"detail.bankNO"];
    }
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
    } else if (KHHCardModelTypePrivateCard == cardType) {
        query = @"kinghhPrivateCardService.create";
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
    } else if (KHHCardModelTypePrivateCard == cardType) {
        query = @"kinghhPrivateCardService.update";
        parameters[@"card.id"] = iCard.id;
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
            @"number" : ([count integerValue]? count: @"50"),
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
