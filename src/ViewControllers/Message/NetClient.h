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
@interface NetClient : AFHTTPClient

@property (nonatomic,strong) NetFromPlist *netFromPlist;


+ (NetClient *)sharedClient;

#pragma mark - Utils
- (NSString *)queryStringWithDictionary:(NSDictionary *)aDictionary;
- (NSMutableDictionary *)JSONDictionaryWithResponse:(NSData *)responseData;

@end
