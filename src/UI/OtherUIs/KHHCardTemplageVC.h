//
//  KHHCardTemplageVC.h
//  CardBook
//
//  Created by 王国辉 on 12-10-26.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "Edit_eCardViewController.h"
#import "KHHClasses.h"
@interface KHHCardTemplageVC : SuperViewController
@property (strong, nonatomic) Edit_eCardViewController *editCardVC;
@property (strong, nonatomic) Card                     *card;
@property (strong, nonatomic) void(^selectTemplate)(CardTemplate *cardTemplate);

@end
