//  全屏预览名片界面
//  KHHPreViewViewController.h
//  CardBook
//
//  Created by 王定方 on 12-11-13.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Card;
@class KHHFrameCardView;
@interface KHHPreViewViewController : UIViewController
@property(strong, nonatomic) Card               * preViewCard;
@property(strong, nonatomic) KHHFrameCardView   * preViewCardView;
@end
