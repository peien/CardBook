//
//  NSObject+Notification.h
//  CardBook
//
//  Created by 孙铭 on 8/23/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Notification)
- (void)observeNotification:(NSString *)name
                   selector:(NSString *)selector;
- (void)observeNotification:(NSString *)name
                     object:(id)object
                   selector:(NSString *)selector;
- (void)stopObservingNotification:(NSString *)name;
- (void)stopObservingAllNotifications;
- (void)postNotification:(NSString *)name
                    info:(NSDictionary *)dict;
@end
