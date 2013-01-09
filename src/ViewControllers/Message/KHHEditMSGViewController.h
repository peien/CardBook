//
//  KHHEditMSGViewController.h
//  CardBook
//
//  Created by 王国辉 on 12-9-14.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "MsgDelegates.h"

@interface KHHEditMSGViewController : SuperViewController<UITableViewDataSource,UITableViewDelegate,delegateMsgForRead>
@property (strong, nonatomic) IBOutlet UITableView *theTable;
@property (strong, nonatomic) NSArray              *messageArr;
@end
