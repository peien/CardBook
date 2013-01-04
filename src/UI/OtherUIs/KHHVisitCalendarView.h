//
//  KHHVisitCalendarView.h
//  CardBook
//
//  Created by 王国辉 on 12-8-24.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHHVisitCalendarCell.h"
#import "DetailInfoViewController.h"
#import "KHHClasses.h"

@interface KHHVisitCalendarView : UIView<UITableViewDataSource,UITableViewDelegate,KHHVisitCalendarCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView     *theTable;
@property (strong, nonatomic) IBOutlet UIView          *footView;
@property (strong, nonatomic) IBOutlet UIButton        *calBtn;
@property (strong, nonatomic) IBOutlet UIButton        *addBtn;
@property (strong, nonatomic) UIViewController         *viewCtrl;
@property (strong, nonatomic) NSMutableArray           *imgArr;
@property (strong, nonatomic) UIImageView              *imgview;
@property (strong, nonatomic) Card                     *card;
@property (strong, nonatomic) NSArray                  *dataArray;
@property (assign, nonatomic) bool                     isDetailVC;
@property (assign, nonatomic) KHHVisitPlanType         visitType;
@property (assign, nonatomic) bool                     isFromHomeVC;
@property (assign, nonatomic) bool                     isFromCalVC;
@property (strong, nonatomic) NSDate                   *selectedDate;

- (IBAction)VisitCalendarBtnClick:(id)sender;
- (void)initViewData;
- (void)reloadTheTable;
- (void)showTodayScheuds;

@end
