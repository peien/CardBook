//
//  KHHDataMessageDelegate.h
//  CardBook
//
//  Created by CJK on 13-1-12.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef CardBook_KHHDataMessageDelegate_h
#define CardBook_KHHDataMessageDelegate_h
@protocol KHHDataMessageDelegate <NSObject>
@optional
//同步分组
- (void)reseaveMsgForUISuccess:(NSDictionary *)dict;
- (void)reseaveMsgForUIFailed:(NSDictionary *)dict;



@end


#endif
