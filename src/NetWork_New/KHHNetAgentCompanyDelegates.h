//
//  KHHNetAgentCompanyDelegates.h
//  CardBook
//
//  Created by 王定方 on 13-1-13.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef KHH_NetAgent_Company_Delegates
#define KHH_NetAgent_Company_Delegates
@protocol KHHNetAgentCompanyDelegates <NSObject>
@optional
//获取公司logo
- (void)getCompanyLogoSuccess:(NSDictionary *) dict;
- (void)getCompanyLogoFailed:(NSDictionary *) dict;

//获取公司同事根据部门
- (void)getColleagueByDepartmentSuccess:(NSDictionary *) dict;
- (void)getColleagueByDepartmentFailed:(NSDictionary *) dict;

//获取公司部门列表
- (void)getCompanyDepartmentsSuccess:(NSDictionary *) dict;
- (void)getCompanyDepartmentsFailed:(NSDictionary *) dict;
@end
#endif