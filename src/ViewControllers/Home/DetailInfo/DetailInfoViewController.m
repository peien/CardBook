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

#import "KHHCardView.h"
#import "KHHVisitCalendarView.h"
#import "KHHCustomEvaluaView.h"
#import "KHHEditCustomValueVC.h"
#import "MyTabBarController.h"
#import "KHHShowHideTabBar.h"
#import "KHHVisitRecoardVC.h"
#import "UIImageView+WebCache.h"
#import "KHHDataAPI.h"
#import "Company.h"
#import "KHHMyAlertViewWithSubView.h"
#import "KHHDefaults.h"

#define POPDismiss [self.popover dismissPopoverAnimated:YES];
#define LABEL_NAME_TAG    98980
#define LABEL_JOB_TAG     98981
#define LABEL_COMPANY_TAG 98982
#define LABEL_LOGIMG_TAG  98983

@interface DetailInfoViewController ()

@property (nonatomic, strong) WEPopoverController  *popover;
@property (nonatomic, strong) KHHCardView          *cardView;
@property (nonatomic, strong) KHHVisitCalendarView *visitCalView;
@property (nonatomic, strong) KHHCustomEvaluaView  *customView;
@property (nonatomic, strong) UIActionSheet        *actSheet;
@property (nonatomic, assign) int                  style;
@property (nonatomic, strong) KHHData              *dataCtrl;
@property (assign, nonatomic) bool                 isReloadCardTable;
@property (assign, nonatomic) bool                 isReloadCustomValTable;
@end

@implementation DetailInfoViewController

@synthesize eCardVC = _eCardVC;
@synthesize isToeCardVC = _isToeCardVC;
@synthesize popover = _popover;
@synthesize cardView = _cardView;
@synthesize visitCalView = _visitCalView;
@synthesize containView = _containView;
@synthesize customView = _customView;
@synthesize lastBtn = _lastBtn;
@synthesize app = _app;
@synthesize actSheet = _actSheet;
@synthesize style = _style;
@synthesize card;
@synthesize cardM;
@synthesize isNeedReloadTable;
@synthesize dataCtrl;
@synthesize isReloadCardTable;
@synthesize isReloadVisiteTable;
@synthesize isReloadCustomValTable;
@synthesize myDefaultReplyCard = _myDefaultReplyCard;

#pragma mark -
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"详细信息", nil);
        //公司同事不显示回赠
        if ([self isCompanyColleagues]) {
            self.rightBtn.hidden = NO;
        }else {
            [self.rightBtn setTitle:NSLocalizedString(@"回赠", nil) forState:UIControlStateNormal];
        }
        self.tabBarController.tabBar.hidden = YES;
        self.dataCtrl = [KHHData sharedData];
        //回赠名片跟回赠按钮一起初始化
        NSArray *cards = [self.dataCtrl allMyCards];
        if (cards) {
            _myDefaultReplyCard = [cards objectAtIndex:0];
        }
    }
    return self;
}

