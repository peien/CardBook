//
//  NetClient.h
//  CardBook
//
//  Created by CJK on 12-12-27.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "AFHTTPClient.h"
#import "NetFromPlist.h"
@interface NetClient : AFHTTPClient

@property (nonatomic,strong) NetFromPlist *netFromPlist;

+ (NetClient *)sharedClient;

@end
