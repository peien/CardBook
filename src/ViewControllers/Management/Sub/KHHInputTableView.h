//
//  KHHInputTableView.h
//  CardBook
//
//  Created by CJK on 13-1-6.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KHHInputTableViewHiddenDelegate <NSObject>

@required
- (void)hiddenKeyboard;

@end

@interface KHHInputTableView : UITableView

@property (nonatomic,strong) id<KHHInputTableViewHiddenDelegate> hiddenDelgate;

- (void)goToInsetForKeyboard:(CGRect)frame;
- (void)showNormal;

@end
