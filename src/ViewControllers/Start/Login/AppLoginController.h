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
#import "KHHDataNew+Group.h"
#import "KHHDataNew+Template.h"
#import "KHHDataNew+Card.h"
#import "KHHDataNew+SyncDefault.h"
#import "KHHDataNew+SyncContact.h"

@interface AppLoginController : SuperViewController<KHHDataAccountDelegate,ResetPasswordDelegate,KHHDataGroupDelegate,KHHDataSyncDefaultDelegate,KHHDataSyncContactDelegate>
@property (nonatomic,strong) id<changeViewDelegate> delegate;
@end
