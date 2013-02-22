//
//  SuperViewController.h
//  LoveCard
//
//  Created by gh w on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHHTypes.h"
#import "KHHDataMessageDelegate.h"
#import "KHHDataSyncContactDelegate.h"
#import "KHHDataCardDelegate.h"

@interface SuperViewController : UIViewController<KHHDataMessageDelegate,KHHDataSyncContactDelegate,KHHDataCardDelegate>
@property (strong, nonatomic) UIButton *leftBtn;
@property (strong, nonatomic) UIButton *rightBtn;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end
