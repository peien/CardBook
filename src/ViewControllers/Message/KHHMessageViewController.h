//
//  KHHMessageViewController.h
//  CardBook
//
//  Created by 王国辉 on 12-8-20.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
@interface KHHMessageViewController : SuperViewController<KHHDataMessageDelegate>;
@property (strong, nonatomic) IBOutlet UITableView *theTable;
@property (strong, nonatomic) IBOutlet UIButton *editBtn;
- (IBAction)editMessageBtnClick:(id)sender;

- (void) refreshTable;

@end
