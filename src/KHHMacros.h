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
 *  2   海波电脑
 *  非1 测试服务器
 */
#ifndef KHH_RELEASE_SERVER
#define KHH_RELEASE_SERVER 1
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
 *  KHH_Default_CardTemplate_ID 默认的模板ID
 */
#ifndef KHH_Default_CardTemplate_ID
#define KHH_Default_CardTemplate_ID 41
#endif

/*
 *  KHH_MULTI_COMPANY 是否支持单用户属于多公司
 *  0 不支持，一个用户属于一个公司
 *  1 支持。
 */
#ifndef KHH_MULTI_COMPANY 
#define KHH_MULTI_COMPANY 0
#endif

/*
 *  KHH_JSON_BASE64
 *  1   Json是用base64转码的
 *  非1 普通Json
 */
#ifndef KHH_JSON_BASE64
#define KHH_JSON_BASE64 1
#endif

/*
 *  KHH_APP_Name
 */
#ifndef KHH_APP_NAME
#define KHH_APP_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey]
#endif

/*
 * iphone5
 */
#ifndef iPhone5
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#endif
// URLs {
#if KHH_RELEASE_SERVER == 1
static NSString * const KHHServer = @"www.kinghanhong.com";
static NSString * const KHHURLFormat = @"http://%@/cardbook/%@";
#elif KHH_RELEASE_SERVER == 2
static NSString * const KHHServer = @"192.168.1.70:8081"; //海波
static NSString * const KHHURLFormat = @"http://%@/XCardServer/%@";
#else
static NSString * const KHHServer = @"s2.kinghanhong.com:9999";
static NSString * const KHHURLFormat = @"http://%@/XCardServer/%@";
#endif
static NSString * const KHHURLUserGuide = @"useGuide.jsp";
static NSString * const KHHURLContactUs = @"contactUs.jsp";
static NSString * const KHHURLRecommendation = @"recommendFriend.html";
static NSString * const KHHURLDisclaimer = @"disclaimer.jsp?language=chinese";


#pragma mark - 分享网址
static NSString * const KHH_Recommend_URL = @"http://www.fafamp.com";

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
