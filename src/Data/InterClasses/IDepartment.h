//
//  IDepartment.h
//  CardBook
//
//  Created by 王定方 on 13-1-13.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "SMObject.h"

@interface IDepartment : SMObject
//"companyId":24,"gmtCreateTime":"2012-07-19 10:34:08","gmtModTime":"2012-08-09 17:00:00","id":19,"orgName":"游戏部门"},
@property (nonatomic, strong) NSNumber          *id;
@property (nonatomic, strong) NSNumber          *companyID;
@property (nonatomic, strong) NSString          *departmentName;
@end

@interface IDepartment (KHHTransformation)
//从json解析成ICheckInForNetWork 对象
- (id)updateWithJSON:(NSDictionary *)json;
@end