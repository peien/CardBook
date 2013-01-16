//
//  AppLoginController.h
//  CardBook
//
//  Created by Sun Ming on 12-10-26.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "KHHDataNew+Account.h"
#import "ResetPasswordViewController.h"
#import "AppRegisterController.h"

@interface AppLoginController : SuperViewController<KHHDataAccountDelegate,ResetPasswordDelegate>
@property (nonatomic,strong) id<changeViewDelegate> delegate;
@end
