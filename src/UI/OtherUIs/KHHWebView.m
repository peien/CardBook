//
//  KHHWebView.m
//  CardBook
//
//  Created by 王定方 on 12-11-30.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHWebView.h"
#import "NetClient.h"
static NSString * const KHH_HTTP = @"http";
static NSString * const KHH_3W = @"www";
@interface KHHWebView ()

@end

@implementation KHHWebView
@synthesize webView = _webView;
@synthesize myRequestUrl = _myRequestUrl;
@synthesize callback = _callback;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//初始化一些变量
//url如果只是xxx.jsp就要用默认的服务器地址
//如果是hhtp://或者www.开头就不用
-(void) initUrl:(NSString *) url title:(NSString *) title rightBarName:(NSString*) barName rightBarBlock:(KHHDefaultBlock) callback {
    //url
    if (!url) {
        //指向默认网址（fafamp.com）
        _myRequestUrl = KHH_Recommend_URL;
    }else {
        BOOL isRealUrl = [[url lowercaseString] hasPrefix:KHH_HTTP] || [[url lowercaseString] hasPrefix:KHH_3W];
        if (isRealUrl) {
            _myRequestUrl = url;
        }else {
            _myRequestUrl = [NSString stringWithFormat:KHHURLFormat,[[NetClient sharedClient] currentServerUrl],url];
        }
    }
    
    //title
    if (!title || title.length <= 0) {
        title = KHH_APP_NAME;
    }
    self.title = title;
    
    //是否显示右键
    if (barName) {
        self.rightBtn.hidden = NO;
        [self.rightBtn setTitle:barName forState:UIControlStateNormal];
        _callback = callback;
    }else {
        self.rightBtn.hidden = YES;
    }
}

//右键点击事件
- (void)rightBarButtonClick:(id)sender
{
    if (_callback) {
        _callback();
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSURL *url = [NSURL URLWithString:self.myRequestUrl];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:req];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    _webView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
