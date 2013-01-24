//
//  KHHFrameCardView.h
//  CardBook
//
//  Created by 王国辉 on 12-9-13.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLPageControl.h"
@class Card;
@class KHHVisualCardViewController;
@interface KHHFrameCardView : UIView<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView                  *   scrView;
@property (assign, nonatomic) bool                              isVer;
@property (strong, nonatomic) XLPageControl                 *   xlPage;
@property (nonatomic, strong) KHHVisualCardViewController   *   cardTempVC;
@property (nonatomic, strong) Card                          *   card;
@property (nonatomic, strong) UIImageView                   *   shadowCard;
@property (nonatomic, strong) UIViewController              *   myDelegate;
@property (assign, nonatomic) bool                              isOnePage;
@property (assign, nonatomic) int                               pages;
@property (strong, nonatomic) NSString                      *   myActionName;

@property (strong, nonatomic) void(^tapCallBack)();

- (id)initWithFrame:(CGRect)frame delegate:(id) delegate isVer:(BOOL)ver callbackAction:(NSString *) actionName;
- (void)showView;
-(void) showPreView;
@end
