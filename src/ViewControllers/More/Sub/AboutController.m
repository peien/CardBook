//
//  AboutController.m
//  eCard
//
//  Created by Ming Sun on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AboutController.h"

#define textAboutThisApp NSLocalizedString(@"关于", @"")
#define URL_OFFICIAL_SITE @"http://www.fafamp.com"

@interface AboutController ()

@end

@implementation AboutController
@synthesize urlButton = _urlButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = textAboutThisApp;
        self.navigationItem.rightBarButtonItem = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 更换背景
    UIImage *bgImage = [[UIImage imageNamed:@"activity_bg.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    [(UIImageView *)self.view setImage:bgImage];
    //版本号
    _versionCode.text = KHH_APP_VERSION;
}

- (void)viewDidUnload
{
    [self setUrlButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)urlButtonTapped:(id)sender {
#ifdef DEBUG
    NSLog(@"打开官网：www.fafamp.com");
#endif
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL_OFFICIAL_SITE]]; 
}
@end