//回赠todo
- (void)rightBarButtonClick:(id)sender
{
    //初始化预览名片
    KHHFrameCardView* cardView = [[KHHFrameCardView alloc] initWithFrame:CGRectMake(45, 35, 180 , 108) delegate:nil isVer:NO callbackAction:nil];
    if (!cardView) {
        return;
    }
    cardView.card = _myDefaultReplyCard;
    [cardView showPreView];
    
    UIView *preView = [[UIView alloc] initWithFrame:CGRectMake(10, 15, 180, 108 + 30 + 35)];
    [preView addSubview: cardView];
    
    //显示预览框
    KHHMyAlertViewWithSubView *alert = [[KHHMyAlertViewWithSubView alloc] initWithTitle:@"回赠名片" subView:preView delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"回赠"];
    [alert show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    self.view.backgroundColor = [UIColor clearColor];
    UIButton *btn = (UIButton *)[self.view viewWithTag:999];
    [self performSelector:@selector(headBtnClick:) withObject:btn afterDelay:0.1];

}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [KHHShowHideTabBar hideTabbar];
//    if (self.isNeedReloadTable) {
//
//        //刷新客户评估表
//
//        //刷新拜访纪录
//    }
    if (self.isReloadCardTable) {
        [_cardView reloadTable];
        [_cardView initView];
        [self updateViewData:self.card];
    }
    if (self.isReloadCustomValTable){
        if ([self.card isKindOfClass:[ReceivedCard class]]) {
            self.card = [self.dataCtrl receivedCardByID:self.card.id];
        }else if ([self.card isKindOfClass:[PrivateCard class]]){
            self.card = [self.dataCtrl privateCardByID:self.card.id];
        }
        _customView.card = self.card;
        [_customView reloadTable];
    
    }
    if (self.isReloadVisiteTable){
        if ([self.card isKindOfClass:[ReceivedCard class]]) {
            self.card = [self.dataCtrl receivedCardByID:self.card.id];
        }else if ([self.card isKindOfClass:[PrivateCard class]]){
            self.card = [self.dataCtrl privateCardByID:self.card.id];
        }
        _visitCalView.card = self.card;
        [_visitCalView reloadTheTable];
    }
    
}
- (void)viewWillDisappear:(BOOL)animated{

}

