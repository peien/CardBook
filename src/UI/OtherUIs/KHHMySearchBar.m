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
@synthesize delegateKHH = _delegateKHH;
@synthesize isSimple = _isSimple;
@synthesize takePhoto = _takePhoto;
- (id)initWithFrame:(CGRect)frame simple:(BOOL)sim
{
     self = [super initWithFrame:frame];
   
    if (self) {
        _isSimple = sim;
        if (_isSimple) {
            
        }else{
            UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            refreshBtn.frame = CGRectMake(250, 0, 65, 40);
            refreshBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [refreshBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [refreshBtn setBackgroundImage:[[UIImage imageNamed:@"tongbu_normal.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:2] forState:UIControlStateNormal];
            [refreshBtn setTitle:@"同步" forState:UIControlStateNormal];
            refreshBtn.tag = 2222;
            [self addSubview:refreshBtn];
            
            UIButton *OneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [OneBtn setBackgroundImage:[UIImage imageNamed:@"shexiangtou.png"]forState:UIControlStateNormal];
            OneBtn.frame = CGRectMake(5, 0, 44, 44);
            OneBtn.tag = 1111;
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
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UITextField class]]) {
                UITextField *tf = (UITextField *)view;
                CGRect rect = tf.frame;
                rect.size.width = 200;
                rect.origin.x = 50;
                tf.frame = rect;
            }
        }
        
    }else{
        for (UIView *view in self.subviews) {
            if ([view isKindOfClass:[UITextField class]]) {
                UITextField *tf = (UITextField *)view;
                CGRect rect = tf.frame;
                rect.size.width = 180;
                rect.origin.x = 65;
                tf.frame = rect;
            }
        }
    }


}
- (void)BtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [_delegateKHH KHHMySearchBarBtnClick:btn.tag];

}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (_isSimple) {
       [self setBackgroundImage:[UIImage imageNamed:@"searchbar_bg_normal.png"]]; 
    }else{
       [self setBackgroundImage:[UIImage imageNamed:@"searchBarbg.png"]];
    }
      
}

@end
