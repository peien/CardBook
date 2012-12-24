//
//  KHHCalendarViewController.h
//  CardBook
//
//  Created by 王国辉 on 12-8-22.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "KHHClasses.h"

@interface KHHCalendarViewController : SuperViewController
@property (strong, nonatomic) IBOutlet UITableView *theTable;
@property (strong, nonatomic) IBOutlet UIButton    *addBtn;
@property (strong, nonatomic) Card                 *card;
@property (assign, nonatomic) bool                 isneedReloadeVisitTable;
//拜访计划日期变化后的最新日期，返回后要定位到相应的日期
@property (strong, nonatomic) NSDate               *changedDate;
- (IBAction)plusBtnClick:(id)sender;
@end
