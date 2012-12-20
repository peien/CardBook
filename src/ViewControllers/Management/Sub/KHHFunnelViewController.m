//
//  KHHFunnelViewController.m
//  CardBook
//
//  Created by 王国辉 on 12-8-22.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "KHHFunnelViewController.h"
#import "KHHValueViewController.h"
#import "KHHData+UI.h"
#import "KHHClasses.h"

@interface KHHFunnelViewController (){
    int groupId;
}
@property (strong, nonatomic) KHHData *dataCtrl;
@property (strong, nonatomic) NSMutableDictionary *allDic;

@end

@implementation KHHFunnelViewController
@synthesize dataCtrl;
@synthesize allDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //先隐藏
        //self.rightBtn.hidden = YES;
        [self.rightBtn setTitle:@"所有" forState:UIControlStateNormal];
        self.title = @"价值漏斗";
        self.dataCtrl = [KHHData sharedData];
    }
    return self;
}

- (void)rightBarButtonClick:(id)sender
{

	[[KHHFilterPopup shareUtil]  showPopUpGroup:0 delegate:self];
   
	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithRed:241 green:238 blue:232 alpha:1.0]];
    self.allDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSArray *oneStarsArr = [self.dataCtrl cardsofStarts:1.0];
    NSArray *twoStarsArr = [self.dataCtrl cardsofStarts:2.0];
    NSArray *threeStarsArr = [self.dataCtrl cardsofStarts:3.0];
    NSArray *fourStarsArr = [self.dataCtrl cardsofStarts:4.0];
    NSArray *fiveStarsArr = [self.dataCtrl cardsofStarts:5.0];
    [self.allDic setObject:oneStarsArr forKey:@"oneStar"];
    [self.allDic setObject:twoStarsArr forKey:@"twoStar"];
    [self.allDic setObject:threeStarsArr forKey:@"threeStar"];
    [self.allDic setObject:fourStarsArr forKey:@"fourStar"];
    [self.allDic setObject:fiveStarsArr forKey:@"fiveStar"];
    self.lab1.text = [NSString stringWithFormat:@"%d",oneStarsArr.count];
    self.lab2.text = [NSString stringWithFormat:@"%d",twoStarsArr.count];
    self.lab3.text = [NSString stringWithFormat:@"%d",threeStarsArr.count];
    self.lab4.text = [NSString stringWithFormat:@"%d",fourStarsArr.count];
    self.lab5.text = [NSString stringWithFormat:@"%d",fiveStarsArr.count];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.dataCtrl = nil;
    self.lab1 = nil;
    self.lab2 = nil;
    self.lab3 = nil;
    self.lab4 = nil;
    self.lab5 = nil;
    self.allDic = nil;
}

- (IBAction)btnClick:(UIButton *)sender{
    DLog(@"btnClick!");
    KHHValueViewController *valueVC = [[KHHValueViewController alloc] initWithNibName:nil bundle:nil];
    switch (sender.tag) {
        case 100:
            valueVC.generArr = [self.allDic objectForKey:@"oneStar"];
            break;
        case 101:
            valueVC.generArr = [self.allDic objectForKey:@"twoStar"];
            break;
        case 102:
            valueVC.generArr = [self.allDic objectForKey:@"threeStar"];
            break;
        case 103:
            valueVC.generArr = [self.allDic objectForKey:@"fourStar"];
            break;
        case 104:
            valueVC.generArr = [self.allDic objectForKey:@"fiveStar"];
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:valueVC animated:YES];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark KHHFilterPopup delegate
- (void)selectInAlert:(NSString *)index {
    groupId = 
}

@end
