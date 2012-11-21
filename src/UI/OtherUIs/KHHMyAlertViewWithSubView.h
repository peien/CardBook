//
//  KHHMyAlertViewWithSubView.h
//  CardBook
//
//  Created by 王定方 on 12-11-9.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class Card;
//@class KHHFrameCardView;
@interface KHHMyAlertViewWithSubView : UIAlertView
//@property(strong,nonatomic) KHHFrameCardView *cardView;
//带view的alert
//- (id)initWithTitle:(NSString *)title preViewCard:(Card *)card delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;
@property (strong, nonatomic) UIView *mySubView;
- (id)initWithTitle:(NSString *)title subView:(UIView *)subView delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;
@end
