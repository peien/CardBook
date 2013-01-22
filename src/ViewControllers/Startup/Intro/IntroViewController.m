//
//  IntroViewController.m
//
//  Created by Ming Sun on 12-5-2.
//

#import "IntroViewController.h"
#import "KHHDefaults.h"
#import "NSObject+SM.h"
#import "XLPageControl.h"
#import "KHHViewAdapterUtil.h"

@interface IntroViewController ()
@property (nonatomic, strong) KHHDefaults *defaults;
@property (nonatomic, strong) XLPageControl *xlPage;
@end

@implementation IntroViewController

{
    UILabel *label;
    UIButton* but;
}

@synthesize xlPage;

- (void)dealloc
{
    self.defaults = nil;
    DLog(@"[II] dealloc %@", self);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _defaults = [KHHDefaults sharedDefaults];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //先把scrollView,要不然就有空的部分，详细原因未找
    [KHHViewAdapterUtil checkIsNeedAddHeightForIphone5:_theScrollView];
    //判断是从哪个界面过来，不是从启动页来的
    if (!_isFromStartUp) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        //添加一个返回按钮
        UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(8, 10, 60, 30)];
        [back setTitle:KHHMessageBack forState:UIControlStateNormal];
        [back setBackgroundImage:[UIImage imageNamed:@"Button_grey"] forState:UIControlStateNormal];
        [back setBackgroundImage:[UIImage imageNamed:@"Button_red"] forState:UIControlStateHighlighted];
        back.titleLabel.font = label.font = [UIFont systemFontOfSize:16];
        [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:back];
    }
    //Create the views which are going to display in the scrollview.
    [self.view setBackgroundColor:[UIColor colorWithRed:241 green:238 blue:232 alpha:1.0]];
    CGFloat ww = self.theScrollView.frame.size.width;
    CGFloat hh = self.theScrollView.frame.size.height;
    int count= 4;
    self.theScrollView.contentSize = CGSizeMake(ww * count, hh);
    label = [[UILabel alloc]initWithFrame:CGRectMake(320/2-200/2, 0, 200, 50)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"弘“云”服务";
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:label];
    //self.theTitleLabel.text = @"弘“云”服务";
    for (int i = 0; i < count; i++)
    {
        CGFloat x = i * ww;
        UIImage *anImage = [UIImage imageNamed:[NSString stringWithFormat:@"intro_%i", i]];
        UIImageView *aView = [[UIImageView alloc] initWithImage:anImage];
       // aView.backgroundColor = [UIColor clearColor];
        aView.frame = CGRectMake(x, 0, ww, hh);
        [self.theScrollView addSubview:aView];
        if (i == 3 && _isFromStartUp) {
            but =[[UIButton alloc]initWithFrame:CGRectMake(i*ww+200, 50, 100, 40)];
            [but setTitle:@"立即体验" forState:UIControlStateNormal];
            but.backgroundColor = [UIColor grayColor];
            [but addTarget:self action:@selector(btnUse) forControlEvents:UIControlEventTouchUpInside];
            [self.theScrollView addSubview:but];
        }
    }
    
    xlPage = [[XLPageControl alloc] initWithFrame:CGRectMake(65, 420, 200, 15)];
    xlPage.activeImg = [UIImage imageNamed:@"p2.png"];
    xlPage.unActiveImg = [UIImage imageNamed:@"p1.png"];
    xlPage.numberOfPages = 4;
    xlPage.currentPage = 0;
    //iphone5适配，看xlpage是否要移位置
    [KHHViewAdapterUtil checkIsNeedMoveDownForIphone5:xlPage];
    [self.view addSubview:xlPage];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSString *titles[4] = {NSLocalizedString(@"弘“云”服务",@""),
        NSLocalizedString(@"小名片里的大视野",@""), 
        NSLocalizedString(@"客户访销管理",@""),
        NSLocalizedString(@"超越名片",@""),};
    CGFloat pageWidth = self.theScrollView.frame.size.width;
    int page = floor((self.theScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.xlPage.currentPage = page;
   label.text = titles[page];
    
}

- (void)btnUse
{
    self.defaults.firstLaunch = NO;
    NSString *name = nAppSkipIntro;
  
    [self postASAPNotificationName:name];
}

-(void) back
{
    [UIView animateWithDuration: 0.5
                     animations:^{
                         self.view.alpha = 0.0;
                         
                     }
                     completion:^(BOOL finished) {
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];
                     }];
     
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
}

@end
