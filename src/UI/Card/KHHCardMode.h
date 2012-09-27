//
//  KHHCardMode.h
//  CardBook
//
//  Created by 王国辉 on 12-9-26.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Company.h"

@interface KHHCardMode : NSObject
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) Company  *company;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *mobilePhone;
@property (strong, nonatomic) NSString *logUrl;
@end
