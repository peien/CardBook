//
//  ATestViewController.h
//  CardBook
//
//  Created by Sun Ming on 12-9-24.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHHVisualCardViewController.h"

@interface ATestViewController : UIViewController
@property (nonatomic, strong) KHHData *data;
@property (nonatomic, strong) Card *card;
@property (nonatomic, strong) KHHVisualCardViewController *visualCard;
@end
