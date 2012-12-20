//
//  KHHRadarViewController.h
//  CardBook
//
//  Created by 王国辉 on 12-8-22.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"

@interface KHHRadarViewController : SuperViewController
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;
@property (weak, nonatomic) IBOutlet UIButton *btn5;
@property (weak, nonatomic) IBOutlet UIButton *btnLatent;
@property (weak, nonatomic) IBOutlet UIButton *btnLackExpand;
@property (weak, nonatomic) IBOutlet UIButton *btnNormal;
@property (weak, nonatomic) IBOutlet UIButton *btnBetter;
@property (weak, nonatomic) IBOutlet UIButton *btnIntimate;
- (IBAction)btnClick:(id)sender;
@end
