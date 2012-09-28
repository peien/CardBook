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
    xlPage = [[XLPageControl alloc] initWithFrame:CGRectMake(130, 190, 60, 15)];
    [xlPage setBackgroundColor:[UIColor clearColor]];
    xlPage.activeImg = [UIImage imageNamed:@"p1.png"];
    xlPage.unActiveImg = [UIImage imageNamed:@"p2.png"];
    xlPage.tag = 118;
    [xlPage addTarget:self action:@selector(pageCtrlClick:) forControlEvents:UIControlEventValueChanged];
    [xlPage setCurrentPage:0];
    xlPage.hidesForSinglePage = YES;
    xlPage.numberOfPages = 2;
    [self addSubview:xlPage];
    if (_isVer) {
        CGRect rect = CGRectMake(75, 10, 180, 245);
        [self creatCardTemplate:rect];
        xlPage.frame = CGRectMake(110, 260, 100, 15);
    }else{
        CGRect rect = CGRectMake(30, 15, 260, 190);
        [self creatCardTemplate:rect];
        xlPage.frame = CGRectMake(100, 205, 100, 15);
    }
    [self addSubview:_scrView];
}
- (void)creatCardTemplate:(CGRect)frame
{
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:frame];
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.delegate = self;
    for (int i = 0; i<2; i++) {
        CGRect rect = frame;
        rect.origin.x = i*frame.size.width;
        frame = rect;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
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
    scroll.contentSize = CGSizeMake(2*frame.size.width, frame.size.height);
    scroll.backgroundColor = [UIColor clearColor];
    _scrView = scroll;
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
