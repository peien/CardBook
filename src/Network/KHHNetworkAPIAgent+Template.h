//
//  KHHNetworkAPIAgent+Template.h
//  CardBook
//
//  Created by 孙铭 on 8/29/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHNetworkAPIAgent.h"

@interface KHHNetworkAPIAgent (Template)
/**
 按照模板ID查询模板详细信息 kinghhTemplateService.getOnlyTemplate
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=194
 */
- (BOOL)templateByID:(NSString *)templateID;
/*!
 按照模板ID和version批量查询模板详细信息 kinghhTemplateService.getTemplateLisByIdAndVersion
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=213
 IDs/versions: array of NSString
 */
//- (BOOL)templatesByIDAndVersions:(NSArray *)IDAndVersions;
/**
 模板增量接口 kinghhTemplateService.synTemplate
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=174
 */
- (void)templatesAfterDate:(NSString *)lastDate
                     extra:(NSDictionary *)extra;
@end
