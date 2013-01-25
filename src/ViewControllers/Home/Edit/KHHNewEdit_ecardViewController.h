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
#import "SuperViewController.h"
#import "MBProgressHUD.h"
#import "KHHDataNew+Card.h"

@interface KHHNewEdit_ecardViewController : SuperViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,HZAreaPickerDelegate,KHHDataCardDelegate>
@property (strong, nonatomic) KHHInputTableView *table;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (strong, nonatomic) void(^addCardSuccess)();

@property (strong, nonatomic) void(^updateCardSuccess)();

//for edit view
@property (strong, nonatomic) Card *toEditCard;
@end
