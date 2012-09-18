//
//  KHHMacros.h
//
//  Created by 孙铭 on 8/22/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#ifndef KHHMacros_h
#define KHHMacros_h

/*
 *  KHH_TEST
 *  1   内部测试
 *  非1 正式环境
 */
#ifndef KHH_TEST
#define KHH_TEST 1
#endif

#pragma mark - URLs
/*!
 URLs
 */
#if KHH_TEST == 1
    static NSString * const KHHServer = @"s2.kinghanhong.com:9999";
//    static NSString * const KHHServer = @"192.168.1.151:9999";
//    static NSString * const KHHServer = @"192.168.1.70:8081"; //海波
#else
    static NSString * const KHHServer = @"www.kinghanhong.com";
#endif

static NSString * const KHHURLFormat = @"http://%@/XCardServer/%@";
static NSString * const KHHURLUserGuide = @"useGuide.jsp";
static NSString * const KHHURLContactUs = @"contactUs.jsp";
static NSString * const KHHURLRecommendation = @"recommendFriend.html";
static NSString * const KHHURLDisclaimer = @"disclaimer.jsp?language=chinese";

/*
 *  KHH_JSON_BASE64
 *  1   Json是用base64转码的
 *  非1 普通Json
 */
#ifndef KHH_JSON_BASE64
#define KHH_JSON_BASE64 1
#endif
#if KHH_JSON_BASE64 == 1
static NSString * const KHHJSONFormat = @"json";
#else
static NSString * const KHHJSONFormat = @"json_new";
#endif

// 超时
static NSTimeInterval const KHHTimeOutInterval = 30.0;
static NSTimeInterval const KHHTimeOutIntervalExchange = 20.0;

// 服务器接口中需要的加密key
static NSString * const KHHHttpEncryptorKey = @"12345678";
static NSString * const KHHHttpSignatureKey = @"xcardpassword";

static NSString * const KHHLogoFileName = @"fafampLogo.png";
#endif
