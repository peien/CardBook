//
//  KHHMessageViewController.m
//  CardBook
//
//  Created by 王国辉 on 12-8-20.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "KHHMessageViewController.h"
#import "KHHMessageCell.h"
#import "KHHShowHideTabBar.h"
#import "KHHDetailMessageVC.h"
#import "KHHEditMSGViewController.h"
@interface KHHMessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation KHHMessageViewController
@synthesize theTable = _theTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"消息";
        [self.leftBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [self.rightBtn setTitle:@"刷新" forState:UIControlStateNormal];
    }
    return self;
}
//刷新
- (void)rightBarButtonClick:(id)sender
{

}
//编辑
- (void)leftBarButtonClick:(id)sender
{
    KHHEditMSGViewController *editVC = [[KHHEditMSGViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:editVC animated:YES];
    

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _theTable.backgroundColor = [UIColor clearColor];
    [self.view setBackgroundColor:[UIColor colorWithRed:241 green:238 blue:232 alpha:1.0]];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [KHHShowHideTabBar showTabbar];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[KHHShowHideTabBar hideTabbar];
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _theTable = nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"CELLID";
    KHHMessageCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"KHHMessageCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];

}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    KHHDetailMessageVC *messageVC = [[KHHDetailMessageVC alloc] initWithNibName:@"KHHDetailMessageVC" bundle:nil];
    [self.navigationController pushViewController:messageVC animated:YES];

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
