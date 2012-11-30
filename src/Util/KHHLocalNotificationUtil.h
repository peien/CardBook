//
//  KHHLocalNotificationUtil.h
//  CardBook
//
//  Created by 王定方 on 12-11-23.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KHHLocalNotificationUtil : NSObject
+(void) addLocalNotifiCation:(NSDate *) fireDate alertBody:(NSString *) alertBody;
+(void) addLocalNotifiCation:(NSDate *) fireDate alertBody:(NSString *) alertBody soundName:(NSString *) soundName;
+(void) addLocalNotifiCation:(NSDate *) fireDate alertBody:(NSString *) alertBody repeatInterval:(NSInteger) repeatInterval;
+(void) addLocalNotifiCation:(NSDate *) fireDate alertBody:(NSString *) alertBody userinfo:(NSDictionary *) dict;
+(void) addLocalNotifiCation:(NSDate *) fireDate alertBody:(NSString *) alertBody repeatInterval:(NSInteger) repeatInterval  soundName:(NSString *) soundName;
+(void) addLocalNotifiCation:(NSDate *) fireDate alertBody:(NSString *) alertBody repeatInterval:(NSInteger) repeatInterval  soundName:(NSString *) soundName userInfo:(NSDictionary *) dict;
@end
