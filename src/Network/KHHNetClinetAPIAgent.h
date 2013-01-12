//
//  KHHNetClinetAPIAgent.h
//  CardBook
//
//  Created by 王定方 on 13-1-11.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "KHHTypes.h"
#import "Reachability.h"
#import "KHHKeys.h"

@interface KHHNetClinetAPIAgent : NSObject

#pragma mark - 判断网络是否可用
-(BOOL) networkStateIsValid;
#pragma mark - Utils
/**
 登录成功后，一定要调用这个设置authentication。
 */
- (BOOL)authenticateWithUser:(NSString *)fakeID password:(NSString *)password;
- (NSString *)queryStringWithMethod:(NSString *) method;
- (NSMutableDictionary *)JSONDictionaryWithResponse:(NSData *)responseData;

#pragma mark - 网络请求时默认的错误
//默认失败请求返回的dict
//-(NSDictionary *) defaultFailedResponseDictionary:(NSError *)error;
//参数不满足时返回
-(NSDictionary *) parametersNotMeetRequirementFailedResponseDictionary;
//无网络时返回
-(NSDictionary *) networkUnableFailedResponseDictionary;
//默认的请求失败block
-(KHHFailureBlock) defaultFailedResponse:(id) delegate selector:(NSString *) selector;

#pragma mark - 封装一下与服务器通讯时url要加入的固定参数
- (void)getPath:(NSString *)methodPath
     parameters:(NSDictionary *)parameters
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (void)postPath:(NSString *)methodPath
      parameters:(NSDictionary *)parameters
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)putPath:(NSString *)methodPath
     parameters:(NSDictionary *)parameters
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)deletePath:(NSString *)methodPath
        parameters:(NSDictionary *)parameters
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
- (void)patchPath:(NSString *)methodPath
       parameters:(NSDictionary *)parameters
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

#pragma mark - 新增时，有文件要上传时的接口
- (void) multipartFormRequestWithPOSTPath:(NSString *)methodPath
                                             parameters:(NSDictionary *)parameters
                              constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))construction
                                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
#pragma mark - 修改时，有文件要上传时的接口
- (void) multipartFormRequestWithPUTPath:(NSString *)methodPath
                                 parameters:(NSDictionary *)parameters
                  constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))construction
                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
