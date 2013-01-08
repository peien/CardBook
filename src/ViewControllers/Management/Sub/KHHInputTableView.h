//
//  KHHInputTableView.h
//  CardBook
//
//  Created by CJK on 13-1-6.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHHMacros.h"

#define H460 iPhone5?(460+88):460

static float const KHH_Keyboard_Height = 216.0 + 95;

@protocol KHHInputTableViewHiddenDelegate <NSObject>

@required
- (void)hiddenKeyboard;

@end

@interface KHHInputTableView : UITableView

@property (nonatomic,strong) id<KHHInputTableViewHiddenDelegate> hiddenDelgate;
@property (nonatomic,assign)float offset;
- (void)goToInsetForKeyboard:(CGRect)frame;
- (void)showNormal;

@end
