//
//  KHHData+Message.h
//  CardBook
//
//  Created by CJK on 13-1-12.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHDataNew.h"
#import "MsgDelegates.h"

@interface KHHDataNew (Message)<delegateMsgForMain>

- (NSUInteger)countOfUnreadMessages;

@end
