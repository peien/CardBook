//
//  KHHDataNew+Group.m
//  CardBook
//
//  Created by 王定方 on 13-1-15.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew+Group.h"
#import "Group.h"
@implementation KHHDataNew (Group)



#pragma mark - 同步分组
- (void) doSyncGroup:(id<KHHDataGroupDelegate>) delegate
{
    [self syncGroup:delegate syncType:KHHGroupSyncTypeSync];
}
- (void) syncGroup:(id<KHHDataGroupDelegate>) delegate syncType:(KHHGroupSyncType) syncType
{
    self.delegate = delegate;
    self.syncType = syncType;
    [self.agent syncGroup:self];
}
#pragma mark - 增加分组
- (void) doAddGroup:(IGroup *)iGroup userCardID:(long)cardID delegate:(id<KHHDataGroupDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent addGroup:iGroup userCardID:cardID delegate:self];
}

#pragma mark - 修改分组
- (void) doUpdateGroupName:(IGroup *)iGroup delegate:(id<KHHDataGroupDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent updateGroupName:iGroup delegate:self];
}

#pragma mark - 删除分组
- (void) doDeleteGroup:(long) groupID delegate:(id<KHHDataGroupDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent deleteGroup:groupID delegate:self];
}

#pragma mark - 取分组下的名片
- (void) getGroupMembers:(id<KHHDataGroupDelegate>) delegate
{
    [self getGroupMembers:delegate syncType:KHHGroupSyncTypeSyncGroupMenbers];
}
- (void) getGroupMembers:(long) groupID delegate:(id<KHHDataGroupDelegate>) delegate
{
    [self getGroupMembers:groupID delegate:delegate syncType:KHHGroupSyncTypeSyncGroupMenbers];
}
- (void) getGroupMembers:(id<KHHDataGroupDelegate>) delegate syncType:(KHHGroupSyncType) syncType
{
    self.delegate = delegate;
    self.syncType = syncType;
    [self.agent getGroupMembers:self];
}
- (void) getGroupMembers:(long) groupID delegate:(id<KHHDataGroupDelegate>) delegate syncType:(KHHGroupSyncType) syncType
{
    self.delegate = delegate;
    self.syncType = syncType;
    [self.agent getGroupMembers:groupID delegate:self];
}

#pragma mark - 添加、删除、移动客户名片到分组
- (void)doMoveCards:(NSArray *)cards fromGroup:(Group *)fromGroup toGroup:(Group *) toGroup delegate:(id<KHHDataGroupDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent moveCards:cards fromGroup:fromGroup toGroup:toGroup delegate:self];
}
#pragma mark - KHHNetAgentGroupDelegates
//同步分组
-(void) syncGroupSuccess:(NSDictionary *) dict
{
    NSLog(@"%@",dict);
    DLog(@"syncGroupSuccess! dict = %@", dict);
    //同步分组成功，把返回的分组存到数据库中
    //先删除本地所有分组
    [Group processDeleteAllLocalGroups];
    NSArray *iGroupList = dict[kInfoKeyGroupList];
    // 插入数据库
    for (id igrp in iGroupList) {
        [Group processIObject:igrp];
    }
    [self saveContext];
    
    switch (self.syncType) {
        case KHHGroupSyncTypeAdd:
        {
            if ([self.delegate respondsToSelector:@selector(addGroupForUISuccess)]) {
                [self.delegate addGroupForUISuccess];
            }
        }
            break;
        case KHHGroupSyncTypeUpdate:
        {
            if ([self.delegate respondsToSelector:@selector(updateGroupNameForUISuccess)]) {
                [self.delegate updateGroupNameForUISuccess];
            }
        }
            break;
        case KHHGroupSyncTypeDelete:
        {
            //告诉界面分组删除成功
            if ([self.delegate respondsToSelector:@selector(deleteGroupForUISuccess)]) {
                [self.delegate deleteGroupForUISuccess];
            }
        }
            break;
        default:
        {
            //告诉界面分组同步成功
            if ([self.delegate respondsToSelector:@selector(syncGroupForUISuccess)]) {
                [self.delegate syncGroupForUISuccess];
            }
        }
            break;
    }
}
-(void) syncGroupFailed:(NSDictionary *) dict
{
    DLog(@"syncGroupFailed! dict = %@", dict);
    switch (self.syncType) {
        case KHHGroupSyncTypeAdd:
        {
            if ([self.delegate respondsToSelector:@selector(addGroupForUIFailed:)]) {
                [self.delegate addGroupForUIFailed:dict];
            }
        }
            break;
        case KHHGroupSyncTypeUpdate:
        {
            if ([self.delegate respondsToSelector:@selector(updateGroupNameForUIFailed:)]) {
                [self.delegate updateGroupNameForUIFailed:dict];
            }
        }
            break;
        case KHHGroupSyncTypeDelete:
        {
            //告诉界面分组删除失败
            if ([self.delegate respondsToSelector:@selector(deleteGroupForUIFailed:)]) {
                [self.delegate deleteGroupForUIFailed:dict];
            }
        }
            break;
        default:
        {
            //告诉界面分组同步失败
            if ([self.delegate respondsToSelector:@selector(syncGroupForUIFailed:)]) {
                [self.delegate syncGroupForUIFailed:dict];
            }
        }
            break;
    }
}

