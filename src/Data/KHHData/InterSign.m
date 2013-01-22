//
//  InterSign.m
//  CardBook
//
//  Created by CJK on 13-1-21.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "InterSign.h"

@implementation InterSign
- (void)setLocalStr:(NSString *)localStr
{
  
        if (!localStr) {
            if ([localStr rangeOfString:@"国外"].location == 0) {
                NSArray *splitArr = [localStr componentsSeparatedByString:@" "];
                _addressCountry = splitArr[1];
            }else{
                _addressCountry = @"中国";
                NSArray *splitArr = [localStr componentsSeparatedByString:@" "];
                _addressProvince = splitArr[0];
                if ([splitArr count] == 2) {
                    _addressCity = splitArr[0];
                    _addressDistrict  = splitArr[1];
                }else{
                    _addressCity = splitArr[1];
                    _addressDistrict  = splitArr[2];
                }
            }
        }   
}
@end
