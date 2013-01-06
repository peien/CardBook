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

@interface KHHPlanViewController : SuperViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,HZAreaPickerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,KHHInputTableViewHiddenDelegate>
{
    KHHInputTableView *table;
    
}
@property (nonatomic,strong)KHHDatePicker *datePicker;
@property (nonatomic,strong)HZAreaPickerView *areaPicker;
@property (nonatomic,strong)KHHMemoPicker *memoPicker;
@end
