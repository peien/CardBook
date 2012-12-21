//
//  KHHFunnelViewController.h
//  CardBook
//
//  Created by 王国辉 on 12-8-22.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "KHHFilterPopup.h"
@interface KHHFunnelViewController : SuperViewController<KHHFilterPopupDelegate>
@property (strong, nonatomic) IBOutlet UILabel *lab1;
@property (strong, nonatomic) IBOutlet UILabel *lab2;
@property (strong, nonatomic) IBOutlet UILabel *lab3;
@property (strong, nonatomic) IBOutlet UILabel *lab4;
@property (strong, nonatomic) IBOutlet UILabel *lab5;
- (IBAction)btnClick:(id)sender;
@end
