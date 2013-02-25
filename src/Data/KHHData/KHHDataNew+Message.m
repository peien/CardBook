//
//  KHHData+Message.m
//  CardBook
//
//  Created by CJK on 13-1-12.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew+Message.h"
#import "KHHMessage.h"

@implementation KHHDataNew (Message)

- (NSUInteger)countOfUnreadMessages {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isRead == %@", @(NO)];
    NSArray *fetched = [KHHMessage objectArrayByPredicate:predicate
                                          sortDescriptors:nil];
    return fetched.count;
}

#pragma mark - reseaveMsg

- (void)reseaveMsg:(id<KHHDataMessageDelegate>)delegate
{
    self.delegate = delegate;
    [self.agent reseaveMessage:self];
}


- (void)reseaveMsgSuccess:(NSMutableDictionary *)dict
{
    if ([dict[@"haveNew"] isEqualToString:@"0"]) {
        [self.delegate reseaveMsgForUISuccess:dict];
        return;
    }
    
    for (int i=0;i<[dict[@"fsendList"] count];i++) {
        InMessage *im = (InMessage *)dict[@"fsendList"][i];
        [dict[@"fsendList"] removeObjectAtIndex:i];
        
        if (![KHHMessage objectByID:im.id createIfNone:NO]) {            
            [dict[@"fsendList"] insertObject:[KHHMessage processIObject:im] atIndex:i];
            continue;
        }
        
        i--;        
    }
    [self saveContext];
    [self.delegate reseaveMsgForUISuccess:dict];
}

- (void)reseaveMsgFailed:(NSDictionary *)dict
{
    [self.delegate reseaveMsgForUIFailed:dict];
}

#pragma mark - setRead

- (void)setRead:(NSString *)messageId delegate:(id<KHHDataMessageDelegate>)delegate
{
    self.delegate = delegate;
    if (!self.needDic) {
        self.needDic = [[NSMutableDictionary alloc]initWithCapacity:10];
    }
    self.needDic[@"messageId"] = messageId;
    [self.agent deleteMessage:messageId delegate:self];
}

- (void)deleteMessageFailed:(NSDictionary *) dict
{
    if (self.needDic[@"trueDelete"]) {
        [self.needDic removeObjectForKey:@"trueDelete"];
        [self saveContext];
        return;
    }
    
    ((KHHMessage *)[KHHMessage objectByID:[NSNumber numberFromString:self.needDic[@"messageId"]] createIfNone:NO]).isReadValue = NO;
    [self saveContext];
    //[self.delegate setReadForUIFailed];
}

- (void)deleteMessageSuccess
{
    if (self.needDic[@"trueDelete"]) {
        [self.needDic removeObjectForKey:@"trueDelete"];
        KHHMessage *mess = (KHHMessage *)[KHHMessage objectByID:[NSNumber numberFromString:self.needDic[@"messageId"]] createIfNone:NO];
        [self.context deleteObject:mess];
    }
    [self saveContext];
}

#pragma mark - deleteMsg

- (void)doDeleteMessage:(NSString *)messageId delegate:(id<KHHDataMessageDelegate>)delegate
{
    KHHMessage *mess = (KHHMessage *)[KHHMessage objectByID:[NSNumber numberFromString:self.needDic[@"messageId"]] createIfNone:NO];
    if (mess.isReadValue) {
        [self.context deleteObject:mess];
        [self saveContext];
        return;
    }
    self.delegate = delegate;
    
    if (!self.needDic) {
        self.needDic = [[NSMutableDictionary alloc]initWithCapacity:10];
    }
    self.needDic[@"messageId"] = messageId;
    self.needDic[@"trueDelete"] = @"1";
    [self.agent deleteMessage:messageId delegate:self];
    
}

#pragma mark - allMessage

- (NSArray *)allMessages
{
    for (int i=0; i<20; i++) {
        InMessage *inMessage = [[InMessage alloc]init];
        inMessage.id = @(i);
        inMessage.content = [NSString stringWithFormat:@"第%d信息",i];
        [KHHMessage processIObject:inMessage];
    }
    [self saveContext];
    NSSortDescriptor *sortDes = [NSSortDescriptor sortDescriptorWithKey:@"time"
                                                              ascending:NO];
    NSArray *result = [KHHMessage objectArrayByPredicate:nil
                                         sortDescriptors:@[sortDes]];
    return result;
}

@end
