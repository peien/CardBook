//
//  KHHDataNew+CustomerEvaluation.m
//  CardBook
//
//  Created by 王定方 on 13-1-15.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew+CustomerEvaluation.h"
#import "CustomerEvaluation.h"
@implementation KHHDataNew (CustomerEvaluation)
@dynamic syncType;
#pragma mark -  客户评估信息增量接口
- (void)syncCustomerEvaluation:(id<KHHDataCustomerEvaluationDelegate>) delegate
{
    [self syncCustomerEvaluation:delegate syncType:KHHCustomerEvaluationSyncTypeSync];
}

- (void)syncCustomerEvaluation:(id<KHHDataCustomerEvaluationDelegate>) delegate syncType:(KHHCustomerEvaluationSyncType) syncType
{
    self.delegate = delegate;
    self.syncType = syncType;
    SyncMark *syncMark = [SyncMark syncMarkByKey:kSyncMarkKeyCustomerEvaluationLastTime];
    [self.agent syncCustomerEvaluationWithDate:syncMark.value delegate:self];
}

#pragma mark - 客户评估信息新增
- (void)addCustomerEvaluation:(ICustomerEvaluation *)icv aboutCustomer:(Card *)aCard withMyCard:(MyCard *)myCard  delegate:(id<KHHDataCustomerEvaluationDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent addCustomerEvaluation:icv aboutCustomer:aCard withMyCard:myCard delegate:self];
}


#pragma mark - 客户评估信息修改
- (void)updateCustomerEvaluation:(ICustomerEvaluation *)icv aboutCustomer:(Card *)aCard withMyCard:(MyCard *)myCard  delegate:(id<KHHDataCustomerEvaluationDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent updateCustomerEvaluation:icv
                           aboutCustomer:aCard
                              withMyCard:myCard delegate:self];
}

#pragma mark - 客户评估删除
-(void)deleteCustomerEvaluationByID:(long) CEID delegate:(id<KHHDataCustomerEvaluationDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent deleteCustomerEvaluationByID:CEID delegate:self];
}

#pragma mark - 查询单个客户评估信息
-(void)syncSingleCustomerEvaluationWithID:(long)CustomerUserID myUserID:(long)myUserID delegate:(id<KHHDataCustomerEvaluationDelegate>)delegate
{
    self.delegate = delegate;
    [self.agent syncSingleCustomerEvaluationWithID:CustomerUserID myUserID:myUserID delegate:self];
}

#pragma mark - KHHNetAgentCustomerEvaluationDelegates
//同步客户评估
-(void)syncCustomerEvaluationSuccess:(NSDictionary *) dict
{
    //把返回的数据保存在本地数据库
    // 1.List
    NSArray *list = dict[kInfoKeyObjectList];
    for (ICustomerEvaluation *icv in list) {
        // 根据ID查，无则新建。
        CustomerEvaluation *ce = (CustomerEvaluation *)[CustomerEvaluation
                                                        objectByID:icv.id
                                                        createIfNone:YES];
        if (icv.isDeleted.boolValue) {
            // 已删除，则删除。
            [self.context deleteObject:ce];
        } else {
            // 未删除，则填数据。
            [ce updateWithIObject:icv];
        }
    }
    // 2.Timestamp
    [SyncMark UpdateKey:kSyncMarkKeyCustomerEvaluationLastTime
                  value:dict[kInfoKeySyncTime]];
    // 3.保存
    [self saveContext];
    
    //告诉界面,同步成功
    switch (self.syncType) {
        case KHHCustomerEvaluationSyncTypeAdd:
        {
            if ([self.delegate respondsToSelector:@selector(addCustomerEvaluationForUISuccess)]) {
                [self.delegate addCustomerEvaluationForUISuccess];
            }
        }
            break;
        case KHHCustomerEvaluationSyncTypeUpdate:
        {
            if ([self.delegate respondsToSelector:@selector(updateCustomerEvaluationForUISuccess)]) {
                [self.delegate updateCustomerEvaluationForUISuccess];
            }
        }
            break;
        case KHHCustomerEvaluationSyncTypeDelete:
        {
            if ([self.delegate respondsToSelector:@selector(deleteCustomerEvaluationForUISuccess)]) {
                [self.delegate deleteCustomerEvaluationForUISuccess];
            }
        }
            break;
        default:
            if ([self.delegate respondsToSelector:@selector(syncCustomerEvaluationForUISuccess)]) {
                [self.delegate syncCustomerEvaluationForUISuccess];
            }
            break;
    }
}

