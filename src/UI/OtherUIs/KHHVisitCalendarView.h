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

@interface KHHVisitCalendarView : UIView<UITableViewDataSource,UITableViewDelegate,KHHVisitCalendarCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView     *theTable;
@property (strong, nonatomic) IBOutlet UIView          *footView;
@property (strong, nonatomic) UIViewController         *viewCtrl;
@property (strong, nonatomic) NSMutableArray           *imgArr;
@property (strong, nonatomic) UIImageView              *imgview;

- (IBAction)VisitCalendarBtnClick:(id)sender;
@end
