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
#import "KHHViewAdapterUtil.h"
#import "KHHDataNew+TransCard.h"

@class eCardViewController;

@interface DetailInfoViewController : SuperViewController <UIAlertViewDelegate,KHHDataTransCardDelegate>{
    
        UIImageView *iconImgView;
}

@property (strong, nonatomic) eCardViewController *eCardVC;
@property (assign, nonatomic) bool                isToeCardVC;
@property (strong, nonatomic) IBOutlet UIView     *containView;
@property (assign, nonatomic) NSUInteger          lastBtn;
@property (assign, nonatomic) KHHAppDelegate      *app;
@property (strong, nonatomic) Card                *card;
@property (strong, nonatomic) KHHCardMode         *cardM;
@property (nonatomic, assign) bool                isNeedReloadTable;
@property (assign, nonatomic) bool                isReloadVisiteTable;
@property (strong, nonatomic) Card              *myDefaultReplyCard;

@property (nonatomic,strong) void(^deleteSelfSuccess)();

//- (IBAction)btnEditCard:(id)sender;

- (void)updateViewData:(Card *)temCard;



@end
