//
//  NSObject+Notification.m
//  CardBook
//
//  Created by 孙铭 on 8/23/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "NSObject+Notification.h"

@implementation NSObject (Notification)
- (void)observeNotification:(NSString *)name
                          selector:(NSString *)selector {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:NSSelectorFromString(selector)
                                                 name:name
                                               object:nil];
}
- (void)observeNotification:(NSString *)name
                     object:(id)object
                   selector:(NSString *)selector {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:NSSelectorFromString(selector)
                                                 name:name
                                               object:object];
}
- (void)stopObservingNotification:(NSString *)name {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:name
                                                  object:nil];
}
- (void)stopObservingAllNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)postNotification:(NSString *)name info:(NSDictionary *)dict {
    [self postNotification:name info:dict now:NO];
}
// now == YES：发出的消息被立即处理
- (void)postNotification:(NSString *)name
                    info:(NSDictionary *)dict
                     now:(BOOL)now {
    NSNotification *noti = [NSNotification notificationWithName:name
                                                         object:self
                                                       userInfo:dict];
    DLog(@"[II] 发送 notification = %@", noti);
    [[NSNotificationQueue defaultQueue] enqueueNotification:noti
                                               postingStyle:now?NSPostNow:NSPostASAP];
}

@end
