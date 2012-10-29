//
//  KHHCalendarViewController.h
//  CardBook
//
//  Created by 王国辉 on 12-8-22.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"

@interface KHHCalendarViewController : SuperViewController
@property (strong, nonatomic) IBOutlet UITableView *theTable;
@property (strong, nonatomic) IBOutlet UIButton    *addBtn;
- (IBAction)plusBtnClick:(id)sender;
@end
