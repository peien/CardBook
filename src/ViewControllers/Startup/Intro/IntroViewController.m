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
    self.theTitleLabel.text = @"弘“云”服务";
    for (int i = 0; i < count; i++)
    {
        CGFloat x = i * ww;
        UIImage *anImage = [UIImage imageNamed:[NSString stringWithFormat:@"intro_%i.png", i]];
        UIImageView *aView = [[UIImageView alloc] initWithImage:anImage];
        aView.backgroundColor = [UIColor clearColor];
        aView.frame = CGRectMake(x, 0, ww, hh);
        [self.theScrollView addSubview:aView];
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
    self.theTitleLabel.text = titles[page];
}

- (IBAction)startNow:(id)sender {
    self.defaults.firstLaunch = NO;
    NSString *name = nAppSkipIntro;
    DLog(@"[II] 发送消息 %@", name);
    [self postASAPNotificationName:name];
}

@end
