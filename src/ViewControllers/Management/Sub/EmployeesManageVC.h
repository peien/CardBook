//
//  EmployeesManageVC.h
//  CardBook
//
//  Created by 王国辉 on 12-8-10.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"

@interface EmployeesManageVC : SuperViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *theTable;

@end
