//
//  KHHMainUIController.m
//  CardBook
//
//  Created by 孙铭 on 12-9-14.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHMainUIController.h"
#import "KHHExchangeViewController.h"
#import "KHHManagementViewController.h"
#import "KHHHomeViewController.h"
#import "KHHMessageViewController.h"
#import "MoreViewController.h"
#import "MyTabBarController.h"
#import "KHHDataAPI.h"
#import "KHHDefaults.h"
#import "KHHAppDelegate.h"

@interface KHHMainUIController ()
@property (readonly, nonatomic, weak) UIWindow *window; // 当前的keyWindow
@property (readonly, nonatomic, weak) KHHDefaults *defaults; // 当前的keyWindow
@property (strong, nonatomic) MyTabBarController *aTabBarController;
@end

@implementation KHHMainUIController
- (void)dealloc
{
    self.aTabBarController = nil;
}
- (id)init
{
    self = [super init];
    if (self) {
        // 初始化
        _defaults = [KHHDefaults sharedDefaults];
        _aTabBarController = [[MyTabBarController alloc] initWithNum:5];
        
//        // 交换
//        UIViewController *vc3 = [[KHHExchangeViewController alloc] initWithNibName:@"KHHExchangeViewController" bundle:nil];
//        vc3.hidesBottomBarWhenPushed = YES;
//        // 管理
//        UIViewController *vc2 = [[KHHManagementViewController alloc] initWithNibName:@"KHHManagementViewController" bundle:nil];
//        vc2.hidesBottomBarWhenPushed = YES;
//        // 主页 － 所有客户
//        UIViewController *vc1 = [[KHHHomeViewController alloc] initWithNibName:@"KHHHomeViewController" bundle:nil];
//        vc1.hidesBottomBarWhenPushed = YES;
//        // 消息
//        UIViewController *vc4 = [[KHHMessageViewController alloc] initWithNibName:@"KHHMessageViewController" bundle:nil];
//        vc4.hidesBottomBarWhenPushed = YES;
//        // 更多
//        UIViewController *vc5 = [[MoreViewController alloc] initWithNibName:@"MoreViewController" bundle:nil];
//        vc5.hidesBottomBarWhenPushed = YES;
//        UIViewController *navOne = [[UINavigationController alloc] initWithRootViewController:vc1];
//        UIViewController *navTwo = [[UINavigationController alloc] initWithRootViewController:vc2];
//        UIViewController *navThree = [[UINavigationController alloc] initWithRootViewController:vc3];
//        UIViewController *navFour = [[UINavigationController alloc] initWithRootViewController:vc4];
//        UIViewController *navFive = [[UINavigationController alloc] initWithRootViewController:vc5];
        
        //    navOne.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"", nil) image:[UIImage imageNamed:@"ico0.png"] tag:0];
        //    navTwo.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"", nil) image:[UIImage imageNamed:@"ico1.png"] tag:1];
        //    navThree.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"", nil) image:[UIImage imageNamed:@"ico2.png"] tag:2];
        //    navFour.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"", nil) image:[UIImage imageNamed:@"ico3.png"] tag:3];
        //    navFive.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"", nil) image:[UIImage imageNamed:@"ico4.png"] tag:4];
        
        //_aTabBarController.viewControllers = @[ navOne, navTwo, navThree, navFour, navFive ];
        // 显示主界面
        KHHAppDelegate *app = (KHHAppDelegate *)[[UIApplication sharedApplication] delegate];
        app.aTabBarController = self.aTabBarController;
        //消息还没同步完，就直接显示主界面，以至于无法显示消息个数。
        [self performSelector:@selector(showMainUIFor) withObject:nil afterDelay:1];
    }
    return self;
}
- (void)showMainUIFor{
    [self showMainUI];
}
- (UIWindow *)window {
    // 返回当前的keyWindow
    return [UIApplication sharedApplication].keyWindow;
}
#pragma mark -
- (void)showMainUI {
    UIViewController *vc2 = [[KHHManagementViewController alloc] initWithNibName:@"KHHManagementViewController" bundle:nil];
    UIViewController *navTwo = [[UINavigationController alloc] initWithRootViewController:vc2];
    //self.window.rootViewController = self.aTabBarController;
    self.window.rootViewController = navTwo;
}
@end
