//
//  KHHNetAgentGroupDelegates.h
//  CardBook
//
//  Created by 王定方 on 13-1-10.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef KHH_NetAgent_Group_Delegates
#define KHH_NetAgent_Group_Delegates
@protocol KHHNetAgentGroupDelegates <NSObject>
@optional
//同步分组
-(void) syncGroupSuccess:(NSDictionary *) dict;
-(void) syncGroupFailed:(NSDictionary *) dict;

//添加分组
-(void) addGroupSuccess:(NSDictionary *) dict;
-(void) addGroupFailed:(NSDictionary *) dict;

//修改分组
-(void) updateGroupNameSuccess:(NSDictionary *) dict;
-(void) updateGroupNameFailed:(NSDictionary *) dict;

//删除分组
-(void) deleteGroupSuccess:(NSDictionary *) dict;
-(void) deleteGroupFailed:(NSDictionary *) dict;

//修改分组下的组员
-(void) moveGroupMembersSuccess:(int) groupId;
-(void) moveGroupMembersFailed:(NSDictionary *) dict;

//修改分组下的组员
-(void) getGroupMembersSuccess:(NSDictionary *) dict;
-(void) getGroupMembersFailed:(NSDictionary *) dict;
@end
#endif