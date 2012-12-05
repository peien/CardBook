//
//  KHHMySearchBar.m
//  CardBook
//
//  Created by 王国辉 on 12-8-23.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "KHHMySearchBar.h"
#import <QuartzCore/QuartzCore.h>
@implementation KHHMySearchBar
@synthesize isSimple = _isSimple;
@synthesize takePhoto = _takePhoto;
@synthesize isSearching = _isSearching;
- (id)initWithFrame:(CGRect)frame simple:(BOOL)sim  showSearchBtn:(BOOL) isShow
{
     self = [super initWithFrame:frame];
   
    if (self) {
        _isSimple = sim;
        _isShowSearchBarBtn = isShow;
        if (_isSimple) {
            
        }else{
            if (_isShowSearchBarBtn) {
                UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                refreshBtn.tag = 2222;
                refreshBtn.frame = CGRectMake(250, 0, 65, 40);
                refreshBtn.titleLabel.font = [UIFont systemFontOfSize:12];
                [refreshBtn setBackgroundImage:[[UIImage imageNamed:@"tongbu_normal.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 8, 0, 8)] forState:UIControlStateNormal];
                [refreshBtn setTitle:NSLocalizedString(@"同步", nil) forState:UIControlStateNormal];
                [self addSubview:refreshBtn];
                self.synBtn = refreshBtn;
            }
            
            UIButton *OneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            OneBtn.tag = 1111;
            [OneBtn setBackgroundImage:[UIImage imageNamed:@"tianjia_Btn_Red.png"]forState:UIControlStateNormal];
            OneBtn.frame = CGRectMake(3, -5, 50, 50);
            [self addSubview:OneBtn];
            _takePhoto = OneBtn;
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_isSimple) {
//        for (UIView *view in self.subviews) {
//            if ([view isKindOfClass:[UITextField class]]) {
//                UITextField *tf = (UITextField *)view;
//                CGRect rect = tf.frame;
//                rect.size.width = 260;
//                rect.origin.x = 50;
//                tf.frame = rect;
//            }
//        }
        
    }else{
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
                UITextField *tf = (UITextField *)view;
                CGRect rect = tf.frame;
                if (!_isSearching) {
                    if (!_isShowSearchBarBtn) {
                        rect.size.width = 180 + 65;
                    }else {
                        rect.size.width = 180;
                    }
                    rect.origin.x = 65;
                }else {
                    rect.size.width = 180 + 65;
                    rect.origin.x = 5;
                }
                
                tf.frame = rect;
            }
        }
    }


}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (_isSimple) {
       [self setBackgroundImage:[UIImage imageNamed:@"searchbar_bg_normal.png"]]; 
    }else{
       [self setBackgroundImage:[UIImage imageNamed:@"searchbar_bg_normal.png"]];
    }
      
}

@end
