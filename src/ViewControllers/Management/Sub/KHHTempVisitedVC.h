//
//  KHHTempVisitedVC.h
//  CardBook
//
//  Created by 王国辉 on 12-11-14.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "KHHClasses.h"
typedef enum
{
    KVisitRecoardVCStyleNewBuild1,
    KVisitRecoardVCStyleShowInfo1
    
}KVisitRecoardVCStyle1;

@interface KHHTempVisitedVC : SuperViewController
@property (weak, nonatomic) IBOutlet UITableView  *theTable;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *pick;
@property (assign, nonatomic) KVisitRecoardVCStyle1  style;
@property (strong, nonatomic) Schedule              *schedu;
@property (assign, nonatomic) bool                  isFromCalVC;
@property (assign, nonatomic) bool                  isFinishTask; //是否需要签到，时间不可以编辑
@property (assign, nonatomic) bool                  isNeedWarn;
@property (assign, nonatomic) bool                  isAddress;
@property (assign, nonatomic) bool                  isHaveImage;
@property (assign, nonatomic) bool                  isWarnBtnClick;
@property (assign, nonatomic) int                   index;
@property (strong, nonatomic) NSString              *dateStr;
@property (strong, nonatomic) NSString              *timeStr;
@property (strong, nonatomic) NSDate                *selectedDateFromCal;
@property (strong, nonatomic) Card                  *visitInfoCard;
@property (strong, nonatomic) NSArray               *noteArray;
@property (strong, nonatomic) NSArray               *tempPickArr;

@end
