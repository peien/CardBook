//
//  NSObject+SM.h
//  CardBook
//
//  Created by 孙铭 on 8/23/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 */
NSString *KHHDateStringFromDate(NSDate *aDate);
NSDate *DateFromKHHDateString(NSString *aString);

@interface NSObject (SMNotification)
- (void)observeNotificationName:(NSString *)name selector:(NSString *)selector;
- (void)stopObservingNotificationName:(NSString *)name;
- (void)stopObservingAllNotifications;

// 发出的消息被立即处理（NOW）
- (void)postNowNotificationName:(NSString *)name;
- (void)postNowNotificationName:(NSString *)name info:(NSDictionary *)dict;
// 发出的消息被尽快处理（ASAP）
- (void)postASAPNotificationName:(NSString *)name;
- (void)postASAPNotificationName:(NSString *)name info:(NSDictionary *)dict;
// now == YES：发出的消息被立即处理
- (void)postQueueNotificationName:(NSString *)name
                             info:(NSDictionary *)dict
                     postingStyle:(NSPostingStyle)style;
@end
