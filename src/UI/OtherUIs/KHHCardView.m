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
#import "KHHClasses.h"
#import "KHHDataAPI.h"
#import "KHHNotifications.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "KHHAddressBook.h"
#import "KHHAppDelegate.h"
#import "KHHDefaults.h"
#import <QuartzCore/QuartzCore.h>

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
@synthesize itemArray;
@synthesize dataCtrl;
@synthesize progressHud;
@synthesize cardView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //[self initView];
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
    self.dataCtrl = [KHHData sharedData];
    self.backgroundColor = [UIColor colorWithRed:241 green:238 blue:232 alpha:1.0];
    self.cardView = [[KHHFrameCardView alloc] initWithFrame:CGRectMake(0, 0, 320, 225) delegate:self.detailVC isVer:NO callbackAction:nil];
    self.cardView.card = self.myCard;
    [self.cardView showView];
    _theTable.tableHeaderView = self.cardView;
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 165.0f)];
    footView.backgroundColor = [UIColor clearColor];
    UIButton *btnFooter = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnFooter setBackgroundImage:[[UIImage imageNamed:@"tongbu_normal.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)] forState:UIControlStateNormal];
    btnFooter.frame = CGRectMake(60.0f, 5.0f, 200, 37);
    [btnFooter setTitle:KHHMessageAddContactToLocal forState:UIControlStateNormal];
    btnFooter.titleLabel.font = [UIFont systemFontOfSize:15];
    [btnFooter setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnFooter addTarget:self action:@selector(saveToContactBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:btnFooter];
    
    //是同事、我的名片的时候不添加
    KHHDefaults *khhDefault = [KHHDefaults sharedDefaults];
    NSNumber *companyID = [khhDefault currentCompanyID];
    if (self.myCard.company && self.myCard.company.id.longValue == companyID.longValue && companyID.longValue > 0) {
        self.isColleague = YES;
    }
    
    if (!([self.myCard isKindOfClass:[MyCard class]] || self.isColleague)) {
        UIButton *btnFooterDel = [UIButton buttonWithType:UIButtonTypeCustom];
        btnFooterDel.frame = CGRectMake(60.0f, 55.0f, 200, 37);
        [btnFooterDel setTitle:@"删除名片" forState:UIControlStateNormal];
        [btnFooterDel setBackgroundImage:[[UIImage imageNamed:@"tongbu_normal.png"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 10, 0, 10)] forState:UIControlStateNormal];
        btnFooterDel.titleLabel.font = [UIFont systemFontOfSize:15];
        [btnFooterDel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnFooterDel addTarget:self action:@selector(delCardBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:btnFooterDel];
    }
    _theTable.tableFooterView = footView;
}
//初始化界面数据
- (void)initViewData
{
    self.itemArray = [[NSMutableArray alloc] initWithCapacity:0];
    if (_myCard.mobilePhone.length > 0) {
        NSArray *phoneArr = [_myCard.mobilePhone componentsSeparatedByString:KHH_SEPARATOR];
        [self.itemArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[phoneArr objectAtIndex:0],@"value",@"手机",@"key", nil]];
    }
    if (_myCard.telephone.length > 0) {
        NSArray *telArr = [_myCard.telephone componentsSeparatedByString:KHH_SEPARATOR];
        [self.itemArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[telArr objectAtIndex:0],@"value",@"电话",@"key", nil]];
    }
    if (_myCard.fax.length > 0) {
        NSArray *faxArr = [_myCard.fax componentsSeparatedByString:KHH_SEPARATOR];
        [self.itemArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[faxArr objectAtIndex:0],@"value",@"传真",@"key", nil]];
    }
    if (_myCard.email.length > 0) {
        NSArray *faxArr = [_myCard.email componentsSeparatedByString:KHH_SEPARATOR];
        [self.itemArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:[faxArr objectAtIndex:0],@"value",@"邮箱",@"key", nil]];
    }
    if (_myCard.company.name.length > 0) {
        [self.itemArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:_myCard.company.name,@"value",@"公司",@"key", nil]];
    }
    if (_myCard.address.province.length > 0 || _myCard.address.city.length > 0 || _myCard.address.other.length > 0) {
        NSString *address = [NSString stringWithFormat:@"%@%@%@",_myCard.address.province,_myCard.address.city,_myCard.address.other];
        [self.itemArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:address,@"value",@"地址",@"key", nil]];
    }
    if (_myCard.address.zip.length > 0) {
        [self.itemArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:_myCard.address.zip,@"value",@"邮编",@"key", nil]];
    }
    if (_myCard.department.length > 0) {
        [self.itemArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:_myCard.department,@"value",@"邮编",@"key", nil]];
    }
    if (_myCard.company.email.length > 0) {
        [self.itemArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:_myCard.company.email,@"value",@"公司邮箱",@"key", nil]];
    }
    if (_myCard.web.length > 0) {
        [self.itemArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:_myCard.web,@"value",@"网页",@"key", nil]];
    }
    if (_myCard.qq.length > 0) {
        [self.itemArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:_myCard.qq,@"value",@"QQ",@"key", nil]];
    }
    if (_myCard.msn.length > 0) {
        [self.itemArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:_myCard.msn,@"value",@"MSN",@"key", nil]];
    }
    if (_myCard.aliWangWang.length > 0) {
        [self.itemArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:_myCard.aliWangWang,@"value",@"旺旺",@"key", nil]];
    }
    if (_myCard.businessScope.length > 0) {
        [self.itemArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:_myCard.businessScope,@"value",@"业务范围",@"key", nil]];
    }

}
// 刷新表
- (void)reloadTable{
    if ([_myCard isKindOfClass:[PrivateCard class]]) {
        Card *card = [self.dataCtrl privateCardByID:_myCard.id];
        self.cardView.card = card;  
        self.myCard = card;
        self.detailVC.card = card;
    }else if ([_myCard isKindOfClass:[MyCard class]]){
        Card *card = [self.dataCtrl myCardByID:_myCard.id];
        self.cardView.card = card;
        self.myCard = card;
    }
    [self initViewData];
    [_theTable reloadData];
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
    return 3;
    
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
            return 1;
            break;
        case 2:
            return [self.itemArray count];
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
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 11.0f, 60.0f, 15.0f)];
        label.textAlignment = UITextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:14];
        label.numberOfLines = 0;
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.contentMode = UIViewContentModeScaleAspectFit;
//        label.textAlignment = UITextAlignmentCenter;
        label.tag = LABEL_CELL_TAG;
        [cell.contentView addSubview:label];
        UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(80.0f, 10.0f, 200.0f, 40.0f)];
        textfield.tag = TEXTFIELD_CELL_TAG;
        textfield.enabled = NO;
        textfield.textAlignment = UITextAlignmentLeft;
        textfield.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:textfield];
    }
    UILabel *lab = (UILabel *)[cell.contentView viewWithTag:LABEL_CELL_TAG];
    [lab setBackgroundColor:[UIColor clearColor]];
    UITextField *tf = (UITextField *)[cell.contentView viewWithTag:TEXTFIELD_CELL_TAG];
    
    if (indexPath.section == 0) {
        UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(13, 5, 50, 50)];
        //iconImage.backgroundColor = [UIColor blackColor];
        [cell addSubview:iconImage];
        CALayer *l = [iconImage layer];
