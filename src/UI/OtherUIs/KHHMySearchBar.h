//
//  KHHMySearchBar.h
//  CardBook
//
//  Created by 王国辉 on 12-8-23.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KHHMySearchBar : UISearchBar
@property (assign, nonatomic) bool isSimple;
@property (strong, nonatomic) UIButton *takePhoto;
@property (strong, nonatomic) UIButton *synBtn;
- (id)initWithFrame:(CGRect)frame simple:(BOOL)sim;
@end
