//
//  NSObject+SM.m
//  CardBook
//
//  Created by 孙铭 on 8/23/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "NSObject+SM.h"
#import "KHHLog.h"
/*!
 */
NSString *KHHDateStringFromDate(NSDate *aDate) {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    df.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSString *string = [df stringFromDate:aDate];
    DLog(@"[II] date = %@, timezone = %@", string, df.timeZone);
    return string;
}
NSDate *DateFromKHHDateString(NSString *aString) {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    df.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSDate *date = [df dateFromString:aString];
    DLog(@"[II] date = %@, timezone = %@", date, df.timeZone);
    return date;
}

@implementation NSObject (SMNotification)
- (void)observeNotificationName:(NSString *)name selector:(NSString *)selector {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:NSSelectorFromString(selector)
                                                 name:name
                                               object:nil];
}
- (void)stopObservingNotificationName:(NSString *)name {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:name
                                                  object:nil];
}
- (void)stopObservingAllNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
// 发出的消息被立即处理（NOW）
- (void)postNowNotificationName:(NSString *)name {
    [self postNowNotificationName:name info:nil];
}
- (void)postNowNotificationName:(NSString *)name info:(NSDictionary *)dict {
    [self postQueueNotificationName:name info:dict postingStyle:NSPostNow];
}
- (void)postASAPNotificationName:(NSString *)name {
    [self postASAPNotificationName:name info:nil];
}
// NSPostASAP
- (void)postASAPNotificationName:(NSString *)name info:(NSDictionary *)dict {
    [self postQueueNotificationName:name info:dict postingStyle:NSPostASAP];
}
// now == YES：发出的消息被立即处理
- (void)postQueueNotificationName:(NSString *)name
                             info:(NSDictionary *)dict
                     postingStyle:(NSPostingStyle)style {
    NSNotification *noti = [NSNotification notificationWithName:name
                                                         object:self
                                                       userInfo:dict];
    DLog(@"[II] 发送 notification = %@", noti);
    [[NSNotificationQueue defaultQueue] enqueueNotification:noti
                                               postingStyle:style];
}

@end
