//
//  KHHNetworkAPIAgent+Group.m
//  CardBook
//
//  Created by 孙铭 on 8/29/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgent+Group.h"
#import "KHHNetworkAPIAgent+Card.h"
#import "NSNumber+SM.h"

@implementation KHHNetworkAPIAgent (Group)
/**
 增加分组 groupService.addGroup
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=205
 */
- (BOOL)createGroup:(IGroup *)igrp
         userCardID:(NSString *)cardID {
    if (![igrp.name length]) {
        return NO;
    }
    NSDictionary *parameters = @{
    @"group.groupName" : igrp.name,
    @"group.cardId"    : cardID,
    @"group.parentId"  : igrp.parentID?igrp.parentID:@"",
    };
    NSString *action = @"createGroup";
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        DLog(@"[II] responseDict = %@", responseDict);
        KHHErrorCode errCode = [responseDict[kInfoKeyErrorCode] integerValue];
        // 把返回的数据转成本地数据
        igrp.id = [NSNumber numberFromObject:responseDict[JSONDataKeyID] zeroIfUnresolvable:NO];
        NSDictionary *dict = @{
        kInfoKeyObject    : igrp,
        kInfoKeyErrorCode : @(errCode),
        };
        NSString *name = NameWithActionAndCode(action, errCode);
        DLog(@"[II] 发送 Notification Name = %@", name);
        [self postASAPNotificationName:name info:dict];
    };
    [self postAction:action
               query:@"groupService.addGroup"
          parameters:parameters
             success:success];
    return YES;
}
/**
 修改分组 groupService.updateGroup
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=206
 */
- (BOOL)updateGroup:(IGroup *)igrp {
    if (!(igrp.id.integerValue)) {
        return NO;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:3];
    parameters[@"group.id"] = igrp.id.stringValue;
    if ([igrp.name length]) {
        parameters[@"group.groupName"] = igrp.name;
    }
    if (igrp.parentID.integerValue) {
        parameters[@"group.parentId"] = igrp.parentID.stringValue;
    }
    NSString *action = @"updateGroup";
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        DLog(@"[II] responseDict = %@", responseDict);
        KHHErrorCode errCode = [responseDict[kInfoKeyErrorCode] integerValue];
        // 把返回的数据转成本地数据
        NSDictionary *dict = @{
        kInfoKeyObject    : igrp,
        kInfoKeyErrorCode : @(errCode),
        };
        NSString *name = NameWithActionAndCode(action, errCode);
        DLog(@"[II] 发送 Notification Name = %@", name);
        [self postASAPNotificationName:name info:dict];
    };
    [self postAction:action
               query:@"groupService.updateGroup"
          parameters:parameters
             success:success];
    return YES;
}
/**
 删除分组 groupService.deleteGroup
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=207
 */
- (BOOL)deleteGroup:(Group *)group {
    if (!(group.idValue)) {
        return NO;
    }
    NSDictionary *parameters = @{ @"group.id" : group.id.stringValue };
    NSString *action = @"deleteGroup";
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        DLog(@"[II] responseDict = %@", responseDict);
        KHHErrorCode errCode = [responseDict[kInfoKeyErrorCode] integerValue];
        // 把待删除的Group也返回
        NSDictionary *dict = @{
        kInfoKeyObject    : group,
        kInfoKeyErrorCode : @(errCode)
        };
        NSString *name = NameWithActionAndCode(action, errCode);
        DLog(@"[II] 发送 Notification Name = %@", name);
        [self postASAPNotificationName:name info:dict];
    };
    [self postAction:action
               query:@"groupService.deleteGroup"
          parameters:parameters
             success:success];
    return YES;
}
/*!
 获得当前登录的所有分组下的联系人 cardGroupService.getCardIdsByCurrUser
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=221
 */
- (void)cardIDsInAllGroupWithExtra:(NSDictionary *)extra {
    NSString *action = kActionNetworkCardIDsInAllGroup;
    NSString *query = @"cardGroupService.getCardIdsByCurrUser";
    NSDictionary *parameters = @{};
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        DLog(@"[II] responseDict = %@", responseDict);
        KHHErrorCode errCode = [responseDict[kInfoKeyErrorCode] integerValue];
        NSArray *oldList = responseDict[JSONDataKeyCardGroupList];
        // 转换一下
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:oldList.count];
        for (NSDictionary *cgm in oldList) {
            ICardGroupMap *icgm = [[ICardGroupMap alloc] init];
            icgm.cardID = cgm[JSONDataKeyCardId];
            icgm.cardModelType = TypeOfCardModelName(cgm[JSONDataKeyCardType]);
            icgm.groupID = cgm[JSONDataKeyGroupId];
            [newList addObject:icgm];
        }
        NSMutableDictionary *info = [NSMutableDictionary dictionaryWithCapacity:3];
        info[kInfoKeyErrorCode] = @(errCode);
        if (newList) {
            info[kInfoKeyICardGroupMapList] = newList;
        }
        if (extra) {
            info[kInfoKeyExtra] = extra;
        }
        [self postASAPNotificationName:NameWithActionAndCode(action, errCode)
                                  info:info];
    };
    [self postAction:action
               query:query
          parameters:parameters
             success:success
               extra:extra];
}

