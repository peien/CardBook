//
//  IntroViewController.m
//
//  Created by Ming Sun on 12-5-2.
//

#import "IntroViewController.h"
#import "KHHDefaults.h"
#import "NSObject+SM.h"

@interface IntroViewController ()
@property (nonatomic, strong) KHHDefaults *defaults;
@end

@implementation IntroViewController

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
    CGFloat ww = self.theScrollView.frame.size.width;
    CGFloat hh = self.theScrollView.frame.size.height;
    int count= 5;
    self.theScrollView.contentSize = CGSizeMake(ww * count, hh);
    for (int i = 0; i < count; i++)
    {
        CGFloat x = i * ww;
        UIImage *anImage = [UIImage imageNamed:[NSString stringWithFormat:@"intro_%i.jpg", i]];
        UIImageView *aView = [[UIImageView alloc] initWithImage:anImage];
        aView.backgroundColor = [UIColor clearColor];
        aView.frame = CGRectMake(x, 0, ww, hh);
        [self.theScrollView addSubview:aView];
    }
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
    NSString *titles[5] = {NSLocalizedString(@"交换名片简单快捷",@""),
        NSLocalizedString(@"发送名片到手机号",@""), 
        NSLocalizedString(@"收录名片",@""),
        NSLocalizedString(@"自建联系人",@""),
        NSLocalizedString(@"编辑名片",@"")};
    CGFloat pageWidth = self.theScrollView.frame.size.width;
    int page = floor((self.theScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.thePageControl.currentPage = page;
    self.theTitleLabel.text = titles[page];
}

- (IBAction)startNow:(id)sender {
    self.defaults.firstLaunch = NO;
    NSString *name = KHHUISkipIntro;
    DLog(@"[II] 发送消息 %@", name);
    [self postASAPNotificationName:name];
}

@end
