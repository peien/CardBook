//
//  KHHAppDelegate.h
//  CardBook
//
//  Created by 孙铭 on 12-9-14.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StartupViewController.h"
#import "KHHMainUIController.h"
#import "MyTabBarController.h"
#import "BMapKit.h"
#import "NetClient+Message.h"

@interface KHHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) KHHMainUIController *mainUI;
@property (nonatomic, strong) MyTabBarController  *aTabBarController;

//把这个放在KHHBMapViewController里的时候，查看完地图返回上个viewcontroller的时候程序会闪退
//故跟baidu提供的例子一样放在appdelegate类里
@property (strong, nonatomic) BMKMapManager *mapManager;
@end
