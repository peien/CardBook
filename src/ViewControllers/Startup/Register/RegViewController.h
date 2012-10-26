//
//  RegViewController.h
//  eCard
//
//  Created by Ming Sun on 12-4-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SignupAccountFieldTag     1002
#define SignupPasswordFieldTag 1003

@interface RegViewController : UIViewController <UITableViewDelegate,
                                                UITableViewDataSource, 
                                                UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITableView *regTableView;
@property (nonatomic, weak) IBOutlet UIButton *theRegButton;
@property (nonatomic, weak) IBOutlet UITextView *theWarnTextView;

- (IBAction) registerThis: (id) sender;
- (IBAction) showAgreement:(id) sender;
@end
