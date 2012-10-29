//
//  KHHFullFrameController.m
//  CardBook
//
//  Created by 王国辉 on 12-9-20.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHFullFrameController.h"

@interface KHHFullFrameController ()

@end

@implementation KHHFullFrameController
@synthesize image = _image;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
    UIImageView *imgview = [[UIImageView alloc] initWithImage:_image];
    imgview.userInteractionEnabled = YES;
    imgview.frame = CGRectMake(0, 0, 320, 480);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOriginal:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [imgview addGestureRecognizer:tap];
    [self.view addSubview:imgview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _image = nil;

}
- (void)tapOriginal:(UITapGestureRecognizer *)sender
{
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
    [self.navigationController popViewControllerAnimated:YES];

}
//ios 6 不能横屏了
- (BOOL)shouldAutorotate{
    return YES;
}
//- (NSUInteger)supportedInterfaceOrientations{
//    return UIInterfaceOrientationMaskLandscape;
//}
//ios 6 一下
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
     return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft);
}

@end
