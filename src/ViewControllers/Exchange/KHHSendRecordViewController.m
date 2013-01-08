//
//  KHHSendRecordViewController.m
//  CardBook
//
//  xib文件用KHHEditMSGViewController.xib
//  Created by 王定方 on 13-1-6.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "KHHSendRecordViewController.h"
#import "KHHSendRecordCell.h"

@interface KHHSendRecordViewController () <UITableViewDataSource,UITableViewDelegate>
{
    UITableView     *table;
    NSArray         *sendRecordArray;
}
@end

@implementation KHHSendRecordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(KHHMessageSendRecord, nil);
        self.rightBtn.hidden = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //添加tableview
    int height = 480 - 64;
    if (iPhone5) {
        height = 568 - 64;
    }
    CGRect frame = CGRectMake(0, 0, 320, height);
    table = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    table.autoresizesSubviews = YES;
    table.dataSource = self;
    table.delegate = self;
    self.view.autoresizesSubviews = YES;
    [self.view addSubview:table];
    table.contentMode = UIViewContentModeScaleToFill;
    self.view.contentMode = UIViewContentModeScaleToFill;
    //获取发送记录数据
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableViewDataSource function
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * cellID = NSStringFromClass([KHHSendRecordCell class]);
    KHHSendRecordCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = cell = [[[NSBundle mainBundle] loadNibNamed:cellID
                                                     owner:self
                                                   options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.backgroundColor = [UIColor clearColor];
    }
    
#warning 从sendRecordArray中获取index = indexPath.row的数据，填充到界面上去
//    [sendRecordArray objectAtIndex:indexPath.row];
    cell.name.text = @"张三";
    cell.sendTime.text = @"2012-12-12 16:43:51";
    
    return cell;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
//    return [sendRecordArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

@end
