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

- (void)reseaveMsg:(id<KHHDataMessageDelegate>)delegate
{
    self.delegate = delegate;
    [self.agent reseaveMessage:self];
}

#pragma mark - delegates
- (void)reseaveMsgSuccess:(Boolean)haveNewMsg
{
    [self.delegate reseaveMsgForUISuccess:haveNewMsg];
}

- (void)reseaveMsgFailed:(NSDictionary *)dict
{
    [self.delegate reseaveMsgForUIFailed:dict];
}

@end
