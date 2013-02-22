//
//  KHHDataSyncDefaultDelegate.h
//  CardBook
//
//  Created by CJK on 13-1-30.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef CardBook_KHHDataSyncDefaultDelegate_h
#define CardBook_KHHDataSyncDefaultDelegate_h
@protocol KHHDataSyncDefaultDelegate <NSObject>

- (void)syncDefaultForUISuccess;
- (void)syncDefaultForUIFailed:(NSDictionary *) dict;

@end


#endif
