//
//  KHHNewEdit_ecardViewController.h
//  CardBook
//
//  Created by CJK on 13-1-11.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHHInputTableView.h"


@interface KHHNewEdit_ecardViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,PickViewControllerDelegate>
@property (strong, nonatomic) KHHInputTableView *table;

@end
