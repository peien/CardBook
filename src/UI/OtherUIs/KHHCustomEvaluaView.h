//
//  KHHCustomEvaluaView.h
//  CardBook
//
//  Created by 王国辉 on 12-8-24.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "KHHVisitCalendarView.h"
#import "DLStarRatingControl.h"
#import "Card.h"
@protocol KHHCustomEvaluaViewDelegate<NSObject>
- (void)handleTextfieldValue:(UITextField *)textf;
- (void)handleStarNum:(DLStarRatingControl *)control startNum:(CGFloat)num;
@end
@interface KHHCustomEvaluaView : UITableViewCell<UITableViewDataSource,UITableViewDelegate,DLStarRatingDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView           *theTableOne;
@property (assign, nonatomic) bool                           isFieldValueEdit;
@property (strong, nonatomic) NSString                       *importFlag;
@property (assign, nonatomic) CGFloat                        relationEx;
@property (assign, nonatomic) CGFloat                        customValue;
@property (strong, nonatomic) Card                           *card;
@property (assign, nonatomic) id<KHHCustomEvaluaViewDelegate>delegate;

- (void)reloadTable;
@end
