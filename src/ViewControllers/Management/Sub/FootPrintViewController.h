//
//  FootPrintViewController.h
//  CardBook
//
//  Created by 王国辉 on 12-8-9.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"

@interface FootPrintViewController : SuperViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *theTable;
@end
