//
//  KHHNetworkAPIAgent.h
//  CardBook
//
//  Created by 孙铭 on 8/22/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "KHHActions.h"
#import "KHHClasses.h"
#import "KHHKeys.h"
#import "KHHMacros.h"
#import "KHHNotifications.h"
#import "KHHStatusCodes.h"
#import "KHHTypes.h"
#import "NetClient.h"
#import "AppStartController.h"

/**
 该类及其扩展封装了所有的服务器接口。
 对返回结果进行处理以后，用notification通知调用者。
 */
@interface KHHNetworkAPIAgent : NSObject
/**
 登录成功后，一定要调用这个设置authentication。
 */
- (BOOL)authenticateWithUser:(NSString *)fakeID password:(NSString *)password;
/**
 生成所谓的系统级别参数
 */
- (NSString *)queryStringWithDictionary:(NSDictionary *)aDictionary;
/**
 系统级别参数中的sign
 */
- (NSString *)signatureWithDictionary:(NSDictionary *)aDictionary;
/**
 发请求
 */
- (void)postAction:(NSString *)action
             query:(NSString *)query
        parameters:(NSDictionary *)parameters;
- (void)postAction:(NSString *)action
             query:(NSString *)query
        parameters:(NSDictionary *)parameters
           success:(KHHSuccessBlock)success;
- (void)postAction:(NSString *)action
             query:(NSString *)query
        parameters:(NSDictionary *)parameters
           success:(KHHSuccessBlock)success
             extra:(NSDictionary *)extra;
- (void)postAction:(NSString *)action
          pathRoot:(NSString *)pathRoot
             query:(NSString *)query
        parameters:(NSDictionary *)parameters
           success:(KHHSuccessBlock)success
           failure:(KHHFailureBlock)failure
             extra:(NSDictionary *)extra;
- (void)postAction:(NSString *)action
             query:(NSString *)query
        parameters:(NSDictionary *)parameters
  constructingBody:(KHHConstructionBlock)construction
           success:(KHHSuccessBlock)success;
- (void)postAction:(NSString *)action
          pathRoot:(NSString *)pathRoot
             query:(NSString *)query
        parameters:(NSDictionary *)parameters
  constructingBody:(KHHConstructionBlock)construction
           success:(KHHSuccessBlock)success
           failure:(KHHFailureBlock)failure
             extra:(NSDictionary *)extra;
/**
 把http response body的base64数据，转成json，再解析为dictionary。
 */
- (NSMutableDictionary *)JSONDictionaryWithResponse:(id)responseObject;
/*!
 根据 Action 和 Status Code 生成 Notification Name。
 KHHErrorCodeSucceeded 返回 action＋Succeeded
 其他返回action＋Failed
 */
NSString *NameWithActionAndCode(NSString *action, KHHErrorCode code);
/*!
 根据 Action 和 Status Code 生成 提示消息。
 */
NSString *MessageWithActionAndCode(KHHErrorCode code, NSString *errorMessage);
/*!
 根据 Action 发 notification，提醒参数错误。
 返回action＋Failed。
 */
void WarnParametersNotMeetRequirement(NSString *action);

@end


