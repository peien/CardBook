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
#import "KHHData+UI.h"

static NSInteger const KHH_PCPieChart_Tag = 1000;

@interface KHHRadarViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (strong, nonatomic) KHHData *dataCtrl;
@property (strong, nonatomic) NSMutableArray    *valueItems;
@property (strong, nonatomic) NSArray           *titleArr;
@property (assign, nonatomic) BOOL              isNeedReloadTable;
@property (strong, nonatomic) Group             *currentGroup;
//当前分组下的名片总数
@property (assign, nonatomic) NSInteger         totalCount;

@end

@implementation KHHRadarViewController
@synthesize dataCtrl;
@synthesize valueItems;
@synthesize titleArr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //先隐藏
        self.rightBtn.hidden = YES;
       [self.rightBtn setTitle:@"所有" forState:UIControlStateNormal];
        self.dataCtrl = [KHHData sharedData];
        self.title = @"关系拓展";
        self.titleArr = [self.dataCtrl allTopLevelGroups];
        //默认指到所有
#warning 给currentGroup设置个默认的
    }
    return self;
}
- (void)rightBarButtonClick:(id)sender{
    UIPickerView *pick = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 500, 320, 216)];
    pick.showsSelectionIndicator = YES;
    pick.delegate = self;
    pick.dataSource = self;
    [self.view addSubview:pick];
    //[self pickAnimationUp:pick];
    //NSArray *arr1 = [self.dataCtrl cardsofStartsValue:1.0 from:[self.titleArr objectAtIndex:0]];
    //DLog(@"arr1 ====== %@",arr1);
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.titleArr.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    Group *group = [self.titleArr objectAtIndex:row];
    return group.name;

}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [self pickAnimationDown:pickerView];
    _currentGroup = [self.titleArr objectAtIndex:row];
    [self.rightBtn setTitle:_currentGroup.name forState:UIControlStateNormal];
    //根据分组刷新相应数据
}
- (void)pickAnimationUp:(UIPickerView *)pick{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect rect = pick.frame;
    rect.origin.y = 200;
    pick.frame = rect;
    [UIView commitAnimations];

}
- (void)pickAnimationDown:(UIPickerView *)pick{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    CGRect rect = pick.frame;
    rect.origin.y = 500;
    pick.frame = rect;
    [UIView commitAnimations];
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
    [self getDataForCircle:nil];
    [self drawCircle];
}

-(void) viewWillAppear:(BOOL)animated {
    if (_isNeedReloadTable) {
        _isNeedReloadTable = NO;
        //重新获取数据
        [self getDataForCircle:_currentGroup];
        //重绘界面
        [self drawCircle];
    }
}

- (void)getDataForCircle:(Group *)group{
    _totalCount = 0;
    valueItems = [[NSMutableArray alloc] initWithCapacity:0];
    if (group == nil) {
        //查询所有
//        [self.dataCtrl cardsOfstartsForRelation:-1]
        //查询某值下的数据
        NSArray *arr1 = [self.dataCtrl cardsOfstartsForRelation:1.0];
        NSArray *arr2 = [self.dataCtrl cardsOfstartsForRelation:2.0];
        NSArray *arr3 = [self.dataCtrl cardsOfstartsForRelation:3.0];
        NSArray *arr4 = [self.dataCtrl cardsOfstartsForRelation:4.0];
        NSArray *arr5 = [self.dataCtrl cardsOfstartsForRelation:5.0];
        //记录下所有名片的个数
        _totalCount = arr1.count + arr2.count + arr3.count + arr4.count + arr5.count;
        [valueItems addObject:arr1];
        [valueItems addObject:arr2];
        [valueItems addObject:arr3];
        [valueItems addObject:arr4];
        [valueItems addObject:arr5];
    }else{
        //根据分组查该分组下的relation分布
    }
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

@end
