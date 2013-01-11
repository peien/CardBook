//
//  KHHNetClinetAPIAgent+Group.h
//  CardBook
//
//  Created by 王定方 on 13-1-10.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent.h"
#import "KHHNetAgentGroupDelegates.h"
@class IGroup;
@class Group;

@interface KHHNetClinetAPIAgent (Group)
/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=242
 * 同步分组
 * 方法 get
 */
- (void) syncGroup:(id<KHHNetAgentGroupDelegates>) delegate;
/*!
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=243
 * 增加分组
 * @param group
 * name      必传
 * parentId  父分组id，空或0表示顶级分组
 * cardId    当前登录用户所使用的名片id(当支持一个用户属于多个公司时，该项必传)
 * 方法 post
 */
- (void) addGroup:(IGroup *)igroup userCardID:(long)cardID delegate:(id<KHHNetAgentGroupDelegates>) delegate;

/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=244
 * 修改分组
 * @param group
 * name      必传
 * parentId  父分组id，空或0表示顶级分组
 * cardId    当前登录用户所使用的名片id(当支持一个用户属于多个公司时，该项必传)
 * 方法 put
 */
- (void) updateGroupName:(IGroup *)igroup delegate:(id<KHHNetAgentGroupDelegates>) delegate;

/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=245
 * 删除分组
 * 方法 delete
 */
- (void) deleteGroup:(long) groupID delegate:(id<KHHNetAgentGroupDelegates>) delegate;

/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=246
 * 取分组下的名片
 * 方法 get
 * 所有分组下的名片  card/cardgroup 方法：GET
 * 指定分组下的名片 card/cardgroup/{cardgroupid} 方法：GET
 */
- (void) getGroupMembers:(id<KHHNetAgentGroupDelegates>) delegate;
- (void) getGroupMembers:(long) groupID delegate:(id<KHHNetAgentGroupDelegates>) delegate;

/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=247
 * 添加、删除、移动客户名片到分组
 * 方法 post
 */
- (void)moveCards:(NSArray *)cards fromGroup:(Group *)fromGroup toGroup:(Group *) toGroup delegate:(id<KHHNetAgentGroupDelegates>) delegate;
@end
