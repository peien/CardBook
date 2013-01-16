//
//  ResetPasswordViewController.h
//  eCard
//
//  Created by Ming Sun on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHHDataNew+Account.h"

@protocol ResetPasswordDelegate <NSObject>

- (void)doReset:(NSString *)phone;

@end

@interface ResetPasswordViewController : UIViewController<KHHDataAccountDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *theView;
@property (nonatomic, weak) IBOutlet UITextField *theTextField;
@property (nonatomic, weak) IBOutlet UIButton *theOKButton;
@property (nonatomic, strong) id<ResetPasswordDelegate> delegate;
- (IBAction)actionButtonPressed:(id)sender;

@end
