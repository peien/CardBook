//
//  KHHStatusCodes.h
//  CardBook
//
//  Created by 孙铭 on 8/23/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#ifndef KHHStatusCodes_h
#define KHHStatusCodes_h

typedef NSInteger KHHErrorCode;

// KHHErrorCode
static const NSInteger KHHErrorCodeSucceeded = 0;
static const NSInteger KHHErrorCodeFailed = -1;
static const NSInteger KHHErrorCodeDataServerError = -2;
static const NSInteger KHHErrorCodeAlreadyCreated = -3;
static const NSInteger KHHErrorCodeAccountExpired = -4;
static const NSInteger KHHErrorCodeExceedRetryLimit = -6;
static const NSInteger KHHErrorCodeCompanyAlreadyExist = -7; // 注册时公司名已存在。
static const NSInteger KHHErrorCodeAlreadyEnqueued = -11;
static const NSInteger KHHErrorCodeDuplication = -12; 
static const NSInteger KHHErrorCodeOldPasswordWrong = -13; // 修改密码
static const NSInteger KHHErrorCodeLatitudeOrLongitudeWrong = -14;
static const NSInteger KHHErrorCodeNoneCounterpartCard = -21;
static const NSInteger KHHErrorCodeSomethingWrong = -999;
static const NSInteger KHHErrorCodeUnresolvableData = 10000; // 不可解析
static const NSInteger KHHErrorCodeConnectionOffline = -1009; //
static const NSInteger KHHErrorCode404 = -1011; //
//static const NSInteger KHHErrorCodeConnectionTimeOut;
static const NSInteger KHHErrorCodeUnknownError = 3000; // 要你命3000

static const NSInteger KHHErrorCodeLocalDataOperationFailed = 44001;//本地数据库操作失败

static const NSInteger KHHErrorCodeBusy = 880001;//忙！因此不能完成操作，稍后再试！
static const NSInteger KHHErrorCodeParametersNotMeetRequirement = 880002; // 参数不符合要求

static const NSInteger KHHErrorCodeNotReachable = -1000; //当前无网络

#endif
