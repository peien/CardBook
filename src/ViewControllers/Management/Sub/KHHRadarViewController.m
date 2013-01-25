//
//  KHHRadarViewController.m
//  CardBook
//
//  Created by 王国辉 on 12-8-22.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "KHHRadarViewController.h"
#import "KHHValueViewController.h"
#import "PCPieChart.h"
#import "KHHClasses.h"
#import "KHHDataNew+Card.h"

#import "KHHFilterPopup.h"

static NSInteger const KHH_PCPieChart_Tag = 1000;

@interface KHHRadarViewController ()<KHHFilterPopupDelegate>
//@property (strong, nonatomic) KHHData *dataCtrl;
@property (strong, nonatomic) NSMutableArray    *valueItems;
@property (assign, nonatomic) BOOL              isNeedReloadTable;
@property (strong, nonatomic) Group             *currentGroup;
@property (assign, nonatomic) int               currentIndex;
//当前分组下的名片总数
@property (assign, nonatomic) NSInteger         totalCount;

@end

@implementation KHHRadarViewController
//@synthesize dataCtrl;
@synthesize valueItems;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //先隐藏
//        self.rightBtn.hidden = YES;
       [self.rightBtn setTitle:@"所有" forState:UIControlStateNormal];
     //   self.dataCtrl = [KHHData sharedData];
        self.title = @"关系拓展";
    }
    return self;
}
- (void)rightBarButtonClick:(id)sender{
    //show 选择分组的alert
    [[KHHFilterPopup shareUtil] showPopUpGroup:_currentIndex delegate:self];
}

//刷新title的右边按钮文字及重绘饼图
-(void) refreshButtonAndChart:(Group *) group
{
    _currentGroup = group;
    //更新按钮名称
    if (group) {
        [self.rightBtn setTitle:_currentGroup.name forState:UIControlStateNormal];
    }else{
        [self.rightBtn setTitle:@"所有" forState:UIControlStateNormal];
    }
    
    //根据分组刷新相应数据
    //重新获取数据
    [self getDataForCircle:_currentGroup];
    //重绘界面
    [self drawCircle];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view setBackgroundColor:[UIColor colorWithRed:241 green:238 blue:232 alpha:1.0]];
    [self.btn1 setBackgroundColor:PCColorYellow];
    [self.btn2 setBackgroundColor:PCColorGreen];
    [self.btn3 setBackgroundColor:PCColorOrange];
    [self.btn4 setBackgroundColor:PCColorRed];
    [self.btn5 setBackgroundColor:PCColorBlue];
    //显示数据
    [self refreshButtonAndChart:nil];
    
    //iphone 5 适配
    [KHHViewAdapterUtil checkIsNeedMoveHalfDownForIphone5:_btn1];
    [KHHViewAdapterUtil checkIsNeedMoveHalfDownForIphone5:_btn2];
    [KHHViewAdapterUtil checkIsNeedMoveHalfDownForIphone5:_btn3];
    [KHHViewAdapterUtil checkIsNeedMoveHalfDownForIphone5:_btn4];
    [KHHViewAdapterUtil checkIsNeedMoveHalfDownForIphone5:_btn5];
    [KHHViewAdapterUtil checkIsNeedMoveHalfDownForIphone5:_btnLatent];
    [KHHViewAdapterUtil checkIsNeedMoveHalfDownForIphone5:_btnLackExpand];
    [KHHViewAdapterUtil checkIsNeedMoveHalfDownForIphone5:_btnNormal];
    [KHHViewAdapterUtil checkIsNeedMoveHalfDownForIphone5:_btnBetter];
    [KHHViewAdapterUtil checkIsNeedMoveHalfDownForIphone5:_btnIntimate];
}

-(void) viewWillAppear:(BOOL)animated {
    if (_isNeedReloadTable) {
        _isNeedReloadTable = NO;
        //刷新当前组
        [self refreshButtonAndChart:_currentGroup];
    }
}

//获取数据
- (void)getDataForCircle:(Group *)group{
    //查询所有
    //        [self.dataCtrl cardsOfstartsForRelation:-1]
    _totalCount = 0;
    valueItems = [[NSMutableArray alloc] initWithCapacity:0];
    long groupID = -1;
    if (group) {
        groupID = group.id.longValue;
    }
    
    //根据分组查该分组下的relation分布
    //查询某值下的数据
    NSArray *arr1 = [[KHHDataNew sharedData] cardsOfstartsForRelation:1.0 groupID:groupID];
    NSArray *arr2 = [[KHHDataNew sharedData] cardsOfstartsForRelation:2.0 groupID:groupID];
    NSArray *arr3 = [[KHHDataNew sharedData] cardsOfstartsForRelation:3.0 groupID:groupID];
    NSArray *arr4 = [[KHHDataNew sharedData] cardsOfstartsForRelation:4.0 groupID:groupID];
    NSArray *arr5 = [[KHHDataNew sharedData] cardsOfstartsForRelation:5.0 groupID:groupID];
    //记录下所有名片的个数
    _totalCount = arr1.count + arr2.count + arr3.count + arr4.count + arr5.count;
    [valueItems addObject:arr1];
    [valueItems addObject:arr2];
    [valueItems addObject:arr3];
    [valueItems addObject:arr4];
    [valueItems addObject:arr5];
}

