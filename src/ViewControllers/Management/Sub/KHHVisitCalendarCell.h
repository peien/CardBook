//
//  KHHVisitCalendarCell.h
//  CardBook
//
//  Created by 王国辉 on 12-8-23.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol KHHVisitCalendarCellDelegate<NSObject>
- (void)KHHVisitCalendarCellBtnClick:(UIButton *)btn;
- (void)showLocaButtonClick:(id)sender;
@end
@interface KHHVisitCalendarCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *Btn;
@property (strong, nonatomic) IBOutlet UIButton *photoBtn;
@property (assign, nonatomic) id<KHHVisitCalendarCellDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIButton    *finishBtn;
@property (strong, nonatomic) IBOutlet UILabel     *objValueLab;
@property (strong, nonatomic) IBOutlet UILabel     *locValueLab;
@property (strong, nonatomic) IBOutlet UILabel     *noteValueLab;
@property (strong, nonatomic) IBOutlet UIButton    *showLocBtn;
@property (strong, nonatomic) IBOutlet UILabel     *dateLab;


- (IBAction)KHHVisitCalendarCellBtnClick:(id)sender;
- (IBAction)showLocBtnClick:(id)sender;
@end
