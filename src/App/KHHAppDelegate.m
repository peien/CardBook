//
//  KHHAppDelegate.m
//  CardBook
//
//  Created by 孙铭 on 12-9-14.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHAppDelegate.h"
#import "NSObject+Notification.h"
#import "KHHNotifications.h"
#import "MyTabBarController.h"

@implementation KHHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor blackColor];
    
    // 注册响应的消息
    [self observeNotification:KHHNotificationShowStartup selector:@"handleShowStartup:"]; // 显示主界面消息
    [self observeNotification:KHHNotificationShowMainUI  selector:@"handleShowMainUI:"]; // 显示主界面消息
    
    // 显示Startup界面
    [self.window makeKeyAndVisible];
    [self postNotification:KHHNotificationShowStartup info:nil];
    
    //捕获摇摇动作
    application.applicationSupportsShakeToEdit = YES;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
- (void)handleShowStartup:(NSNotification *)noti {
    // 销毁主界面
    self.window.rootViewController = nil;
    self.mainUI = nil;
    // 显示启动界面
    self.window.rootViewController = [[StartupViewController alloc] initWithNibName:nil bundle:nil];
}
- (void)handleShowMainUI:(NSNotification *)noti {
    // 显示主界面
    self.mainUI = [[KHHMainUIController alloc] init];
    //暂时写在这里，处理新到联系人或消息提示
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:9999],@"Num", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KNotificationNewMsgNum" object:dic];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KNotificationNewContactNum" object:dic];
}
//设置时间触发
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    DLog(@"didReceiveLocalNotification");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"时间到" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];

}
@end
