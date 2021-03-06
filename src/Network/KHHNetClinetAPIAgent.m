//
//  KHHNetClinetAPIAgent.m
//  CardBook
//
//  Created by 王定方 on 13-1-11.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHNetClinetAPIAgent.h"
#import "AFJSONRequestOperation.h"
#import "NSString+Networking.h"
#import "NSString+MD5.h"
#import "NSData+Base64.h"
#import "KHHStatusCodes.h"
#import "KHHUser.h"

@implementation KHHNetClinetAPIAgent

#pragma mark - 判断网络是否可用
-(BOOL) networkStateIsValid
{
    if ([[NetClient sharedClient].r currentReachabilityStatus] == NotReachable) {
        return NO;
    }
    
    return YES;
}

//网络是否可用，不可用时执行某delegate下的某函数，并返回网络是否可用
-(BOOL) networkStateIsValid:(id) delegate selector:(NSString *) selector
{
    if (![self networkStateIsValid]) {
        //网络不可用
        NSDictionary *dict = [self networkUnableFailedResponseDictionary];
        if (selector && delegate && [delegate respondsToSelector:NSSelectorFromString(selector)] ) {
            [delegate performSelector:NSSelectorFromString(selector) withObject:dict];
        }
        
        return NO;
    }
    
    return YES;
}

#pragma mark - netState

- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    if (![self networkStateIsValid]) {
        if (success) {
            NSError *error = [[NSError alloc]initWithDomain:@"网络不可用,不能进行操作!" code:KHHErrorCodeNotReachable userInfo:nil];
            failure(nil,error);
        }
        return nil;
        
    }
    return [[NetClient sharedClient] HTTPRequestOperationWithRequest:request success:success failure:failure];
}

#pragma mark - Utils

/**
 登录成功后，一定要调用这个设置authentication。
 */
- (BOOL)authenticateWithUser:(NSString *)fakeID
                    password:(NSString *)password {
    if (0 == [fakeID length] || 0 == [password length]) {
        return NO;
    }
    [[NetClient sharedClient] setAuthorizationHeaderWithUsername:fakeID password:password];
    return YES;
}

#pragma mark 拼装url
//拼装url中固定参数
//serverurl/ cellvisiting/mobile/{sessionId}/{companyId}/method
- (NSString *)queryStringWithMethod:(NSString *) method
{
    NSMutableString *cellvisiting = [[NSMutableString alloc]init];
   
#ifdef HAIBO
    [cellvisiting appendString:@"cellvisiting-mobile"];   
#else
    [cellvisiting appendString:@"cellvisiting"];
#endif
    
    if ([method isEqualToString:@"register"]) {
        return [NSString stringWithFormat:@"%@/account/register",cellvisiting];
    }
    if ([method isEqualToString:@"login"]) {
        
        return [NSString stringWithFormat:@"%@/account/login",cellvisiting];
    }
    if ([method rangeOfString:@"resetPwd"].location == 0) {
        return [NSString stringWithFormat:@"%@/account/%@",cellvisiting,method];
    }
    [cellvisiting appendString:@"/mobile/%@/%@/%@"];
    NSString *urlFormat = cellvisiting;
    return [NSString stringWithFormat:urlFormat,[KHHUser shareInstance].sessionId ,[KHHUser shareInstance].companyId,method];
}

//解析返回结果
- (NSMutableDictionary *)JSONDictionaryWithResponse:(NSData *)responseData
{
    ALog(@"[II] responseData -> JSON dictionary");
    NSString *base64 = [[NSString alloc] initWithBytes:[responseData bytes]
                                                length:[responseData length]
                                              encoding:NSASCIIStringEncoding];
    NSData *decodedData = [NSData dataWithBase64EncodedString:base64];
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:nil];
    NSLog(@"%@",base64);
    NSMutableDictionary *result = dict[@"jsonData"];
    NSNumber *state = result[@"state"];
    NSInteger code = KHHErrorCodeUnresolvableData;
    if (result) {
        if (state) {
            code = state.integerValue;
        } else {
            code = KHHErrorCodeUnknownError;
        }
    } else {
        // 确保返回的 result 不是nil
        result = [NSMutableDictionary dictionaryWithCapacity:2];
        result[JSONDataKeyNote] = @"服务器忙，请稍后再试";
    }
    // 根据状态，插入errorCode
    result[@"errorCode"] = [NSNumber numberWithInteger:code];
    DLog(@"[II] result class = %@, value = %@", [result class], result);
    return result;
}


#pragma mark - 网络请求时默认的错误
-(NSDictionary *) defaultFailedResponseDictionary:(NSError *)error
{
    DLog(@"[II] error = %@", error);
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
    dict[kInfoKeyErrorCode] = @(error.code);
    dict[kInfoKeyErrorMessage] = error.localizedDescription;
    
    return dict;
}

#pragma mark -参数无效的返回的dictionary
-(NSDictionary *) parametersNotMeetRequirementFailedResponseDictionary
{
    NSDictionary *dict = @{
    kInfoKeyErrorCode : [NSString stringWithFormat:@"%d",KHHErrorCodeParametersNotMeetRequirement],
    kInfoKeyErrorMessage : NSLocalizedString(@"参数不满足要求！", nil)
    };
    return dict;
}

