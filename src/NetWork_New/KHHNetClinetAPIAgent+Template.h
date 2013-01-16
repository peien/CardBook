//
//  KHHNetClinetAPIAgent+Template.h
//  CardBook
//
//  Created by 王定方 on 13-1-10.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent.h"
#import "KHHNetAgentTemplateDelegates.h"
@interface KHHNetClinetAPIAgent (Template)

/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=234
 * 模板增量接口
 * 方法 get
 */
- (void)syncTemplatesWithDate:(NSString *)lastDate delegate:(id<KHHNetAgentTemplateDelegates>) delegate;

///*
// * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=285
// * 根据模板id和版本获取联系人模板
// * 拼装方法 模板的id和version，id在前，用-连接，多个使用|间隔，如31-1|170-3
// * 方法 get
// */
//- (void)syncTemplatesWithTemplateIDAndVersion:(NSString *) idAndVersions delegate:(id<KHHNetAgentTemplateDelegates>)delegate;

/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=286
 * 根据模板id获取模板详细信息
 * url
 * 方法 get
 */
- (void)syncTemplateItemsWithTemplateID:(long) templateID delegate:(id<KHHNetAgentTemplateDelegates>)delegate;

/*
 * http://192.168.1.151/zentaopms/www/index.php?m=doc&f=view&docID=303
 * 一次获取多个模板的详细信息
 * url template/templates/{templateIds}
 * 方法 get
 * templateIds多个是多个templateId通过英文逗号（,）进行分割的，最后一个id的后面没有逗号，示例：1,2,3,4，表示四个模板
 */
- (void)syncTemplateItemsWithTemplateIDs:(NSString *) templateIDs delegate:(id<KHHNetAgentTemplateDelegates>)delegate;
@end
