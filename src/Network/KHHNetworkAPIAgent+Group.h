//
//  KHHNetworkAPIAgent+Group.h
//  CardBook
//
//  Created by 孙铭 on 8/29/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgent.h"
#import "Card.h"
#import "Group.h"
/*!
 Notification names
 */
// Create group
static NSString * const KHHNotificationCreateGroupSucceeded = @"createGroupSucceeded";
static NSString * const KHHNotificationCreateGroupFailed    = @"createGroupFailed";
// Update group
static NSString * const KHHNotificationUpdateGroupSucceeded = @"updateGroupSucceeded";
static NSString * const KHHNotificationUpdateGroupFailed    = @"updateGroupFailed";
// Delete group
static NSString * const KHHNotificationDeleteGroupSucceeded = @"deleteGroupSucceeded";
static NSString * const KHHNotificationDeleteGroupFailed    = @"deleteGroupFailed";
// card IDs in group
static NSString * const KHHNotificationCardIDsWithinGroupSucceeded = @"cardIDsWithinGroupSucceeded";
static NSString * const KHHNotificationCardIDsWithinGroupFailed    = @"cardIDsWithinGroupFailed";
// Move cards from ... to ...
static NSString * const KHHNotificationMoveCardsSucceeded = @"moveCardsSucceeded";
static NSString * const KHHNotificationMoveCardsFailed    = @"moveCardsFailed";

typedef enum {
    KHHGroupAttributeNone     = 0UL,
    KHHGroupAttributeID       = 1UL << 0,
    KHHGroupAttributeName     = 1UL << 1,
    KHHGroupAttributeParentID = 1UL << 2,
    KHHGroupAttributeAll      = ~KHHGroupAttributeNone,
} KHHGroupAttributes;

NSMutableDictionary * ParametersFromGroup(Group *group,
                                          KHHGroupAttributes requiredAttributes);
BOOL GroupHasRequiredAttributes(Group *group, KHHGroupAttributes attributes);

@interface KHHNetworkAPIAgent (Group)
/*!
 增加分组 groupService.addGroup
 @param group
    name      必传
    parentId  父分组id，空或0表示顶级分组
    cardId    当前登录用户所使用的名片id(当支持一个用户属于多个公司时，该项必传)
 @return
    YES 请求已发出
    NO  参数有问题
 */
- (BOOL)createGroup:(Group *)group;
/**
 修改分组 groupService.updateGroup
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=206
 */
- (BOOL)updateGroup:(Group *)group
            newName:(NSString *)name
          newParent:(Group *)parent;
/**
 删除分组 groupService.deleteGroup
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=207
 */
- (BOOL)deleteGroup:(Group *)group;
/**
 获取分组下的客户名片id cardGroupService.getCardIdsByGroupId
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=164
 */
- (BOOL)cardIDsWithinGroup:(Group *)group;
/**
 移动、删除、添加客户名片到分组 cardGroupService.addOrDelCardGroup
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=154
 */
- (BOOL)moveCards:(NSArray *)cards
        fromGroup:(Group *)fromGroup
          toGroup:(Group *)toGroup;
@end
