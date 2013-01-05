//
//  KHHOrganizationViewController.h
//  CardBook
//
//  Created by 孙铭 on 8/6/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "KHHVisitRecoardVC.h"
@interface KHHOrganizationViewController : SuperViewController <UITableViewDelegate, UITableViewDataSource,
UINavigationControllerDelegate>
@property (nonatomic, strong) NSMutableArray            *btnTitleArr;
@property (nonatomic, strong) NSMutableDictionary       *dicBtnTttle;
@property (nonatomic, assign) NSInteger                 lastBtnTag;
@property (strong, nonatomic) IBOutlet UITableView      *btnTable;
@property (strong, nonatomic) IBOutlet UITableView      *bigTable;
@property (nonatomic, strong) NSMutableArray            *btnArray;
@property (assign, nonatomic) bool                      isShowData;
@property (strong, nonatomic) UIButton                  *currentBtn;
@property (strong, nonatomic) UISearchDisplayController *searCtrl;
@property (strong, nonatomic) NSIndexPath               *lastIndexPath;
@property (strong, nonatomic) UIView                    *btnBackbg;
@property (strong, nonatomic) NSMutableDictionary       *btnDic;
@property (strong, nonatomic) NSArray                   *generalArray;
@property (strong, nonatomic) NSArray                   *oWnGroupArray;
@property (strong, nonatomic) KHHVisitRecoardVC         *visitVC;

@end
