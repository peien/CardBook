//
//  KHHVisualCardViewController.h
//  CardBook
//
//  Created by Sun Ming on 12-9-24.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Card;
@interface KHHVisualCardViewController : UIViewController
@property (nonatomic, strong) Card *card;
@property(assign, nonatomic) CGFloat cardWidth;
-(void) setCardWidth:(CGFloat) cardWidth;
@end
