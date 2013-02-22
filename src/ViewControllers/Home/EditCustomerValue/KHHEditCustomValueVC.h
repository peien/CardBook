//
//  KHHEditCustomValueVC.h
//  CardBook
//
//  Created by 王国辉 on 12-8-24.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "KHHCustomEvaluaView.h"
#import "Card.h"
#import "KHHDataNew+Customer.h"

@interface KHHEditCustomValueVC : SuperViewController<KHHDataCustomerDelegate>
@property (strong, nonatomic) NSString             *importFlag;
@property (assign, nonatomic) CGFloat              relationEx;
@property (assign, nonatomic) CGFloat              customValue;
@property (strong, nonatomic) UITextField          *tf;
@property (strong, nonatomic) KHHCustomEvaluaView  *cusView;
@property (strong, nonatomic) Card                 *card;

@property (nonatomic,strong) void(^addUpdateCostomerSuccess)();

@end
