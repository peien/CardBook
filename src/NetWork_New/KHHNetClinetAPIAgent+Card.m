//
//  KHHNetClinetAPIAgent+Card.m
//  CardBook
//
//  Created by CJK on 13-1-12.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent+Card.h"
#import "Card.h"
#import "UIImage+KHH.h"
#import "ReceivedCard.h"

@implementation KHHNetClinetAPIAgent (Card)

//准备参数
NSMutableDictionary * parametersToCreateOrUpdateCard(InterCard *iCard) {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:10];
    // template
    [result setObject:(iCard.templateID? iCard.templateID.stringValue: @"")
               forKey:@"template"];
    /*  cardType 名片类型 取值如下： 个人名片、公司名片、客服名片
    [result setObject: iCard.cardType ? iCard.cardType : @""
                   forKey:@"cardType"];
    //  cardSource 名片来源 取值如下：导入名片、客户端自建名片、服务端自建名片、个人用户创建名片
    [result setObject:iCard.cardSource ? iCard.cardSource : @""
                   forKey:@"cardSource"];
     */
    // detail.trueName
    [result setObject:(iCard.name? iCard.name:  @"")
               forKey:@"detail.trueName"];
    // detail.jobTitle
    [result setObject:(iCard.title? iCard.title: @"")
               forKey:@"detail.jobTitle"];
    // detail.contact.email
    [result setObject:(iCard.email? iCard.email: @"")
               forKey:@"detail.contact.email"];
    // detail.companyName
    [result setObject:(iCard.companyName? iCard.companyName: @"")
               forKey:@"detail.companyName"];
    // detail.address.country
    [result setObject:(iCard.addressCountry? iCard.addressCountry: @"")
               forKey:@"detail.address.country"];
    // detail.address.province
    [result setObject:(iCard.addressProvince? iCard.addressProvince: @"")
               forKey:@"detail.address.province"];
    // detail.address.city
    [result setObject:(iCard.addressCity? iCard.addressCity: @"")
               forKey:@"detail.address.city"];
    // detail.address.address
    [result setObject:(iCard.addressOther? iCard.addressOther: @"")
               forKey:@"detail.address.address"];
    // detail.address.zipcode 邮编
    [result setObject:(iCard.addressZip? iCard.addressZip: @"")
               forKey:@"detail.address.zipcode"];
    // detail.contact.telephone 固定电话
    [result setObject:(iCard.telephone? iCard.telephone: @"")
               forKey:@"detail.contact.telephone"];
    // detail.contact.mobile 手机
    [result setObject:(iCard.mobilePhone? iCard.mobilePhone: @"")
               forKey:@"detail.contact.mobile"];
    // detail.contact.fax
    [result setObject:(iCard.fax? iCard.fax: @"")
               forKey:@"detail.contact.fax"];
    // detail.contact.qq
    [result setObject:(iCard.qq? iCard.qq: @"")
               forKey:@"detail.contact.qq"];
    // detail.contact.msn
    [result setObject:(iCard.msn? iCard.msn: @"")
               forKey:@"detail.contact.msn"];
    // detail.contact.homePage
    [result setObject:(iCard.web? iCard.web: @"")
               forKey:@"detail.contact.homePage"];
    [result setObject:(iCard.companyEmail? iCard.companyEmail: @"")
               forKey:@"detail.companyEmail"];
    // detail.detail.department 部门
    [result setObject:(iCard.department? iCard.department: @"")
               forKey:@"detail.detail.department"];
    // detail.detail.memo 备注（名片中可看到）
    [result setObject:(iCard.remarks? iCard.remarks: @"")
               forKey:@"detail.detail.memo"];
    // detail.contact.microBlog 微博
    [result setObject:(iCard.microblog? iCard.microblog: @"")
               forKey:@"detail.contact.microBlog"];
    // detail.contact.wangwang 旺旺
    [result setObject:(iCard.aliWangWang? iCard.aliWangWang: @"")
               forKey:@"detail.contact.wangwang"];
    // detail.businessScope 业务范围
    [result setObject:(iCard.businessScope? iCard.businessScope: @"")
               forKey:@"detail.businessScope"];
    // detail.openBank 开户行
    [result setObject:(iCard.bankAccountBranch? iCard.bankAccountBranch: @"")
               forKey:@"bankCardNo.name"];
    // detail.bankNO 银行账号
    [result setObject:(iCard.bankAccountNumber? iCard.bankAccountNumber: @"")
               forKey:@"bankCardNo.name"];
    //    // detail.moreInfo 其他
    //    [result setObject:(iCard.moreInfo? iCard.moreInfo: @"")
    //               forKey:@"detail.moreInfo"];
    return result;
}

