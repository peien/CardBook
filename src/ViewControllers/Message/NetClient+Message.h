//
//  NetClient+Message.h
//  CardBook
//
//  Created by CJK on 12-12-27.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "NetClient.h"
#import "MsgDelegates.h"
#import "Reachability.h"

@interface NetClient (Message)

#pragma mark - flags
@property (nonatomic,assign)Boolean inMsgView;

- (void)doDeleteInEdit:(id<delegateMsgForRead>)delegate messages:(NSArray *)messages;
- (void)doDelete:(id<delegateMsgForRead>) delegate messages:(NSArray *)messages;
- (void)doReseaveMessage:(id<delegateMsgForMain>) delegate;

@end
