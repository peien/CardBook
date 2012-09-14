//
//  KHHCardView.h
//  CardBook
//
//  Created by 王国辉 on 12-8-24.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XLPageControl;
@interface KHHCardView : UIView<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *theTable;
@property (nonatomic, strong) UIView *card;
@property (strong, nonatomic) UIScrollView  *scroller;
@property (strong, nonatomic) UIPageControl *pageCtrl;
@property (strong, nonatomic) XLPageControl *xlPage;
- (void)initView;
@end
