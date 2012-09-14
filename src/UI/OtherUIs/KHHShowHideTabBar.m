//
//  KHHShowHideTabBar.m
//  CardBook
//
//  Created by 王国辉 on 12-8-30.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "KHHShowHideTabBar.h"
#import "KHHAppDelegate.h"
#import "MyTabBarController.h"
@implementation KHHShowHideTabBar
+ (void)showTabbar
{
    KHHAppDelegate *app = (KHHAppDelegate *)[[UIApplication sharedApplication] delegate];
#warning 改写这里
//    MyTabBarController *tab = (MyTabBarController *)app.aTabBarController;
//    tab.tabBarView.hidden = NO;

}
+ (void)hideTabbar
{
    KHHAppDelegate *app = (KHHAppDelegate *)[[UIApplication sharedApplication] delegate];
#warning 改写这里
//    MyTabBarController *tab = (MyTabBarController *)app.aTabBarController;
//    tab.tabBarView.hidden = YES;

}
@end
