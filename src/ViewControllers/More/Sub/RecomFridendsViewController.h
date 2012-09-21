//
//  RecomFridendsViewController.h
//  LoveCard
//
//  Created by gh w on 12-7-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import <MessageUI/MFMessageComposeViewController.h>
#import "SuperViewController.h"
@interface RecomFridendsViewController : SuperViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *theTable;
@property (strong, nonatomic) IBOutlet NSArray     *ItemArray;
@end
