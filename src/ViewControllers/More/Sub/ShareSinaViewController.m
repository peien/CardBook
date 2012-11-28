//
//  ShareSinaViewController.m
//  LoveCard
//
//  Created by gh w on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ShareSinaViewController.h"
#import "LoginSinaViewController.h"

@interface ShareSinaViewController ()

@end

@implementation ShareSinaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title =@"分享到新浪微博";
        [self.rightBtn setTitle:@"确认" forState:UIControlStateNormal];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)rightBarButtonClick:(id)sender
{
    LoginSinaViewController *logsinaVC = [[LoginSinaViewController alloc] initWithNibName:@"LoginSinaViewController" bundle:nil];
    [self.navigationController pushViewController:logsinaVC animated:YES];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
