//
//  DetailInfoViewController.m
//  CardBook
//
//  Created by 王国辉 on 12-8-6.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "DetailInfoViewController.h"
#import "Edit_eCardViewController.h"

#import "KHHFloatBarController.h"
#import "WEPopoverController.h"
#import "KHHCalendarViewController.h"
#import "KHHFinishVisitVC.h"

#import "KHHCardView.h"
#import "KHHVisitCalendarView.h"
#import "KHHCustomEvaluaView.h"
#import "KHHEditCustomValueVC.h"
#import "MyTabBarController.h"
#import "KHHShowHideTabBar.h"
#import "KHHVisitRecoardVC.h"
#import "UIImageView+WebCache.h"

#import "Company.h"

#define POPDismiss [self.popover dismissPopoverAnimated:YES];

@interface DetailInfoViewController ()
@property (nonatomic, strong) WEPopoverController *popover;
@property (nonatomic, strong) KHHCardView         *cardView;
@property (nonatomic, strong) KHHVisitCalendarView *visitCalView;
@property (nonatomic, strong) KHHCustomEvaluaView  *customView;
@property (nonatomic, strong) UIActionSheet        *actSheet;
@property (nonatomic, assign) int                  style;
@end

@implementation DetailInfoViewController
@synthesize right_bottomBtn = _right_bottomBtn;
@synthesize eCardVC = _eCardVC;
@synthesize isToeCardVC = _isToeCardVC;
@synthesize popover = _popover;
@synthesize cardView = _cardView;
@synthesize visitCalView = _visitCalView;
@synthesize containView = _containView;
@synthesize segmCtrl = _segmCtrl;
@synthesize customView = _customView;
@synthesize lastBtn = _lastBtn;
@synthesize app = _app;
@synthesize actSheet = _actSheet;
@synthesize style = _style;
@synthesize card;
@synthesize cardM;
#pragma mark -
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"详细信息";
        [self.rightBtn setTitle:@"回赠" forState:UIControlStateNormal];
        self.tabBarController.tabBar.hidden = YES;

    }
    return self;
}

//回赠todo
- (void)rightBarButtonClick:(id)sender
{
    
}

//右下角按钮 todo
- (IBAction)right_bottomBtnClick:(id)sender
{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self initView];
    self.view.backgroundColor = [UIColor clearColor];
    UIButton *btn = (UIButton *)[self.view viewWithTag:1000];
    [self performSelector:@selector(headBtnClick:) withObject:btn afterDelay:0.1];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [KHHShowHideTabBar hideTabbar];

}
- (void)viewWillDisappear:(BOOL)animated{

}

