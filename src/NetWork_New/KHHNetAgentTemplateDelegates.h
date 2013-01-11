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
-(void) syncTemplateSuccess:(NSDictionary *) dict;
-(void) syncTemplateFailed:(NSDictionary *) dict;
@end
#endif
