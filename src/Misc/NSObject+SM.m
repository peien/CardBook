//
//  NSObject+SM.m
//  CardBook
//
//  Created by 孙铭 on 8/23/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "NSObject+SM.h"

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
