//
//  KHHDataNew+SyncContact.m
//  CardBook
//
//  Created by CJK on 13-2-1.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew+SyncContact.h"
#import "ReceivedCard.h"
#import "PrivateCard.h"
#import "CardTemplate.h"
#import "KHHDataNew+Template.h"
#import "MyCard.h"
#import "InterCard.h"

@implementation KHHDataNew (SyncContact)

#pragma mark - syncContact

- (void)doSyncContact:(contactSyncType)contactSyncType delegate:(id<KHHDataSyncContactDelegate>) delegate
{
    self.delegate = delegate;
    [self doSyncContact:contactSyncType];
}

- (void)doSyncContact:(contactSyncType)contactSyncType
{
    self.syncType = contactSyncType;
    [self.agent syncContact:[SyncMark syncMarkByKey:@"syncContactLastDate"].value lastCardId:[SyncMark syncMarkByKey:@"syncContactLastCardId"].value delegate:self];
}

- (void)syncContactSuccess:(NSDictionary *)dict

{
    NSMutableString *temIdsPro = [[NSMutableString alloc]initWithString:@""];
    
    for (NSDictionary *dicPro in dict[@"cardBookList"]) {
        if (![CardTemplate objectByID:dicPro[@"card"][@"templateId"] createIfNone:NO]) {
            if ([temIdsPro isEqualToString:@""]) {
                [temIdsPro appendFormat:@"%@",dicPro[@"card"][@"templateId"]];
            }else{
                [temIdsPro appendFormat:@",%@",dicPro[@"card"][@"templateId"]];
            }
        }
        
        if ([dicPro[@"card"][@"cardType"] isEqual:[NSNumber  numberWithInt:1]]) {
            [ReceivedCard processIObject:[InterCard interCardWithReceivedCardJSON:dicPro]];           
        }else if([dicPro[@"card"][@"cardType"] isEqual:[NSNumber  numberWithInt:2]]){
            [PrivateCard processIObject:[InterCard interCardWithPrivateCardJSON:dicPro]];
           
        }    
    }    
    [SyncMark UpdateKey:@"syncContactLastDate" value:[NSString stringWithFormat:@"%@",dict[@"syncTime"]]];
    [SyncMark UpdateKey:@"syncContactLastCardId" value:[NSString stringWithFormat:@"%@",dict[@"lastCardbookId"]]];
    
    if ([temIdsPro isEqualToString:@""]) {
        [self saveContext];
        
        if (self.syncType == contactSyncTypeDelete) {
            [self.delegate deleteContactForUISuccess];
            return;
        }
        
        [self.delegate syncContactForUISuccess];
    }else{
        [self syncTemplateItemsWithTemplateIDs:temIdsPro delegate:self];
    }
    
    
}

- (void)syncContactFailed:(NSDictionary *)dict
{
    if (self.syncType == contactSyncTypeDelete) {
        [self.delegate deleteContactForUISuccess];
        return;
    }
    
    [self.delegate syncContactForUIFailed:dict];
}

#pragma mark - touchCardForPushMsg

- (void)doTouchCardForPushMsg:(NSString *)cardId delegate:(id<KHHDataSyncContactDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent touchCardForPushMsg:cardId delegate:self];
}

- (void)touchCardSuccess:(NSDictionary *)dict
{
    NSString *strPro;
    if (![CardTemplate objectByID:dict[@"card"][@"templateId"] createIfNone:NO]) {        
            strPro = [NSString stringWithFormat:@"%@",dict[@"card"][@"templateId"]];
    }
    [ReceivedCard processIObject:[InterCard interCardWithReceivedCardJSON:dict[@"card"] nodeName:nil]];
    [self saveContext];
    [self.delegate touchCardForUISuccess:dict];
    if (strPro) {
       [self syncTemplateItemsWithTemplateID:[strPro intValue]  delegate:self];
    }
    
}

- (void)touchCardFailed:(NSDictionary *)dict
{
    [self.delegate touchCardForUIFailed:dict];
}

#pragma mark - syncTemplateItemsUI

- (void)syncTemplateItemsWithTemplateIDsForUISuccess
{
    [self saveContext];
    if (self.syncType == contactSyncTypeDelete) {
        [self.delegate deleteContactForUISuccess];
        return;
    }
    [self.delegate syncContactForUISuccess];
}

- (void)syncTemplateItemsWithTemplateIDsFailed:(NSDictionary *)dict
{
    [self.delegate syncContactForUIFailed:dict]; 
}

- (void)syncTemplateItemsWithTemplateIDForUIFailed:(NSDictionary *)dict
{
    if(self.needDic && [self.needDic[@"inTempSuccess"] isEqualToString:@"myCard"]){
        [self saveContext];
        [self.delegate syncMycardForUIFailed:dict];
    }
}

- (void)syncTemplateItemsWithTemplateIDForUISuccess
{
    if(self.needDic && [self.needDic[@"inTempSuccess"] isEqualToString:@"myCard"]){        
        [self saveContext];
        [self.delegate syncMycardForUISuccess];
    }
   
}

#pragma mark - delete contact
- (void)doDeleteContact:(NSString *)contactId delegate:(id<KHHDataSyncContactDelegate>) delegate
{
    self.delegate = delegate;
    [self.agent deleteContact:contactId delegate:self];
}

- (void)deleteContactSuccess:(NSDictionary *)dict
{
    [self doSyncContact:contactSyncTypeDelete];
}

- (void)deleteContactFailed:(NSDictionary *)dict
{
    [self.delegate deleteContactForUIFailed:dict];
}

#pragma mark - sync myContact
- (void)doSyncMycard:(id<KHHDataSyncContactDelegate>)delegate
{
    self.delegate = delegate;
    [self.agent syncMycard:self];
}

- (void)syncMycardSuccess:(NSDictionary *)dict
{
    if (dict[@"myCard"] ) {
        NSString *strPro;
        if (![CardTemplate objectByID:dict[@"myCard"][@"templateId"] createIfNone:NO]) {
            strPro = [NSString stringWithFormat:@"%@",dict[@"myCard"][@"templateId"]];
        }
        [MyCard processIObject:[InterCard interCardWithMyCardJSON:dict[@"myCard"]]];
        
        if (strPro) {
            if(!self.needDic){
                self.needDic = [[NSMutableDictionary alloc]initWithCapacity:5];
            }
            self.needDic[@"inTempSuccess"] = @"myCard";
            [self syncTemplateItemsWithTemplateID:[strPro intValue]  delegate:self];
            return;
        }        
    }
    [self saveContext];
    [self.delegate syncMycardForUISuccess];
    
}

- (void)syncMycardFailed:(NSDictionary *)dict
{
    [self.delegate syncMycardForUIFailed:dict];
}
@end
