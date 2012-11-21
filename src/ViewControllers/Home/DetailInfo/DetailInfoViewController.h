//
//  DetailInfoViewController.h
//  CardBook
//
//  Created by 王国辉 on 12-8-6.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "KHHAppDelegate.h"
#import "KHHCustomEvaluaView.h"
#import "Card.h"
#import "KHHCardMode.h"
@class eCardViewController;

@interface DetailInfoViewController : SuperViewController <UIAlertViewDelegate>
@property (strong, nonatomic) eCardViewController *eCardVC;
@property (assign, nonatomic) bool                isToeCardVC;
@property (strong, nonatomic) IBOutlet UIView     *containView;
@property (assign, nonatomic) NSUInteger          lastBtn;
@property (assign, nonatomic) KHHAppDelegate      *app;
@property (strong, nonatomic) Card                *card;
@property (strong, nonatomic) KHHCardMode         *cardM;
@property (assign, nonatomic) bool                isCompanyColleagues;
@property (nonatomic, assign) bool                isNeedReloadTable;
@property (assign, nonatomic) bool                isReloadVisiteTable;
@property (assign, nonatomic) bool                isColleagues;
@property (strong, nonatomic) Card              *myDefaultReplyCard;

@end