#pragma mark - 名片查询---同步(私有与自己的名片);
- (void)syncCard:(NSString *)lastDate delegate:(id<KHHNetAgentCardDelegate>) delegate
{
    
    if (![self networkStateIsValid]) {
        if ([delegate respondsToSelector:@selector(syncCardFailed:)]) {
            NSDictionary * dict = [self networkUnableFailedResponseDictionary];
            [delegate syncCardFailed:dict];
        }
        return;
    }
    //url format
    NSString *path = @"card/sync";
    if (lastDate.length > 0) {
        //以前同步过
        path = [NSString stringWithFormat:@"%@/%@", path, lastDate];
    }
    
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *op, id response) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:response];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
        
        // 把返回的数据转成本地数据
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        // errorCode
        dict[kInfoKeyErrorCode] = @(code);
        if (KHHErrorCodeSucceeded == code) {
#warning 服务器那边返回数据还未定义好
            dict[kInfoKeyCount] = responseDict[JSONDataKeyCount];
            dict[@"myPrivateCard"] = responseDict[@"myPrivateCard"];
            // synTime -> syncTime
            NSString *syncTime = responseDict[@"syncTime"];
            dict[kInfoKeySyncTime] = syncTime? syncTime: @"";
            
            //同步成功,把解析后的数据传出，上层去保存数据
            if ([delegate respondsToSelector:@selector(syncCardSuccess:)]) {
                [delegate syncCardSuccess:dict];
            }
        }else {
            //错误码
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //同步失败，返回错误信息
            if ([delegate respondsToSelector:@selector(syncCardFailed:)]) {
                [delegate syncCardFailed:dict];
            }
        }
    };
    
    //其它失败的block
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"syncCardFailed:"];
    
    //发送请求
    [self getPath:path parameters:nil success:success failure:failed];
    
}

#pragma mark - 联系人查询---同步;
- (void)syncCustomerCard:(NSString *) startPage pageSize:(NSString *) pageSize lastDate:(NSString *)lastDate delegate:(id<KHHNetAgentCardDelegate>) delegate
{
    if (![self networkStateIsValid:delegate selector:@"syncCustomerCardFailed:"])
    {
        return;
    }
    //url format
#warning 服务器还未定义
    NSString *path = @"cardSendedRecievedRecord/sync";
    if (lastDate.length > 0) {
        //以前同步过
        path = [NSString stringWithFormat:@"%@/%@", path, lastDate];
    }
    
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *op, id response) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:response];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
        
        // 把返回的数据转成本地数据
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        // errorCode
        dict[kInfoKeyErrorCode] = @(code);
        if (KHHErrorCodeSucceeded == code) {
#warning 服务器那边返回数据还未定义好
            
            //同步成功,把解析后的数据传出，上层去保存数据
            if ([delegate respondsToSelector:@selector(syncCustomerCardSuccess:)]) {
                [delegate syncCustomerCardSuccess:dict];
            }
        }else {
            //错误码
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //同步失败，返回错误信息
            if ([delegate respondsToSelector:@selector(syncCustomerCardFailed:)]) {
                [delegate syncCustomerCardFailed:dict];
            }
        }
    };
    
    //其它失败的block
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"syncCustomerCardFailed:"];
    
    //发送请求
    [self getPath:path parameters:nil success:success failure:failed];
    
}

