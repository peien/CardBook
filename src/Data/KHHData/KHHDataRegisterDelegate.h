//
//  KHHDataRegisterDelegate.h
//  CardBook
//
//  Created by CJK on 13-1-15.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef CardBook_KHHDataRegisterDelegate_h
#define CardBook_KHHDataRegisterDelegate_h

@protocol KHHDataRegisterDelegate <NSObject>
@optional

- (void)registerForUISuccess:(NSDictionary *) dict;
- (void)registerForUIFailed:(NSDictionary *) dict;

@end

#endif
