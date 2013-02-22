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

- (void)reseaveMsgSuccess:(Boolean)haveNewMsg;
- (void)reseaveMsgFailed:(NSDictionary *) dict;

@end

#endif
