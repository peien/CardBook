//
//  NetClient+Group.m
//  CardBook
//
//  Created by 王定方 on 13-1-10.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent+Group.h"
#import "IGroup.h"
#import "ICardGroupMap.h"
#import "Card.h"
#import "PrivateCard.h"
#import "ReceivedCard.h"
#import "Group.h"

@implementation KHHNetClinetAPIAgent (Group)

/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=242
 * 同步分组
 * 方法 get
 */
- (void) syncGroup:(id<KHHNetAgentGroupDelegates>) delegate
{
    //网络状态
    if (![self networkStateIsValid]) {
        if ([delegate respondsToSelector:@selector(syncGroupFailed:)]) {
            NSDictionary * dict = [self networkUnableFailedResponseDictionary];
            [delegate syncGroupFailed:dict];
        }
        
        return;
    }
    
    //url
    NSString *path = @"cardGroup/groups";
    
    //成功block
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        // 把返回的数据转成本地数据
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
        //成功失败标记
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        dict[kInfoKeyErrorCode] = @(code);
        if (KHHErrorCodeSucceeded == code) {
            // count
            dict[kInfoKeyCount] = responseDict[JSONDataKeyCount];
            
            // groupList -> groupList
            NSArray *oldList = responseDict[JSONDataKeyGroupList];
            // 转换一下
            NSMutableArray *newList = [NSMutableArray arrayWithCapacity:oldList.count];
            for (NSDictionary *grp in oldList) {
                IGroup *igrp = [[IGroup alloc] init];
                igrp.id = grp[JSONDataKeyID];
                igrp.name = grp[@"name"];
                igrp.parentID = grp[JSONDataKeyParentID];
                igrp.cardID = grp[JSONDataKeyCardId];
                [newList addObject:igrp];
            }
            if (newList) {
                dict[kInfoKeyGroupList] = newList;
            }
            
            //todo 同步成功,返回数据到data层保存数据
            if ([delegate respondsToSelector:@selector(syncGroupSuccess:)]) {
                [delegate syncGroupSuccess:dict];
            }
        }else {
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //同步失败
            if ([delegate respondsToSelector:@selector(syncGroupFailed:)]) {
                [delegate syncGroupFailed:dict];
            }
        }
    };
    
    //其它失败的block
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"syncGroupFailed:"];
    
    //发送请求
    [self getPath:path parameters:nil success:success failure:failed];
}

/*!
 http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=243
 增加分组
 @param group
 name      必传
 parentId  父分组id，空或0表示顶级分组
 cardId    当前登录用户所使用的名片id(当支持一个用户属于多个公司时，该项必传)
 方法 post
 */
- (void) addGroup:(IGroup *)igroup userCardID:(long)cardID delegate:(id<KHHNetAgentGroupDelegates>) delegate
{
    //网络状态
    if (![self networkStateIsValid]) {
        if ([delegate respondsToSelector:@selector(addGroupFailed:)]) {
            NSDictionary * dict = [self networkUnableFailedResponseDictionary];
            [delegate addGroupFailed:dict];
        }
        
        return;
    }
    
    //检查参数
    if ( 0 == igroup.name.length) {
        if ([delegate respondsToSelector:@selector(addGroupFailed:)]) {
            NSDictionary * dict = [self parametersNotMeetRequirementFailedResponseDictionary];
            [delegate addGroupFailed:dict];
        }
        
        return;
    }
    
    //请求url的格式
    NSString *path = @"cardGroup";
    
    //参数
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:3];
    //分组名
    parameters[@"name"]  = igroup.name;
    //cardID
    if (cardID > 0) {
        parameters[@"card"] = [NSNumber numberWithLong:cardID];
    }
    //parentID
    if (!igroup.parentID && [igroup.parentID longValue] > 0) {
        parameters[@"parent"] = igroup.parentID;
    }
    
    //其它的col1 - col5目前没用到，就不写了
    
    //成功block
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        // 把返回的数据转成本地数据
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
        //成功失败标记
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        //code号
        dict[kInfoKeyErrorCode] = @(code);
        if (KHHErrorCodeSucceeded == code) {
            //获取groupID
            dict[kInfoKeyID] = [responseDict valueForKey:@"id"];
            //添加成功,返回到data层保存数据或与服务器进行一次同步
            if ([delegate respondsToSelector:@selector(addGroupSuccess:)]) {
                [delegate addGroupSuccess:dict];
            }
        }else {
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //添加失败
            if ([delegate respondsToSelector:@selector(addGroupFailed:)]) {
                [delegate addGroupFailed:dict];
            }
        }
    };
    
    //其它失败的block
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"addGroupFailed:"];
    
    //发送请求
    [self postPath:path parameters:parameters success:success failure:failed];
}


