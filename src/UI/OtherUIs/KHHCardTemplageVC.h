//
//  KHHCardTemplageVC.h
//  CardBook
//
//  Created by CJK on 13-2-1.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
//#import "Edit_eCardViewController.h"
#import "KHHClasses.h"
@interface KHHCardTemplageVC : SuperViewController
//@property (strong, nonatomic) Edit_eCardViewController *editCardVC;
@property (strong, nonatomic) Card                     *card;
@property (strong, nonatomic) void(^selectTemplate)(CardTemplate *cardTemplate);

@end
