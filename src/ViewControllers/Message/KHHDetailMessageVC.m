//
//  KHHDetailMessageVC.m
//  CardBook
//
//  Created by 王国辉 on 12-9-11.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "KHHDetailMessageVC.h"
#import "KHHShowHideTabBar.h"
@interface KHHDetailMessageVC ()

@end

@implementation KHHDetailMessageVC
@synthesize message;
@synthesize timeLabel;
@synthesize contentLabel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"消息详情";
        self.navigationItem.rightBarButtonItem = nil;
    }
    return self;
}
- (void)rightBarButtonClick:(id)sender
{
 
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithRed:241 green:238 blue:232 alpha:1.0]];
    self.timeLabel.text = self.message.time;
    self.contentLabel.text = self.message.content;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [KHHShowHideTabBar hideTabbar];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.message = nil;
    self.timeLabel = nil;
    self.contentLabel = nil;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
