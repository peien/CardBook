//
//  NetWorking.m
//  CardBook
//
//  Created by CJK on 12-12-28.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "NetWorking.h"

@implementation NetWorking

+ (NetWorking *)sharedInstance
{
    static NetWorking *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[NetWorking alloc] initWithFrame:CGRectMake(110, 210, 100, 40)];
        [_sharedInstance initSubs];
        
    });
    
    return _sharedInstance;
}

- (void)initSubs{
    actView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0,10,20,20)];
    label = [[UILabel alloc]initWithFrame:CGRectMake(30,10,70,20)];
    [self addSubview:actView];
    [self addSubview:label];
}

- (void)start
{
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(animDo) userInfo:nil repeats:YES];
    [actView startAnimating];
    
}

- (void)stop
{
    [actView stopAnimating];
    if (timer) {
        [timer invalidate];
        timer = nil;
    }   
}
- (void)animDo
{
    num++;
    if (num >= 3) {
        num = 0;
    }
switch (num) {
    case 0:
        label.text = @"请稍候.";
        break;
    case 1:
        label.text = @"请稍候..";
        break;
    case 2:
        label.text = @"请稍候...";
        break;   
    default:
        break;
}
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
