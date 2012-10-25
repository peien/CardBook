//
//  IAddress.m
//  CardBook
//
//  Created by Sun Ming on 12-10-11.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "IAddress.h"
#import "NSString+SM.h"

@implementation IAddress
@end

@implementation IAddress (KHHTransformation)

- (id)updateWithJSON:(NSDictionary *)json {
    self.country  = [NSString stringFromObject:json[JSONDataKeyCountry]];// 国
    self.province = [NSString stringFromObject:json[JSONDataKeyProvince]];// 省
    self.city     = [NSString stringFromObject:json[JSONDataKeyCity]];// 市
    self.district = KHHPlaceholderForEmptyString;// 区
    self.street   = KHHPlaceholderForEmptyString;// 街
    self.other    = [NSString stringFromObject:json[JSONDataKeyAddress]];// 其他
    self.zip      = [NSString stringFromObject:json[JSONDataKeyZipcode]];// 邮编
    return self;
}

@end
