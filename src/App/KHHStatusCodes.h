//
//  KHHStatusCodes.h
//  CardBook
//
//  Created by 孙铭 on 8/23/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#ifndef KHHStatusCodes_h
#define KHHStatusCodes_h

typedef enum {
    //    KHHNetworkStatusCode
    KHHNetworkStatusCodeUnknownError = 10000,
    KHHNetworkStatusCodeSucceeded = 0,
    KHHNetworkStatusCodeFailed = -1,
    KHHNetworkStatusCodeDataServerError = -2,
    KHHNetworkStatusCodeAlreadyCreated = -3,
    KHHNetworkStatusCodeAlreadyEnqueued = -11,
    KHHNetworkStatusCodeDuplication = -12, 
    KHHNetworkStatusCodeOldPasswordWrong = -13, // 修改密码
    KHHNetworkStatusCodeLatitudeOrLongitudeWrong = -14,
    KHHNetworkStatusCodeNoneCounterpartCard = -21,
    KHHNetworkStatusCodeSomethingWrong = -999,
    KHHNetworkStatusCodeConnectionFailed,
    KHHNetworkStatusCodeConnectionTimeOut,
} KHHNetworkStatusCode;

#endif
