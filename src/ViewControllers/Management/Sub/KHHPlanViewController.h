//
//  KHHPlanViewController.h
//  CardBook
//
//  Created by CJK on 13-1-4.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "KHHDatePicker.h"
#import "KHHDateUtil.h"
#import "HZAreaPickerView.h"
#import "KHHInputTableView.h"
#import "KHHMemoPicker.h"
#import "KHHMemoCell.h"
#import "KHHImageCell.h"
#import "KHHDataNew+SignForPlan.h"
#import "InterPlan.h"

typedef enum {
    plan =0,
    collect,
    sign,
} planCollectSign;

@interface KHHPlanViewController : SuperViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,HZAreaPickerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,KHHInputTableViewHiddenDelegate,KHHMemoCellDelegate,KHHImgViewInCellDelegate,KHHDataSignPlanDelegate>
{
    KHHInputTableView *table;
    
}
@property (nonatomic,strong)KHHDatePicker *datePicker;
@property (nonatomic,strong)HZAreaPickerView *areaPicker;
@property (nonatomic,strong)KHHMemoPicker *memoPicker;
@property (nonatomic,strong)KHHMemoPicker *remindPicker;


@property (nonatomic,strong)NSMutableDictionary *paramDic;


@property (nonatomic,strong)void(^uperSuccess)();

- (void)set_dicTempTarget:(Card *)card;

- (void)setTargetStr:(NSString *)target cardsArr:(NSArray *)cardsArrPro;

- (void)setSchedule:(Schedule *)schedulePro type:(planCollectSign)type;

@end
