//
//  NetClient.h
//  CardBook
//
//  Created by CJK on 12-12-27.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "AFHTTPClient.h"
#import "NetFromPlist.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface NetClient : AFHTTPClient

@property (nonatomic,strong) NetFromPlist *netFromPlist;

@property (nonatomic,strong) Reachability *r;

+ (NetClient *)sharedClient;

#pragma server url
-(NSURL *) currentServerUrl;

@end
