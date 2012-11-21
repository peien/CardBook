//
//  KHHFloatBarController.h
//  CardBook
//
//  Created by 孙铭 on 8/7/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WEPopoverController.h"
#import "KHHCardMode.h"
#import "Card.h"


@interface KHHFloatBarController : UIViewController
@property (strong, nonatomic) IBOutlet UIView     *viewF;
@property (assign, nonatomic) bool                isFour;
@property (strong, nonatomic) UIViewController    *viewController;
@property (strong, nonatomic) WEPopoverController *popover;
@property (assign, nonatomic) int                 type;
@property (strong, nonatomic) Card                *card;
//用来区分选择card还是contactDic作为数据源
@property (assign, nonatomic) bool                isContactCellClick;
//只显示普通联系信息
@property (assign, nonatomic) bool                isJustNormalComunication;
@property (strong, nonatomic) NSDictionary        *contactDic;
@property (strong, nonatomic) IBOutlet UIButton   *btn0;
@property (strong, nonatomic) IBOutlet UIButton   *btn1;
@property (strong, nonatomic) IBOutlet UIButton   *btn2;
@property (strong, nonatomic) IBOutlet UIButton   *btn3;

- (IBAction)BtnClick:(id)sender;
@end
