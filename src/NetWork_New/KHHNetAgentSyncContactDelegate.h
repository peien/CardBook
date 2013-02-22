//
//  KHHNetAgentSyncContactDelegate.h
//  CardBook
//
//  Created by CJK on 13-2-1.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef CardBook_KHHNetAgentSyncContactDelegate_h
#define CardBook_KHHNetAgentSyncContactDelegate_h

@protocol KHHNetAgentSyncContactDelegate <NSObject>
@optional

- (void)syncContactSuccess:(NSDictionary *) dict;
- (void)syncContactFailed:(NSDictionary *) dict;

- (void)touchCardSuccess:(NSDictionary *) dict;
- (void)touchCardFailed:(NSDictionary *) dict;

- (void)deleteContactSuccess:(NSDictionary *) dict;
- (void)deleteContactFailed:(NSDictionary *) dict;

- (void)syncMycardSuccess:(NSDictionary *) dict;
- (void)syncMycardFailed:(NSDictionary *) dict;

@end


#endif
