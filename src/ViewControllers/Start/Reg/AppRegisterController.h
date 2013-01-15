//
//  AppRegisterController.h
//  CardBook
//
//  Created by Ming Sun on 10/27/12.
//  Copyright (c) 2012 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHHDataRegisterDelegate.h"
@interface AppRegisterController : UIViewController<KHHDataRegisterDelegate>

@property (nonatomic, assign) BOOL isCompany;

@end
