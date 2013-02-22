//
//  KHHDataSyncContactDelegate.h
//  CardBook
//
//  Created by CJK on 13-2-1.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef CardBook_KHHDataSyncContactDelegate_h
#define CardBook_KHHDataSyncContactDelegate_h
@protocol KHHDataSyncContactDelegate <NSObject>

- (void)syncContactForUISuccess;
- (void)syncContactForUIFailed:(NSDictionary *) dict;

- (void)touchCardForUISuccess:(NSDictionary *) dict;
- (void)touchCardForUIFailed:(NSDictionary *) dict;

- (void)deleteContactForUISuccess;
- (void)deleteContactForUIFailed:(NSDictionary *) dict;

- (void)syncMycardForUISuccess;
- (void)syncMycardForUIFailed:(NSDictionary *) dict;


@end


#endif
