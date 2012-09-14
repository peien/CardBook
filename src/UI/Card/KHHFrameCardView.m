//
//  KHHFrameCardView.m
//  CardBook
//
//  Created by 王国辉 on 12-9-13.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "KHHFrameCardView.h"
#import "UIImageView+WebCache.h"

@implementation KHHFrameCardView
@synthesize scrView = _scrView;
@synthesize isVer = _isVer;
@synthesize xlPage;
- (id)initWithFrame:(CGRect)frame isVer:(BOOL)ver
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _isVer = ver;
        [self showView];
    }
    return self;
}
- (void)showView
{
    if (_isVer) {
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(65, 20, 180, 220)];
        scroll.showsHorizontalScrollIndicator = NO;
        scroll.delegate = self;
        for (int i = 0; i<2; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*180, 0, 180, 220)];
            if (i == 0) {
                imgView.backgroundColor = [UIColor clearColor];
                imgView.image = [UIImage imageNamed:@"card_tesco.png"];
            }else{
                //第二张从网络获取
                imgView.backgroundColor = [UIColor clearColor];
                imgView.image = [UIImage imageNamed:@"card_watsons.png"];
                //[imgView setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@""]];
            }
            
            [scroll addSubview:imgView];
        }
        scroll.pagingEnabled = YES;
        scroll.contentSize = CGSizeMake(2*180, 220);
        scroll.backgroundColor = [UIColor clearColor];
        _scrView = scroll;
    }else{
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(30, 35, 260, 180)];
        scroll.showsHorizontalScrollIndicator = NO;
        scroll.delegate = self;
        for (int i = 0; i<2; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*260, 0, 260, 180)];
            if (i == 0) {
                imgView.backgroundColor = [UIColor clearColor];
                imgView.image = [UIImage imageNamed:@"card_tesco.png"];
            }else{
                imgView.backgroundColor = [UIColor clearColor];
                imgView.image = [UIImage imageNamed:@"card_watsons.png"];
            }
            [scroll addSubview:imgView];
        }
        scroll.pagingEnabled = YES;
        scroll.contentSize = CGSizeMake(2*260, 180);
        scroll.backgroundColor = [UIColor clearColor];
        _scrView = scroll;
        
    }
    [self addSubview:_scrView];
    xlPage = [[XLPageControl alloc] initWithFrame:CGRectMake(130, 190, 60, 15)];
    [xlPage setBackgroundColor:[UIColor clearColor]];
    xlPage.activeImg = [UIImage imageNamed:@"p1.png"];
    xlPage.unActiveImg = [UIImage imageNamed:@"p2.png"];
    xlPage.tag = 118;
    [xlPage addTarget:self action:@selector(pageCtrlClick:) forControlEvents:UIControlEventValueChanged];
    xlPage.currentPage = 0;
    xlPage.hidesForSinglePage = YES;
    xlPage.numberOfPages = 2;
    
    if (_isVer) {
        xlPage.frame = CGRectMake(100, 260, 100, 15);
    }else{
        xlPage.frame = CGRectMake(100, 215, 100, 15);
    }
    
    [xlPage addTarget:self action:@selector(pageCtrlClick:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:xlPage];

}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_scrView]) {
        CGFloat scrollWidth = scrollView.frame.size.width;
        int page = ((scrollView.contentOffset.x-scrollWidth/2)/scrollWidth)+1;
        XLPageControl *pageCtrl = (XLPageControl *)[self viewWithTag:118];
        pageCtrl.currentPage = page;
        
    }
}
- (void)pageCtrlClick:(id)sender
{
    XLPageControl *page = (XLPageControl *)sender;
    int i  = page.currentPage;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    int w = _isVer?180:260;
    _scrView.contentOffset = CGPointMake(i * w, 0);
    [UIView commitAnimations];
    
}
//异步获取图片


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
