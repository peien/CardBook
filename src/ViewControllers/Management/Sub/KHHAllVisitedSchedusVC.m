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
@property (strong, nonatomic)KHHVisitCalendarView *visitView;

@end

@implementation KHHAllVisitedSchedusVC
@synthesize visitView = _visitView;
@synthesize isNeedReloadData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.rightBtn.hidden = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[self.view removeFromSuperview];
    Card *card = [[[KHHData sharedData] allMyCards] lastObject];
    _visitView = [[[NSBundle mainBundle] loadNibNamed:@"KHHVisitCalendarView" owner:self options:nil] objectAtIndex:0];
    _visitView.card = card;
    _visitView.isAllVisitedSch = YES;
    _visitView.viewCtrl = self;
    _visitView.footView.hidden = YES;
    [_visitView initViewData];
    CGRect rect = _visitView.footView.frame;
    CGRect rectTable = _visitView.theTable.frame;
    rect.origin.y = 355;
    rectTable.size.height = 460;
    rectTable.origin.y = 0;
    _visitView.footView.frame = rect;
    _visitView.theTable.frame = rectTable;
    [self.view addSubview:_visitView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_visitView reloadTheTable];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
