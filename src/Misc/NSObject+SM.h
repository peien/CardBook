//
//  NSObject+SM.h
//  CardBook
//
//  Created by 孙铭 on 8/23/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SMNotification)
- (void)observeNotification:(NSString *)name
                   selector:(NSString *)selector;
//- (void)observeNotification:(NSString *)name
//                     object:(id)object
//                   selector:(NSString *)selector;
- (void)stopObservingNotification:(NSString *)name;
- (void)stopObservingAllNotifications;

// 发出的消息被立即处理（NOW）
- (void)postNotification:(NSString *)name
                    info:(NSDictionary *)dict;
// now == YES：发出的消息被立即处理
- (void)postNotification:(NSString *)name
                    info:(NSDictionary *)dict
                     now:(BOOL)now;
@end
