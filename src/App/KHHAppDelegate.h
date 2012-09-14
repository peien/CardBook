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

@interface KHHAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) KHHMainUIController *mainUI;

@end
