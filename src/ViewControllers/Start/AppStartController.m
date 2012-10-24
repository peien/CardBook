//
//  AppStartController.m
//  CardBook
//
//  Created by Sun Ming on 12-10-24.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "AppStartController.h"
#import "KHHNotifications.h"
#import "IntroViewController.h"
#import "LaunchImageViewController.h"
#import "LoginActionViewController.h"
#import "LoginViewController.h"
#import "BTestViewController.h"

@interface AppStartController (Utils)
- (void)transitionToViewController:(UIViewController *)toViewController
                           options:(UIViewAnimationOptions)options;
@end

@implementation AppStartController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)dealloc {
    [self stopObservingAllNotifications];
}//dealloc
#pragma mark - 从这里开始
- (void)viewDidLoad
{
    [super viewDidLoad];
    DLog(@"[II] viewDidLoad...");
    
    // 先显示 Launch Image。
    [self showLaunchImage];
    
    // 判断是否是首次启动。首次启动显示引导页，不是首次启动根据标志进不同界面。
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

@implementation AppStartController (ShowViews)
- (void)showTestView {
    UIViewController *toVC = [[BTestViewController alloc] initWithNibName:nil bundle:nil];
    UIViewAnimationOptions options = UIViewAnimationOptionTransitionCurlUp;
    [self transitionToViewController:toVC
                             options:options];
}
#pragma mark - 显示界面
- (void)showLaunchImage {
    UIViewController *toVC = [[LaunchImageViewController alloc] initWithNibName:nil bundle:nil];
    UIViewAnimationOptions options = UIViewAnimationOptionTransitionCurlUp;
    [self transitionToViewController:toVC
                             options:options];
}
- (void)showIntroView {
    UIViewController *toVC = [[IntroViewController alloc] initWithNibName:nil bundle:nil];
    UIViewAnimationOptions options = UIViewAnimationOptionTransitionCurlUp;
    [self transitionToViewController:toVC
                             options:options];
}
- (void)showLoginView {
    
}

@end

@implementation AppStartController (Utils)
- (void)transitionToViewController:(UIViewController *)toViewController
                           options:(UIViewAnimationOptions)options {
    DLog(@"[II] 切换前：\n \
         child controllers = %@\n \
         subviews = %@", self.childViewControllers, self.view.subviews);
    if (self.childViewControllers.count) {
        UIViewController *fromVC = self.childViewControllers.lastObject;
        [self addChildViewController:toViewController];
        [self transitionFromViewController:fromVC
                          toViewController:toViewController
                                  duration:APP_START_TRANSITION_DURATION
                                   options:options
                                animations:nil
                                completion:^(BOOL finished) {
                                }];
        [fromVC.view removeFromSuperview];
        [fromVC removeFromParentViewController];
    } else {
        [self addChildViewController:toViewController];
        [self.view addSubview:toViewController.view];
    }
    
    DLog(@"[II] 切换后：\n \
         child controllers = %@\n \
         subviews = %@", self.childViewControllers, self.view.subviews);
}
@end
