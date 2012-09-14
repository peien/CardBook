//
//  KHHNetworkAPIAgent.h
//  CardBook
//
//  Created by 孙铭 on 8/22/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "KHHKeys.h"
#import "KHHStatusCodes.h"
#import "KHHHTTPClient.h"
#import "SBJson.h"

/**
 该类及其扩展封装了所有的服务器接口。
 对返回结果进行处理以后，用notification通知调用者。
 */
@interface KHHNetworkAPIAgent : NSObject
/**
 登录成功后，一定要调用这个设置authentication。
 */
- (BOOL)authenticateWithFakeID:(NSString *)fakeID
                      password:(NSString *)password;
/**
 生成所谓的系统级别参数
 */
- (NSString *)queryStringWithDictionary:(NSDictionary *)aDictionary;
/**
 系统级别参数中的sign
 */
- (NSString *)signatureWithDictionary:(NSDictionary *)aDictionary;
/**
 发请求的统一方法
 */
- (void)postAction:(NSString *)action
             query:(NSString *)query
        parameters:(NSDictionary *)parameters;
- (void)postAction:(NSString *)action
          pathRoot:(NSString *)pathRoot
             query:(NSString *)query
        parameters:(NSDictionary *)parameters;
/**
 把http response body的base64数据，转成json，再解析为dictionary。
 */
- (NSDictionary *)resultDictionaryFromResponse:(id)responseObject;

@end