/**
 移动、删除、添加客户名片到分组 cardGroupService.addOrDelCardGroup
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=154
 */
- (BOOL)moveCards:(NSArray *)cards
        fromGroup:(Group *)fromGroup
          toGroup:(Group *)toGroup {
    if (![cards count] || !(fromGroup || toGroup)) {
        // cards为nil或不包含任何元素
        // fromGroup和toGroup都为nil或空
        return NO;
    }
    NSMutableArray *idAndTypes = [NSMutableArray arrayWithCapacity:[cards count]];
    for (id card in cards) {
        NSString *cardID = [[card valueForKey:kAttributeKeyID] stringValue];
        NSString *cardType = [card isKindOfClass:[ReceivedCard class]]?@"linkman"
                            :([card isKindOfClass:[PrivateCard class]]?@"me"
                              :@"private");
        [idAndTypes addObject:[NSString stringWithFormat:@"%@;%@", cardID, cardType]];
    }
    NSDictionary *parameters = @{
    @"cardIdAndTypes" : [idAndTypes componentsJoinedByString:@"|"],
    @"delGroupId"     : fromGroup?fromGroup.id.stringValue:@"",
    @"addGroupId"     : toGroup?toGroup.id.stringValue:@"",
    };
    DLog(@"[II] request parameters = %@", parameters);
    NSString *action = @"moveCards";
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        DLog(@"[II] responseDict = %@", responseDict);
        KHHErrorCode errCode = [responseDict[kInfoKeyErrorCode] integerValue];
        // 把cards fromGroupID toGroupID也返回
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:4];
        dict[kInfoKeyErrorCode]  = @(errCode);
        dict[kInfoKeyObjectList] = cards;
        if (fromGroup) {
            dict[kInfoKeyFromGroup]  = fromGroup;
        }
        if (toGroup) {
            dict[kInfoKeyToGroup]    = toGroup;
        }
        NSString *name = NameWithActionAndCode(action, errCode);
        DLog(@"[II] 发送 Notification Name = %@", name);
        [self postASAPNotificationName:name info:dict];
    };
    [self postAction:action
               query:@"cardGroupService.addOrDelCardGroup"
          parameters:parameters
             success:success];
    return YES;
}

/*!
 获得(某张名片的)父分组下的所有子分组列表(new) groupService.getAllGroups
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=219
 */
- (void)childGroupsOfGroupID:(NSString *)groupID
                  withCardID:(NSString *)cardID
                       extra:(NSDictionary *)extra {
    NSString *action = kActionNetworkChildGroupsOfGroupID;
    NSString *query  = @"groupService.getAllGroups";
    // 检查必传参数
//    if (0 == groupID.length) {// groupID为空或nil
//        // 发失败消息
//        KHHErrorCode errCode = KHHErrorCodeParametersNotMeetRequirement;
//        [self postASAPNotificationName:NameWithActionAndCode(action, errCode)
//                                  info:@{
//                    kInfoKeyErrorCode : @(errCode),
//                 kInfoKeyErrorMessage : @"参数不满足条件!",
//         }];
//        return;
//    }
    NSDictionary *parameters = @{
    @"group.cardId"   : cardID? cardID: @"",
    @"group.parentId" : groupID? groupID: @"",
    };
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *responseDict = [self JSONDictionaryWithResponse:responseObject];
        DLog(@"[II] responseDict = %@", responseDict);
        KHHErrorCode errCode = [responseDict[kInfoKeyErrorCode] integerValue];
        NSArray *oldList = responseDict[JSONDataKeyGroupList];
        // 转换一下
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:oldList.count];
        for (NSDictionary *grp in oldList) {
            IGroup *igrp = [[IGroup alloc] init];
            igrp.id = grp[JSONDataKeyID];
            igrp.name = grp[JSONDataKeyGroupName];
            igrp.parentID = grp[JSONDataKeyParentID];
            [newList addObject:igrp];
        }
        NSMutableDictionary *info = [NSMutableDictionary dictionaryWithCapacity:3];
        info[kInfoKeyErrorCode] = @(errCode);
        if (newList) {
            info[kInfoKeyGroupList] = newList;
        }
        if (extra) {
            info[kInfoKeyExtra] = extra;
        }
        [self postASAPNotificationName:NameWithActionAndCode(action, errCode)
                                  info:info];
    };
    [self postAction:action
               query:query
          parameters:parameters
             success:success];
}

@end
