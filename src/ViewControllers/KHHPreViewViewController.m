//
//  KHHPreViewViewController.m
//  CardBook
//
//  Created by 王定方 on 12-11-13.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHPreViewViewController.h"
#import "Card.h"
#import "KHHFrameCardView.h"
#import "KHHNotifications.h"


@interface KHHPreViewViewController ()

@end

@implementation KHHPreViewViewController
@synthesize preViewCard = _preViewCard;
@synthesize preViewCardView = _preViewCardView;


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
    
    _preViewCardView = [[KHHFrameCardView alloc] initWithFrame:CGRectMake(0, 0, 480, 288) delegate:self isVer:NO callbackAction:KHHUICanclePreViewActionName];
    _preViewCardView.card = self.preViewCard;
    [_preViewCardView showPreView];
    [self.view addSubview:_preViewCardView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.navigationController.navigationBarHidden = YES;
    [UIView animateWithDuration:0.0f animations:^{
        [self.view setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
        //iphone5 要做区分
        if (iPhone5) {
            self.view.frame = CGRectMake(0, 0, 586, 320);
        }else{
            self.view.frame = CGRectMake(0, 0, 480, 320);
        }
        
    }];
    
    //注册接受取消全屏预览的广播
    [self observeNotificationName:KHHUICanclePreViewActionName selector:@"canclePreViewCard"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBarHidden = NO;
    //关闭接受取消全屏预览的广播
    [self stopObservingNotificationName:KHHUICanclePreViewActionName];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return UIInterfaceOrientationLandscapeRight;
}

//取消全屏预览的的事件
-(void) canclePreViewCard
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
