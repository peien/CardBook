//
//  KHHAllVisitedSchedusVC.m
//  CardBook
//
//  Created by 王国辉 on 12-11-5.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "KHHAllVisitedSchedusVC.h"
#import "KHHVisitCalendarView.h"
#import "KHHClasses.h"
#import "KHHData+UI.h"

@interface KHHAllVisitedSchedusVC ()
{
    int lastBtnTag;
}
@property (strong, nonatomic)KHHVisitCalendarView *visitView;

@end

@implementation KHHAllVisitedSchedusVC
@synthesize visitView = _visitView;
@synthesize isNeedReloadData;
@synthesize tableContainer;
@synthesize headerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"沟通拜访日历";
        self.rightBtn.hidden = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //添加title button
    NSArray *arr = [NSArray arrayWithObjects:@"全部",@"执行中",@"已过期", @"已完成", nil];
    for (int i = 0; i < arr.count; i++) {
        UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        headBtn.adjustsImageWhenHighlighted = NO;
        headBtn.frame = CGRectMake(0+i*(320/arr.count), 0, 320/arr.count, 37);
        [headBtn setTitle:NSLocalizedString([arr objectAtIndex:i], nil) forState:UIControlStateNormal];
        if (i == arr.count - 1) {
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
        [self.headerView addSubview:headBtn];
        //默认选择每一个
        if (i == 0) {
            [self performSelector:@selector(headBtnClick:) withObject:headBtn afterDelay:0.5];
        }
    }
    
    //[self.view removeFromSuperview];
    Card *card = [[[KHHData sharedData] allMyCards] objectAtIndex:0];
    _visitView = [[[NSBundle mainBundle] loadNibNamed:@"KHHVisitCalendarView" owner:self options:nil] objectAtIndex:0];
    _visitView.card = card;
    _visitView.visitType = KHHVisitPlanAll;
    _visitView.viewCtrl = self;
    [_visitView initViewData];
    _visitView.footView.hidden = YES;
////    CGRect rect = _visitView.footView.frame;
////    rect.origin.y = 355;
////    _visitView.footView.frame = rect;
    CGRect rectTable = _visitView.theTable.frame;
//    rectTable.size.height = 420;
    rectTable.origin.y = 0;
    _visitView.theTable.frame = rectTable;
    [self.tableContainer addSubview:_visitView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [_visitView reloadTheTable];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)headBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (lastBtnTag >= 999 && lastBtnTag < 1003) {
        UIButton *lastBtn = (UIButton *)[self.view viewWithTag:lastBtnTag];
        if (lastBtn.tag == 1002) {
            [lastBtn setBackgroundImage:[UIImage imageNamed:@"xiangqing_btn13_normal.png"] forState:UIControlStateNormal];
        }else{
            UIImage *img = [[UIImage imageNamed:@"xiangqing_btn2_normal.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:2];
            [lastBtn setBackgroundImage:img forState:UIControlStateNormal];
        }
    }
    
    if (btn.tag == 1002) {
        [btn setBackgroundImage:[UIImage imageNamed:@"xq_btn13_selected.png"] forState:UIControlStateNormal];
    }else{
        UIImage *img = [[UIImage imageNamed:@"xq_btn2_selected.png"] stretchableImageWithLeftCapWidth:2 topCapHeight:2];
        [btn setBackgroundImage:img forState:UIControlStateNormal];;
    }
    
    lastBtnTag = btn.tag;
    
    switch (btn.tag) {
        case 999:
        {
            //全部
            _visitView.visitType = KHHVisitPlanAll;
        }
            break;
        case 1000:
        {
            //执行中
            _visitView.visitType = KHHVisitPlanExecuting;
        }
            break;
        case 1001:
        {
            //已过期
            _visitView.visitType = KHHVisitPlanOverdue;
        }
            break;
        case 1002:
        {
            //已完成
            _visitView.visitType = KHHVisitPlanFinished;
        }
            break;
        default:
            break;
    }
    
    //刷新数据
    [_visitView reloadTheTable];
}

@end
