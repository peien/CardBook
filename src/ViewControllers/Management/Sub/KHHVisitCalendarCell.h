//
//  KHHVisitCalendarCell.h
//  CardBook
//
//  Created by 王国辉 on 12-8-23.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol KHHVisitCalendarCellDelegate<NSObject>
- (void)KHHVisitCalendarCellBtnClick:(NSInteger)tag;
@end
@interface KHHVisitCalendarCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *Btn;
@property (assign, nonatomic) id<KHHVisitCalendarCellDelegate>delegate;
@property (strong, nonatomic) IBOutlet UIButton *finishBtn;
@property (strong, nonatomic) IBOutlet UIImageView *imgviewIco1;
@property (strong, nonatomic) IBOutlet UIImageView *imgviewIco2;
@property (strong, nonatomic) IBOutlet UIImageView *imgviewIco3;
@property (strong, nonatomic) IBOutlet UIImageView *imgviewIco4;

- (IBAction)KHHVisitCalendarCellBtnClick:(id)sender;
@end
