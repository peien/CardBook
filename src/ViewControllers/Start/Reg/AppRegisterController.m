//
//  AppRegisterController.m
//  CardBook
//
//  Created by Ming Sun on 10/27/12.
//  Copyright (c) 2012 Kinghanhong. All rights reserved.
//

#import "AppRegisterController.h"
#import "KHHNotifications.h"

@interface AppRegisterController ()

@end

@implementation AppRegisterController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = NSLocalizedString(@"注册", nil);
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"返回", nil)
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(goBack:)];
        self.navigationItem.leftBarButtonItem = backItem;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack:(id)sender {
    [self postASAPNotificationName:nAppShowPreviousView];
}
@end