//添加分组
-(void) addGroupSuccess:(NSDictionary *) dict
{
    DLog(@"syncGroupSuccess! dict = %@", dict);    
    //同步分组成功，把返回的分组存到数据库中
    [self syncGroup:self.delegate syncType:KHHGroupSyncTypeAdd];
}
-(void) addGroupFailed:(NSDictionary *) dict
{
    DLog(@"syncGroupFailed! dict = %@", dict);
    if ([self.delegate respondsToSelector:@selector(addGroupForUIFailed:)]) {
        [self.delegate addGroupForUIFailed:dict];
    }
}

//修改分组
-(void) updateGroupNameSuccess:(NSDictionary *) dict
{
    DLog(@"updateGroupNameSuccess! dict = %@", dict);
    //修改分组成功，把本地数据库中分组名更新，建议同步（但同步没有增量每次都是拿的全部数据）
    [self syncGroup:self.delegate syncType:KHHGroupSyncTypeUpdate];
}
-(void) updateGroupNameFailed:(NSDictionary *) dict
{
    DLog(@"updateGroupNameFailed! dict = %@", dict);
    if ([self.delegate respondsToSelector:@selector(updateGroupNameForUIFailed:)]) {
        [self.delegate updateGroupNameForUIFailed:dict];
    }
}

//删除分组
-(void) deleteGroupSuccess:(NSDictionary *) dict
{
    DLog(@"deleteGroupSuccess! dict = %@", dict);
    //删除分组成功，把本地数据库中分组删除，建议与服务器进行同步
    [self syncGroup:self.delegate syncType:KHHGroupSyncTypeDelete];
}
-(void) deleteGroupFailed:(NSDictionary *) dict
{
    DLog(@"deleteGroupFailed! dict = %@", dict);
    if ([self.delegate respondsToSelector:@selector(deleteGroupForUIFailed:)]) {
        [self.delegate deleteGroupForUIFailed:dict];
    }
}

//修改分组下的组员
-(void) moveGroupMembersSuccess:(int) groupId;
{
    DLog(@"moveGroupMembersSuccess!");
    //修改分组成功，与服务器同步一下分组组员
    [self getGroupMembers:groupId delegate:self.delegate syncType:KHHGroupSyncTypeSyncGroupMenbersMove];
}
-(void) moveGroupMembersFailed:(NSDictionary *) dict
{
    DLog(@"syncGroupFailed! dict = %@", dict);
    if ([self.delegate respondsToSelector:@selector(moveGroupMembersForUIFailed:)]) {
        [self.delegate moveGroupMembersForUIFailed:dict];
    }
}

//修改分组下的组员
-(void) getGroupMembersSuccess:(NSDictionary *) dict
{
    DLog(@"getGroupMembersSuccess! dict = %@", dict);
    //同步分组成功，把返回的分组存到数据库中
    NSArray *iCardGroupMapList = dict[kInfoKeyICardGroupMapList];
    [Group processDeleteAllCardGroupMaps];
    // 插入数据库
    for (id obj in iCardGroupMapList) {
        [Group processICardGroupMap:obj];
    }
    [self saveContext];
    
    switch (self.syncType) {
        case KHHGroupSyncTypeSyncGroupMenbersMove:
        {
            //告诉界面分组移动成功
            if ([self.delegate respondsToSelector:@selector(moveGroupMembersForUISuccess)]) {
                [self.delegate moveGroupMembersForUISuccess];
            }
        }
            break;
            
        default:
        {
            //告诉界面分组同步成功
            if ([self.delegate respondsToSelector:@selector(getGroupMembersForUISuccess)]) {
                [self.delegate getGroupMembersForUISuccess];
            }
        }
            break;
    }
}
-(void) getGroupMembersFailed:(NSDictionary *) dict
{
    DLog(@"getGroupMembersFailed! dict = %@", dict);
    switch (self.syncType) {
        case KHHGroupSyncTypeSyncGroupMenbersMove:
        {
            //告诉界面分组移动成功
            if ([self.delegate respondsToSelector:@selector(moveGroupMembersForUISuccess)]) {
                [self.delegate moveGroupMembersForUISuccess];
            }
        }
            break;
            
        default:
        {
            //告诉界面分组同步失败
            if ([self.delegate respondsToSelector:@selector(getGroupMembersForUIFailed:)]) {
                [self.delegate getGroupMembersForUIFailed:dict];
            }
        }
            break;
    }
    
    
}

#pragma mark - data from manageContext

- (NSArray *)allTopLevelGroups
{
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent.id = %@", @(0)];
    NSArray *array = [Group objectArrayByPredicate:predicate
                                   sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES selector:@selector(compare:)]]];
    return array;
}

@end
