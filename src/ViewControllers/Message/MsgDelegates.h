//
//  Delegates.h
//  CardBook
//
//  Created by CJK on 12-12-28.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#ifndef CardBook_Delegates_h
#define CardBook_Delegates_h

#pragma mark - for data
@protocol delegateMsgForMainData<NSObject>

@required
- (void)reseaveDone:(Boolean)haveNewMsg;
- (void)reseaveFail;
@end

@protocol delegateMsgForReadData<NSObject>

@required
- (void)deleDone;
- (void)deleFail;
@end

#pragma mark - for UI
@protocol delegateMsgForMain<NSObject>

@required
- (void)reseaveDone:(Boolean)haveNewMsg;
- (void)reseaveFail;
@end

@protocol delegateMsgForRead<NSObject>

@required
- (void)deleDone;
- (void)deleFail;
@end


#endif
