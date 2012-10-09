//
//  KHHNetworkAPIAgent+Group.h
//  CardBook
//
//  Created by 孙铭 on 8/29/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgent.h"

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
- (BOOL)createGroup:(NSString *)groupName
           userCard:(NSString *)cardID
             parent:(NSString *)parentGroupID;
/**
 修改分组 groupService.updateGroup
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=206
 */
- (BOOL)updateGroup:(NSString *)groupID
            newName:(NSString *)newName
          newParent:(NSString *)newParentGroupID;
/**
 删除分组 groupService.deleteGroup
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=207
 */
- (BOOL)deleteGroup:(NSString *)groupID;
/**
 获取分组下的客户名片id cardGroupService.getCardIdsByGroupId
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=164
 */
- (BOOL)cardIDsWithinGroup:(NSString *)groupID;
/**
 移动、删除、添加客户名片到分组 cardGroupService.addOrDelCardGroup
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=154
 */
- (BOOL)moveCards:(NSArray *)cards
        fromGroup:(NSString *)fromGroupID
          toGroup:(NSString *)toGroupID;
@end
