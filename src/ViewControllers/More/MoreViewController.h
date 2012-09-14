//
//  MoreViewController.h
//  LoveCard
//
//  Created by gh w on 12-7-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MoreViewController:UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *theTable;
@property (strong, nonatomic) IBOutlet UISwitch *autoLog;
@property (strong, nonatomic) IBOutlet UISwitch *autoReturn;
@property (strong, nonatomic) IBOutlet UILabel *updateStyle;
@property (strong, nonatomic) IBOutlet UILabel *defaultPage;
@property (strong, nonatomic) NSString         *titleStr;
@end