#pragma mark - 名片新增
- (void)addCard:(InterCard *)iCard delegate:(id<KHHNetAgentCardDelegate>) delegate
{
    [self addCard:iCard logoImage:nil cardLinks:nil delegate:delegate];
}

- (void)addCard:(InterCard *)iCard logoImage:(UIImage *) logoImage cardLinks:(NSArray *) cardLinks delegate:(id<KHHNetAgentCardDelegate>) delegate
{
    //检查网络
    if (![self networkStateIsValid:delegate selector:@"addCardFailed:"]) {
        return;
    }
    
    //检查参数
    if (!iCard) {
        [self parametersNotMeetRequirementFailedResponse:delegate selector:@"addCardFailed:"];
        return;
    }
    
    //url
    NSString *path = @"card";
    //准备参数
    NSMutableDictionary *parameters = parametersToCreateOrUpdateCard(iCard);

    // 图片
    KHHConstructionBlock construction = ^(id <AFMultipartFormData> formData) {
        //第2-N帧 现在服务只让传一个，现在要真的设置第2到N帧时可能只会上传最后一帧
        int index = 1;
        for (UIImage *image in cardLinks) {
            // cardlink.idx 第几帧
            [parameters setObject:[NSString stringWithFormat:@"%d", index]
                           forKey:@"cardlink.idx"];
            NSData *imageData = [image resizedImageDataForKHHUpload];
            [formData appendPartWithFileData:imageData
                                        name:@"cardlink.img"
                                    fileName:@"cardlink.img"
                                    mimeType:@"image/jpeg"];
            index ++;
        }
        
        //头像
        if (logoImage) {
            NSData *imageData = [logoImage resizedImageDataForKHHUpload];
            [formData appendPartWithFileData:imageData
                                        name:@"logoUrl"
                                    fileName:@"logoUrl"
                                    mimeType:@"image/jpeg"];
        }
    };
    
    //服务器有返回值
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        DLog(@"[II] response = %@", responseDict);
        // 把返回的数据转成本地数据
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        if (KHHErrorCodeSucceeded == code) {
            //添加成功, 返回到data层进行同步
            if ([delegate respondsToSelector:@selector(addCardSuccess:)]) {
                [delegate addCardSuccess:responseDict];
            }
        }else {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
            // errorCode
            dict[kInfoKeyErrorCode] = @(code);
            //错误信息
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //添加失败，返回失败信息
            if ([delegate respondsToSelector:@selector(addCardFailed:)]) {
                [delegate addCardFailed:dict];
            }
        }
    };
    
    //其他错误返回
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"addCardFailed:"];
    
    //调接口
    [self multipartFormRequestWithPOSTPath:path parameters:parameters constructingBodyWithBlock:construction success:success failure:failed];
}

#pragma mark - 名片删除
/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=259
 * 名片删除 (除联系人)
 * url card/{cardid}
 * 方法 delete
 */
- (void)deleteCard:(Card *)card delegate:(id<KHHNetAgentCardDelegate>) delegate
{
    //检查网络
    if (![self networkStateIsValid:delegate selector:@"deleteCardFailed:"]) {
        return;
    }
    
    //检查参数
    if (!card || card.id.longValue < 0) {
        [self parametersNotMeetRequirementFailedResponse:delegate selector:@"deleteCardFailed:"];
        return;
    }
    
    //url
    NSString *pathFormat = @"card/%ld";
    NSString *path = [NSString stringWithFormat:pathFormat, card.id.longValue];
    
    //服务器有返回值
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        DLog(@"[II] response = %@", responseDict);
        // 把返回的数据转成本地数据
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        if (KHHErrorCodeSucceeded == code) {
            //删除成功, 返回到data层进行保存
            if ([delegate respondsToSelector:@selector(deleteCardSuccess)]) {
                [delegate deleteCardSuccess];
            }
        }else {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
            // errorCode
            dict[kInfoKeyErrorCode] = @(code);
            //错误信息
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //删除失败，返回失败信息
            if ([delegate respondsToSelector:@selector(deleteCardFailed:)]) {
                [delegate deleteCardFailed:dict];
            }
        }
    };
    
    //其他错误返回
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"deleteCardFailed:"];
    
    //调接口
    [self deletePath:path parameters:nil success:success failure:failed];
}

