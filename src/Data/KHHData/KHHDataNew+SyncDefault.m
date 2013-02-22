//
//  KHHDataNew+SyncDefault.m
//  CardBook
//
//  Created by CJK on 13-1-30.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew+SyncDefault.h"
#import "MyCard.h"
#import "CardTemplate.h"
#import "KHHDataNew+Card.h"

@implementation KHHDataNew (SyncDefault)

- (void)doSyncDefault:(id<KHHDataSyncDefaultDelegate>) delegate
{
    self.delegate = delegate;
    SyncMark* syncMark = [SyncMark syncMarkByKey:@"syncMarkLastDateSyncDefault"];
    [self.agent syncDefault:syncMark.value delegate:self];
}

- (void)syncDefaultSuccess:(NSDictionary *)dict
{
    
    if(![dict[@"myCard"] isEqual:[NSNull null]]&&[dict[@"myCard"] count]){
        [MyCard  processIObject:[InterCard interCardWithMyCardJSON:dict[@"myCard"][0]]];
    }else if(![[self allMyCards]count]){
            ((NSMutableDictionary *)dict)[kInfoKeyErrorMessage] = @"没获取到个人名片";
            [self.delegate syncDefaultForUIFailed:dict];
            return;
    }
        
    
    [CardTemplate processJSONList:dict[@"templatelist"]];
    
    [SyncMark UpdateKey:@"syncMarkLastDateSyncDefault" value:[NSString stringWithFormat:@"%@",dict[kInfoKeySyncTime]]];
    [self saveContext];
    [self.delegate syncDefaultForUISuccess];
}

- (void)syncDefaultFailed:(NSDictionary *)dict
{
    [self.delegate syncDefaultForUIFailed:dict];
}

@end
