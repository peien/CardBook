//
//  KHHSendToViewController.h
//  CardBook
//
//  Created by 王国辉 on 12-8-22.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperViewController.h"
#import "JSTokenField.h"
#import "Card.h"
#import "KHHDataNew+TransCard.h"

@interface CardReceiver : NSObject
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *mobile;

- (CardReceiver *)initWithName:(NSString *)name andMobile:(NSString *)mobile;
@end

@interface KHHSendToViewController : SuperViewController<KHHDataTransCardDelegate>
{
    CGFloat theBgView_y;
    CGFloat theScroll_y;
}
@property (strong, nonatomic) IBOutlet UIScrollView *theScroll;
@property (retain, nonatomic) IBOutlet UIView       *theBgView;
@property (strong, nonatomic) JSTokenField          *theTokenField;
@property (strong, nonatomic) Card                  *theCard;


@end
