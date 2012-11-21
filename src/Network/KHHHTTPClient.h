//
//  KHHHTTPClient.h
//  CardBook
//
//  Created by 孙铭 on 8/22/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "AFHTTPClient.h"

/**
 KHHHTTPClient 处理网络通讯的类
 KHHNetworkInterfaceAgent 通过 KHHHTTPClient 的 postPath:parameters:success:failure: 方法来调用服务器接口。
 */
@interface KHHHTTPClient : AFHTTPClient

+ (KHHHTTPClient *)sharedClient;

@end
