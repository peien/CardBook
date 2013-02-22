//
//  KHHNetAgentSyncDefaultDelegate.h
//  CardBook
//
//  Created by CJK on 13-1-30.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef CardBook_KHHNetAgentSyncDefaultDelegate_h
#define CardBook_KHHNetAgentSyncDefaultDelegate_h


@protocol KHHNetAgentSyncDefaultDelegate <NSObject>
@optional

- (void)syncDefaultSuccess:(NSDictionary *) dict;
- (void)syncDefaultFailed:(NSDictionary *) dict;

@end

#endif
