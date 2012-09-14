//
//  ResetPasswordViewController.h
//  eCard
//
//  Created by Ming Sun on 12-5-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetPasswordViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView *theView;
@property (nonatomic, weak) IBOutlet UITextField *theTextField;
@property (nonatomic, weak) IBOutlet UIButton *theOKButton;

- (IBAction)actionButtonPressed:(id)sender;

@end
