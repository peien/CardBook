//
//  EmployDetailInfoVC.h
//  CardBook
//
//  Created by 王国辉 on 12-8-13.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmployDetailInfoVC : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *theTable;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segCtrl;

- (IBAction)segmentCtrl_ValueChange:(id)sender;
@end
