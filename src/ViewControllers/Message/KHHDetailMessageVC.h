//
//  KHHDetailMessageVC.h
//  CardBook
//
//  Created by 王国辉 on 12-9-11.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "KHHMessage.h"

@interface KHHDetailMessageVC : SuperViewController
@property (strong, nonatomic) KHHMessage           *message;
@property (strong, nonatomic) IBOutlet UILabel     *timeLabel;
@property (strong, nonatomic) IBOutlet UITextView  *contentLabel;
@end
