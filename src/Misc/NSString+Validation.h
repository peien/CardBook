//
//  NSString+Validation.h
//  eCard
//
//  Created by fei ye on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>

/**
 * @discussion 扩展字符串功能，增加有效性判断(手机号, 电话号码, email, URL等)
 */
@interface NSString (Validation)

/**
 * @discussion 判断手机号码的合法性
 * @param 手机号码字符串
 * @return 手机号码合法性
 */
- (BOOL)isValidMobilePhoneNumber;

/**
 * @discussion 判断电话号码的合法性
 * @param 电话号码字符串
 * @return 电话号码合法性
 */
- (BOOL)isValidTelephoneNUmber;

/**
 * @discussion 判断电子邮件地址的合法性
 * @param 电子邮件地址
 * @return 电子邮件地址合法性
 */
- (BOOL)isValidEmail;

/**
 * @discussion 判断输入串是否为中文(简体,繁体)
 * @param 待检测串
 * @return 
 */
- (BOOL)isValidChinese;

/**
 * @discussion 判断是否是有效URL串
 * @param 待检测串
 * @return 
 */
- (BOOL)isValidURL;

/**
 * @discussion 判断是否是有效IP地址
 * @param 待检测串
 * @return 
 */
- (BOOL)isValidIPAddress;

/**
 * @discussion 判断是否是有效qq号码
 * @param 待检测串
 * @return 
 */
- (BOOL)isValidQQ;

/**
 * @discussion 判断是否是有效邮政编码
 * @param 待检测串
 * @return 
 */
- (BOOL)isValidPostalCode;

/**
 * @discussion 判断是否是有效身份证号码
 * @param 待检测串
 * @return 
 */
- (BOOL)isValidIdCardNumber;

/*!
 @method isAccountLikeNumber
 @abstract 判断是否是像帐号的数字
 */
- (BOOL)isAccountLikeNumber;

/*!
 @method isValidPassword
 @abstract 判断是否是有效的密码
 */
- (BOOL)isValidPassword;

/*!
 @method isInternalNumber
 @abstract 判断是否是内部号码
 */
- (BOOL)isInternalNumber;

/*!
 @method isRegistrablePhone
 @abstract 判断是否是可注册的电话号码
 */
- (BOOL)isRegistrablePhone;
@end
