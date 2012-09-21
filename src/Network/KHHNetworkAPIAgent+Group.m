//
//  KHHNetworkAPIAgent+Group.m
//  CardBook
//
//  Created by 孙铭 on 8/29/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgent+Group.h"
#import "KHHNetworkAPIAgent+Card.h"
#import "NSObject+Notification.h"

/*!
 @fuctiongroup Group参数整理函数
 */
NSMutableDictionary * ParametersFromGroup(Group *group,
                                          KHHGroupAttributes requiredAttributes) {
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:3];
    // id
    NSString *ID = [[group valueForKey:kAttributeKeyID] stringValue];
    if ((requiredAttributes & KHHGroupAttributeID) && ID) {
        [result setObject:(ID.length > 0? ID: @"") forKey:@"group.id"];
    }
    // name
    NSString *name = [group valueForKey:kAttributeKeyName];
    if ((requiredAttributes & KHHGroupAttributeName) && name) {
        [result setObject:(name.length > 0? name: @"") forKey:@"group.groupName"];
    }
    // parentID
    NSString *parentID = [[group valueForKeyPath:kAttributeKeyPathParentID] stringValue];
    if ((requiredAttributes & KHHGroupAttributeParentID) && parentID) {
        [result setObject:(parentID.length > 0? parentID: @"") forKey:@"group.parentId"];
    }
    return result;
}
BOOL GroupHasRequiredAttributes(Group *group,
                                KHHGroupAttributes attributes) {
    NSString *ID = [[group valueForKey:kAttributeKeyID] stringValue];
    NSString *Name = [group valueForKey:kAttributeKeyName];
    NSString *parentID = [[group valueForKeyPath:kAttributeKeyPathParentID] stringValue];
    if ((attributes & KHHGroupAttributeID) && ID.length == 0) {
        return NO;
    }
    if ((attributes & KHHGroupAttributeName) && Name.length == 0) {
        return NO;
    }
    if ((attributes & KHHGroupAttributeParentID) && parentID.length == 0) {
        return NO;
    }
    return YES;
}

@implementation KHHNetworkAPIAgent (Group)
/**
 增加分组 groupService.addGroup
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=205
 */
- (BOOL)createGroup:(Group *)group {
    if (!GroupHasRequiredAttributes(group, KHHGroupAttributeName)) {
        return NO;
    }
    NSDictionary *parameters = ParametersFromGroup(group,
                                                   KHHGroupAttributeName|KHHGroupAttributeParentID);
    [self postAction:@"createGroup"
               query:@"groupService.addGroup"
          parameters:parameters];
    return YES;
}
//- (void)createGroupResultCode:(KHHNetworkStatusCode)code
//                        json:(NSDictionary *)jsonDict {
//    
//    NSString *name = (KHHNetworkStatusCodeSucceeded == code)?
//    KHHNotificationCreateGroupSucceeded
//    : KHHNotificationCreateGroupFailed;
//    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:jsonDict];
//    [dict setValue:[NSNumber numberWithInteger:code] forKey:kInfoKeyErrorCode];
//    
//    [self postNotification:name info:dict];
//}
/**
 修改分组 groupService.updateGroup
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=206
 */
- (BOOL)updateGroup:(Group *)group
            newName:(NSString *)name
          newParent:(Group *)parent {
    if (!GroupHasRequiredAttributes(group, KHHGroupAttributeID)) {
        return NO;
    }
    if (parent && !GroupHasRequiredAttributes(parent, KHHGroupAttributeID)) {
        return NO;
    }
    NSMutableDictionary *parameters = ParametersFromGroup(group, KHHGroupAttributeID);
    if ([name length]) {
        [parameters setObject:name
                       forKey:@"group.groupName"];
    }
    if (parent) {
        [parameters setObject:parent.id.stringValue
                       forKey:@"group.parentId"];
    }
    
    [self postAction:@"updateGroup"
               query:@"groupService.updateGroup"
          parameters:parameters];
    return YES;
}
//- (void)updateGroupResultCode:(KHHNetworkStatusCode)code
//                              json:(NSDictionary *)jsonDict {
//    
//    NSString *name = (KHHNetworkStatusCodeSucceeded == code)?
//    KHHNotificationUpdateGroupSucceeded
//    : KHHNotificationUpdateGroupFailed;
//    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:jsonDict];
//    [dict setValue:[NSNumber numberWithInteger:code] forKey:kInfoKeyErrorCode];
//    
//    [self postNotification:name info:dict];
//}
/**
 删除分组 groupService.deleteGroup
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=207
 */
