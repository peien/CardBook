//
//  NetClient.m
//  CardBook
//
//  Created by CJK on 12-12-27.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "NetClient.h"

@implementation NetClient

+ (NetClient *)sharedClient
{
    static NetClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[NetClient alloc] initWithBase];
       
    });
    
    return _sharedClient;
}

- (id)initWithBase
{
    _r = [Reachability reachabilityWithHostname:@"www.apple.com"];
    _netFromPlist = [[NetFromPlist alloc]init];
    self = [super initWithBaseURL:[_netFromPlist currentUrl]];
    if (self) {
//        [self registerHTTPOperationClass:[AFHTTPRequestOperation class]];        
       
        // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
        /**
         受当前服务器糟糕设计的限制，暂时不做限制。
         */
        //        [self setDefaultHeader:@"Accept" value:@"application/json"];
        
    }
    return self;
}


#pragma mark - service url
- (NSURL *) currentServerUrl
{
    return [_netFromPlist currentUrl];
}

@end
