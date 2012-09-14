//
//  UseGuideViewController.m
//  CardBook
//
//  Created by 王国辉 on 12-9-4.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "UseGuideViewController.h"

#define URL_FAQ @"http://www.kinghanhong.com/XCardServer/useGuide.jsp"

@interface UseGuideViewController ()

@end

@implementation UseGuideViewController
@synthesize web = _web;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"使用指南";
        self.navigationItem.rightBarButtonItem = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSURL *url = [NSURL URLWithString:URL_FAQ];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [self.web loadRequest:req];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _web = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