//        [iconImage setImageWithURL:[NSURL URLWithString:_myCard.logo.url] placeholderImage:[UIImage imageNamed:@"logopic.png"]];
        [iconImage setImageWithURL:[NSURL URLWithString:_myCard.logo.url]
                       placeholderImage:[UIImage imageNamed:@"logopic.png"]
                                success:^(UIImage *image, BOOL cached){
                                    
                                    if(!CGSizeEqualToSize(image.size, CGSizeZero)){                                        
                                        [l setMasksToBounds:YES];
                                        [l setCornerRadius:6.0];
                                    }
                                }
                                failure:^(NSError *error){
                                    
                                }];
        CGRect rectLab = lab.frame;
        rectLab.origin.x = 65;
        lab.frame = rectLab;
        CGRect rectTf = tf.frame;
        rectTf.origin.y = 30;
        rectTf.origin.x = 69;
        tf.frame = rectTf;
        lab.text = _myCard.name;
        tf.text = _myCard.title;
        
    }else if (indexPath.section == 1){
        lab.text = @"分组";
        //首先默认为未分组
        tf.text = KHHMessageDefaultGroupUnGroup;
        if (self.isColleague) {
            tf.text = KHHMessageDefaultGroupColleague;
        }else {
            //获取该名片所在的所有分组名
            NSString * groupNames = [self cardGroupNames];
            if (groupNames) {
                tf.text = groupNames;
            }
        }
        
        //如果是同事就要发成同事
        
        
    }else if (indexPath.section == 2){
        lab.text = [[self.itemArray objectAtIndex:indexPath.row] objectForKey:@"key"];
        tf.text = [[self.itemArray objectAtIndex:indexPath.row] objectForKey:@"value"];
    }
    return cell;
}

