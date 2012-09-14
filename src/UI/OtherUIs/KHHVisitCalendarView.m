//
//  KHHVisitCalendarView.m
//  CardBook
//
//  Created by 王国辉 on 12-8-24.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "KHHVisitCalendarView.h"
#import "KHHVisitCalendarCell.h"
#import "KHHCalendarViewController.h"
#import "KHHFinishVisitVC.h"
#import "KHHVisitRecoardVC.h"

@implementation KHHVisitCalendarView
@synthesize theTable = _theTable;
@synthesize footView = _footView;
@synthesize imgArr = _imgArr;
//@synthesize delegate = _delegate;
@synthesize viewCtrl = _viewCtrl;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 11;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    KHHVisitCalendarCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"KHHVisitCalendarCell" owner:self options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    if (indexPath.row%2 == 0) {
        cell.finishBtn.hidden = YES;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KHHVisitRecoardVC *visitVC = [[KHHVisitRecoardVC alloc] initWithNibName:nil bundle:nil];
    //有没有图片
    visitVC.style = KVisitRecoardVCStyleShowInfo;
    visitVC.isHaveImage = YES;
    visitVC.num = 1;
    [self.viewCtrl.navigationController pushViewController:visitVC animated:YES];
}

- (void)KHHVisitCalendarCellBtnClick:(NSInteger)tag
{
    if (tag == 222) {
        //铃铛提示
    }else if (tag == 223){
        //完成
        KHHVisitRecoardVC *finishVC = [[KHHVisitRecoardVC alloc] initWithNibName:nil bundle:nil];
        finishVC.isNeedWarn = NO;
        finishVC.isFinishTask = YES;
        finishVC.style = KVisitRecoardVCStyleShowInfo;
        [self.viewCtrl.navigationController pushViewController:finishVC animated:YES];
    }
}
- (IBAction)VisitCalendarBtnClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 333) {
        DLog(@"添加");
        KHHVisitRecoardVC *visitRVC = [[KHHVisitRecoardVC alloc] initWithNibName:nil bundle:nil];
        visitRVC.style = KVisitRecoardVCStyleNewBuild;
        visitRVC.isNeedWarn = YES;
        [self.viewCtrl.navigationController pushViewController:visitRVC animated:YES];
        
    }else if (btn.tag == 444){
        DLog(@"日历");
        KHHCalendarViewController *calendarVC = [[KHHCalendarViewController alloc] initWithNibName:nil bundle:nil];
        [self.viewCtrl.navigationController pushViewController:calendarVC animated:YES];
        
    }

}

@end
