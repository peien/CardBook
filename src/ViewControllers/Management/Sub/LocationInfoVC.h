//
//  LocationInfoVC.h
//  CardBook
//
//  Created by 王国辉 on 12-8-9.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"

@interface LocationInfoVC : SuperViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *theTable;
@property (assign, nonatomic) bool isGetLocationInfo;
@property (strong, nonatomic) NSMutableArray *imgArray;
@end
