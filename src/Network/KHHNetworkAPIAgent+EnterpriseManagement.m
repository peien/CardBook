//
//  KHHNetworkAPIAgent+EnterpriseManagement.m
//  CardBook
//
//  Created by 孙铭 on 9/10/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgent+EnterpriseManagement.h"

@implementation KHHNetworkAPIAgent (EnterpriseManagement)
/*!
 根据当前登录用户的公司权限，加载部门列表 employeeViewService.getOrgsByPermission
 @param
 @return
 @see
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=214
 */
- (void)listDepartments {
    [self postAction:@"listDepartments"
               query:@"employeeViewService.getOrgsByPermission"
          parameters:nil
             success:nil];
}
@end
