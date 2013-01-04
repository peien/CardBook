//
//  Delegates.h
//  CardBook
//
//  Created by CJK on 12-12-28.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#ifndef CardBook_Delegates_h
#define CardBook_Delegates_h

@protocol delegateMsgForMain<NSObject>

@required
- (void)reseaveDone:(Boolean)haveNewMsg;
- (void)reseaveFail;
@end

@protocol delegateMsgForRead<NSObject>

@required
- (void)deleDone;
- (void)deleFail;
- (void)inNetWorking;
- (void)outNetWorking;
@end

#endif
