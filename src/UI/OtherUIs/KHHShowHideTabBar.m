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
#import "KHHMainUIController.h"
@implementation KHHShowHideTabBar
+ (void)showTabbar
{
    KHHAppDelegate *app = (KHHAppDelegate *)[[UIApplication sharedApplication] delegate];
    MyTabBarController *tab = (MyTabBarController *)app.aTabBarController;
    tab.tabBarView.hidden = NO;

}
+ (void)hideTabbar
{
    KHHAppDelegate *app = (KHHAppDelegate *)[[UIApplication sharedApplication] delegate];
    MyTabBarController *tab = (MyTabBarController *)app.aTabBarController;
    tab.tabBarView.hidden = YES;

}
@end
