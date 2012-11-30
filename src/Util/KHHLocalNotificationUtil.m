//
//  KHHLocalNotificationUtil.m
//  CardBook
//
//  Created by 王定方 on 12-11-23.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHLocalNotificationUtil.h"

@implementation KHHLocalNotificationUtil

//默认声音，不重复
+(void) addLocalNotifiCation:(NSDate *) fireDate alertBody:(NSString *) alertBody
{
    [self addLocalNotifiCation:fireDate alertBody:alertBody repeatInterval:0];
}

//不重复，按用户指定的声音
+(void) addLocalNotifiCation:(NSDate *) fireDate alertBody:(NSString *) alertBody soundName:(NSString *) soundName
{
    [self addLocalNotifiCation:fireDate alertBody:alertBody repeatInterval:0 soundName:soundName];
}


//按用户设置的重复时间，用默认声音
+(void) addLocalNotifiCation:(NSDate *) fireDate alertBody:(NSString *) alertBody repeatInterval:(NSInteger) repeatInterval
{
    [self addLocalNotifiCation:fireDate alertBody:alertBody repeatInterval:repeatInterval soundName:UILocalNotificationDefaultSoundName];
}

//默认声音、不重复、有参数
+(void) addLocalNotifiCation:(NSDate *) fireDate alertBody:(NSString *) alertBody userinfo:(NSDictionary *) dict
{
    [self addLocalNotifiCation:fireDate alertBody:alertBody repeatInterval:0 soundName:UILocalNotificationDefaultSoundName userInfo:dict];
}

//按用户设置的重复时间，按用户设置的声音
+(void) addLocalNotifiCation:(NSDate *) fireDate alertBody:(NSString *) alertBody repeatInterval:(NSInteger) repeatInterval  soundName:(NSString *) soundName
{
    [self addLocalNotifiCation:fireDate alertBody:alertBody repeatInterval:repeatInterval soundName:soundName userInfo:nil];
}

//有用户信息的本地提醒
+(void) addLocalNotifiCation:(NSDate *) fireDate alertBody:(NSString *) alertBody repeatInterval:(NSInteger) repeatInterval  soundName:(NSString *) soundName userInfo:(NSDictionary *) dict
{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil)
    {
        //提醒时间
        notification.fireDate = fireDate;
        notification.timeZone = [NSTimeZone defaultTimeZone];
        //重复提醒时间
        notification.repeatInterval = repeatInterval;
        //提醒时间
        notification.soundName = UILocalNotificationDefaultSoundName;
        //给应用图标数字+1
        NSInteger number = [[UIApplication sharedApplication] applicationIconBadgeNumber];
        notification.applicationIconBadgeNumber = ++number;
        //alertBody
        notification.alertBody = alertBody;
        //notification.alertAction = @"打开";
        //添加参数值
        notification.userInfo = dict;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}
@end
