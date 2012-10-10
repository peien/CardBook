//
//  KHHStatusCodes.h
//  CardBook
//
//  Created by 孙铭 on 8/23/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#ifndef KHHStatusCodes_h
#define KHHStatusCodes_h

typedef NSInteger KHHNetworkStatusCode;
typedef NSInteger KHHStatusCode;

// KHHNetworkStatusCode
static const NSInteger KHHNetworkStatusCodeSucceeded = 0;
static const NSInteger KHHNetworkStatusCodeFailed = -1;
static const NSInteger KHHNetworkStatusCodeDataServerError = -2;
static const NSInteger KHHNetworkStatusCodeAlreadyCreated = -3;
static const NSInteger KHHNetworkStatusCodeAlreadyEnqueued = -11;
static const NSInteger KHHNetworkStatusCodeDuplication = -12; 
static const NSInteger KHHNetworkStatusCodeOldPasswordWrong = -13; // 修改密码
static const NSInteger KHHNetworkStatusCodeLatitudeOrLongitudeWrong = -14;
static const NSInteger KHHNetworkStatusCodeNoneCounterpartCard = -21;
static const NSInteger KHHNetworkStatusCodeSomethingWrong = -999;
static const NSInteger KHHNetworkStatusCodeUnresolvableData = 10000; // 不可解析
static const NSInteger KHHNetworkStatusCodeConnectionFailed;
static const NSInteger KHHNetworkStatusCodeConnectionTimeOut;
static const NSInteger KHHNetworkStatusCodeUnknownError = 3000; // 要你命3000

// KHHStatusCode
static const NSInteger KHHStatusCodeLocalDataOperationFailed = 44001;//本地数据库操作失败

#endif