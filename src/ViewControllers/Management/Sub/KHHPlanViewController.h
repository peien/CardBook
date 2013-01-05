//
//  KHHPlanViewController.h
//  CardBook
//
//  Created by CJK on 13-1-4.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "KHHDatePicker.h"
@interface KHHPlanViewController : SuperViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *table;
}
@property (nonatomic,strong)KHHDatePicker *datePicker;
@end
