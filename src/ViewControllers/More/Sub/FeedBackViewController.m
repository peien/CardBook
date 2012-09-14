//
//  FeedBackViewController.m
//  CardBook
//
//  Created by 王国辉 on 12-9-4.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "FeedBackViewController.h"

#define URL_CONTACT_US @"http://www.kinghanhong.com/XCardServer/contactUs.jsp"
#define textContactUs NSLocalizedString(@"反馈", @"")
@interface FeedBackViewController ()

@end

@implementation FeedBackViewController
@synthesize webView = _webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = textContactUs;
        self.navigationItem.rightBarButtonItem = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSURL *url = [NSURL URLWithString:URL_CONTACT_US];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:req];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _webView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
