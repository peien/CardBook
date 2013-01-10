//
//  PrivateDelegates.h
//  CardBook
//
//  Created by CJK on 13-1-9.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#ifndef CardBook_PrivateDelegates_h
#define CardBook_PrivateDelegates_h

@protocol delegateNewPrivateForEdit<NSObject>

@required

- (void)createDone;
- (void)createFail:(NSString *)msg;

@end

//@protocol delegateMsgForRead<NSObject>
//
//@required
//
//- (void)deleDone;
//- (void)deleFail;
//
//@end

#endif
