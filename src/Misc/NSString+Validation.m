//
//  NSString+Validation.m
//  eCard
//
//  Created by fei ye on 12-3-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSString+Validation.h"

@implementation NSString (Validation)

- (BOOL)matchString:(NSString *)input withPattern:(NSString *)pattern
{
    if (!input || 0 == [input length]) {
        return FALSE;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [predicate evaluateWithObject:input];

}

//判断手机是否为有效手机号
//8888开头的都为测试账号
- (BOOL)isValidMobilePhoneNumber
{
    BOOL isMatch = [self matchString:self //phone number
                         withPattern:@"(13[0-9]|14[0-9]|15[0-9]|18[0-9])\\d{8}"];
    BOOL isTest = [self hasPrefix:@"8888"];
    return isMatch || isTest;
}

- (BOOL)isValidTelephoneNUmber
{
    return [self matchString:self //telephoneNumber 
                 withPattern:@"(\\+[0-9]+[\\- \\.]*)?(\\([0-9]+\\)[\\- \\.]*)?([0-9][0-9\\- \\.][0-9\\- \\.]+[0-9])"];    
}

- (BOOL)isValidEmail
{
    return [self matchString:self //email 
                 withPattern:@"[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}\\@[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}(\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})+"];    
}

- (BOOL)isValidChinese
{
    return [self matchString:self //string 
                 withPattern:@"[\u4E00-\u9FA5]+"];    
}

- (BOOL)isValidURL
{
    return [self matchString:self //url 
                 withPattern:@"[a-zA-z]+://[^\\s]*"];    
}

- (BOOL)isValidIPAddress
{
    return [self matchString:self //ipAddress 
                 withPattern:@"((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)"];    
}

- (BOOL)isValidQQ
{
    return [self matchString:self //qqNumber 
                 withPattern:@"[1-9]\\d{4,}"];    
}

- (BOOL)isValidPostalCode
{
    return [self matchString:self //postalCode 
                 withPattern:@"[1-9]\\d{5}"];    
}

- (BOOL)isValidIdCardNumber
{
    return [self matchString:self //idCardNumber 
                 withPattern:@"\\d{15}(\\d\\d[0-9xX])?"];    
}
- (BOOL)isAccountLikeNumber
{
    return [self matchString:self 
                 withPattern:@"[0-9]{4,}"];
}
- (BOOL)isValidPassword
{
    return [self matchString:self 
                 withPattern:@"[a-zA-Z0-9_-]{4,12}"];
}
- (BOOL)isInternalNumber
{
    return [self matchString:self 
                 withPattern:@"8{4}[0-9]{4,8}"];
}
- (BOOL)isRegistrablePhone
{
    return (self.isValidMobilePhoneNumber || self.isInternalNumber);
}

@end
