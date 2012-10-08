//
//  KHHNetworkAPIAgent+Group.m
//  CardBook
//
//  Created by 孙铭 on 8/29/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgent+Group.h"
#import "KHHNetworkAPIAgent+Card.h"

@implementation KHHNetworkAPIAgent (Group)
/**
 增加分组 groupService.addGroup
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=205
 */
- (BOOL)createGroup:(NSString *)groupName
           userCard:(NSString *)cardID
             parent:(NSString *)parentGroupID {
    if (![groupName length] || ![cardID length]) {
        return NO;
    }
    NSDictionary *parameters = @{
    @"group.groupName" : groupName,
    @"group.cardId"    : cardID,
    @"group.parentId"  : parentGroupID?parentGroupID:@"",
    };
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *op, id response) {
#warning TODO
    };
    [self postAction:@"createGroup"
               query:@"groupService.addGroup"
          parameters:parameters
             success:success];
    return YES;
}
/**
 修改分组 groupService.updateGroup
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=206
 */
- (BOOL)updateGroup:(NSString *)groupID
            newName:(NSString *)newName
          newParent:(NSString *)newParentGroupID {
    if (![groupID length]) {
        return NO;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:3];
    parameters[@"group.id"] = groupID;
    if ([newName length]) {
        parameters[@"group.groupName"] = newName;
    }
    if (newParentGroupID) {
        parameters[@"group.parentId"] = newParentGroupID;
    }
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *op, id response) {
#warning TODO
    };
    [self postAction:@"updateGroup"
               query:@"groupService.updateGroup"
          parameters:parameters
             success:success];
    return YES;
}
/**
 删除分组 groupService.deleteGroup
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=207
 */
- (BOOL)deleteGroup:(NSString *)groupID {
    if (![groupID length]) {
        return NO;
    }
    NSDictionary *parameters = @{ @"group.id" : groupID };
    [self postAction:@"deleteGroup"
               query:@"groupService.deleteGroup"
          parameters:parameters
             success:nil];
    return YES;
}
/**
 获取分组下的客户名片id cardGroupService.getCardIdsByGroupId
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=164
 */
- (BOOL)cardIDsWithinGroup:(NSString *)groupID {
    if (![groupID length]) {
        return NO;
    }
    NSDictionary *parameters = @{ @"cardGroup.groupId": groupID };
    KHHSuccessBlock success = ^(AFHTTPRequestOperation *op, id response) {
#warning TODO
    };
    [self postAction:@"cardIDsWithinGroup"
               query:@"cardGroupService.getCardIdsByGroupId"
          parameters:parameters
             success:success];
    return YES;
}
/**
 移动、删除、添加客户名片到分组 cardGroupService.addOrDelCardGroup
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=154
 */
- (BOOL)moveCards:(NSArray *)cards
        fromGroup:(NSString *)fromGroupID
          toGroup:(NSString *)toGroupID {
    if (![cards count] || !([fromGroupID length] || [toGroupID length])) {
        // cards为nil或不包含任何元素
        // fromGroup和toGroup都为nil或空
        return NO;
    }
    NSMutableArray *idAndTypes = [NSMutableArray arrayWithCapacity:[cards count]];
    for (id card in cards) {
        if (![card isKindOfClass:[Card class]]
            || !CardHasRequiredAttributes(card, KHHCardAttributeID)) {
            return NO;
        }
        NSString *cardID = [[card valueForKey:kAttributeKeyID] stringValue];
        NSString *cardType = [card isKindOfClass:[ReceivedCard class]]?@"linkman"
                            :([card isKindOfClass:[PrivateCard class]]?@"me"
                              :@"private");
        [idAndTypes addObject:[NSString stringWithFormat:@"%@;%@", cardID, cardType]];
    }
    NSDictionary *parameters = @{
    @"cardIdAndTypes" : [idAndTypes componentsJoinedByString:@"|"],
    @"delGroupId"     : fromGroupID?fromGroupID:@"",
    @"addGroupId"     : toGroupID?toGroupID:@"",
    };
    DLog(@"[II] request parameters = %@", parameters);
    
    [self postAction:@"moveCards"
               query:@"cardGroupService.addOrDelCardGroup"
          parameters:parameters
             success:nil];
    return YES;
}

@end
