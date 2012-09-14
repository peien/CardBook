//
//  KHHExchangeViewController.m
//  CardBook
//
//  Created by 王国辉 on 12-8-20.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "KHHExchangeViewController.h"
#import "KHHSendToViewController.h"
#import "KHHShowHideTabBar.h"
#import "XLPageControl.h"
#import "UIImageView+WebCache.h"
#import "KHHFrameCardView.h"

@interface KHHExchangeViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) XLPageControl *xlPage;
@end

@implementation KHHExchangeViewController
@synthesize scrView = _scrView;
@synthesize isVer = _isVer;
@synthesize xlPage;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"交换名片";
        [self.leftBtn setTitle:@"切换名片" forState:UIControlStateNormal];
        [self.rightBtn setTitle:@"发送纪录" forState:UIControlStateNormal];
    }
    return self;
}
//切换名片
- (void)leftBarButtonClick:(id)sender
{

}
//发送纪录
- (void)rightBarButtonClick:(id)sender
{

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //设置背景
    [self.view setBackgroundColor:[UIColor colorWithRed:241.0f green:238.0f blue:231.0f alpha:1.0f]];
    //竖屏
    if (NO) {
        KHHFrameCardView *cardView = [[KHHFrameCardView alloc] initWithFrame:CGRectMake(0, 0, 320, 260) isVer:YES];
        [self.view addSubview:cardView];
    }else{
        KHHFrameCardView *cardView = [[KHHFrameCardView alloc] initWithFrame:CGRectMake(0, 0, 320, 220) isVer:NO];
        [self.view addSubview:cardView];
    }
    NSArray *titleArray = [[NSArray alloc] initWithObjects:@"交换名片",@"发送至手机",@"收名片", nil];
    for (int i = 0; i<3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setBackgroundImage:[[UIImage imageNamed:@"tongbu_normal.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:10] forState:UIControlStateNormal];
        btn.tag = i + 111;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
        btn.frame = CGRectMake(25+i*(80 + 15), 280, 90, 50);
        [self.view insertSubview:btn atIndex:10];
    }
    
    // 摇一摇交换名片
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    [self becomeFirstResponder];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [KHHShowHideTabBar showTabbar];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[KHHShowHideTabBar hideTabbar];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _scrView = nil;
    xlPage = nil;
}
- (void)pageCtrlClick:(id)sender
{
    XLPageControl *page = (XLPageControl *)sender;
    int i  = page.currentPage;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    int w = _isVer?180:260;
    _scrView.contentOffset = CGPointMake(i * w, 0);
    [UIView commitAnimations];

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_scrView]) {
        CGFloat scrollWidth = scrollView.frame.size.width;
        int page = ((scrollView.contentOffset.x-scrollWidth/2)/scrollWidth)+1;
        XLPageControl *pageCtrl = (XLPageControl *)[self.view viewWithTag:118];
        pageCtrl.currentPage = page;

    }
}

- (void)btnClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    switch (button.tag) {
        case 111:
            break;
        case 112:
        {
            KHHSendToViewController *sendToVC = [[KHHSendToViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:sendToVC animated:YES];
        }
            break;
        case 113:
            break;
        default:
            break;
    }

}
// 摇摇交换
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake) {
        NSLog(@"shake......");
    }
    
    
}
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (event.subtype == UIEventSubtypeMotionShake) {
        NSLog(@"开始交换");
    }

}
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