- (BOOL)deleteGroup:(Group *)group {
    if (!GroupHasRequiredAttributes(group, KHHGroupAttributeID)) {
        return NO;
    }
    NSDictionary *parameters = ParametersFromGroup(group, KHHGroupAttributeID);
    [self postAction:@"deleteGroup"
               query:@"groupService.deleteGroup"
          parameters:parameters];
    return YES;
}
//- (void)deleteGroupResultCode:(KHHNetworkStatusCode)code
//                              json:(NSDictionary *)jsonDict {
//    
//    NSString *name = (KHHNetworkStatusCodeSucceeded == code)?
//    KHHNotificationDeleteGroupSucceeded
//    : KHHNotificationDeleteGroupFailed;
//    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:jsonDict];
//    [dict setValue:[NSNumber numberWithInteger:code] forKey:kInfoKeyErrorCode];
//    
//    [self postNotification:name info:dict];
//}
/**
 获取分组下的客户名片id cardGroupService.getCardIdsByGroupId
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=164
 */
- (BOOL)cardIDsWithinGroup:(Group *)group {
    if (!GroupHasRequiredAttributes(group, KHHGroupAttributeID)) {
        return NO;
    }
    NSDictionary *parameters = @{
    @"cardGroup.groupId": [[group valueForKey:kAttributeKeyID] stringValue]
    };
    [self postAction:@"cardIDsWithinGroup"
               query:@"cardGroupService.getCardIdsByGroupId"
          parameters:parameters];
    return YES;
}
//- (void)cardIDsWithinGroupResultCode:(KHHNetworkStatusCode)code
//                              json:(NSDictionary *)jsonDict {
//    
//    NSString *name = (KHHNetworkStatusCodeSucceeded == code)?
//    KHHNotificationCardIDsWithinGroupSucceeded
//    : KHHNotificationCardIDsWithinGroupFailed;
//    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:jsonDict];
//    [dict setValue:[NSNumber numberWithInteger:code] forKey:kInfoKeyErrorCode];
//    
//    [self postNotification:name info:dict];
//}
/**
 移动、删除、添加客户名片到分组 cardGroupService.addOrDelCardGroup
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=154
 */
- (BOOL)moveCards:(NSArray *)cards
        fromGroup:(Group *)fromGroup
          toGroup:(Group *)toGroup {
    if (0 == [cards count]) {
        // cards为nil或不包含任何元素
        return NO;
    }
    if (!GroupHasRequiredAttributes(fromGroup, KHHGroupAttributeID)
        && !GroupHasRequiredAttributes(toGroup, KHHGroupAttributeID))
    {   // fromGroup和toGroup都为nil（或其id都为空）
        return NO;
    }
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:3];
    [parameters setObject:[[fromGroup valueForKey:kAttributeKeyID] stringValue]
                   forKey:@"delGroupId"];
    [parameters setObject:[[toGroup valueForKey:kAttributeKeyID] stringValue]
                   forKey:@"addGroupId"];
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
    [parameters setObject:[idAndTypes componentsJoinedByString:@"|"]
                   forKey:@"cardIdAndTypes"];
    DLog(@"[II] request parameters = %@", parameters);
    [self postAction:@"moveCards"
               query:@"cardGroupService.addOrDelCardGroup"
          parameters:parameters];
    return YES;
}
//- (void)moveCardsResultCode:(KHHNetworkStatusCode)code
//                            json:(NSDictionary *)jsonDict {
//    
//    NSString *name = (KHHNetworkStatusCodeSucceeded == code)?
//    KHHNotificationMoveCardsSucceeded
//    : KHHNotificationMoveCardsFailed;
//    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:jsonDict];
//    [dict setValue:[NSNumber numberWithInteger:code] forKey:kInfoKeyErrorCode];
//    
//    [self postNotification:name info:dict];
//}

@end
