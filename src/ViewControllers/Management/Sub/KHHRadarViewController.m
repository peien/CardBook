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
@interface KHHRadarViewController ()
@property (strong, nonatomic) KHHData *dataCtrl;
@property (strong, nonatomic) NSMutableArray *valueItems;

@end

@implementation KHHRadarViewController
@synthesize dataCtrl;
@synthesize valueItems;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.rightBtn.hidden = YES;
        self.dataCtrl = [KHHData sharedData];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    NSString *sampleFile = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"sample_piechart_data.plist"];
//    NSDictionary *sampleInfo = [NSDictionary dictionaryWithContentsOfFile:sampleFile];
    [self.view setBackgroundColor:[UIColor colorWithRed:241 green:238 blue:232 alpha:1.0]];
    [self.btn1 setBackgroundColor:PCColorYellow];
    [self.btn2 setBackgroundColor:PCColorGreen];
    [self.btn3 setBackgroundColor:PCColorOrange];
    [self.btn4 setBackgroundColor:PCColorRed];
    [self.btn5 setBackgroundColor:PCColorBlue];
    int height = [self.view bounds].size.width/3*2.; // 220;
    int width = [self.view bounds].size.width; //320;
    PCPieChart *pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake(([self.view bounds].size.width-width)/2,([self.view bounds].size.height-height)/2-80,width,height+80)];
    [pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [pieChart setDiameter:width/2];
    [pieChart setSameColorLabel:YES];
    [self.view addSubview:pieChart];
    if ([[self.dataCtrl cardsOfstartsForRelation:-1] count] == 0) {
        pieChart.hidden = YES;
        return;
    }else{
        pieChart.hidden = NO;
    }
    NSArray *titlesArr = [[NSArray alloc] initWithObjects:@"潜在关系",@"待拓展关系",@"一般关系",@"轻关系",@"重要关系", nil];
    valueItems = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *arr1 = [self.dataCtrl cardsOfstartsForRelation:1.0];
    NSArray *arr2 = [self.dataCtrl cardsOfstartsForRelation:2.0];
    NSArray *arr3 = [self.dataCtrl cardsOfstartsForRelation:3.0];
    NSArray *arr4 = [self.dataCtrl cardsOfstartsForRelation:4.0];
    NSArray *arr5 = [self.dataCtrl cardsOfstartsForRelation:5.0];
    [valueItems addObject:arr1];
    [valueItems addObject:arr2];
    [valueItems addObject:arr3];
    [valueItems addObject:arr4];
    [valueItems addObject:arr5];
    
    
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
        else if (i==3) //轻关系 4星
        {
            [component setColour:PCColorRed];
        }
        else if (i==4) //重要关系 5星
        {
            [component setColour:PCColorBlue];
        }
    }

    [pieChart setComponents:components];
}
- (IBAction)btnClick:(UIButton *)sender{
    KHHValueViewController *valVC = [[KHHValueViewController alloc] initWithNibName:nil bundle:nil];
    switch (sender.tag) {
        case 220:
            valVC.generArr = [self.valueItems objectAtIndex:0];
            break;
        case 221:
            valVC.generArr = [self.valueItems objectAtIndex:1];
            break;
        case 222:
            valVC.generArr = [self.valueItems objectAtIndex:2];
            break;
        case 223:
            valVC.generArr = [self.valueItems objectAtIndex:3];
            break;
        case 224:
            valVC.generArr = [self.valueItems objectAtIndex:4];
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
