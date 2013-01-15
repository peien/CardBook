//
//  KHHDataLoginDelegate.h
//  CardBook
//
//  Created by CJK on 13-1-14.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef CardBook_KHHDataLoginDelegate_h
#define CardBook_KHHDataLoginDelegate_h

@protocol KHHDataLoginDelegate <NSObject>
@optional

- (void)loginForUISuccess:(NSDictionary *) dict;
- (void)loginForUIFailed:(NSDictionary *) dict;

@end

#endif
