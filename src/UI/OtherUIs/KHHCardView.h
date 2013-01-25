//
//  KHHCardView.h
//  CardBook
//
//  Created by 王国辉 on 12-8-24.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "KHHData+UI.h"
#import "MyCard.h"
#import "Card.h"
#import "KHHMyDetailController.h"
#import "DetailInfoViewController.h"
//#import "KHHData+UI.h"
#import "MBProgressHUD.h"
#import "KHHFrameCardView.h"
#import "KHHDataNew+Card.h"

@class XLPageControl;

@interface KHHCardView : UIView<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,KHHDataCardDelegate>
@property (strong, nonatomic) IBOutlet UITableView *theTable;
@property (nonatomic, strong) UIView *card;
@property (strong, nonatomic) UIButton *saveToContactBtn;
@property (strong, nonatomic) UIButton *delContactBtn;
//@property (strong, nonatomic) KHHData *data;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) Card    *myCard;
@property (strong, nonatomic) KHHMyDetailController    *myDetailVC;
@property (strong, nonatomic) DetailInfoViewController *detailVC;
@property (strong, nonatomic) NSMutableArray           *itemArray;
//@property (strong, nonatomic) KHHData                  *dataCtrl;
@property (weak, nonatomic) IBOutlet UIButton *btnEditCard;
- (IBAction)btnEditCard:(id)sender;

@property (strong, nonatomic) KHHFrameCardView         *cardView;
@property (assign, nonatomic) BOOL                     isColleague;
- (void)initView;
- (void)initViewData;
- (void)reloadTable;
@end
