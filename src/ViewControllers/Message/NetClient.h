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
#import "KHHTypes.h"
@interface NetClient : AFHTTPClient

@property (nonatomic,strong) NetFromPlist *netFromPlist;


+ (NetClient *)sharedClient;

#pragma server url
-(NSURL *) currentServerUrl;

#pragma mark - Utils
- (NSString *)queryStringWithDictionary:(NSDictionary *)aDictionary;
- (NSMutableDictionary *)JSONDictionaryWithResponse:(NSData *)responseData;

#pragma 网络请求时默认的错误
//默认失败请求返回的dict
//-(NSDictionary *) defaultFailedResponseDictionary:(NSError *)error;
//参数不满足时返回
-(NSDictionary *) parametersNotMeetRequirementFailedResponseDictionary;
//默认的请求失败block
-(KHHFailureBlock) defaultFailedResponse:(id) delegate selector:(NSString *) selector;
@end
