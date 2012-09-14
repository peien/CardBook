//
//  KHHFinishVisitVC.m
//  CardBook
//
//  Created by 王国辉 on 12-8-23.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "KHHFinishVisitVC.h"
#import "KHHLabFieldCell.h"
#import "KHHAddImageView.h"
@interface KHHFinishVisitVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation KHHFinishVisitVC
@synthesize theTable = _theTable;
@synthesize secZeroArr = _secZeroArr;
@synthesize secOneArr = _secOneArr;
@synthesize isShowUpdateBtn = _isShowUpdateBtn;
@synthesize isFinishVisit = _isFinishVisit;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"完成拜访", nil);
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
    if (_isFinishVisit) {
        _secZeroArr = [[NSMutableArray alloc] initWithObjects:@"对象",@"时间",@"位置", nil];
    }else{
       _secZeroArr = [[NSMutableArray alloc] initWithObjects:@"时间",@"位置", nil];
    }
    _secOneArr = [[NSMutableArray alloc] initWithObjects:@"备注",@"陪同",nil];
    
    if (_isFinishVisit && !_isShowUpdateBtn) {
        self.title = NSLocalizedString(@"编辑详情", nil);
    }else if (_isFinishVisit && _isShowUpdateBtn){
        self.title = NSLocalizedString(@"完成拜访", nil);
    }else if (!_isFinishVisit){
        self.title = NSLocalizedString(@"编辑详情", nil);
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _theTable = nil;
    _secZeroArr = nil;
    _secOneArr = nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _secZeroArr.count;
    }else if (section == 1){
        return _secOneArr.count+1;
    }
    return 0;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 2 && _isShowUpdateBtn && _isFinishVisit) {
        return 80;
    }else if (indexPath.section == 1 && indexPath.row == 2){
        return 75;
    }
    
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    KHHLabFieldCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"KHHLabFieldCell" owner:self options:nil] objectAtIndex:0];
    }
    if (indexPath.section == 0) {
        cell.fieldName.text = [_secZeroArr objectAtIndex:indexPath.row];
        if (indexPath.row == 2 && _isShowUpdateBtn && _isFinishVisit) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = CGRectMake(60, 38, 200, 37);
            [btn setTitle:@"更新位置" forState:UIControlStateNormal];
            [cell addSubview:btn];
        }
    }else if (indexPath.section == 1 && indexPath.row <= 1){
        cell.fieldName.text = [_secOneArr objectAtIndex:indexPath.row ];

    }else if (indexPath.row == 2){
        //[cell.fieldName removeFromSuperview];
        [cell.fieldValue removeFromSuperview];
        if (_isFinishVisit && _isShowUpdateBtn) {
            cell.fieldName.text = @"添加图片";
            CGRect labRect = cell.fieldName.frame;
            labRect.origin.x = 60;
            cell.fieldName.frame = labRect;
            UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            addBtn.frame = CGRectMake(18, 10, 35, 35);
            [addBtn addTarget:self action:@selector(addBtnImageClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:addBtn];
        }else{
            cell.fieldName.text = @"图片添加";
            KHHAddImageView *btnImag = [[[NSBundle mainBundle] loadNibNamed:@"KHHAddImageView" owner:self options:nil] objectAtIndex:0];
            [btnImag.addImageBtn addTarget:self action:@selector(clickImageAdd:) forControlEvents:UIControlEventTouchUpInside];
            CGRect rect = btnImag.frame;
            rect.origin.x = 0;
            rect.origin.y = 2;
            btnImag.frame = rect;
            [cell.contentView addSubview:btnImag];
        }

    }
    return cell;

}

- (void)addBtnImageClick:(id)sender
{

}
- (void)clickImageAdd:(id)sender
{

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
