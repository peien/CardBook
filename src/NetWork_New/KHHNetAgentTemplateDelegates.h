//
//  KHHNetAgentTemplateDelegates.h
//  CardBook
//
//  Created by 王定方 on 13-1-10.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef KHH_NetAgent_Template_Delegates
#define KHH_NetAgent_Template_Delegates
@protocol KHHNetAgentTemplateDelegates <NSObject>
@optional
//同步所有模板
-(void)syncTemplateSuccess:(NSDictionary *) dict;
-(void)syncTemplateFailed:(NSDictionary *) dict;

////根据模板id与版本号获取模板
//-(void)syncTemplateWithIDAndVersionSuccess:(NSDictionary *) dict;
//-(void)syncTemplateWithIDAndVersionFailed:(NSDictionary *) dict;

//根据模板id获取模板的详细信息
-(void)syncTemplateItemsWithTemplateIDSuccess:(NSDictionary *) dict;
-(void)syncTemplateItemsWithTemplateIDFailed:(NSDictionary *) dict;

//根据模板ids获取多个模板的详细信息
-(void)syncTemplateItemsWithTemplateIDsSuccess:(NSDictionary *) dict;
-(void)syncTemplateItemsWithTemplateIDsFailed:(NSDictionary *) dict;

@end
#endif
