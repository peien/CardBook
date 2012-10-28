//
//  KHHAppDelegate.m
//  CardBook
//
//  Created by 孙铭 on 12-9-14.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHAppDelegate.h"
#import "KHHDataAPI.h"
#import "KHHDefaults.h"
#import "KHHHTTPClient.h"
#import "KHHNetworkAPI.h"
#import "KHHNotifications.h"
#import "MyTabBarController.h"
#import "ATestViewController.h"
#import "AppStartController.h"

@implementation KHHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // 设置window默认背景
    self.window.backgroundColor = [UIColor blackColor];
    // 设置界面元素的公共属性
    [self customizeCommonUI];
    
    // 注册响应的消息
    [self observeNotificationName:KHHUIShowStartup selector:@"handleShowStartup:"]; // 显示主界面消息
    [self observeNotificationName:nAppShowMainView  selector:@"handleShowMainUI:"]; // 显示主界面消息
    [self observeNotificationName:KHHAppLogout     selector:@"handleLogout:"];// 登出
    
    // 显示Startup界面
    [self.window makeKeyAndVisible];
    [self postASAPNotificationName:KHHUIShowStartup];
    
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
- (void)customizeCommonUI {
    //MARK: - UINavigationBar
    UINavigationBar *navBar = [UINavigationBar appearance];
    UIEdgeInsets navBgInsets = { 0, 0, 0, 0 };
    UIImage *navBarBg = [[UIImage imageNamed:@"title_bg.png"]
                     resizableImageWithCapInsets:navBgInsets];
    [navBar setBackgroundImage:navBarBg
                 forBarMetrics:UIBarMetricsDefault];
    
    //MARK: - UIBarButtonItem
    UIBarButtonItem *barButtonItem = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    UIEdgeInsets barButtonBgInsets = { 12, 16, 12, 16 };
    UIImage *barButtonBg = [[UIImage imageNamed:@"titlebtn_normal.png"]
                            resizableImageWithCapInsets:barButtonBgInsets];
    // 换背景
    [barButtonItem setBackButtonBackgroundImage:barButtonBg
                                       forState:UIControlStateNormal
                                     barMetrics:UIBarMetricsDefault];
    [barButtonItem setBackgroundImage:barButtonBg
                             forState:UIControlStateNormal
                           barMetrics:UIBarMetricsDefault];
    // 调位置
    CGFloat adjustment = -3.f;
    [barButtonItem setBackButtonBackgroundVerticalPositionAdjustment:adjustment
                                                       forBarMetrics:UIBarMetricsDefault];
    [barButtonItem setBackgroundVerticalPositionAdjustment:adjustment
                                             forBarMetrics:UIBarMetricsDefault];
    // Title的位置调整
//    UIOffset titleOffset = {0, 0};
//    [barButtonItem setBackButtonTitlePositionAdjustment:titleOffset
//                                          forBarMetrics:UIBarMetricsDefault];
    
    
}
- (void)handleShowStartup:(NSNotification *)noti {
    // 销毁主界面
    self.window.rootViewController = nil;
    self.mainUI = nil;
    // 显示启动界面
    AppStartController *startVC = [[AppStartController alloc] initWithNibName:nil bundle:nil];
    startVC.agent    = [[KHHNetworkAPIAgent alloc] init];
    startVC.data     = [KHHData sharedData];
    startVC.defaults = [KHHDefaults sharedDefaults];
    self.window.rootViewController = startVC;
}
- (void)handleShowMainUI:(NSNotification *)noti {
#if KHH_TEST_VIEWCONTROLLER == 1
    // 显示 THE TEST VIEW
    self.window.rootViewController = [[ATestViewController alloc] initWithNibName:nil bundle:nil];
#else
    // 显示主界面
    self.mainUI = [[KHHMainUIController alloc] init];
    //暂时写在这里，处理新到联系人或消息提示
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:9999],@"Num", nil];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"KNotificationNewMsgNum" object:dic];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"KNotificationNewContactNum" object:dic];
#endif
}
- (void)handleLogout:(NSNotification *)noti {
    // 清除UserDefaults用户的数据
    [[KHHDefaults sharedDefaults] clearSettingsAfterLogout];
    // 停掉httpclient的operation queue
    [[[KHHHTTPClient sharedClient] operationQueue] cancelAllOperations];
    // 清除httpclient AuthorizationHeader
    [[KHHHTTPClient sharedClient] clearAuthorizationHeader];
    // 清除core data context
    [[KHHData sharedData] removeContext];
    // 切换到登陆界面
    [self postASAPNotificationName:KHHUIShowStartup];
}
//设置时间触发
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    DLog(@"didReceiveLocalNotification");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"时间到" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];

}
@end