//初始化视图
- (void)initView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    UIImage *bgimg = [[UIImage imageNamed:@"xiangqing_top_bg.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
    UIImageView *bgimgView = [[UIImageView alloc] initWithImage:bgimg];
    bgimgView.frame = headerView.frame;
    [headerView addSubview:bgimgView];
    UIImageView *iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 7, 51, 51)];
    iconImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOne:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    
    [iconImgView addGestureRecognizer:tap];
    UIImage *iconImg = [UIImage imageNamed:@"logopic.png"];
    iconImgView.image = iconImg;
    [iconImgView setImageWithURL:[NSURL URLWithString:self.cardM.logUrl] placeholderImage:iconImg];
    iconImgView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:iconImgView];
    _segmCtrl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 75, 320, 30)];
    [_segmCtrl insertSegmentWithTitle:@"客户评估" atIndex:0 animated:NO];
    [_segmCtrl insertSegmentWithTitle:@"拜访日历" atIndex:1 animated:NO];
    [_segmCtrl insertSegmentWithTitle:@"电子名片" atIndex:2 animated:NO];
    [_segmCtrl addTarget:self action:@selector(segCtrlClick:) forControlEvents:UIControlEventValueChanged];
    _segmCtrl.selectedSegmentIndex = 0;
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, 120, 20)];
    nameLab.text = self.cardM.name;
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.font = [UIFont boldSystemFontOfSize:15];
    nameLab.textAlignment = UITextAlignmentLeft;
    [headerView addSubview:nameLab];
    UILabel *companylab = [[UILabel alloc] initWithFrame:CGRectMake(75, 25, 300, 20)];
    companylab.font = [UIFont systemFontOfSize:11];
    companylab.textAlignment = UITextAlignmentLeft;
    companylab.backgroundColor = [UIColor clearColor];
    companylab.text = @"浙江金汉弘软件有限公司";
    //companylab.text = self.cardM.company.name;
    [headerView addSubview:companylab];
    UILabel *jobLab = [[UILabel alloc] initWithFrame:CGRectMake(125, 10, 100, 20)];
    jobLab.text = self.cardM.title;
    jobLab.textAlignment = UITextAlignmentLeft;
    jobLab.font = [UIFont systemFontOfSize:13];
    jobLab.backgroundColor = [UIColor clearColor];
    [headerView addSubview:jobLab];
    [self.view addSubview:headerView];
    NSArray *arr = [NSArray arrayWithObjects:@"电子名片",@"拜访日志",@"客户评估", nil];
    for (int i = 0; i<3; i++) {
        UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headBtn.adjustsImageWhenHighlighted = NO;
        headBtn.frame = CGRectMake(0+i*(45+60), 63, 320/3, 37);
        [headBtn setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
        if (i == 0 || i == 2) {
            [headBtn setBackgroundImage:[UIImage imageNamed:@"xiangqing_btn13_normal.png"] forState:UIControlStateNormal];
        }else{
            UIImage *img = [[UIImage imageNamed:@"xiangqing_btn2_normal.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:1];
            [headBtn setBackgroundImage:img forState:UIControlStateNormal];
        }
        headBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [headBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [headBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        headBtn.tag = i + 999;
        [headBtn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:headBtn];
    }
    _cardView = [[[NSBundle mainBundle] loadNibNamed:@"KHHCardView" owner:self options:nil] objectAtIndex:0];
    [_cardView initView];
    _cardView.detailVC = self;
    //暂时显示数据
    [_cardView initViewData];
    [self.containView addSubview:_cardView];
    _visitCalView = [[[NSBundle mainBundle] loadNibNamed:@"KHHVisitCalendarView" owner:self options:nil] objectAtIndex:0];
    
    CGRect rect = _visitCalView.footView.frame;
    rect.origin.y = 290;
    _visitCalView.footView.frame = rect;
    _visitCalView.viewCtrl = self;
    [self.containView addSubview:_visitCalView];
    
    //客户评估视图
    _customView = [[[NSBundle mainBundle] loadNibNamed:@"KHHCustomEvaluaView" owner:self options:nil] objectAtIndex:0];
    _customView.importFlag = @"与谁有关系";
    _customView.relationEx = 3;
    _customView.customValue = 3;
    [self.containView addSubview:_customView];
    
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.tag = 323;
    [bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    bottomBtn.frame = CGRectMake(260, 360, 60, 60);
    [bottomBtn setBackgroundImage:[UIImage imageNamed:@"editBtn_normal.png"] forState:UIControlStateNormal];
    [self.view insertSubview:bottomBtn atIndex:100];
    
    //popView

}
- (void)bottomBtnClick:(id)sender
{
    if (_isToeCardVC) {
        Edit_eCardViewController *editeCardVC = [[Edit_eCardViewController alloc] initWithNibName:@"Edit_eCardViewController" bundle:nil];
        editeCardVC.type = KCardViewControllerTypeShowInfo;
        editeCardVC.glCard = self.card;
        [self.navigationController pushViewController:editeCardVC animated:YES];
        
    }else{
        KHHEditCustomValueVC *editCustomVC = [[KHHEditCustomValueVC alloc] initWithNibName:nil bundle:nil];
        editCustomVC.cusView = _customView;
        [self.navigationController pushViewController:editCustomVC animated:YES];
    }
}

- (void)headBtnClick:(id)sender
{
    UIButton *bottomBtn = (UIButton *)[self.view viewWithTag:323];
    UIButton *btn = (UIButton *)sender;
    
    if (_lastBtn != btn.tag && _lastBtn != 0) {
        UIButton *lastBtn = (UIButton *)[self.view viewWithTag:_lastBtn];
        if (lastBtn.tag != 1000) {
            [lastBtn setBackgroundImage:[UIImage imageNamed:@"xiangqing_btn13_normal.png"] forState:UIControlStateNormal];
        }else{
            UIImage *img = [[UIImage imageNamed:@"xiangqing_btn2_normal.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:2];
            [lastBtn setBackgroundImage:img forState:UIControlStateNormal];

        }
    }
    if (btn.tag != 1000) {
       [btn setBackgroundImage:[UIImage imageNamed:@"xq_btn13_selected.png"] forState:UIControlStateNormal];
    }else{
        UIImage *img = [[UIImage imageNamed:@"xq_btn2_selected.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:2];
       [btn setBackgroundImage:img forState:UIControlStateNormal];;
    }
   _lastBtn = btn.tag;
    
    if (btn.tag == 999) {
        [self.containView bringSubviewToFront:_cardView];
        bottomBtn.hidden = NO;
        _isToeCardVC  = YES;
        
    }else if (btn.tag == 1000){
        CGRect rect = _visitCalView.theTable.frame;
        CGRect rectfoot = _visitCalView.footView.frame;
        rect.size.height = 200;
        rectfoot.origin.y = 260;
        _visitCalView.footView.frame = rectfoot;
        _visitCalView.theTable.frame = rect;
        [self.containView bringSubviewToFront:_visitCalView];
        bottomBtn.hidden = YES;
    
    }else if (btn.tag == 1001){
        [self.containView bringSubviewToFront:_customView];
        _isToeCardVC = NO;
        bottomBtn.hidden = NO;
    }


}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _right_bottomBtn = nil;
    _cardView = nil;
    _visitCalView = nil;
    _containView = nil;
    _customView = nil;
    _popover = nil;
    _actSheet = nil;
    self.card = nil;
    self.cardM = nil;
}
#pragma mark -
- (void)tapOne:(id)sender
{
    KHHFloatBarController *floatBarVC = [[KHHFloatBarController alloc] initWithNibName:nil bundle:nil];
    floatBarVC.viewController = self;
    self.popover = [[WEPopoverController alloc] initWithContentViewController:floatBarVC];
    floatBarVC.popover = self.popover;
    floatBarVC.card = self.cardM;
    CGRect rect = CGRectMake(55, 5, 2, 40);
    UIPopoverArrowDirection arrowDirection = UIPopoverArrowDirectionLeft;
    [self.popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:arrowDirection animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
