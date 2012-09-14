//
//  KHHNetworkAPIAgent+EnterpriseManagement.h
//  CardBook
//
//  Created by 孙铭 on 9/10/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgent.h"
/*!
 Notification names
 */
// listDepartments
static NSString * const KHHNotificationListDepartmentsSucceeded = @"listDepartmentsSucceeded";
static NSString * const KHHNotificationListDepartmentsFailed    = @"listDepartmentsFailed";

@interface KHHNetworkAPIAgent (EnterpriseManagement)
/*!
 根据当前登录用户的公司权限，加载部门列表 employeeViewService.getOrgsByPermission
 @param
 @return
 @see
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=214
 */
- (void)listDepartments;
@end