/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=244
 * 修改分组
 * @param group
 * name      必传
 * parentId  父分组id，空或0表示顶级分组
 * cardId    当前登录用户所使用的名片id(当支持一个用户属于多个公司时，该项必传)
 * 方法 post
 */
- (void) updateGroupName:(IGroup *)igroup delegate:(id<KHHNetAgentGroupDelegates>) delegate
{
    //网络状态
    if (![self networkStateIsValid]) {
        if ([delegate respondsToSelector:@selector(updateGroupNameFailed:)]) {
            NSDictionary * dict = [self networkUnableFailedResponseDictionary];
            [delegate updateGroupNameFailed:dict];
        }
        
        return;
    }
    
    //检查参数
    if (0 == igroup.name.length) {
        if ([delegate respondsToSelector:@selector(updateGroupNameFailed:)]) {
            NSDictionary * dict = [self parametersNotMeetRequirementFailedResponseDictionary];
            [delegate updateGroupNameFailed:dict];
        }
        
        return;
    }
    
    //请求url的格式
    NSString *path = @"cardGroup";
    
    //参数
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:4];
    //id
    parameters[@"id"]  = igroup.id;
    //分组名
    parameters[@"name"]  = igroup.name;
    //cardid （区分多公司的）
    if (!igroup.parentID && [igroup.parentID longValue] > 0) {
        parameters[@"card"] = igroup.cardID;
    }
    
    //parentID
    if (!igroup.parentID && [igroup.parentID longValue] > 0) {
        parameters[@"parent"] = igroup.parentID;
    }
    
    //其它的col1 - col5目前没用到，就不写了
    
    //成功block
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        // 把返回的数据转成本地数据
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
        //成功失败标记
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        //code号
        dict[kInfoKeyErrorCode] = @(code);
        if (KHHErrorCodeSucceeded == code) {
            //获取groupID
            dict[kInfoKeyID] = [responseDict valueForKey:JSONDataKeyID];
            //修改成功,返回数据到data层保存数据
            if ([delegate respondsToSelector:@selector(updateGroupNameSuccess:)]) {
                [delegate updateGroupNameSuccess:dict];
            }
        }else {
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //修改失败
            if ([delegate respondsToSelector:@selector(updateGroupNameFailed:)]) {
                [delegate updateGroupNameFailed:dict];
            }
        }
    };
    
    //其它失败的block
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"updateGroupNameFailed:"];
    
    //发送请求
    [self putPath:path parameters:parameters success:success failure:failed];
}


/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=245
 * 删除分组
 * 方法 delete
 */
