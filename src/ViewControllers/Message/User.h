//
//  User.h
//  CardBook
//
//  Created by CJK on 12-12-27.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Encryptor.h"
#import "NetClient.h"

@interface User : NSObject

@property(nonatomic,strong)NSString *phone;
@property(nonatomic,strong)NSString *password;


+ (User *)sharedInstance;

@end
