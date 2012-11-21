//
//  KHHMessageViewController.h
//  CardBook
//
//  Created by 王国辉 on 12-8-20.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
@interface KHHMessageViewController : SuperViewController;
@property (strong, nonatomic) IBOutlet UITableView *theTable;

- (IBAction)editMessageBtnClick:(id)sender;

@end
