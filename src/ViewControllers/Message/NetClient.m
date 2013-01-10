//
//  NetClient.m
//  CardBook
//
//  Created by CJK on 12-12-27.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "NetClient.h"
#import "AFJSONRequestOperation.h"
#import "NSString+Networking.h"
#import "NSString+MD5.h"
#import "NSData+Base64.h"
#import "KHHStatusCodes.h"

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
        [self registerHTTPOperationClass:[AFHTTPRequestOperation class]];        
       
        // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
        /**
         受当前服务器糟糕设计的限制，暂时不做限制。
         */
        //        [self setDefaultHeader:@"Accept" value:@"application/json"];
        
    }
    return self;
}

#pragma mark - netState

- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    if ([_r currentReachabilityStatus] == NotReachable) {
        if (success) {
            NSError *error = [[NSError alloc]initWithDomain:@"网络不可用,不能进行操作!" code:KHHErrorCodeNotReachable userInfo:nil];            
            failure(nil,error);
        }
        return nil;
        
    }
    return [super HTTPRequestOperationWithRequest:request success:success failure:failure];
}


#pragma mark - service url
- (NSURL *) currentServerUrl
{
    return [_netFromPlist currentUrl];
}

#pragma mark - Utils
- (NSString *)queryStringWithDictionary:(NSDictionary *)aDictionary
{
    
    NSMutableDictionary *queryDict = [NSMutableDictionary dictionaryWithDictionary:aDictionary];
    
    // timestamp
    NSString *timestamp = [[[NSNumber numberWithDouble:(1000.0 * [[NSDate date] timeIntervalSince1970])]
                            stringValue] stringByDeletingPathExtension];//毫秒
    [queryDict setObject:timestamp forKey:@"timestamp"];
    
    // format
    [queryDict setObject:KHHJSONFormat forKey:@"format"];
    
    // sign
    NSString *signature = [self signatureWithDictionary:queryDict];
    [queryDict setObject:signature forKey:@"sign"];
    
    //
    NSString *result = [@"" stringByAppendingQueryParameters:queryDict];
    DLog(@"[II] query = %@", result);
    return result;
}

- (NSString *)signatureWithDictionary:(NSDictionary *)aDictionary
{
    NSArray *keys=[[aDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSMutableString *result = [NSMutableString stringWithString:KHHHttpSignatureKey];
    for (NSString *key in keys) {
        [result appendString:key];
        [result appendString:[aDictionary objectForKey:key]];
    }
    [result appendString:KHHHttpSignatureKey];
    return [result MD5];
}


- (NSMutableDictionary *)JSONDictionaryWithResponse:(NSData *)responseData
{
    ALog(@"[II] responseData -> JSON dictionary");
    NSString *base64 = [[NSString alloc] initWithBytes:[responseData bytes]
                                                length:[responseData length]
                                              encoding:NSASCIIStringEncoding];
    NSData *decodedData = [NSData dataWithBase64EncodedString:base64];
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:decodedData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:nil];
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
    }
    // 根据状态，插入errorCode
    result[@"errorCode"] = [NSNumber numberWithInteger:code];
    DLog(@"[II] result class = %@, value = %@", [result class], result);
    return result;
}
@end