//获取当前card所在的所有分组名，多个时用","分开
-(NSString *) cardGroupNames {
    if (!_myCard || !_myCard.groups || _myCard.groups.count <= 0) {
        return nil;
    }
    @try {
        NSSet *groups = _myCard.groups;
        NSEnumerator *enumerator = [groups objectEnumerator];
        NSMutableString *groupNames = [[NSMutableString alloc] initWithCapacity:0];
        NSObject* obj = enumerator.nextObject;
        while (obj) {
            Group * group = (Group *) obj;
            if (group) {
                //多个分组用"," 隔开
                if (groupNames.length > 0) {
                    [groupNames appendString:KHH_COMMA];
                }
                
                [groupNames appendString:group.name];
            }
            obj = enumerator.nextObject;
        }
        
        //如果分组名不为空时显示分组名
        if (groupNames.length > 0) {
            return groupNames;
        }
    }
    @catch (NSException *exception) {
        DLog(@"KKCardView.m get groups failed! error is %@",exception);
    }
    @finally {
        
    }
    return nil;
}

//添加card到通讯录
- (void)saveToContactBtnClick:(id)sender
{
    NSString *message = nil;
    if ([KHHAddressBook saveToCantactWithCard:_myCard]) {
        message = [NSString stringWithFormat:@"%@%@",KHHMessageAddContactToLocal, KHHMessageSucceed];
    }else {
        message = [NSString stringWithFormat:@"%@%@",KHHMessageAddContactToLocal, KHHMessageFailed];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:KHHMessageAddContactToLocal
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:KHHMessageSure
                                          otherButtonTitles:nil, nil];
    [alert show];
}

- (void)delCardBtnClick:(id)sender
{
    //注册删除卡片的消息
    [self observeNotificationName:KHHUIDeleteCardSucceeded selector:@"handleDeleteCardSucceeded:"];
    [self observeNotificationName:KHHUIDeleteCardFailed selector:@"handleDeleteCardFailed"];
    //KHHAppDelegate *app = (KHHAppDelegate *)[UIApplication sharedApplication].delegate;
    self.progressHud = [MBProgressHUD showHUDAddedTo:self.detailVC.view animated:YES];
    self.progressHud.labelText = KhhMessageDeleteContact;
    if ([self.myCard isKindOfClass:[PrivateCard class]]) {
        [self.dataCtrl deletePrivateCardByID:self.myCard.id];
    }else if ([self.myCard isKindOfClass:[ReceivedCard class]]){
        [self.dataCtrl deleteReceivedCard:(ReceivedCard *)self.myCard];
    }
}
#pragma mark - 
- (void)handleDeleteCardSucceeded:(NSNotification *)info{
    DLog(@"DeleteCardSucceeded:");
    [self stopObservingNotificationName:KHHUIDeleteCardSucceeded];
    [self stopObservingNotificationName:KHHUIDeleteCardFailed];
    [self.progressHud hide:YES];
    [self.detailVC.navigationController popViewControllerAnimated:YES];
}
- (void)handleDeleteCardFailed:(NSNotification *)info{
    DLog(@"DeleteCardFailed:");
    self.progressHud.labelText = NSLocalizedString(@"删除失败", nil);
    [self.progressHud hide:YES];
    [self stopObservingNotificationName:KHHUIDeleteCardSucceeded];
    [self stopObservingNotificationName:KHHUIDeleteCardFailed];
}

@end
