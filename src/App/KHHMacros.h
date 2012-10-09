//
//  KHHMacros.h
//
//  Created by 孙铭 on 8/22/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#ifndef KHHMacros_h
#define KHHMacros_h

/*
 *  KHH_RELEASE_SERVER
 *  1   正式服务器
 *  非1 测试服务器
 */
#ifndef KHH_RELEASE_SERVER
#define KHH_RELEASE_SERVER 0
#endif
/*
 *  KHH_TEST_VIEWCONTROLLER
 *  1   启动后进TestViewController
 *  非1 走正式流程
 */
#ifndef KHH_TEST_VIEWCONTROLLER
#define KHH_TEST_VIEWCONTROLLER 0
#endif
/*
 *  KHH_JSON_BASE64
 *  1   Json是用base64转码的
 *  非1 普通Json
 */
#ifndef KHH_JSON_BASE64
#define KHH_JSON_BASE64 1
#endif

// URLs {
#if KHH_RELEASE_SERVER == 1
static NSString * const KHHServer = @"www.kinghanhong.com";
static NSString * const KHHURLFormat = @"http://%@/XCardServer/%@";
#else
//static NSString * const KHHServer = @"s2.kinghanhong.com:9999";
static NSString * const KHHServer = @"192.168.1.70:8081"; //海波
//static NSString * const KHHURLFormat = @"http://%@/XCardServerTest/%@";
static NSString * const KHHURLFormat = @"http://%@/XCardServer/%@"; //海波
#endif
static NSString * const KHHURLUserGuide = @"useGuide.jsp";
static NSString * const KHHURLContactUs = @"contactUs.jsp";
static NSString * const KHHURLRecommendation = @"recommendFriend.html";
static NSString * const KHHURLDisclaimer = @"disclaimer.jsp?language=chinese";
// }

// 超时
static NSTimeInterval const KHHTimeOutInterval = 30.0;
static NSTimeInterval const KHHTimeOutIntervalExchange = 20.0;

// 服务器接口中需要的加密key
static NSString * const KHHHttpEncryptorKey = @"12345678";
static NSString * const KHHHttpSignatureKey = @"xcardpassword";

// 默认的公司Logo图片－－金汉弘的Logo
static NSString * const KHHLogoFileName = @"fafampLogo.png";

// 默认模板ID
static const NSInteger KHHDefaultTemplateID = 41;


#if KHH_JSON_BASE64 == 1
static NSString * const KHHJSONFormat = @"json";
#else
static NSString * const KHHJSONFormat = @"json_new";
#endif

#endif
