//
//  KHHDataNew+Evaluation.m
//  CardBook
//
//  Created by CJK on 13-1-24.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew+Customer.h"
#import "KHHNetClinetAPIAgent+Customer.h"
@implementation KHHDataNew (Customer)

- (void)doAddUpdateCustomer:(InterCustomer *)iCustomer delegate:(id<KHHDataCustomerDelegate>)delegate
{
    self.delegate = delegate;
    [self.agent addUpdateCustomer:iCustomer delegate:self];
}

- (void)doSyncCustomer:(id<KHHDataCustomerDelegate>)delegate;
{
    self.delegate = delegate;
    SyncMark *syncMark = [SyncMark syncMarkByKey:kSyncMarkKeySyncCustomerLastTime];
    [self.agent syncCustomer:syncMark.value delegate:self];
}

#pragma mark - delegates

- (void)addUpdateCustomerSuccess:(NSDictionary *)dict
{
    self.syncType = KHHCustomerSyncTypeAddUpdate;
    [self doSyncCustomer:self.delegate];
}

- (void)addUpdateCustomerFailed:(NSDictionary *)dict
{
    if ([self.delegate respondsToSelector:@selector(addUpdateCustomerForUIFailed:)]) {
        [self.delegate addUpdateCustomerForUIFailed:dict];
    }
    
}

- (void)syncCustomerSuccess:(NSDictionary *) dict
{
    NSArray *list = dict[@"customerAppraise"];
    for (NSDictionary *dicToICustomer in list) {
        InterCustomer *iCustomer = [[InterCustomer alloc]init];
        iCustomer.customerCard = dicToICustomer[@"customCardId"];
        iCustomer.depth = dicToICustomer[@"relateDepth"];
        iCustomer.cost = dicToICustomer[@"customCost"];
        iCustomer.id = dicToICustomer[@"id"];
        iCustomer.remarks = dicToICustomer[@"remarks"];
        iCustomer.customType = dicToICustomer[@"customType"];
        [iCustomer toDBCustomer];
    }

    // 2.Timestamp
    [SyncMark UpdateKey:kSyncMarkKeySyncCustomerLastTime
                  value:[NSString stringWithFormat:@"%@",dict[kInfoKeySyncTime]]];
    // 3.保存
    [self saveContext];
    
    if (self.syncType == KHHCustomerSyncTypeAddUpdate) {
        if ([self.delegate respondsToSelector:@selector(addUpdateCustomerForUISuccess)]) {
            [self.delegate addUpdateCustomerForUISuccess];
        }
        return;
    }
    if ([self.delegate respondsToSelector:@selector(syncCustomerForUISuccess)]) {
        [self.delegate syncCustomerForUISuccess];
    }
    
}
- (void)syncCustomerFailed:(NSDictionary *) dict
{
    if (self.syncType == KHHCustomerSyncTypeAddUpdate) {
        if ([self.delegate respondsToSelector:@selector(addUpdateCustomerForUIFailed:)]) {
            [self.delegate addUpdateCustomerForUIFailed:dict];
        }
        return;
    }
    if ([self.delegate respondsToSelector:@selector(syncCustomerForUIFailed:)]) {
        [self.delegate syncCustomerForUIFailed:dict];
    }
}

@end
