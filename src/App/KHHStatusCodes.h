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
    KHHNetworkStatusCodeUnresolvableData = 10000, // 不可解析
    KHHNetworkStatusCodeConnectionFailed,
    KHHNetworkStatusCodeConnectionTimeOut,
    KHHNetworkStatusCodeUnknownError = 3000, // 要你命3000
} KHHNetworkStatusCode;

#endif
