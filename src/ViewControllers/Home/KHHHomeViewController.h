//
//  KHHHomeViewController.h
//  CardBook
//
//  Created by 孙铭 on 8/6/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "KHHVisitRecoardVC.h"
typedef enum {
    KUIActionSheetStylePhone,
    KUIActionSheetStyleMessage,
    KUIActionSheetStyleEditGroupMember,
    KUIActionSheetStyleUpload
}KUIActionSheetHomeType;
@interface KHHHomeViewController : SuperViewController <UITableViewDelegate, UITableViewDataSource,
UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, weak)   IBOutlet UISearchBar      *searchBar;
@property (nonatomic, weak)   IBOutlet UIToolbar        *toolBar;
@property (nonatomic, strong) NSMutableArray            *btnTitleArr;
@property (nonatomic, strong) NSMutableDictionary       *dicBtnTttle;
@property (nonatomic, assign) NSInteger                 lastBtnTag;
@property (strong, nonatomic) IBOutlet UITableView      *btnTable;
@property (strong, nonatomic) IBOutlet UITableView      *bigTable;
@property (nonatomic, strong) NSMutableArray            *btnArray;
@property (assign, nonatomic) bool                      isShowData;
@property (strong, nonatomic) UIButton                  *currentBtn;
@property (assign, nonatomic) bool                      isAddGroup;
@property (strong, nonatomic) UISearchDisplayController *searCtrl;
@property (strong, nonatomic) NSIndexPath               *lastIndexPath;
@property (assign, nonatomic) bool                      isNotHomePage;
@property (strong, nonatomic) IBOutlet UIImageView      *imgview;
@property (assign, nonatomic) bool                      isNormalSearchBar;
@property (assign, nonatomic) IBOutlet UIButton         *smallBtn;
@property (strong, nonatomic) IBOutlet UIImageView      *smalImageView;
@property (strong, nonatomic) IBOutlet UIView           *footView;
@property (strong, nonatomic) IBOutlet UIButton         *btnForCancel;
@property (strong, nonatomic) UIView                    *btnBackbg;
@property (strong, nonatomic) NSMutableDictionary       *btnDic;
@property (assign, nonatomic) KUIActionSheetHomeType    type;
@property (strong, nonatomic) NSArray                   *generalArray;
@property (strong, nonatomic) NSArray                   *oWnGroupArray;
@property (strong, nonatomic) KHHVisitRecoardVC         *visitVC;

- (IBAction)addBtnClick:(id)sender;
- (IBAction)cancelBtnClick:(id)sender;
@end
