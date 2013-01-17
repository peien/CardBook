//
//  KHHDataNew+Company.h
//  CardBook
//
//  Created by 王定方 on 13-1-15.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew.h"
#import "KHHDataCompanyDelegate.h"
#import "KHHNetClinetAPIAgent+Company.h"
@interface KHHDataNew (Company) <KHHNetAgentCompanyDelegates>
#pragma mark - 获取公司logo
- (void) getCompanyLogo:(id<KHHDataCompanyDelegate>) delegate;


#pragma mark - 获取公司部门
- (void) getCompanyDepartment:(id<KHHDataCompanyDelegate>) delegate;

#pragma mark - 获取公司logo
- (void) getCompanyColleagueByDepartmentID:(long) departmentID startPage:(int) startPage pageSize:(int) pageSize delegate:(id<KHHDataCompanyDelegate>) delegate;
@end
