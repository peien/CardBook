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

#pragma mark - delegates
- (void)reseaveDone:(Boolean)haveNewMsg
{

}
- (void)reseaveFail
{

}
@end
