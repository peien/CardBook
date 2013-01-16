//
//  KHHDataTemplateDelegate.h
//  CardBook
//
//  Created by 王定方 on 13-1-15.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef CardBook_KHHDataTemplateDelegate_h
#define CardBook_KHHDataTemplateDelegate_h
@protocol KHHDataTemplateDelegate <NSObject>
@optional

//同步所有模板,界面做同步成功的事
-(void)syncTemplateForUISuccess;
-(void)syncTemplateForUIFailed:(NSDictionary *) dict;

//根据模板id与版本号获取模板
-(void)syncTemplateWithIDAndVersionForUISuccess;
-(void)syncTemplateWithIDAndVersionForUIFailed:(NSDictionary *) dict;

//根据模板id获取模板的详细信息
-(void)syncTemplateItemsWithTemplateIDForUISuccess;
-(void)syncTemplateItemsWithTemplateIDForUIFailed:(NSDictionary *) dict;

//根据模板id获取模板的详细信息
-(void)syncTemplateItemsWithTemplateIDsForUISuccess;
-(void)syncTemplateItemsWithTemplateIDsForUIFailed:(NSDictionary *) dict;
@end
#endif
