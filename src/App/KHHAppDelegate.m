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

#import "NSString+Base64.h"
#import "KHHTypes.h"

@implementation KHHAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // 设置window默认背景
    self.window.backgroundColor = [UIColor blackColor];
    

     [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    // 设置界面元素的公共属性
    [self customizeCommonUI];
    
    //启动百度地图
    _mapManager = [[BMKMapManager alloc] init];
    BOOL ret = [_mapManager start:KHHMessageBMapAPIKey generalDelegate:nil];
    if (!ret) {
        NSLog(@"mapManager start failed!");
    }
    // 注册响应的消息
    [self observeNotificationName:KHHUIShowStartup selector:@"handleShowStartup:"]; // 显示主界面消息
    [self observeNotificationName:nAppShowMainView  selector:@"handleShowMainUI:"]; // 显示主界面消息
    [self observeNotificationName:KHHAppLogout     selector:@"handleLogout:"];// 登出    
   
        AppStartController *startVC = [[AppStartController alloc] initWithNibName:nil bundle:nil];
        startVC.agent    = [[KHHNetworkAPIAgent alloc] init];
        startVC.data     = [KHHData sharedData];
        startVC.defaults = [KHHDefaults sharedDefaults];
        self.window.rootViewController = startVC;
    
    
    // 显示启动界面
   
    
    // 显示Startup界面
    [self.window makeKeyAndVisible];
   // [self postASAPNotificationName:KHHUIShowStartup];
    
    //捕获摇摇动作
    application.applicationSupportsShakeToEdit = YES;
    //清除程序图标数字（每次新进程序时默认把图标的数字清空）
    [application setApplicationIconBadgeNumber:0];
    UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif)
    {
        //更新应用程序新消息图标数
        [self updateApplicationIconNumber:application];
    }
    
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

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *_deviceToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    _deviceToken = [_deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    //NSString *str = [[NSString alloc] initWithData:deviceToken encoding:NSUTF16StringEncoding];
    DLog(@"%@",_deviceToken);
    [KHHDefaults sharedDefaults].token = _deviceToken;
//    [PFPush storeDeviceToken:deviceToken];
//    [PFPush subscribeToChannelInBackground:@"" block:^(BOOL succeeded, NSError *error) {
//        if (succeeded)
//            NSLog(@"Successfully subscribed to broadcast channel!");
//        else
//            NSLog(@"Failed to subscribe to broadcast channel; Error: %@",error);
//    }];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error.code == 3010) {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    } else {
        // show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
	}
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    DLog(@"userInfo%@",userInfo);
    //PFPush handlePush:userInfo];
   NSString *type = [userInfo objectForKey:@"type"];
    if([type isEqualToString:@"1"]){
        if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
            [[NetClient sharedClient]doReseaveMessage:(id<delegateMsgForMain>)[(UINavigationController *)self.window.rootViewController topViewController]];
                
        }
        
       // [[KHHData sharedData] syncMessages];
    }else{
        [[KHHData sharedData]syncReceivedCards:[NSArray arrayWithObject:@(KHHQueuedOperationSyncReceivedCards)]];
    }
    
    [self updateApplicationIconNumber:application];
    
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
    UIEdgeInsets barButtonBgInsets = { 0, 16, 0, 16 };
    UIImage *barButtonBg = [[UIImage imageNamed:@"titlebtn_normal.png"]
                            resizableImageWithCapInsets:barButtonBgInsets];
    // 换背景
    [barButtonItem setBackButtonBackgroundImage:barButtonBg
                                       forState:UIControlStateNormal
                                     barMetrics:UIBarMetricsDefault];
    [barButtonItem setBackgroundImage:barButtonBg
                             forState:UIControlStateNormal
                           barMetrics:UIBarMetricsDefault];
    // 调背景位置
    CGFloat adjustment = -2.f;
    [barButtonItem setBackButtonBackgroundVerticalPositionAdjustment:adjustment
                                                       forBarMetrics:UIBarMetricsDefault];
    [barButtonItem setBackgroundVerticalPositionAdjustment:adjustment
                                             forBarMetrics:UIBarMetricsDefault];
    // 调Title位置
    UIOffset titleOffset = {0, 0};
    [barButtonItem setBackButtonTitlePositionAdjustment:titleOffset
                                          forBarMetrics:UIBarMetricsDefault];
    [barButtonItem setTitlePositionAdjustment:titleOffset
                                forBarMetrics:UIBarMetricsDefault];
    
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

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{

    UIApplicationState state = application.applicationState;
    //    NSLog(@"%@,%d",notification,state);
    if (state == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:KHH_APP_NAME
                                                        message:notification.alertBody
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:KHHMessageSure,nil];
        [alert show];
    }

    //若有notification里有数就取里面的dictionary
    NSDictionary* infoDic = notification.userInfo;
    if (infoDic) {
        NSLog(@"userInfo description=%@",[infoDic description]);
        //获取要跳转的viewcontrollerName
        NSString * targetViewCtrollerName = infoDic[kLocalNotification_Target_Name];
        if (targetViewCtrollerName && targetViewCtrollerName.length > 0) {
            //测试跳转到某个界面
            if(self.window.rootViewController && [self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
                id viewController = [[NSClassFromString(targetViewCtrollerName) alloc] initWithNibName:nil bundle:nil];
                UINavigationController* navigate = (UINavigationController *) self.window.rootViewController;
                if (navigate) {
                    //不管在哪个界面回到主界面
                    [navigate popToRootViewControllerAnimated:YES];
                    //跳转到目标界面
                    [navigate pushViewController:viewController animated:YES];
                }
            }
        }
    }
    
    //更新应用程序图标数字
    [self updateApplicationIconNumber:application];
}

//更新应用程序图标数字
-(void) updateApplicationIconNumber:(UIApplication *)application {
    NSInteger number = application.applicationIconBadgeNumber;
    if (number <= 0) {
        return;
    }
    number -= 1;
    application.applicationIconBadgeNumber = number;
}
@end
