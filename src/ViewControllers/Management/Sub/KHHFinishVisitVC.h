//
//  KHHFinishVisitVC.h
//  CardBook
//
//  Created by 王国辉 on 12-8-23.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KHHFinishVisitVC : UIViewController
@property (strong, nonatomic)  IBOutlet UITableView *theTable;
@property (strong, nonatomic)  NSMutableArray *secZeroArr;
@property (strong, nonatomic)  NSMutableArray *secOneArr;
@property (assign, nonatomic)  bool           isShowUpdateBtn;
@property (assign, nonatomic)  bool           isFinishVisit;
@end