#pragma mark - 默认的请求失败block
-(KHHFailureBlock) defaultFailedResponse:(id) delegate selector:(NSString *) selector
{
    KHHFailureBlock failed = ^(AFHTTPRequestOperation *operation, NSError *error){
        NSDictionary *dict = [self defaultFailedResponseDictionary:error];
        if (selector && delegate && [delegate respondsToSelector:NSSelectorFromString(selector)] ) {
            [delegate performSelector:NSSelectorFromString(selector) withObject:dict];
        }
    };
    
    return failed;
}

#pragma mark - 参数是否可用，不可用时执行某delegate下的某函数，并返回网络是否可用
-(void) parametersNotMeetRequirementFailedResponse:(id) delegate selector:(NSString *) selector
{
    if (selector && delegate && [delegate respondsToSelector:NSSelectorFromString(selector)] ) {
        NSDictionary *dict = [self parametersNotMeetRequirementFailedResponseDictionary];
        [delegate performSelector:NSSelectorFromString(selector) withObject:dict];
    }
}

#pragma mark - 无网络时返回
-(NSDictionary *)networkUnableFailedResponseDictionary
{
    NSDictionary *dict = @{
    kInfoKeyErrorCode : [NSString stringWithFormat:@"%d",KHHErrorCodeNotReachable],
    kInfoKeyErrorMessage : NSLocalizedString(@"网络不可用，请检查您的网络状态！", nil)
    };
    return dict;
}


#pragma mark - 封装一下与服务器通讯时url要加入的固定参数
- (void)getPath:(NSString *)methodPath
     parameters:(NSDictionary *)parameters
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    // 组合query url
    NSString *realpath = [self queryStringWithMethod:methodPath];
    DLog(@"realpath = %@",realpath);
    [[NetClient sharedClient] getPath:realpath parameters:parameters success:success failure:failure];
}

- (void)postPath:(NSString *)methodPath
      parameters:(NSDictionary *)parameters
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    // 组合query url
    NSString *realpath = [self queryStringWithMethod:methodPath];
    DLog(@"realpath = %@",realpath);
    [[NetClient sharedClient] postPath:realpath parameters:parameters success:success failure:failure];
}

- (void)putPath:(NSString *)methodPath
     parameters:(NSDictionary *)parameters
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    // 组合query url
    NSString *realpath = [self queryStringWithMethod:methodPath];
    DLog(@"realpath = %@",realpath);
    [[NetClient sharedClient] putPath:realpath parameters:parameters success:success failure:failure];
}

- (void)deletePath:(NSString *)methodPath
        parameters:(NSDictionary *)parameters
           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    // 组合query url
    NSString *realpath = [self queryStringWithMethod:methodPath];
    DLog(@"realpath = %@",realpath);
    [[NetClient sharedClient] deletePath:realpath parameters:parameters success:success failure:failure];
}

- (void)patchPath:(NSString *)methodPath
       parameters:(NSDictionary *)parameters
          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    // 组合query url
    NSString *realpath = [self queryStringWithMethod:methodPath];
    DLog(@"realpath = %@",realpath);
    [[NetClient sharedClient] patchPath:realpath parameters:parameters success:success failure:failure];
}

#pragma mark - 新增时，有文件要上传时的接口
- (void) multipartFormRequestWithPOSTPath:(NSString *)methodPath
                                 parameters:(NSDictionary *)parameters
                  constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))construction
                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    // 创建请求
    NetClient *httpClient = [NetClient sharedClient];
    
    // 组合query url
    NSString *realpath = [self queryStringWithMethod:methodPath];
    DLog(@"realpath = %@",realpath);
    
    NSURLRequest *request = [httpClient
                             multipartFormRequestWithMethod:@"POST"
                             path:realpath
                             parameters:parameters
                             constructingBodyWithBlock:construction];
    AFHTTPRequestOperation *reqOperation = [httpClient
                                            HTTPRequestOperationWithRequest:request
                                            success:success
                                            failure:failure];
    // 实际发送请求
    [httpClient enqueueHTTPRequestOperation:reqOperation];
}

#pragma mark - 修改时，有文件要上传时的接口
- (void) multipartFormRequestWithPUTPath:(NSString *)methodPath
                                parameters:(NSDictionary *)parameters
                 constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))construction
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    // 创建请求
    NetClient *httpClient = [NetClient sharedClient];
    
    // 组合query url
    NSString *realpath = [self queryStringWithMethod:methodPath];
    DLog(@"realpath = %@",realpath);
    
    NSURLRequest *request = [httpClient
                             multipartFormRequestWithMethod:@"PUT"
                             path:realpath
                             parameters:parameters
                             constructingBodyWithBlock:construction];
    AFHTTPRequestOperation *reqOperation = [httpClient
                                            HTTPRequestOperationWithRequest:request
                                            success:success
                                            failure:failure];
    // 实际发送请求
    [httpClient enqueueHTTPRequestOperation:reqOperation];
}
@end
