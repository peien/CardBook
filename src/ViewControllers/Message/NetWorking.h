//
//  NetWorking.h
//  CardBook
//
//  Created by CJK on 12-12-28.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetWorking : UIView
{
    NSTimer *timer;
    UIActivityIndicatorView *actView;
    UILabel *label;
    int num;
}

+ (NetWorking *)sharedInstance;

- (void)start;
- (void)stop;

@end
