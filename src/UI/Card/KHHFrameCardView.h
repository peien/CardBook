//
//  KHHFrameCardView.h
//  CardBook
//
//  Created by 王国辉 on 12-9-13.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLPageControl.h"

@interface KHHFrameCardView : UIView<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrView;
@property (assign, nonatomic) bool         isVer;
@property (strong, nonatomic) XLPageControl *xlPage;
- (id)initWithFrame:(CGRect)frame isVer:(BOOL)ver;
@end
