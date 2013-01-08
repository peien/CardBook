//
//  KHHImgViewInCell.h
//  CardBook
//
//  Created by CJK on 13-1-7.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol KHHImgViewInCellDelegate <NSObject>

@optional
- (void)showLarge:(UIView*)img;
- (void)doDelete:(UIView*)img;

@end



@interface KHHImgViewInCell : UIView
@property(nonatomic,strong) UIImage *img;
@property(nonatomic,strong) id<KHHImgViewInCellDelegate> touchDelegate;
@end