//判断是否是同事
-(BOOL) isCompanyColleagues {
    KHHDefaults *myDefault = [KHHDefaults sharedDefaults];
    NSNumber *companyID = [myDefault currentCompanyID];
    if(self.card.company && self.card.company.id.longValue == companyID.longValue && companyID.longValue > 0){
        return YES;
    }
    
    return NO;
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
    iconImgView.tag = LABEL_LOGIMG_TAG;
    iconImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOne:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    
    [iconImgView addGestureRecognizer:tap];
    UIImage *iconImg = [UIImage imageNamed:@"logopic.png"];
    iconImgView.image = iconImg;
    [iconImgView setImageWithURL:[NSURL URLWithString:self.card.logo.url] placeholderImage:iconImg];
    iconImgView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:iconImgView];
    UILabel *nameLab = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, 120, 20)];
    nameLab.tag = LABEL_NAME_TAG;
    nameLab.text = NSLocalizedString(self.card.name, nil);
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.font = [UIFont boldSystemFontOfSize:15];
    nameLab.textAlignment = UITextAlignmentLeft;
    [headerView addSubview:nameLab];
    UILabel *companylab = [[UILabel alloc] initWithFrame:CGRectMake(75, 25, 300, 20)];
    companylab.tag = LABEL_COMPANY_TAG;
    companylab.font = [UIFont systemFontOfSize:11];
    companylab.textAlignment = UITextAlignmentLeft;
    companylab.backgroundColor = [UIColor clearColor];
    companylab.text = NSLocalizedString(self.card.company.name, nil);
    [headerView addSubview:companylab];
    UILabel *jobLab = [[UILabel alloc] initWithFrame:CGRectMake(135, 10, 100, 20)];
    jobLab.tag = LABEL_JOB_TAG;
    jobLab.text = NSLocalizedString(self.card.title, nil);
    jobLab.textAlignment = UITextAlignmentLeft;
    jobLab.font = [UIFont systemFontOfSize:13];
    jobLab.backgroundColor = [UIColor clearColor];
    [headerView addSubview:jobLab];
    [self.view addSubview:headerView];
    NSArray *arr = [NSArray arrayWithObjects:@"电子名片",@"拜访日志",@"客户评估", nil];
    NSInteger showTabCount = 3;
    //同事只显示电子名片
    if ([self isCompanyColleagues]) {
        showTabCount = 1;
    }
    
    //添加
    for (int i = 0; i < showTabCount; i++) {
        UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headBtn.adjustsImageWhenHighlighted = NO;
        headBtn.frame = CGRectMake(0+i*(45+60), 63, 320/showTabCount, 37);
        [headBtn setTitle:NSLocalizedString([arr objectAtIndex:i], nil) forState:UIControlStateNormal];
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

    //电子名片视图
    _cardView = [[[NSBundle mainBundle] loadNibNamed:@"KHHCardView" owner:self options:nil] objectAtIndex:0];
    _cardView.myCard = self.card;
    _cardView.detailVC = self;  
    [_cardView initView];
    [_cardView initViewData];
    [self.containView addSubview:_cardView];
    if (showTabCount > 1) {
        //拜访日志
        _visitCalView = [[[NSBundle mainBundle] loadNibNamed:@"KHHVisitCalendarView" owner:self options:nil] objectAtIndex:0];
        _visitCalView.card = self.card;
        _visitCalView.isFromHomeVC = YES;
        [_visitCalView initViewData];
        
        CGRect rect = _visitCalView.footView.frame;
        CGRect rectTable = _visitCalView.theTable.frame;
        rect.origin.y = 280;
        rectTable.size.height = 325;
        rectTable.origin.y = 8;
        _visitCalView.footView.frame = rect;
        _visitCalView.theTable.frame = rectTable;
        _visitCalView.viewCtrl = self;
        _visitCalView.footView.backgroundColor = [UIColor clearColor];
        [self.containView addSubview:_visitCalView];
        
        //客户评估视图
        _customView = [[[NSBundle mainBundle] loadNibNamed:@"KHHCustomEvaluaView" owner:self options:nil] objectAtIndex:0];
        if (self.card.evaluation != nil) {
            _customView.importFlag = self.card.evaluation.remarks;
            _customView.relationEx = [self.card.evaluation.degree floatValue];
            _customView.customValue = [self.card.evaluation.value floatValue];
        }
        [self.containView addSubview:_customView];
    }
        
    //接收到的卡片不能修改
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bottomBtn.tag = 323;
    [bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    bottomBtn.frame = CGRectMake(260, 360, 50, 50);
    [bottomBtn setBackgroundImage:[UIImage imageNamed:@"edit_Btn_Red.png"] forState:UIControlStateNormal];
    [self.view insertSubview:bottomBtn atIndex:100];
    if (self.card.modelTypeValue !=2) {
        if (self.card.roleTypeValue != 1 || [self.card isKindOfClass:[ReceivedCard class]]) {
            bottomBtn.hidden = YES;
        }
    }

    //popView

}

- (void)updateViewData:(Card *)temCard{
    UILabel *nameLab = (UILabel *)[self.view viewWithTag:LABEL_NAME_TAG];
    UILabel *jobLab = (UILabel *)[self.view viewWithTag:LABEL_JOB_TAG];
    UILabel *companyLab = (UILabel *)[self.view viewWithTag:LABEL_COMPANY_TAG];
    UIImageView *logImageview = (UIImageView *)[self.view viewWithTag:LABEL_LOGIMG_TAG];
    nameLab.text = temCard.name;
    jobLab.text = temCard.title;
    companyLab.text = temCard.company.name;
    UIImage *iconImg = [UIImage imageNamed:@"logopic.png"];
    [logImageview setImageWithURL:[NSURL URLWithString:temCard.logo.url] placeholderImage:iconImg];
    
}
- (void)bottomBtnClick:(id)sender
{
    if (_isToeCardVC) {
        self.isReloadCardTable = YES;
        Edit_eCardViewController *editeCardVC = [[Edit_eCardViewController alloc] initWithNibName:@"Edit_eCardViewController" bundle:nil];
        editeCardVC.type = KCardViewControllerTypeShowInfo;
        editeCardVC.glCard = self.card;
        [self.navigationController pushViewController:editeCardVC animated:YES];
        
    }else{
        
        KHHEditCustomValueVC *editCustomVC = [[KHHEditCustomValueVC alloc] initWithNibName:nil bundle:nil];
        editCustomVC.cusView = _customView;
        editCustomVC.card = self.card;
        self.isReloadCustomValTable = YES;
        editCustomVC.importFlag = self.card.evaluation.remarks;
        editCustomVC.relationEx = [self.card.evaluation.degree floatValue];
        editCustomVC.customValue = [self.card.evaluation.value floatValue];
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
        if (self.card.modelTypeValue != 2) {
            if (self.card.roleTypeValue != 1 || [self.card isKindOfClass:[ReceivedCard class]]) {
                bottomBtn.hidden = YES;
            }else{
                bottomBtn.hidden = NO;
            }
        }
        _isToeCardVC  = YES;
        
    }else if (btn.tag == 1000){
        _visitCalView.isDetailVC = YES;
//        CGRect rect = _visitCalView.theTable.frame;
//        CGRect rectfoot = _visitCalView.footView.frame;
//        rect.size.height = 200;
//        rectfoot.origin.y = 260;
//        _visitCalView.footView.frame = rectfoot;
//        _visitCalView.theTable.frame = rect;
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
    _cardView = nil;
    _visitCalView = nil;
    _containView = nil;
    _customView = nil;
    _popover = nil;
    _actSheet = nil;
    self.card = nil;
    self.cardM = nil;
    self.dataCtrl = nil;
}
#pragma mark -
- (void)tapOne:(id)sender
{
    KHHFloatBarController *floatBarVC = [[KHHFloatBarController alloc] initWithNibName:nil bundle:nil];
    floatBarVC.viewController = self;
    self.popover = [[WEPopoverController alloc] initWithContentViewController:floatBarVC];
    floatBarVC.popover = self.popover;
    floatBarVC.card = self.card;
    CGRect rect = CGRectMake(55, 5, 2, 40);
    UIPopoverArrowDirection arrowDirection = UIPopoverArrowDirectionLeft;
    [self.popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:arrowDirection animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//回赠名片选择按钮点击
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            DLog(@"reply card cancle");
            break;
        case 1:
        {
            DLog(@"begin reply card");
            //注册UI回赠成功失败广播
            [self observeNotificationName:KHHUIReplyCardSucceeded selector:@"handleReplyCardSucessded:"];
            [self observeNotificationName:KHHUIReplyCardFailed selector:@"handleReplyCardFailed:"];
            MBProgressHUD *progess = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            progess.labelText = NSLocalizedString(@"正在回赠名片，请稍后", nil);
            [self.dataCtrl replyCard:self.card myDefaultReplyCard:self.myDefaultReplyCard];
            break;
        }
        default:
            break;
    }
}

-(void) handleReplyCardSucessded:(NSNotification *)noti
{
    
    [self stopReplyCardObservingNotifications];
    //根据返回结果提示用户
    DLog(@"reply card sucessded . userInfo = %@", noti.userInfo);
    NSMutableString *message = [[NSMutableString alloc] initWithCapacity:0];
    [message appendString:@"回赠名片"];
    if (self.card.name && self.card.name.length > 0) {
        [message appendString:@"给["];
        [message appendString:self.card.name];
        [message appendString:@"]"];
    }
        
    
    //成功与已存在都显示成功
    int errorCode = [[noti.userInfo objectForKey:@"errorCode"] intValue];
    switch (errorCode) {
        case 0:
        case 1:
            [message appendString:@"成功"];
            break;
        default:
            [message appendString:@"失败，请稍后再试"];
            break;
    }
    
    [self showReplyResult: message];
}

-(void) handleReplyCardFailed:(NSNotification *)noti
{
    [self stopReplyCardObservingNotifications];
    //根据返回结果提示用户
    DLog(@"reply card failed . userInfo = %@", noti.userInfo);
    NSMutableString *message = [[NSMutableString alloc] initWithCapacity:0];
    [message appendString:@"回赠名片"];
    if (self.card.name && self.card.name.length > 0) {
        [message appendString:@"给["];
        [message appendString:self.card.name];
        [message appendString:@"]"];
    }
    [message appendString:@"失败，请稍后再试"];
    [self showReplyResult: message];
}

//停止广播接收器
-(void) stopReplyCardObservingNotifications
{
    //关闭对话框
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    [self stopObservingNotificationName:KHHUIReplyCardSucceeded];
    [self stopObservingNotificationName:KHHUIReplyCardFailed];
}

//显示回赠结果
-(void) showReplyResult:(NSString*) result
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"回赠名片" message:result delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];
}
@end
