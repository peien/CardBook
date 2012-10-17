//
//  KHHAddGroupMemberVC.h
//  CardBook
//
//  Created by 王国辉 on 12-8-21.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "KHHHomeViewController.h"
#import "Group.h"
@interface KHHAddGroupMemberVC : SuperViewController
@property (strong, nonatomic) UISearchDisplayController *searbarCtrl;
@property (strong, nonatomic) IBOutlet UITableView *theTableM;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (strong, nonatomic) IBOutlet UIButton *sureBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UILabel *numLab;
@property (assign, nonatomic)  bool            isAdd;
@property (strong, nonatomic) NSMutableArray   *selectedItemArray;
@property (strong, nonatomic) NSMutableArray   *addOrDelGroupArray;
@property (strong, nonatomic) NSArray          *resultArray;
@property (strong, nonatomic) NSArray          *searchArray;
@property (strong, nonatomic) NSArray          *handleArray;
@property (strong, nonatomic) KHHHomeViewController *homeVC;
@property (strong, nonatomic) Group                 *group;

- (IBAction)sureBtnClick:(id)sender;
- (IBAction)cancelBtn:(id)sender;
@end
