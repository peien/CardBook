//
//  KHHVisitRecoardVC.h
//  tempPRO
//
//  Created by 王国辉 on 12-8-28.
//  Copyright (c) 2012年 ghWang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
typedef enum
{
    KVisitRecoardVCStyleNewBuild,
    KVisitRecoardVCStyleShowInfo,
    KVisitRecoardVCStyleFinishTask

}KVisitRecoardVCStyle;
@interface KHHVisitRecoardVC : SuperViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView  *theTable;
@property (strong, nonatomic) NSArray               *noteArray;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) NSString              *dateStr;
@property (strong, nonatomic) NSString              *timeStr;
@property (assign, nonatomic) bool                  isShowDate;
@property (strong, nonatomic) IBOutlet UIPickerView *pick;
@property (strong, nonatomic) NSArray               *warnTitleArr;
@property (assign, nonatomic) KVisitRecoardVCStyle  style;
@property (assign, nonatomic) bool                  isFinishTask;
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
@property (strong, nonatomic) NSArray               *objectNameArr;

@end
