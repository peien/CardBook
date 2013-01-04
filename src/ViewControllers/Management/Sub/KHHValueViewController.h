//
//  KHHValueViewController.h
//  CardBook
//
//  Created by 王国辉 on 12-11-13.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "KHHTypes.h"

@interface KHHValueViewController : SuperViewController
@property (strong, nonatomic) IBOutlet UITableView          *theTable;
@property (strong, nonatomic) NSArray                       *generArr;
@property (assign, nonatomic) float                         value;
@property (assign, nonatomic) long                           groupID;
@property (assign, nonatomic) KHHCustomerVauleDetailType    valueType;
@property (strong, nonatomic) UISearchDisplayController     *searCtrl;

@end
