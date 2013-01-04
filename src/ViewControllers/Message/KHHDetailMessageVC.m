//
//  KHHDetailMessageVC.m
//  CardBook
//
//  Created by 王国辉 on 12-9-11.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "KHHDetailMessageVC.h"
#import "KHHShowHideTabBar.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Image.h"

//两个ui间的间隔
static NSInteger const KHH_Message_UIView_Space = 20;
//image 默认的宽高
static NSInteger const KHH_Message_UIImage_Default_Height = 300;
@interface KHHDetailMessageVC ()
//计算scrollView contentSize的高度(也可以理解为当前界面的高度)
@property CGFloat currentViewHeight;
@end

@implementation KHHDetailMessageVC
@synthesize message;
@synthesize scrollView = _scrollView;
@synthesize currentViewHeight = _currentViewHeight;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"消息详情";
        self.navigationItem.rightBarButtonItem = nil;
    }
    return self;
}
- (void)rightBarButtonClick:(id)sender
{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //    [self.view setBackgroundColor:[UIColor colorWithRed:241 green:238 blue:232 alpha:1.0]];
    //计算size
    //设置消息时间
    self.timeLabel.text = self.message.time;
    _currentViewHeight = self.timeLabel.frame.origin.y + self.timeLabel.frame.size.height;
    //添加内容
    [self addMessageContent];
    //设置scrollView的属性
    [self scrollViewAttribute];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [KHHShowHideTabBar hideTabbar];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.message = nil;
    self.timeLabel = nil;
    self.scrollView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) addMessageContent   {
    if (!self.message) {
        return;
    }
    
    //消息内容 高度自适应
    [self addAutoHeightLabelToScrollView:self.message.content];
    
    //消息的图片
    if (self.message.image.url.length > 0) {
        [self addAutoHeightImageViewByUrl:self.message.image.url];
        //        [self addAutoHeightImageViewByUIImage:[UIImage imageNamed:@"template_bg"]];
    }
}

//添加label
-(void) addAutoHeightLabelToScrollView:(NSString *) labelText {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];//后面还会重新设置其size。
    [label setNumberOfLines:0];
    //每段文字前空点字符
    //    NSString * content= [NSString stringWithFormat:@"%@%@",@"   ",labelText];
    NSString * content= [NSString stringWithFormat:@"%@",labelText];
    UIFont *font = [UIFont fontWithName:@"Arial" size:17];
    //最大大小
    CGSize size = CGSizeMake(300,2000);
    //计算高度
    CGSize labelsize = [content sizeWithFont:font constrainedToSize:size]; // lineBreakMode:UILineBreakModeWordWrap
    //设置label的frame
    [label setFrame:CGRectMake(10, _currentViewHeight + KHH_Message_UIView_Space, labelsize.width, labelsize.height)];
    label.text = content;
    label.font = font;
    [_scrollView addSubview:label];
    //最新的高度
    _currentViewHeight += KHH_Message_UIView_Space + labelsize.height;
}

//添加图片通过imageurl
-(void) addAutoHeightImageViewByUrl:(NSString *) imageUrl {
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setFrame:CGRectMake(10, _currentViewHeight + KHH_Message_UIView_Space, KHH_Message_UIImage_Default_Height, KHH_Message_UIImage_Default_Height)];
    //        [imageView setImage:[UIImage ]]
    [imageView setImageWithURL:[NSURL URLWithString:imageUrl]];
    [_scrollView addSubview:imageView];
    //更新高度
    _currentViewHeight += KHH_Message_UIView_Space + imageView.frame.size.height;
}

//添加图片通过imageurl
-(void) addAutoHeightImageViewByUIImage:(UIImage *) image {
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setFrame:CGRectMake(10, _currentViewHeight + KHH_Message_UIView_Space, KHH_Message_UIImage_Default_Height, KHH_Message_UIImage_Default_Height)];
    //        [imageView setImage:[UIImage ]]
    [imageView setImage:image];
    [_scrollView addSubview:imageView];
    //更新高度
    _currentViewHeight += KHH_Message_UIView_Space + imageView.frame.size.height;
}

//设置scrollView和一些属性
-(void) scrollViewAttribute {
    CGRect bounds = [ [ UIScreen mainScreen ] applicationFrame];
    _scrollView.frame = bounds;
    //    _scrollView.directionalLockEnabled = YES;//锁定滑动的方向
    //    _scrollView.pagingEnabled = NO;//滑到subview的边界
    //    _scrollView.showsVerticalScrollIndicator = YES;//不显示垂直滚动条
    //    _scrollView.showsHorizontalScrollIndicator = NO;//不显示水平滚动条
    CGSize newSize = CGSizeMake(self.view.frame.size.width,  _currentViewHeight + KHH_Message_UIView_Space * 4);//设置scrollview的大小
    [_scrollView setContentSize:newSize];
}

@end
