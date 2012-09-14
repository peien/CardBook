//
//  SuperViewController.m
//  LoveCard
//
//  Created by gh w on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SuperViewController.h"
@implementation UIImage(Half)

- (id)transformHalf
{
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width, self.size.height));
    [self drawInRect:CGRectMake(0.0f, 0.0f, self.size.width, self.size.height)]; 
    UIImage *bgImg = UIGraphicsGetImageFromCurrentImageContext();  
    UIGraphicsEndImageContext();
    return bgImg;
}
@end

@implementation UINavigationBar (custom)

- (UIImage *)barBackground
{
    return [[[UIImage imageNamed:@"title_bg.png"] transformHalf] stretchableImageWithLeftCapWidth:0 topCapHeight:0];

}
//ios 5 会调用这个方法，但是drawRect不能调用
- (void)didMoveToSuperview
{
    if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self setBackgroundImage:[self barBackground] forBarMetrics:UIBarMetricsDefault];
    }
}

- (void) drawRect:(CGRect)rect
{
    [[self barBackground] drawInRect:rect];
    
}

@end

@interface SuperViewController ()

@end

@implementation SuperViewController
@synthesize leftBtn;
@synthesize rightBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn setBackgroundImage:[[[UIImage imageNamed:@"titlebtn_normal.png"] transformHalf]stretchableImageWithLeftCapWidth:8 topCapHeight:2] forState:UIControlStateNormal];
        rightBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [rightBtn addTarget:self action:@selector(rightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.frame = CGRectMake(0, 0, 65, 40);
        UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem = rightBar;
        
        leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setBackgroundImage:[[[UIImage imageNamed:@"titlebtn_normal.png"] transformHalf]stretchableImageWithLeftCapWidth:8 topCapHeight:2] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(leftBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        leftBtn.frame = CGRectMake(0, 0, 65, 40);
        [leftBtn setTitle:@"返回" forState:UIControlStateNormal];
        leftBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
        self.navigationItem.leftBarButtonItem = leftBar;
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.navigationItem.rightBarButtonItem = [self woodBarButtonItemWithText:@"Store"];
//    UIButton* rightButton = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
//    [rightButton addTarget:self action:@selector(storeAction:) forControlEvents:UIControlEventTouchUpInside];
//    
//    self.navigationItem.leftBarButtonItem = [self woodBarButtonItemWithText:@"Edit"];
//    UIButton* leftButton = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
//    [leftButton addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    leftBtn = nil;
    rightBtn = nil;
}

- (void)rightBarButtonClick:(id)sender
{

}
- (void)leftBarButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
