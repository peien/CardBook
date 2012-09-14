//
//  KHHHTTPClient.m
//  CardBook
//
//  Created by 孙铭 on 8/22/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "NSURL+KHH.h"

@implementation KHHHTTPClient

+ (KHHHTTPClient *)sharedClient {
    static KHHHTTPClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[KHHHTTPClient alloc] initWithBaseURL:[NSURL KHHBaseURL]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:[AFHTTPRequestOperation class]];
        
        // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
        /**
         受当前服务器糟糕设计的限制，暂时不做限制。
         */
//        [self setDefaultHeader:@"Accept" value:@"application/json"];
        
    }
    return self;
}

@end
