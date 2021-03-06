//
//  KHHFunnelViewController.m
//  CardBook
//
//  Created by 王国辉 on 12-8-22.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "KHHFunnelViewController.h"
#import "KHHValueViewController.h"
//#import "KHHData+UI.h"
#import "KHHClasses.h"
#import "KHHDataNew+Card.h"

@interface KHHFunnelViewController (){
    NSNumber *_groupId;
    int _groupIndex;
    NSString *_rightTitle;
    BOOL isNeedReloadTable;
}
@property (strong, nonatomic) KHHDataNew *dataCtrl;
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
        self.dataCtrl = [KHHDataNew sharedData];
    }
    return self;
}

- (void)rightBarButtonClick:(id)sender
{

	[[KHHFilterPopup shareUtil]  showPopUpGroup:_groupIndex delegate:self];
   
	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithRed:241 green:238 blue:232 alpha:1.0]];
    self.allDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [self refresh:nil];
}

-(void) viewWillAppear:(BOOL)animated {
    if (isNeedReloadTable) {
        isNeedReloadTable = NO;
        //刷新当前组
        [self refresh:_groupId];
    }
}

- (void)refresh:(NSNumber *)groupId{
    if (!groupId) {
        [self.rightBtn setTitle:@"所有" forState:UIControlStateNormal];
    }else{
        [self.rightBtn setTitle:_rightTitle forState:UIControlStateNormal];
    }
    
    NSArray *oneStarsArr = [[KHHDataNew sharedData] cardsofStarts:1.0 groupId:groupId];
    NSArray *twoStarsArr = [[KHHDataNew sharedData] cardsofStarts:2.0 groupId:groupId];
    NSArray *threeStarsArr = [[KHHDataNew sharedData] cardsofStarts:3.0 groupId:groupId];
    NSArray *fourStarsArr = [[KHHDataNew sharedData] cardsofStarts:4.0 groupId:groupId];
    NSArray *fiveStarsArr = [[KHHDataNew sharedData] cardsofStarts:5.0 groupId:groupId];
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
    isNeedReloadTable = YES;
    KHHValueViewController *valueVC = [[KHHValueViewController alloc] initWithNibName:nil bundle:nil];
    switch (sender.tag) {
        case 100:
            valueVC.generArr = [self.allDic objectForKey:@"oneStar"];
            valueVC.value = 1;
            break;
        case 101:
            valueVC.generArr = [self.allDic objectForKey:@"twoStar"];
            valueVC.value = 2;
            break;
        case 102:
            valueVC.generArr = [self.allDic objectForKey:@"threeStar"];
            valueVC.value = 3;
            break;
        case 103:
            valueVC.generArr = [self.allDic objectForKey:@"fourStar"];
            valueVC.value = 4;
            break;
        case 104:
            valueVC.generArr = [self.allDic objectForKey:@"fiveStar"];
            valueVC.value = 5;
            break;
        default:
            break;
    }
    
    //把当前分组的id传过去
    if (_groupId) {
        valueVC.groupID = _groupId.longValue;
    }else{
        valueVC.groupID = -1;
    }
    
    //指明界面的类型
    valueVC.valueType = KHHCustomerVauleFunnel;
    [self.navigationController pushViewController:valueVC animated:YES];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark KHHFilterPopup delegate
- (void)selectInAlert:(id)obj{
    
    if (!obj) {        
        _groupIndex = 0;
        if (!_groupId) {
            
            return;
        }
        _groupId = nil;
        [self refresh:nil];
        return;
    }
    
    NSDictionary *dic = (NSDictionary *)obj;
    _groupIndex = [[dic objectForKey:@"groupIndex"] intValue];
    Group *grp = (Group *)[dic objectForKey:@"obj"];
    if (!_groupId || _groupId != grp.id) {
        _groupId = grp.id;
        _rightTitle = grp.name;
        [self refresh:_groupId];
        
    } 
   
}

@end
