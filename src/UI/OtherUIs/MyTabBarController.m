//
//  MyTabBarController.m
//  91kge
//
//  Created by ge k on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#define BUTTON_WIDTH 32
#define BUTTON_HEIGHT 24
#import "MyTabBarController.h"
#import "SuperViewController.h"

@interface MyTabBarController ()
@property (strong, nonatomic) UIImageView *bgimgView;

@end

@implementation MyTabBarController

-(void)dealloc
{  
    self.tabBarView = nil;
    self.bgimgView = nil;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(id)initWithNum:(int)num
{
    count = num;
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.tabBar removeFromSuperview];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 431, 320, 44)];
    [self.view addSubview:v];
    self.tabBarView = v;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 320, 44)];
    [imgView setImage:[UIImage imageNamed:@"bottom_bg_ 2.png"]];
    [self.tabBarView addSubview:imgView];
    int gap = (320-(BUTTON_WIDTH*count))/(count +1);
    for(int i = 0; i < count;i ++) 
    {
        if (i == 4) {
            _bgimgView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bottom_bg_ 2.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1]];
            _bgimgView.tag = i + 100 +1;
        }else{
            _bgimgView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bottom_bg.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1]];
            _bgimgView.tag = i + 100 + 1;
        }
        _bgimgView.frame = CGRectMake(i*(320/5), 5, 320/5, 44);
        [self.tabBarView addSubview:_bgimgView];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i+100;
        [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *image = [[UIImage imageNamed:[NSString stringWithFormat:@"ico%d",i]] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
        [btn setImage:image forState:UIControlStateNormal];
        if (i == 0) {
           [btn setFrame:CGRectMake(gap-10 + i*(gap+BUTTON_WIDTH),(44-BUTTON_HEIGHT)/2+2, BUTTON_WIDTH, BUTTON_HEIGHT)];
        }else if(i == 4){
            [btn setFrame:CGRectMake(gap+12 + i*(gap+BUTTON_WIDTH),(44-BUTTON_HEIGHT)/2+2, BUTTON_WIDTH, BUTTON_HEIGHT)];
        }else if(i == 3){
           [btn setFrame:CGRectMake(gap+6 + i*(gap+BUTTON_WIDTH),(44-BUTTON_HEIGHT)/2+2, BUTTON_WIDTH, BUTTON_HEIGHT)];
        }else if(i == 1){
          [btn setFrame:CGRectMake(gap-4 + i*(gap+BUTTON_WIDTH),(44-BUTTON_HEIGHT)/2+2, BUTTON_WIDTH, BUTTON_HEIGHT)];
        }else{
           [btn setFrame:CGRectMake(gap+1 + i*(gap+BUTTON_WIDTH),(44-BUTTON_HEIGHT)/2+2, BUTTON_WIDTH, BUTTON_HEIGHT)];
        }
        [self.tabBarView addSubview:btn];
    }
    // 默认选择
    UIButton *btn = (UIButton *)[self.tabBarView viewWithTag:100];
    [self performSelector:@selector(buttonClick:) withObject:btn afterDelay:0.1];

    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.tabBarView =  nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark- change viewcontroller
UIView *view = nil;
-(void)buttonClick:(UIButton *)btn
{
    if (btn.tag - 100 == self.selectedIndex) {
        return;
    }
    self.selectedIndex = btn.tag - 100; 
    //UIImageView *bgimgview = (UIImageView *)[self.tabBarView viewWithTag:btn.tag];
    if (view == nil) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, 45)];
        [view setBackgroundColor:[UIColor clearColor]];
        [self.tabBarView addSubview:view];
        UIImageView *imgview = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"tabbar_jianjiao.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0]];
        imgview.frame = CGRectMake(0, 34, 65, 15);
        [view addSubview:imgview];

    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect rect = view.frame;
    rect.origin.x = self.selectedIndex*64;
    view.frame = rect;
    [UIView commitAnimations];
    
    
}
@end
