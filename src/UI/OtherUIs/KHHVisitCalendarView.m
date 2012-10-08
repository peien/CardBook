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
#import "KHHFullFrameController.h"

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
    return 140;
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
    UIImage *imgBtn = [[UIImage imageNamed:@"tongbu_normal.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 8, 0, 8)];
    [cell.finishBtn setBackgroundImage:imgBtn forState:UIControlStateNormal];
    if (indexPath.row%2 == 0) {
        cell.finishBtn.hidden = YES;
    }
    for (int i = 0; i < 1; i++) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFullFrame:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        if (i == 0) {
            [cell.imgviewIco1 addGestureRecognizer:tap];
        }else if (i == 1){
            [cell.imgviewIco2 addGestureRecognizer:tap];
        }else if (i == 2){
            [cell.imgviewIco3 addGestureRecognizer:tap];
        }else if (i == 3){
            [cell.imgviewIco4 addGestureRecognizer:tap];
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KHHVisitRecoardVC *visitVC = [[KHHVisitRecoardVC alloc] initWithNibName:nil bundle:nil];
    //有没有图片
    visitVC.style = KVisitRecoardVCStyleShowInfo;
    visitVC.isHaveImage = YES;
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
        KHHVisitRecoardVC *visitRVC = [[KHHVisitRecoardVC alloc] initWithNibName:nil bundle:nil];
        visitRVC.style = KVisitRecoardVCStyleNewBuild;
        visitRVC.isNeedWarn = YES;
        [self.viewCtrl.navigationController pushViewController:visitRVC animated:YES];
        
    }else if (btn.tag == 444){
        
        KHHCalendarViewController *calendarVC = [[KHHCalendarViewController alloc] initWithNibName:nil bundle:nil];
        [self.viewCtrl.navigationController pushViewController:calendarVC animated:YES];
        
    }

}
- (void)tapFullFrame:(UITapGestureRecognizer *)sender
{
    self.imgview = (UIImageView *)[sender view];
    KHHFullFrameController *fullVC = [[KHHFullFrameController alloc] initWithNibName:nil bundle:nil];
    fullVC.image = self.imgview.image;
    [self.viewCtrl.navigationController pushViewController:fullVC animated:YES];
    
}

@end
