//
//  KHHDataNew+Group.h
//  CardBook
//
//  Created by 王定方 on 13-1-15.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew.h"
#import "KHHDataGroupDelegate.h"
#import "KHHNetClinetAPIAgent+Group.h"

//同步类型
typedef enum {
    KHHGroupSyncTypeAdd = 1,
    KHHGroupSyncTypeUpdate,
    KHHGroupSyncTypeDelete,
    KHHGroupSyncTypeSync,
    KHHGroupSyncTypeSyncGroupMenbers,
    KHHGroupSyncTypeSyncGroupMenbersMove,
}   KHHGroupSyncType;

@interface KHHDataNew (Group) <KHHNetAgentGroupDelegates>
@property (assign, nonatomic) KHHGroupSyncType syncType;
#pragma mark - 同步分组
- (void) syncGroup:(id<KHHDataGroupDelegate>) delegate;
#pragma mark - 增加分组
- (void) addGroup:(IGroup *)iGroup userCardID:(long)cardID delegate:(id<KHHDataGroupDelegate>) delegate;

#pragma mark - 修改分组
- (void) updateGroupName:(IGroup *)iGroup delegate:(id<KHHDataGroupDelegate>) delegate;

#pragma mark - 删除分组
- (void) deleteGroup:(long) groupID delegate:(id<KHHDataGroupDelegate>) delegate;

#pragma mark - 取分组下的名片
- (void) getGroupMembers:(id<KHHDataGroupDelegate>) delegate;
- (void) getGroupMembers:(long) groupID delegate:(id<KHHDataGroupDelegate>) delegate;

#pragma mark - 添加、删除、移动客户名片到分组
- (void)moveCards:(NSArray *)cards fromGroup:(Group *)fromGroup toGroup:(Group *) toGroup delegate:(id<KHHDataGroupDelegate>) delegate;
@end