//画第三方的饼图
- (void)drawCircle{
    //更新chart
    PCPieChart *pieChart = (PCPieChart *)[self.view viewWithTag:KHH_PCPieChart_Tag];
    if (pieChart) {
        //从父layout中移除
        [pieChart removeFromSuperview];
        pieChart = nil;
    }
    
    //每次有更发时都重新创建，第三方的图没有提供刷新的功能
    int height = [self.view bounds].size.width/3*2.; // 220;
    int width = [self.view bounds].size.width; //320;
    pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(([self.view bounds].size.width-width)/2,([self.view bounds].size.height-height)/2-80,width,height+80)];
    [pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [pieChart setDiameter:width/2];
    [pieChart setSameColorLabel:YES];
    pieChart.tag = KHH_PCPieChart_Tag;
    [self.view addSubview:pieChart];
    
    //-1查所有的
    if (0 == _totalCount) {
        pieChart.hidden = YES;
        return;
    }else{
        pieChart.hidden = NO;
    }
    NSArray *titlesArr = [[NSArray alloc] initWithObjects:@"潜在关系",@"待拓展关系",@"一般关系",@"较好关系",@"密切关系", nil];
    
    NSMutableArray *components = [NSMutableArray array];
    for (int i=0; i< titlesArr.count; i++)
    {
        PCPieComponent *component = [PCPieComponent pieComponentWithTitle:[titlesArr objectAtIndex:i ] value:[[valueItems objectAtIndex:i] count]];
        [components addObject:component];
        if (i==0) //潜在关系 1星
        {
            [component setColour:PCColorYellow];
        }
        else if (i==1) //待拓展关系 2星
        {
            [component setColour:PCColorGreen];
        }
        else if (i==2) //一般关系 3 星
        {
            [component setColour:PCColorOrange];
        }
        else if (i==3) //较好关系 4星
        {
            [component setColour:PCColorRed];
        }
        else if (i==4) //密切关系 5星
        {
            [component setColour:PCColorBlue];
        }
    }
    [pieChart setComponents:components];
    //做一下iphone5 适配
    [KHHViewAdapterUtil checkIsNeedMoveDownForIphone5:pieChart height:30];
}

- (IBAction)btnClick:(UIButton *)sender{
    _isNeedReloadTable = YES;
    KHHValueViewController *valVC = [[KHHValueViewController alloc] initWithNibName:nil bundle:nil];
    switch (sender.tag) {
        case 220:
        case 221:
            valVC.generArr = [self.valueItems objectAtIndex:0];
            valVC.value = 1;
            break;
        case 222:
        case 223:
            valVC.generArr = [self.valueItems objectAtIndex:1];
            valVC.value = 2;
            break;
        case 224:
        case 225:
            valVC.generArr = [self.valueItems objectAtIndex:2];
            valVC.value = 3;
            break;
        case 226:
        case 227:
            valVC.generArr = [self.valueItems objectAtIndex:3];
            valVC.value = 4;
            break;
        case 228:
        case 229:
            valVC.generArr = [self.valueItems objectAtIndex:4];
            valVC.value = 5;
            break;
        default:
            break;
    }
    
    //把当前分组的id传过去
    if (_currentGroup) {
        valVC.groupID = _currentGroup.id.longValue;
    } else {
        valVC.groupID = -1;
    }
    
    //指明界面的类型
    valVC.valueType = KHHCustomerVauleRadar;
    [self.navigationController pushViewController:valVC animated:YES];

}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.valueItems = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma 分组alert delegate
- (void)selectInAlert:(id) obj
{
    //从传回的字典中获取相应的数据
    Group *grp = nil;
    if (!obj) {
        _currentIndex = 0;
    }else {
        NSDictionary *dic = (NSDictionary *)obj;
        _currentIndex = [[dic objectForKey:@"groupIndex"] intValue];
        grp = (Group *)[dic objectForKey:@"obj"];
    }
    
    //如果group为空 就说明选择的是所有
    [self refreshButtonAndChart:grp];
}
@end