#pragma mark - 名片编辑
- (void)updateCard:(InterCard *)iCard delegate:(id<KHHNetAgentCardDelegate>) delegate
{
    [self updateCard:iCard logoImage:nil cardLinks:nil delegate:delegate];
}
- (void)updateCard:(InterCard *)iCard logoImage:(UIImage *) logoImage cardLinks:(NSArray *) cardLinks delegate:(id<KHHNetAgentCardDelegate>) delegate
{
    //检查网络
    if (![self networkStateIsValid:delegate selector:@"updateCardFailed:"]) {
        return;
    }
    
    //检查参数
    if (!iCard) {
        [self parametersNotMeetRequirementFailedResponse:delegate selector:@"updateCardFailed:"];
        return;
    }
    
    //url
    NSString *path = @"card/update";
    //准备参数
    NSMutableDictionary *parameters = parametersToCreateOrUpdateCard(iCard);
    
    //id添加进去
    [parameters setObject:iCard.id.stringValue forKey:@"id"];
    
    // 图片
    KHHConstructionBlock construction = ^(id <AFMultipartFormData> formData) {
        //第2-N帧 现在服务只让传一个，现在要真的设置第2到N帧时可能只会上传最后一帧
        int index = 1;
        for (UIImage *image in cardLinks) {
            // cardlink.idx 第几帧
            [parameters setObject:[NSString stringWithFormat:@"%d", index]
                           forKey:@"cardlink.idx"];
            NSData *imageData = [image resizedImageDataForKHHUpload];
            [formData appendPartWithFileData:imageData
                                        name:@"cardlink.img"
                                    fileName:@"cardlink.img"
                                    mimeType:@"image/jpeg"];
            index ++;
        }
        
        //头像
        if (logoImage) {
            NSData *imageData = [logoImage resizedImageDataForKHHUpload];
            [formData appendPartWithFileData:imageData
                                        name:@"logoUrl"
                                    fileName:@"logoUrl"
                                    mimeType:@"image/jpeg"];
        }
    };
    
    //服务器有返回值
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        DLog(@"[II] response = %@", responseDict);
        // 把返回的数据转成本地数据
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        if (KHHErrorCodeSucceeded == code) {
            //更新成功, 返回到data层进行同步
            if ([delegate respondsToSelector:@selector(updateCardSuccess)]) {
                [delegate updateCardSuccess];
            }
        }else {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
            // errorCode
            dict[kInfoKeyErrorCode] = @(code);
            //错误信息
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //更新失败，返回失败信息
            if ([delegate respondsToSelector:@selector(updateCardFailed:)]) {
                [delegate updateCardFailed:dict];
            }
        }
    };
    
    //其他错误返回
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"updateCardFailed:"];
    
    //调接口
    [self multipartFormRequestWithPOSTPath:path parameters:parameters constructingBodyWithBlock:construction success:success failure:failed];
}

#pragma mark - 联系人新名片状态标记
/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=262
 * 设置联系人的状态为已查看
 * url customer/{myUser_id}/{customerUser_id}/{customercard_id}/customoercard_version}
 * 方法 put
 */