- (void) deleteGroup:(long) groupID delegate:(id<KHHNetAgentGroupDelegates>) delegate
{
    //网络状态
    if (![self networkStateIsValid]) {
        if ([delegate respondsToSelector:@selector(deleteGroupFailed:)]) {
            NSDictionary * dict = [self networkUnableFailedResponseDictionary];
            [delegate deleteGroupFailed:dict];
        }
        
        return;
    }
    
    //检查参数
    if (groupID <= 0) {
        if ([delegate respondsToSelector:@selector(deleteGroupFailed:)]) {
            NSDictionary * dict = [self parametersNotMeetRequirementFailedResponseDictionary];
            [delegate deleteGroupFailed:dict];
        }
        
        return;
    }
    
    //请求url的格式
    NSString *pathFormat = @"cardGroup/%ld";
    NSString *path = [NSString stringWithFormat:pathFormat, groupID];
    
    //成功block
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        // 把返回的数据转成本地数据
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
        //成功失败标记
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        //code号
        dict[kInfoKeyErrorCode] = @(code);
        if (KHHErrorCodeSucceeded == code) {
            //获取groupID
            dict[kInfoKeyID] = [responseDict valueForKey:JSONDataKeyID];
            //删除成功,返回数据到data层与服务同步或，直接通过id删除本地
            if ([delegate respondsToSelector:@selector(deleteGroupSuccess:)]) {
                [delegate deleteGroupSuccess:dict];
            }
        }else {
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //删除失败
            if ([delegate respondsToSelector:@selector(deleteGroupFailed:)]) {
                [delegate deleteGroupFailed:dict];
            }
        }
    };
    
    //其它失败的block
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"deleteGroupFailed:"];
    
    //发送请求
    [self deletePath:path parameters:nil success:success failure:failed];
}


/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=246
 * 取分组下的名片
 * 方法 get
 * 所有分组下的名片  card/cardgroup 方法：GET
 * 指定分组下的名片 card/cardgroup/{cardgroupid} 方法：GET
 */
- (void) getGroupMembers:(id<KHHNetAgentGroupDelegates>) delegate
{
    //取所有
    [self getGroupMembers:-1 delegate:delegate];
}

- (void) getGroupMembers:(long) groupID delegate:(id<KHHNetAgentGroupDelegates>) delegate
{
    //网络状态
    if (![self networkStateIsValid]) {
        if ([delegate respondsToSelector:@selector(getGroupMembersFailed:)]) {
            NSDictionary * dict = [self networkUnableFailedResponseDictionary];
            [delegate getGroupMembersFailed:dict];
        }
        
        return;
    }
    
    //请求url,默认查所有
    NSString *path = @"card/cardgroup";
    //分组id > 0时查某个组
    if (groupID > 0) {
        path = [NSString stringWithFormat:@"%@/%ld", path, groupID];
    }
    
    //成功block
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        // 把返回的数据转成本地数据
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
        //成功失败标记
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        //code号
        dict[kInfoKeyErrorCode] = @(code);
        if (KHHErrorCodeSucceeded == code) {
            //个数
            dict[kInfoKeyCount] = [responseDict valueForKey:JSONDataKeyCount];
            //cardGroupList
            NSArray *oldList = responseDict[JSONDataKeyCardGroupList];
            // 转换一下
            NSMutableArray *newList = [NSMutableArray arrayWithCapacity:oldList.count];
            for (NSDictionary *cgm in oldList) {
                ICardGroupMap *icgm = [[ICardGroupMap alloc] init];
                icgm.cardID = cgm[JSONDataKeyCardId];
                icgm.cardModelType = [Card CardModelTypeForServerName:cgm[JSONDataKeyCardType]];
                icgm.groupID = cgm[JSONDataKeyGroupId];
                [newList addObject:icgm];
            }
            if (newList) {
                dict[kInfoKeyICardGroupMapList] = newList;
            }
            //同步成功,返回数据到data层与服务同步或，直接通过id删除本地
            if ([delegate respondsToSelector:@selector(getGroupMembersSuccess:)]) {
                [delegate getGroupMembersSuccess:dict];
            }
        }else {
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //同步失败
            if ([delegate respondsToSelector:@selector(getGroupMembersFailed:)]) {
                [delegate getGroupMembersFailed:dict];
            }
        }
    };
    
    //其它失败的block
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"getGroupMembersFailed:"];
    
    //发送请求
    [self getPath:path parameters:nil success:success failure:failed];
}


/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=247
 * 添加、删除、移动客户名片到分组
 * 方法 post
 */
