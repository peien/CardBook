//
//  AppRegisterController.h
//  CardBook
//
//  Created by Ming Sun on 10/27/12.
//  Copyright (c) 2012 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHHDataNew+Account.h"

@protocol changeViewDelegate <NSObject>
@required
- (void)changeToActionView;
- (void)changeToCreateAccountView;
- (void)changeToManageView;

- (void)showPreviousView;

@end

@interface AppRegisterController : UIViewController<KHHDataAccountDelegate>

@property (nonatomic, assign) BOOL isCompany;
@property (nonatomic,strong) id<changeViewDelegate> delegate;

@end