- (void)updateCardReadState:(Card *)card myUserID:(long) userID delegate:(id<KHHNetAgentCardDelegate>) delegate
{
    //检查网络
    if (![self networkStateIsValid:delegate selector:@"updateCardNewCardStateFailed:"]) {
        return;
    }
    
    //检查参数
    if (!card || card.id.longValue < 0 || userID <= 0) {
        [self parametersNotMeetRequirementFailedResponse:delegate selector:@"updateCardNewCardStateFailed:"];
        return;
    }
    
    //url
    NSString *pathFormat = @"customer/%ld/%ld/%ld/%ld";
    NSString *path = [NSString stringWithFormat:pathFormat, userID, card.userID.longValue, card.id.longValue, card.version.longValue];
    
    //服务器有返回值
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        DLog(@"[II] response = %@", responseDict);
        // 把返回的数据转成本地数据
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        if (KHHErrorCodeSucceeded == code) {
            //更新成功, 返回到data层进行保存
            if ([delegate respondsToSelector:@selector(updateCardNewCardStateSuccess)]) {
                [delegate updateCardNewCardStateSuccess];
            }
        }else {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
            // errorCode
            dict[kInfoKeyErrorCode] = @(code);
            //错误信息
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //更新失败，返回失败信息
            if ([delegate respondsToSelector:@selector(updateCardNewCardStateFailed:)]) {
                [delegate updateCardNewCardStateFailed:dict];
            }
        }
    };
    
    //其他错误返回
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"updateCardNewCardStateFailed:"];
    
    //调接口
    [self putPath:path parameters:nil success:success failure:failed];
}


#pragma mark - 发送名片
- (void)sendCard:(Card *)myReplyCard toPhones:(NSArray *)newMobiles delegate:(id<KHHNetAgentCardDelegate>) delegate
{
}


/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=282
 * 按照认识时间排序的最后一个联系人
 * url customer/last
 * 方法 put
 */
- (void)latestCustomerCard:(id<KHHNetAgentCardDelegate>) delegate
{
    //检查网络
    if (![self networkStateIsValid:delegate selector:@"getLatestCustomerCardFailed:"]) {
        return;
    }
    //url format
    NSString *path = @"customer/last";
    
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *op, id response) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:response];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
        
        // 把返回的数据转成本地数据
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        // errorCode
        dict[kInfoKeyErrorCode] = @(code);
        if (KHHErrorCodeSucceeded == code) {
            // cardBookVO -> InterCard
            InterCard *iCard = [InterCard interCardWithReceivedCardJSON:responseDict[JSONDataKeyCardBookVO]];
            dict[kInfoKeyInterCard] = iCard;
            
            //同步成功,把解析后的数据传出，上层去保存数据
            if ([delegate respondsToSelector:@selector(getLatestCustomerCardSuccess:)]) {
                [delegate getLatestCustomerCardSuccess:dict];
            }
        }else {
            //错误码
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //同步失败，返回错误信息
            if ([delegate respondsToSelector:@selector(getLatestCustomerCardFailed:)]) {
                [delegate getLatestCustomerCardFailed:dict];
            }
        }
    };
    
    //其它失败的block
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"getLatestCustomerCardFailed:"];
    
    //发送请求
    [self getPath:path parameters:nil success:success failure:failed];

}

#pragma mark - markIsRead
- (void)markIsRead:(ReceivedCard *)aCard delegate:(id<KHHNetAgentCardDelegate>)delegate
{
    if (![self networkStateIsValid:delegate selector:@"markIsReadFailed:"]) {
        return;
    }
    //url format
    NSString *path = [NSString stringWithFormat:@"cardSendedRecievedRecord/%lld",aCard.idValue];
    
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *op, id response) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:response];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
        
        // 把返回的数据转成本地数据
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        // errorCode
        dict[kInfoKeyErrorCode] = @(code);
        
        if (KHHErrorCodeSucceeded == code) {
            //同步成功,把解析后的数据传出，上层去保存数据
            dict[@"card"] = aCard;
            if ([delegate respondsToSelector:@selector(markIsReadSuccess:)]) {
                [delegate markIsReadSuccess:dict];
            }
        }else {
            //错误码
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //同步失败，返回错误信息
            if ([delegate respondsToSelector:@selector(markIsReadFailed:)]) {
                [delegate markIsReadFailed:dict];
            }
        }
    };
    
    //其它失败的block
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"markIsReadFailed:"];
    
    //发送请求
    [self putPath:path parameters:nil success:success failure:failed];

}

@end
