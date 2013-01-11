//
//  Edit_eCardViewController.h
//  CardBook
//
//  Created by 王国辉 on 12-8-14.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//
typedef enum {
  KCardViewControllerTypeNewCreate,
  KCardViewControllerTypeShowInfo
}KCardViewControllerType;

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "Card.h"
#import "KHHClasses.h"
#import "NetClient+PrivateCard.h"
#import "HZAreaPickerView.h"
#import "KHHInputTableView.h"


@interface Edit_eCardViewController : SuperViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,delegateNewPrivateForEdit,KHHInputTableViewHiddenDelegate>
@property (strong, nonatomic) IBOutlet KHHInputTableView *table;
@property (strong, nonatomic)  NSArray              *fieldName;
@property (strong, nonatomic)  NSMutableArray       *fieldValue;
@property (strong, nonatomic)  NSMutableArray       *fieldExternOne;
@property (strong, nonatomic)  NSMutableArray       *fieldExternTwo;
@property (strong, nonatomic)  NSMutableArray       *fieldExternThree;
@property (assign, nonatomic)  NSInteger            oneNums;
@property (assign, nonatomic)  NSInteger            twoNums;
@property (assign, nonatomic)  NSInteger            threeNums;
@property (strong, nonatomic) IBOutlet UIPickerView *pickView;
@property (assign, nonatomic)  NSInteger            whichexternIndex;
@property (strong, nonatomic)  UIScrollView         *scroller;
@property (strong, nonatomic)  UIPageControl        *pageCtrl;
@property (strong, nonatomic)  NSMutableDictionary  *fieldValueDic;
@property (strong, nonatomic)  UILabel              *editLab;
@property (strong, nonatomic)  Card                 *glCard;
@property (assign, nonatomic)  KCardViewControllerType type;
@property (strong, nonatomic)  CardTemplate         *cardTemp;

@property (nonatomic,strong) HZAreaPickerView *areaPicker;

@end