-(void)syncCustomerEvaluationFailed:(NSDictionary *) dict
{
    switch (self.syncType) {
        case KHHCustomerEvaluationSyncTypeAdd:
        {
            if ([self.delegate respondsToSelector:@selector(addCustomerEvaluationForUIFailed:)]) {
                [self.delegate addCustomerEvaluationForUIFailed:dict];
            }
        }
            break;
        case KHHCustomerEvaluationSyncTypeUpdate:
        {
            if ([self.delegate respondsToSelector:@selector(updateCustomerEvaluationForUIFailed:)]) {
                [self.delegate updateCustomerEvaluationForUIFailed:dict];
            }
        }
            break;
        case KHHCustomerEvaluationSyncTypeDelete:
        {
            if ([self.delegate respondsToSelector:@selector(deleteCustomerEvaluationForUIFailed:)]) {
                [self.delegate deleteCustomerEvaluationForUIFailed:dict];
            }
        }
            break;
        default:
            if ([self.delegate respondsToSelector:@selector(syncCustomerEvaluationForUIFailed:)]) {
                [self.delegate syncCustomerEvaluationForUIFailed:dict];
            }
            break;
    }
}

//新增客户评估
-(void)addCustomerEvaluationSuccess:(NSDictionary *) dict
{
    //本想调单个客户的同步，但名片可能是自建的，那use_id不准确
    //添加成功
//    ICustomerEvaluation *icv = dict[kInfoKeyObject];
//    // 根据ID查，无则新建。
//    CustomerEvaluation *ce = (CustomerEvaluation *)[CustomerEvaluation
//                                                    objectByID:icv.id
//                                                    createIfNone:YES];
//    if (icv.isDeleted.boolValue) {
//        // 已删除，则删除。
//        [self.context deleteObject:ce];
//    } else {
//        // 未删除，则填数据。
//        [ce updateWithIObject:icv];
//    }
    
    //与服务器同步
    [self syncCustomerEvaluation:self.delegate syncType:KHHCustomerEvaluationSyncTypeAdd];
}
-(void)addCustomerEvaluationFailed:(NSDictionary *) dict
{
    if ([self.delegate respondsToSelector:@selector(addCustomerEvaluationForUIFailed:)]) {
        [self.delegate addCustomerEvaluationForUIFailed:dict];
    }
}
//更新客户评估
-(void)updateCustomerEvaluationSuccess
{
    //与服务器同步
    [self syncCustomerEvaluation:self.delegate syncType:KHHCustomerEvaluationSyncTypeUpdate];
}
-(void)updateCustomerEvaluationFailed:(NSDictionary *) dict
{
    if ([self.delegate respondsToSelector:@selector(updateCustomerEvaluationForUIFailed:)]) {
        [self.delegate updateCustomerEvaluationForUIFailed:dict];
    }
}
//删除客户评估
-(void)deleteCustomerEvaluationSuccess
{
    //与服务器同步
    [self syncCustomerEvaluation:self.delegate syncType:KHHCustomerEvaluationSyncTypeDelete];
}
-(void)deleteCustomerEvaluationFailed:(NSDictionary *) dict
{
    if ([self.delegate respondsToSelector:@selector(deleteCustomerEvaluationForUIFailed:)]) {
        [self.delegate deleteCustomerEvaluationForUIFailed:dict];
    }
}

//同步单个联系人的客户评估信息
-(void)syncSingleCustomerEvaluationSuccess:(NSDictionary *) dict
{
    //把返回的数据保存在本地数据库
    // 1.List
    NSArray *list = dict[kInfoKeyObjectList];
    for (ICustomerEvaluation *icv in list) {
        // 根据ID查，无则新建。
        CustomerEvaluation *ce = (CustomerEvaluation *)[CustomerEvaluation
                                                        objectByID:icv.id
                                                        createIfNone:YES];
        if (icv.isDeleted.boolValue) {
            // 已删除，则删除。
            [self.context deleteObject:ce];
        } else {
            // 未删除，则填数据。
            [ce updateWithIObject:icv];
        }
    }
    
    // 2.保存
    [self saveContext];
    
    //告诉界面
    if ([self.delegate respondsToSelector:@selector(syncSingleCustomerEvaluationForUISuccess)]) {
        [self.delegate syncSingleCustomerEvaluationForUISuccess];
    }

}
-(void)syncSingleCustomerEvaluationFailed:(NSDictionary *) dict
{
    if ([self.delegate respondsToSelector:@selector(syncSingleCustomerEvaluationForUIFailed:)]) {
        [self.delegate syncSingleCustomerEvaluationForUIFailed:dict];
    }

}
@end
