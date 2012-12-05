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
@property (assign, nonatomic) bool isShowSearchBarBtn;
//homepage页给searchbar添加view后，改变searchBar textfiled的位置了，有这个标记是当进系统搜索searchBar里还原textfiled的位置
@property (assign, nonatomic) bool isSearching;
@property (strong, nonatomic) UIButton *takePhoto;
@property (strong, nonatomic) UIButton *synBtn;
- (id)initWithFrame:(CGRect)frame simple:(BOOL)sim showSearchBtn:(BOOL) isShow;
@end
