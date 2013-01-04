//
//  KHHNetworkAPIAgent+Statistics.m
//  CardBook
//
//  Created by 孙铭 on 8/29/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//
#include <sys/types.h>
#include <sys/sysctl.h>
#import "KHHNetworkAPIAgent+Statistics.h"
#import "Reachability.h"
#import "KHHDefaults.h"

@implementation KHHNetworkAPIAgent (Statistics)
/**
 用户注册信息保存 registerRecordService.save
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=190
 */
/**
 用户登录信息保存 kinghhLoginInfoService.saveLoginInfo
 http://s1.kinghanhong.com:8888/zentaopms/www/index.php?m=doc&f=view&docID=189
 */
- (void)saveToken{
    if (![KHHDefaults sharedDefaults].token ) {
        return;
    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setValue:[self typeNet]  forKey:@"netType"];
    [param setValue:[self platformString]  forKey:@"device.phoneType"];
   [param setValue:[KHHDefaults sharedDefaults].token forKey:@"device.deviceToken"];
   [param setValue:@"IOS" forKey:@"device.opsType"];
    [param setValue:[[UIDevice currentDevice] systemVersion]  forKey:@"device.opsVersion"];
    [param setValue:@"Apple" forKey:@"device.phoneBrand"];

    [self postAction:@"loginSaveToServer" query:@"kinghhLoginInfoService.saveLoginInfo" parameters:param];
}

- (NSString*)getDeviceVersion
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char*)malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    //NSString *platform = [NSStringstringWithUTF8String:machine];二者等效
    free(machine);
    return platform;
}

- (NSString *)platformString{
    NSString *platform = [self getDeviceVersion];
    if ([platform isEqualToString:@"iPhone1,1"])   return@"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])   return@"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])   return@"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])   return@"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])   return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPod1,1"])     return@"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])     return@"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])     return@"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])     return@"iPod Touch 4G";
    if ([platform isEqualToString:@"iPad1,1"])     return@"iPad";
    if ([platform isEqualToString:@"iPad2,1"])     return@"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])     return@"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])     return@"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"i386"])        return@"Simulator";
    
    return platform;
}

- (NSString *)typeNet{
    NSString *typeNet;
    Reachability *r = [Reachability reachabilityWithHostname:@"www.apple.com"];
    
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            // 没有网络连接
            typeNet = @"NotReachable";
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            typeNet = @"ReachableViaWWAN";
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            typeNet = @"ReachableViaWiFi";
            break;
    }
    return typeNet;
}
@end
