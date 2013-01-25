//
//  KHHMyDetailController.m
//  CardBook
//
//  Created by 孙铭 on 8/7/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import "KHHMyDetailController.h"
#import "KHHvisitCalendarView.h"
#import "KHHCardView.h"
#import "KHHShowHideTabBar.h"
#import "Edit_eCardViewController.h"
//#import "KHHData+UI.h"

@interface KHHMyDetailController ()
@property (assign, nonatomic) bool    isNeedReloadTable;
//@property (strong, nonatomic) KHHData *dataCtrl;


@end

@implementation KHHMyDetailController
@synthesize segmCtrl = _segmCtrl;
@synthesize visitView = _visitView;
@synthesize cardView = _cardView;
@synthesize containView = _containView;
@synthesize lastBtn = _lastBtn;
@synthesize card;
@synthesize isNeedReloadTable;
//@synthesize dataCtrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.hidesBottomBarWhenPushed = YES;
        self.navigationItem.title = @"我的详情";
        self.navigationItem.rightBarButtonItem = nil;
       // self.dataCtrl = [KHHData sharedData];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 37)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:headerView];
    for (int i = 0; i<2; i++) {
        UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headBtn.frame = CGRectMake(i*160, 0, 160, 37);
        headBtn.adjustsImageWhenHighlighted = NO;
        headBtn.tag = i+667;
        [headBtn setBackgroundImage:[[UIImage imageNamed:@"xiangqing_btn13_normal.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:1] forState:UIControlStateNormal];
        if (i == 0) {
            [headBtn setTitle:@"电子名片" forState:UIControlStateNormal];
        }else{
            [headBtn setTitle:@"拜访日志" forState:UIControlStateNormal];
        }
        [headBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        headBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [headBtn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:headBtn];
    }
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(160, 4, 1, 29)];
    line.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:line];
    
    //拜访日历界面
    _visitView = [[[NSBundle mainBundle] loadNibNamed:@"KHHVisitCalendarView" owner:self options:nil] objectAtIndex:0];
    _visitView.card = self.card;
    _visitView.visitType = KHHVisitPlanAll;
    [_visitView initViewData];
    
    CGRect rect = _visitView.footView.frame;
    CGRect rectTable = _visitView.theTable.frame;
    rect.origin.y = 355;
    rectTable.size.height = 385 ;
    _visitView.footView.frame = rect;
    _visitView.theTable.frame = rectTable;
    _visitView.viewCtrl = self;
    
    //名片界面
    _cardView = [[[NSBundle mainBundle] loadNibNamed:@"KHHCardView" owner:self options:nil] objectAtIndex:0];
    _cardView.myDetailVC = self;
    _cardView.myCard = self.card;
    CGRect rectTableCard = _cardView.theTable.frame;
    rectTableCard.origin.y = 25;
    _cardView.theTable.frame = rectTableCard;
    [_cardView initView];
    [_cardView initViewData];
    [self.containView addSubview:_visitView];
    [self.containView addSubview:_cardView];
    
    //默认选中某个按钮
    UIButton *defBtn = (UIButton *)[self.view viewWithTag:667];
    [self performSelector:@selector(headBtnClick:) withObject:defBtn afterDelay:0.1];
    //判断公司名片还是个人名片，个人名片有编辑按钮
    if (self.card.roleTypeValue == 1) {
        UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bottomBtn.tag = 323;
        [bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        bottomBtn.frame = CGRectMake(260, 360, 50, 50);
        [bottomBtn setBackgroundImage:[UIImage imageNamed:@"edit_Btn_Red.png"] forState:UIControlStateNormal];
        [self.view insertSubview:bottomBtn atIndex:100];
    }
    //addressbook
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [KHHShowHideTabBar hideTabbar];
    if (self.isNeedReloadTable) {
        [_cardView reloadTable];
        [_cardView initView];
    }
    
    [_visitView reloadTheTable];
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _segmCtrl = nil;
    _visitView = nil;
    _cardView = nil;
    _containView = nil;
    self.card = nil;
   // self.dataCtrl = nil;
}
- (void)headBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    UIButton *bottomBtn = (UIButton *)[self.view viewWithTag:323];
    if (_lastBtn != btn.tag && _lastBtn != 0) {
        UIButton *lastBtn = (UIButton *)[self.view viewWithTag:_lastBtn];
        [lastBtn setBackgroundImage:[UIImage imageNamed:@"xiangqing_btn13_normal.png"] forState:UIControlStateNormal];
    }
    
    [btn setBackgroundImage:[UIImage imageNamed:@"xq_btn13_selected.png"] forState:UIControlStateNormal];
    _lastBtn = btn.tag;
    if (btn.tag == 667) {
        bottomBtn.hidden = NO;
        [self.containView bringSubviewToFront:_cardView];
    }else if (btn.tag == 668){
        bottomBtn.hidden = YES;
        [self.containView bringSubviewToFront:_visitView];
    }

}
- (void)bottomBtnClick:(id)sender
{
    self.isNeedReloadTable = YES;
    Edit_eCardViewController *editeCardVC = [[Edit_eCardViewController alloc] initWithNibName:@"Edit_eCardViewController" bundle:nil];
    editeCardVC.type = KCardViewControllerTypeShowInfo;
    editeCardVC.glCard = self.card;
    [self.navigationController pushViewController:editeCardVC animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