- (void)moveCards:(NSArray *)cards fromGroup:(Group *)fromGroup toGroup:(Group *) toGroup delegate:(id<KHHNetAgentGroupDelegates>) delegate
{
    //网络状态
    if (![self networkStateIsValid]) {
        if ([delegate respondsToSelector:@selector(moveGroupMembersFailed:)]) {
            NSDictionary * dict = [self networkUnableFailedResponseDictionary];
            [delegate moveGroupMembersFailed:dict];
        }
        
        return;
    }
    
    if ([cards count]<=0) {
        if ([delegate respondsToSelector:@selector(moveGroupMembersFailed:)]) {
            NSDictionary * dict = [self parametersNotMeetRequirementFailedResponseDictionary];
            [delegate moveGroupMembersFailed:dict];
        }
    }
    
    //组装成cardIdAndTypes="234;me|345;linkman|456;linkman"格式
    //    NSMutableArray *idAndTypes = [NSMutableArray arrayWithCapacity:[cards count]];
    //    for (id card in cards) {
    //        NSString *cardID = [[card valueForKey:kAttributeKeyID] stringValue];
    //        NSString *cardType = [card isKindOfClass:[ReceivedCard class]]?@"linkman"
    //        :([card isKindOfClass:[PrivateCard class]]?@"me"
    //          :@"private");
    //        [idAndTypes addObject:[NSString stringWithFormat:@"%@;%@", cardID, cardType]];
    //    }
    
    //请求url,默认查所有
    NSString *path = @"cardGroup";
    NSMutableString *ids = [[NSMutableString alloc]init];
    for (int i=0;i<[cards count];i++) {
        Card *card = [cards objectAtIndex:i];
        if (i==0) {
            [ids appendString:[NSString stringWithFormat:@"%lld",card.idValue]];
            continue;
        }
        [ids appendString:[NSString stringWithFormat:@",%lld",card.idValue]];
        
    }
    int groupIdPro;
    if (fromGroup) {
        path = [NSString stringWithFormat:@"%@/%lld/%@",path,fromGroup.idValue,ids];
        groupIdPro = fromGroup.idValue;
    }
    if (toGroup) {
        path = [NSString stringWithFormat:@"%@/%lld/%@",path,toGroup.idValue,ids];
        groupIdPro = toGroup.idValue;
    }
    
    //参数
    //    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:3];
    //    //分组名
    //    parameters[@"cardIdAndTypes"]  = [idAndTypes componentsJoinedByString:KHH_SEPARATOR];
    //    //fromgroupID，fromGroupID <= 0时说原先是没有分组的，所以参数可以不传
    //    parameters[@"delGroupId"]  = fromGroup ? fromGroup.id.stringValue : @"";
    //
    //    //toGroupID, toGroupID <= 0时说明是要把名片移到未分组中去
    //    parameters[@"addGroupId"] = toGroup ? toGroup.id.stringValue : @"";
    
    //成功block
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        // 把返回的数据转成本地数据
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        //成功失败标记
        KHHErrorCode code = [responseDict[kInfoKeyErrorCode] integerValue];
        if (KHHErrorCodeSucceeded == code) {
            //同步成功,返回数据到data层与服务同步一下
            if ([delegate respondsToSelector:@selector(moveGroupMembersSuccess:)]) {
                [delegate moveGroupMembersSuccess:groupIdPro];
            }
        }else {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:5];
            //code号
            dict[kInfoKeyErrorCode] = @(code);
            dict[kInfoKeyErrorMessage] = [responseDict valueForKey:JSONDataKeyNote];
            //同步失败
            if ([delegate respondsToSelector:@selector(moveGroupMembersFailed:)]) {
                [delegate moveGroupMembersFailed:dict];
            }
        }
    };
    
    //其它失败的block
    KHHFailureBlock failed = [self defaultFailedResponse:delegate selector:@"moveGroupMembersFailed:"];
    
    //发送请求
    if (fromGroup) {
        [self deletePath:path parameters:nil success:success failure:failed];
        return;
    }
    [self postPath:path parameters:nil success:success failure:failed];
    
}
@end
