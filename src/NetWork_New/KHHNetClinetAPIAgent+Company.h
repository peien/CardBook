//
//  KHHNetClinetAPIAgent+Company.h
//  CardBook
//
//  Created by 王定方 on 13-1-13.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent.h"
#import "KHHNetAgentCompanyDelegates.h"

@interface KHHNetClinetAPIAgent (Company)
/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=297
 * 获取公司logo
 * url company/logo
 * 方法 get
 */
- (void) getCompanyLogo:(id<KHHNetAgentCompanyDelegates>) delegate;


/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=284
 * 获取公司部门
 * url department/departments
 * 方法 get
 */
- (void) getCompanyDepartment:(id<KHHNetAgentCompanyDelegates>) delegate;

/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=280
 * 获取公司logo
 * url department/{department_id}/{startPage}/{pageSize}
 * 方法 get
 */
- (void) getCompanyColleagueByDepartmentID:(long) departmentID startPage:(int) startPage pageSize:(int) pageSize delegate:(id<KHHNetAgentCompanyDelegates>) delegate;
@end
