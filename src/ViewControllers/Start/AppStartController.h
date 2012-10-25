//
//  AppStartController.h
//  CardBook
//
//  Created by Sun Ming on 12-10-24.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#define APP_START_TRANSITION_DURATION 0.3f

@interface AppStartController : UIViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
@end
@interface AppStartController (ShowViews)
- (void)showLaunchImage;
- (void)showTestView;
@end
