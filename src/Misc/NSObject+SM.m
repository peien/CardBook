//
//  NSObject+SM.m
//  CardBook
//
//  Created by 孙铭 on 8/23/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "NSObject+SM.h"

@implementation NSObject (SMNotification)
- (void)observeNotification:(NSString *)name
                          selector:(NSString *)selector {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:NSSelectorFromString(selector)
                                                 name:name
                                               object:nil];
}
//- (void)observeNotification:(NSString *)name
//                     object:(id)object
//                   selector:(NSString *)selector {
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:NSSelectorFromString(selector)
//                                                 name:name
//                                               object:object];
//}
- (void)stopObservingNotification:(NSString *)name {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:name
                                                  object:nil];
}
- (void)stopObservingAllNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)postNotification:(NSString *)name info:(NSDictionary *)dict {
    [[NSNotificationCenter defaultCenter] postNotificationName:name
                                                        object:nil
                                                      userInfo:dict];
}
// now == YES：发出的消息被立即处理
- (void)postNotification:(NSString *)name
                    info:(NSDictionary *)dict
                     now:(BOOL)now {
    NSNotification *noti = [NSNotification notificationWithName:name
                                                         object:nil
                                                       userInfo:dict];
    DLog(@"[II] 发送 notification = %@", noti);
    [[NSNotificationQueue defaultQueue] enqueueNotification:noti
                                               postingStyle:now?NSPostNow:NSPostASAP];
}

@end

@implementation NSObject (SMInvocation)

@end