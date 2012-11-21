//
//  IAddress.h
//  CardBook
//
//  Created by Sun Ming on 12-10-11.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "SMObject.h"

@interface IAddress : SMObject
@property (nonatomic, strong) NSString *country;// 国
@property (nonatomic, strong) NSString *province;// 省
@property (nonatomic, strong) NSString *city;// 市
@property (nonatomic, strong) NSString *district;// 区
@property (nonatomic, strong) NSString *street;// 街
@property (nonatomic, strong) NSString *other;// 其他
@property (nonatomic, strong) NSString *zip;// 邮编
@end

@interface IAddress (KHHTransformation)
- (id)updateWithJSON:(NSDictionary *)json;
@end

