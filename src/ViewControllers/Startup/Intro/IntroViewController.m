//
//  IntroViewController.m
//
//  Created by Ming Sun on 12-5-2.
//

#import "IntroViewController.h"
#import "KHHDefaults.h"
#import "NSObject+SM.h"
#import "XLPageControl.h"

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
        if (i == 3) {
           
           // [aView addSubview:but];
        }
        [self.theScrollView addSubview:aView];
        but =[[UIButton alloc]initWithFrame:CGRectMake(3*ww+200, 50, 100, 40)];
        [but setTitle:@"立即体验" forState:UIControlStateNormal];
        but.backgroundColor = [UIColor grayColor];
        
        [but addTarget:self action:@selector(btnUse) forControlEvents:UIControlEventTouchUpInside];      
        [self.theScrollView addSubview:but];
               
    }
    
    xlPage = [[XLPageControl alloc] initWithFrame:CGRectMake(65, 420, 200, 15)];
    xlPage.activeImg = [UIImage imageNamed:@"p2.png"];
    xlPage.unActiveImg = [UIImage imageNamed:@"p1.png"];
    xlPage.currentPage = 1;
    xlPage.numberOfPages = 4;
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

- (IBAction)startNow:(id)sender {
    self.defaults.firstLaunch = NO;
    NSString *name = nAppSkipIntro;
    DLog(@"[II] 发送消息 %@", name);
    [self postASAPNotificationName:name];
}

@end
