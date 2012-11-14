//
//  KHHFrameCardView.m
//  CardBook
//
//  Created by 王国辉 on 12-9-13.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "KHHFrameCardView.h"
#import "UIImageView+WebCache.h"
#import "KHHVisualCardViewController.h"
#import "KHHCardTemplageVC.h"
#import "KHHClasses.h"
#import "KHHPreViewViewController.h"
#import "Card.h"

@implementation KHHFrameCardView
@synthesize scrView = _scrView;
@synthesize isVer = _isVer;
@synthesize xlPage;
@synthesize cardTempVC;
@synthesize card;
@synthesize shadowCard;
@synthesize isOnePage;
@synthesize pages;

- (id)initWithFrame:(CGRect)frame delegate:(id) delegate isVer:(BOOL)ver callbackAction:(NSString *) actionName
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _isVer = ver;
        _myActionName = actionName;
        _myDelegate = delegate;
        //[self showView];
    }
    return self;
}
- (void)showView
{
    self.cardTempVC = [[KHHVisualCardViewController alloc] initWithNibName:nil bundle:nil];
    xlPage = [[XLPageControl alloc] initWithFrame:CGRectMake(130, 190, 60, 15)];
    [xlPage setBackgroundColor:[UIColor clearColor]];
    xlPage.activeImg = [UIImage imageNamed:@"p2.png"];
    xlPage.unActiveImg = [UIImage imageNamed:@"p1.png"];
    xlPage.tag = 118;
    xlPage.hidesForSinglePage = YES;
    xlPage.numberOfPages = 2;
    [xlPage addTarget:self action:@selector(pageCtrlClick:) forControlEvents:UIControlEventValueChanged];
    [xlPage setCurrentPage:0];
    [self addSubview:xlPage];
    self.pages = 2;
    if (_isVer) {
        CGRect rect = CGRectMake(75, 10, 180, 245);
        [self creatCardTemplate:rect];
        xlPage.frame = CGRectMake(110, 260, 100, 15);
    }else{
        CGRect rect = CGRectMake(10, 15, 300, 180);
        [self creatCardTemplate:rect];
        xlPage.frame = CGRectMake(100, 205, 100, 15);
    }
    [self addSubview:_scrView];
    self.shadowCard = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cardTouying.png"]];
    self.shadowCard.frame = CGRectMake(0, 195, 320, 20);
    [self addSubview:self.shadowCard];
}

//显示用户设置的大小的名片，不是默认的300 * 180的名片大小
- (void)showPreView
{
    CGRect myFrame = self.frame;
    self.cardTempVC = [[KHHVisualCardViewController alloc] initWithNibName:nil bundle:nil];
    [self.cardTempVC setCardWidth:myFrame.size.width];
    xlPage = [[XLPageControl alloc] initWithFrame:CGRectMake(myFrame.size.width / 2 - 50  , myFrame.size.height + 10, 100, 15)];
    [xlPage setBackgroundColor:[UIColor clearColor]];
    xlPage.activeImg = [UIImage imageNamed:@"p2.png"];
    xlPage.unActiveImg = [UIImage imageNamed:@"p1.png"];
    xlPage.tag = 118;
    xlPage.hidesForSinglePage = YES;
    xlPage.numberOfPages = 2;
    [xlPage addTarget:self action:@selector(pageCtrlClick:) forControlEvents:UIControlEventValueChanged];
    [xlPage setCurrentPage:0];
    [self addSubview:xlPage];
    self.pages = 2;
    if (_isVer) {
        CGRect rect = CGRectMake(75, 10, myFrame.size.width, myFrame.size.height);
        [self creatCardTemplate:rect];
    }else{
        CGRect rect = CGRectMake(0, 0, myFrame.size.width, myFrame.size.height );
//        CGRect rect = CGRectMake(0, 0, 180, 120);
//        CGRect rect = CGRectMake(10, 15, myFrame.size.width, myFrame.size.height);
        [self creatCardTemplate:rect];
    }
    [self addSubview:_scrView];
    self.shadowCard = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cardTouying.png"]];
//    self.shadowCard.frame = CGRectMake(0, myFrame.size.height + 15, myFrame.size.width, 20);
    self.shadowCard.frame = CGRectMake(0, myFrame.size.height, myFrame.size.width, 20);
    [self addSubview:self.shadowCard];
}


- (void)creatCardTemplate:(CGRect)frame
{
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:frame];
    
    scroll.showsHorizontalScrollIndicator = NO;
    scroll.delegate = self;
    if (self.isOnePage) {
        self.pages = 1;
        xlPage.hidden = YES;
    }
    for (int i = 0; i< pages; i++) {
        CGRect rect = frame;
        rect.origin.x = i * frame.size.width ;
        frame = rect;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
        if (i == 0) {
            
//            imgView.backgroundColor = [UIColor clearColor];
//            imgView.image = [UIImage imageNamed:@"card_tesco.png"];
            [scroll addSubview:self.cardTempVC.view];
            self.cardTempVC.card = self.card;
            //添加点击事件(编辑界面是去选择模板，其它界面是全屏预览)
            [self addTapGestureForTemplate:self.cardTempVC.view];
            
        }else{
            //第二张从网络获取
            rect.origin.y = 0;
            imgView.frame = rect;
            NSArray *set = [self.card.frames allObjects];
            if (set.count > 0) {
                Image *img = [set objectAtIndex:0];
                [imgView setImageWithURL:[NSURL URLWithString:img.url] placeholderImage:[UIImage imageNamed:@"qidong_logo.png"]];
            }else{
                imgView.image = [UIImage imageNamed:@"qidong_logo.png"];
            }
            
            [scroll addSubview:imgView];
            //添加点击事件(编辑界面是去选择模板，其它界面是全屏预览)
            [self addTapGestureForTemplate:imgView];
        }
    }
    
    scroll.pagingEnabled = YES;
    scroll.contentSize = CGSizeMake(self.pages*frame.size.width, frame.size.height);
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
    int w = _isVer?180:300;
    _scrView.contentOffset = CGPointMake(i * w, 0);
    [UIView commitAnimations];
    
}
- (void)addTapGestureForTemplate:(UIView *)templateView{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapCallBack:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [templateView addGestureRecognizer:tap];
 
}
- (void)singleTapCallBack:(UITapGestureRecognizer *)sender{
    DLog(@"singleTapCallBack");
    //发送callback广播
    if (_myActionName) {
        [self postASAPNotificationName:_myActionName];
        return;
    }
    
    if (!self.myDelegate) {
        return;
    }
    //默认的事件是全屏预览
    KHHPreViewViewController *preViewVC = [[KHHPreViewViewController alloc] initWithNibName:nil bundle:nil];
    preViewVC.preViewCard = self.card;
    [self.myDelegate.navigationController pushViewController:preViewVC animated:YES];
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
