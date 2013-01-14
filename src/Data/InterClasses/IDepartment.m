//
//  IDepartment.m
//  CardBook
//
//  Created by 王定方 on 13-1-13.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "IDepartment.h"
#import "NSNumber+SM.h"
#import "NSString+SM.h"
//科室接口
@implementation IDepartment

@end

@implementation IDepartment (KHHTransformation)
//从json解析成ICheckInForNetWork 对象
- (id)updateWithJSON:(NSDictionary *)json
{
    self.id                = [NSNumber numberFromObject:[json valueForKey:JSONDataKeyID] zeroIfUnresolvable:NO];
    self.companyID         = [NSNumber numberFromObject:[json valueForKey:JSONDataKeyCompanyId] zeroIfUnresolvable:NO];
    self.departmentName    = [NSString stringFromObject:[json valueForKey:JSONDataKeyDepartmentName]];
    
    return self;
}
@end