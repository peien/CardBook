//
//  KHHDataGroupDelegate.h
//  CardBook
//
//  Created by 王定方 on 13-1-15.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef CardBook_KHHDataGroupDelegate_h
#define CardBook_KHHDataGroupDelegate_h
@protocol KHHDataGroupDelegate <NSObject>
@optional
//同步分组
-(void) syncGroupForUISuccess;
-(void) syncGroupForUIFailed:(NSDictionary *) dict;

//添加分组
-(void) addGroupForUISuccess;
-(void) addGroupForUIFailed:(NSDictionary *) dict;

//修改分组
-(void) updateGroupNameForUISuccess;
-(void) updateGroupNameForUIFailed:(NSDictionary *) dict;

//删除分组
-(void) deleteGroupForUISuccess;
-(void) deleteGroupForUIFailed:(NSDictionary *) dict;

//修改分组下的组员
-(void) moveGroupMembersForUISuccess;
-(void) moveGroupMembersForUIFailed:(NSDictionary *) dict;

//修改分组下的组员
-(void) getGroupMembersForUISuccess;
-(void) getGroupMembersForUIFailed:(NSDictionary *) dict;
@end


#endif
