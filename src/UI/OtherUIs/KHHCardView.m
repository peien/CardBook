//
//  KHHCardView.m
//  CardBook
//
//  Created by 王国辉 on 12-8-24.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "KHHCardView.h"
#import "KHHClientCellLNP.h"
#import "XLPageControl.h"
#import "KHHFrameCardView.h"
#import "MyCard.h"
#import "Image.h"
#import "UIImageView+WebCache.h"
#import "KHHAddressBook.h"

#define CARD_IMGVIEW_TAG 333
#define CARDMOD_VIEW_TAG 444
#define LABEL_CELL_TAG 111
#define TEXTFIELD_CELL_TAG 222

@implementation KHHCardView
@synthesize theTable = _theTable;
@synthesize data = _data;
@synthesize dataArray = _dataArray;
@synthesize myCard = _myCard;
@synthesize detailVC;
@synthesize myDetailVC;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView];
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
- (void)initView
{
    self.backgroundColor = [UIColor colorWithRed:241 green:238 blue:232 alpha:1.0];
    KHHFrameCardView *cardView = [[KHHFrameCardView alloc] initWithFrame:CGRectMake(0, 0, 320, 225) isVer:NO];
    _theTable.tableHeaderView = cardView;
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 165.0f)];
    footView.backgroundColor = [UIColor clearColor];
    UIButton *btnFooter = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnFooter setBackgroundImage:[[UIImage imageNamed:@"tongbu_normal.png"]stretchableImageWithLeftCapWidth:11 topCapHeight:4] forState:UIControlStateNormal];
    btnFooter.frame = CGRectMake(60.0f, 5.0f, 200, 37);
    [btnFooter setTitle:@"保存至手机通讯录" forState:UIControlStateNormal];
    btnFooter.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnFooter setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnFooter addTarget:self action:@selector(saveToContactBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btnFooter];
    
    UIButton *btnFooterDel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnFooterDel.frame = CGRectMake(60.0f, 55.0f, 200, 37);
    [btnFooterDel setTitle:@"删除名片" forState:UIControlStateNormal];
    [btnFooterDel setBackgroundImage:[[UIImage imageNamed:@"tongbu_normal.png"]stretchableImageWithLeftCapWidth:11 topCapHeight:4] forState:UIControlStateNormal];
    btnFooterDel.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnFooterDel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnFooterDel addTarget:self action:@selector(delCardBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btnFooterDel];
    _theTable.tableFooterView = footView;
    
}
//初始化界面数据
- (void)initViewData
{
    self.data = [KHHData sharedData];
    self.dataArray = [self.data allMyCards];
    _myCard = [self.dataArray objectAtIndex:0];
    DLog(@"_myCard============%@",_myCard);
    self.detailVC.card = _myCard;
    self.myDetailVC.card = _myCard;
}
//跳转到全屏
- (void)gotoFullFrame:(id)sender
{

}
- (void)pageCtrlClick:(id)sender
{

}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 60;
    }
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 4;
            break;
        default:
            break;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 10.0f, 60.0f, 15.0f)];
        label.textAlignment = UITextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        label.numberOfLines = 0;
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.contentMode = UIViewContentModeScaleAspectFit;
        label.tag = LABEL_CELL_TAG;
        [cell.contentView addSubview:label];
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(80.0f, 7.0f, 200.0f, 40.0f)];
        textfield.tag = TEXTFIELD_CELL_TAG;
        textfield.enabled = NO;
        textfield.textAlignment = UITextAlignmentLeft;
        textfield.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:textfield];
    }
    UILabel *lab = (UILabel *)[cell.contentView viewWithTag:LABEL_CELL_TAG];
    [lab setBackgroundColor:[UIColor clearColor]];
    UITextField *tf = (UITextField *)[cell.contentView viewWithTag:TEXTFIELD_CELL_TAG];
    switch (indexPath.section) {
        case 1:
            switch (indexPath.row) {
                case 0:
                    lab.text = @"手机";
                    tf.text = _myCard.mobilePhone;
                    break;
                case 1:
                    lab.text = @"电话";
                    tf.text = _myCard.telephone;
                    break;
                 case 2:
                    lab.text = @"传真";
                    tf.text = _myCard.fax;
                    break;
                 case 3:
                    lab.text = @"邮箱";
                    tf.text = _myCard.email;
                    break;
                default:
                    break;
            }
            break;
         case 0:
            switch (indexPath.row) {
                case 0:{
                    //获取图片
                    [cell.imageView setImageWithURL:[NSURL URLWithString:_myCard.logo.url] placeholderImage:[UIImage imageNamed:@"logopic.png"]];
                    CGRect rectLab = lab.frame;
                    rectLab.origin.x = 50;
                    lab.frame = rectLab;
                    CGRect rectTf = tf.frame;
                    rectTf.origin.y = 30;
                    rectTf.origin.x = 69;
                    tf.frame = rectTf;
                    lab.text = _myCard.name;
                    tf.text = _myCard.title;
                }
                    break;
                    
                default:
                    break;
            }

        default:
            break;
    }
    return cell;
}
//添加card到通讯录
- (void)saveToContactBtnClick:(id)sender
{
    [KHHAddressBook saveToCantactWithCard:_myCard];
    
}

- (void)delCardBtnClick:(id)sender
{
#warning 现在不允许删除我自己的名片
//    [self.data deleteMyCardByID:_myCard.id];
}
#pragma mark - ScrollerDelegateMothed
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    if ([scrollView isEqual:_scroller]) {
//        CGFloat scrollWidth = scrollView.frame.size.width;
//        int page = ((scrollView.contentOffset.x-scrollWidth/2)/scrollWidth)+1;
//        XLPageControl *pageCtrl = (XLPageControl *)[self viewWithTag:118];
//        pageCtrl.currentPage = page;
//        
//    }
//}


@end
