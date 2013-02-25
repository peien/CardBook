//
//  KHHNetAgentMessageDelegate.h
//  CardBook
//
//  Created by CJK on 13-2-19.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef CardBook_KHHNetAgentMessageDelegate_h
#define CardBook_KHHNetAgentMessageDelegate_h

@protocol KHHNetAgentMessageDelegate <NSObject>
@optional

- (void)reseaveMsgSuccess:(NSMutableDictionary *) dict;
- (void)reseaveMsgFailed:(NSDictionary *) dict;

- (void)deleteMessageFailed:(NSDictionary *) dict;
- (void)deleteMessageSuccess;


@end

#endif
