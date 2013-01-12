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
- (void)syncTemplatesAfterDate:(NSString *)lastDate delegate:(id<KHHNetAgentTemplateDelegates>) delegate;
@end
