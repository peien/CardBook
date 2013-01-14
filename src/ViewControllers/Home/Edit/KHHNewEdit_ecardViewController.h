//
//  KHHNewEdit_ecardViewController.h
//  CardBook
//
//  Created by CJK on 13-1-11.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHHInputTableView.h"
#import "HZAreaPickerView.h"

@interface KHHNewEdit_ecardViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,HZAreaPickerDelegate>
@property (strong, nonatomic) KHHInputTableView *table;

@end
