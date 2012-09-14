//
//  Edit_eCardViewController.h
//  CardBook
//
//  Created by 王国辉 on 12-8-14.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
@interface Edit_eCardViewController : SuperViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *theTable;
@property (strong, nonatomic)  NSArray *fieldName;
@property (strong, nonatomic)  NSMutableArray *fieldValue;
@property (strong, nonatomic)  NSMutableArray  *fieldExternOne;
@property (strong, nonatomic)  NSMutableArray  *fieldExternTwo;
@property (strong, nonatomic)  NSMutableArray  *fieldExternThree;
@property (assign, nonatomic)  NSInteger       oneNums;
@property (assign, nonatomic)  NSInteger       twoNums;
@property (assign, nonatomic)  NSInteger       threeNums;
@property (strong, nonatomic) IBOutlet UIPickerView *pickView;
@property (assign, nonatomic)  NSInteger        whichexternIndex;
@property (strong, nonatomic)  UIScrollView     *scroller;
@property (strong, nonatomic)  UIPageControl    *pageCtrl;
@property (strong, nonatomic)  NSMutableDictionary *fieldValueDic;
@property (strong, nonatomic)  UILabel             *editLab;

@end
