//
//  KHHDataCompanyDelegate.h
//  CardBook
//
//  Created by 王定方 on 13-1-15.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef CardBook_KHHDataCompanyDelegate_h
#define CardBook_KHHDataCompanyDelegate_h
@protocol KHHDataCompanyDelegate <NSObject>
@optional
//获取公司logo
- (void)getCompanyLogoForUISuccess;
- (void)getCompanyLogoForUIFailed:(NSDictionary *) dict;

//获取公司同事根据部门（看数据要不要保存，不保存就返回数据，保存就可以把参数去掉）
- (void)getColleagueByDepartmentForUISuccess:(NSDictionary *) dict;
- (void)getColleagueByDepartmentForUIFailed:(NSDictionary *) dict;

//获取公司部门列表
- (void)getCompanyDepartmentsForUISuccess:(NSDictionary *) dict;
- (void)getCompanyDepartmentsForUIFailed:(NSDictionary *) dict;
@end


#endif
