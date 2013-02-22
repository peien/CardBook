//
//  KHHDataNew+Template.h
//  CardBook
//
//  Created by 王定方 on 13-1-15.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew.h"
#import "KHHDataTemplateDelegate.h"
#import "KHHNetClinetAPIAgent+Template.h"
@interface KHHDataNew (Template) <KHHNetAgentTemplateDelegates>
#pragma mark - 获取本地所有公有模板
- (NSArray *) allPublicTemplates;// 公共模板

#pragma mark - 模板增量接口
- (void)doSyncTemplates:(id<KHHDataTemplateDelegate>) delegate;

//#pragma mark - 根据模板id和版本获取联系人模板
//- (void)syncTemplatesWithTemplateIDAndVersion:(NSString *) idAndVersions delegate:(id<KHHDataTemplateDelegate>)delegate;

#pragma mark - 根据模板id获取模板详细信息
- (void)syncTemplateItemsWithTemplateID:(long) templateID delegate:(id<KHHDataTemplateDelegate>)delegate;

#pragma mark - 一次获取多个模板的详细信息
- (void)syncTemplateItemsWithTemplateIDs:(NSString *) templateIDs delegate:(id<KHHDataTemplateDelegate>)delegate;
#pragma mark - use in UI Grouped

- (NSArray *)allPublicTemplates;
@end
