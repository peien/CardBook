//
//  KHHExchangeViewController.h
//  CardBook
//
//  Created by 王国辉 on 12-8-20.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
//#import "KHHDataNew+Exchange.h"
#import "KHHDataNew+TransCard.h"

@interface KHHExchangeViewController : SuperViewController<UIAlertViewDelegate,KHHDataTransCardDelegate>
@property (strong, nonatomic) UIScrollView *    scrView;
@property (assign, nonatomic) bool              isVer;

@end
