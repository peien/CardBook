//
//  KHHDataNew+Template.m
//  CardBook
//
//  Created by 王定方 on 13-1-15.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew+Template.h"
#import "CardTemplate.h"
#import "CardTemplateItem.h"

@implementation KHHDataNew (Template)
#pragma mark - 获取本地所有公有模板
- (NSArray *) allPublicTemplates  // 公共模板
{
    NSNumber *domainType = @(KHHTemplateDomainTypePublic);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"domainType == %@", domainType];
    NSArray *fetched;
    fetched = [CardTemplate objectArrayByPredicate:predicate
                                   sortDescriptors:nil];
    NSArray *result = fetched;
    return result;
}

#pragma mark - 模板增量接口
- (void)syncTemplatesWithDate:(NSString *)lastDate delegate:(id<KHHDataTemplateDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent syncTemplatesWithDate:lastDate delegate:self];
}

//#pragma mark - 根据模板id和版本获取联系人模板
//- (void)syncTemplatesWithTemplateIDAndVersion:(NSString *) idAndVersions delegate:(id<KHHDataTemplateDelegate>)delegate
//{
//    self.delegate = delegate;
//    [self.agent syncTemplatesWithTemplateIDAndVersion:idAndVersions delegate:self];
//}

#pragma mark - 根据模板id获取模板详细信息
- (void)syncTemplateItemsWithTemplateID:(long) templateID delegate:(id<KHHDataTemplateDelegate>)delegate
{
    self.delegate = delegate;
    [self.agent syncTemplateItemsWithTemplateID:templateID delegate:self];
}

#pragma mark - 一次获取多个模板的详细信息
- (void)syncTemplateItemsWithTemplateIDs:(NSString *) templateIDs delegate:(id<KHHDataTemplateDelegate>)delegate
{
    self.delegate = delegate;
    [self.agent syncTemplateItemsWithTemplateIDs:templateIDs delegate:self];
}

#pragma KHHNetAgentTemplateDelegates
//同步所有模板
-(void)syncTemplateSuccess:(NSDictionary *) dict
{
    DLog(@"syncTemplateSuccess! dict = %@", dict);
    //把返回的数据保存到本地数据库(根据返回的数据，去添加、删除、更新本地数据库中的数据)
    [self mergeTemplates:dict];
    //通知界面
    if ([self.delegate respondsToSelector:@selector(syncTemplateForUISuccess)]) {
        [self.delegate syncTemplateForUISuccess];
    }
}
-(void)syncTemplateFailed:(NSDictionary *) dict
{
    DLog(@"syncTemplateFailed! dict = %@", dict);
    if ([self.delegate respondsToSelector:@selector(syncTemplateForUIFailed:)]) {
        [self.delegate syncTemplateForUIFailed:dict];
    }
}

////根据模板id与版本号获取模板
//-(void)syncTemplateWithIDAndVersionSuccess:(NSDictionary *) dict
//{
//    DLog(@"syncTemplateWithIDAndVersionSuccess! dict = %@", dict);
//    //把返回的数据保存到本地数据库(根据返回的数据，去添加、删除、更新本地数据库中的数据)
//    //通知界面
//    if ([self.delegate respondsToSelector:@selector(syncTemplateWithIDAndVersionForUISuccess)]) {
//        [self.delegate syncTemplateWithIDAndVersionForUISuccess];
//    }
//}
//-(void)syncTemplateWithIDAndVersionFailed:(NSDictionary *) dict
//{
//    DLog(@"syncTemplateWithIDAndVersionFailed! dict = %@", dict);
//    if ([self.delegate respondsToSelector:@selector(syncTemplateWithIDAndVersionForUIFailed:)]) {
//        [self.delegate syncTemplateWithIDAndVersionForUIFailed:dict];
//    }
//}

//根据模板id获取模板的详细信息
-(void)syncTemplateItemsWithTemplateIDSuccess:(NSDictionary *) dict
{
    DLog(@"syncTemplateItemsWithTemplateIDSuccess! dict = %@", dict);
    //把返回的数据保存到本地数据库(根据返回的数据，去添加、删除、更新本地数据库中的数据)
    [self mergeTemplates:dict];
    
    //通知界面
    if ([self.delegate respondsToSelector:@selector(syncTemplateItemsWithTemplateIDForUISuccess)]) {
        [self.delegate syncTemplateItemsWithTemplateIDForUISuccess];
    }
}
-(void)syncTemplateItemsWithTemplateIDFailed:(NSDictionary *) dict
{
    DLog(@"syncTemplateItemsWithTemplateIDFailed! dict = %@", dict);
    if ([self.delegate respondsToSelector:@selector(syncTemplateItemsWithTemplateIDForUIFailed:)]) {
        [self.delegate syncTemplateItemsWithTemplateIDForUIFailed:dict];
    }
}

//根据模板ids获取多个模板的详细信息
-(void)syncTemplateItemsWithTemplateIDsSuccess:(NSDictionary *) dict
{
    DLog(@"syncTemplateItemsWithTemplateIDsSuccess! dict = %@", dict);
    //把返回的数据保存到本地数据库(根据返回的数据，去添加、删除、更新本地数据库中的数据)
    [self mergeTemplates:dict];
    
    //通知界面
    if ([self.delegate respondsToSelector:@selector(syncTemplateItemsWithTemplateIDsForUISuccess)]) {
        [self.delegate syncTemplateItemsWithTemplateIDsForUISuccess];
    }
}

-(void)syncTemplateItemsWithTemplateIDsFailed:(NSDictionary *) dict
{
    DLog(@"syncTemplateItemsWithTemplateIDsFailed! dict = %@", dict);
    if ([self.delegate respondsToSelector:@selector(syncTemplateItemsWithTemplateIDsForUIFailed:)]) {
        [self.delegate syncTemplateItemsWithTemplateIDsForUIFailed:dict];
    }
}

//与本地数据库merge模板
- (void)mergeTemplates:(NSDictionary *) dict
{
    if (!dict) {
        return;
    }
    //1.TemplateList {
    NSArray *list = dict[kInfoKeyTemplateList];
    [CardTemplate processJSONList:list];
    // }
    //2.syncTime {
    NSString *lastDate = dict[kInfoKeySyncTime];
    if (lastDate.length > 0) {
        [SyncMark UpdateKey:kSyncMarkKeyTemplatesLastTime
                      value:dict[kInfoKeySyncTime]];
    }
    
    // }
    // 3.保存
    [self saveContext];
}
@end
