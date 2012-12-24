//
//  KHHVisitRecoardVC.h
//  tempPRO
//
//  Created by 王国辉 on 12-8-28.
//  Copyright (c) 2012年 ghWang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "KHHClasses.h"
typedef enum
{
    KVisitRecoardVCStyleNewBuild,
    KVisitRecoardVCStyleShowInfo

}KVisitRecoardVCStyle;
@interface KHHVisitRecoardVC : SuperViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView  *theTable;
@property (strong, nonatomic) NSArray               *noteArray;
@property (strong, nonatomic) UIDatePicker          *datePicker;
@property (strong, nonatomic) NSString              *dateStr;
@property (strong, nonatomic) NSString              *timeStr;
@property (assign, nonatomic) bool                  isShowDate;
@property (strong, nonatomic)  UIPickerView         *pick;
@property (strong, nonatomic) NSArray               *warnTitleArr;
@property (assign, nonatomic) KVisitRecoardVCStyle  style;
@property (assign, nonatomic) bool                  isFinishTask; //是否需要签到，时间不可以编辑
@property (assign, nonatomic) bool                  isNeedWarn;
@property (strong, nonatomic) NSArray               *tempPickArr;
@property (assign, nonatomic) bool                  isWarnBtnClick;
@property (assign, nonatomic) bool                  isAddress;
@property (assign, nonatomic) bool                  isHaveImage;
@property (strong, nonatomic) NSMutableArray        *fieldValue;
@property (strong, nonatomic) UILabel               *editLabel;
@property (strong, nonatomic) NSArray               *fieldName;
@property (assign, nonatomic) int                   index;
@property (strong, nonatomic) NSMutableArray        *imgArray;
@property (strong, nonatomic) NSArray               *timeArr;
@property (strong, nonatomic) UIImageView           *tapImgview;
@property (strong, nonatomic) NSMutableArray        *objectNameArr;
@property (strong, nonatomic) Card                  *visitInfoCard;
@property (strong, nonatomic) Schedule              *schedu;
@property (strong, nonatomic) NSDate                *selectedDateFromCal;
@property (assign, nonatomic) bool                  isFromCalVC;
@property (strong, nonatomic) Card                  *searchCard;
@property (assign, nonatomic) double                timeInterval;
//指定是来自哪个viewControlller
@property (weak  , nonatomic) UIViewController      *viewCtl;

- (void)datePickerValueChanged:(UIDatePicker *)sender;
@end
