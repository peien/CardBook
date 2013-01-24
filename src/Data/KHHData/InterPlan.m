//
//  InterPlan.m
//  CardBook
//
//  Created by CJK on 13-1-21.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import "InterPlan.h"
#import "Card.h"
#import "KHHImgViewInCell.h"

@implementation InterPlan
@synthesize imgs = _imgs;

- (void)setCardsArr:(NSArray *)cardsArr
{
    if (!cardsArr) {
        return;
    }
     NSMutableString *strPro = [[NSMutableString alloc]init];
    for (int i=0;i<[cardsArr count];i++) {
        if (i==0) {
            [strPro appendFormat:@"%lld", ((Card *)cardsArr[i]).idValue];
        }else{
            [strPro appendFormat:@"|%lld", ((Card *)cardsArr[i]).idValue];
        }
    }
    _customCardIds = strPro;
}

- (void)setImgViews:(NSArray *)imgViews
{
    if (!imgViews) {
        return;
    }
    _imgs = [[NSMutableArray alloc]init];
    for (KHHImgViewInCell *imgView in imgViews) {
        [_imgs addObject:imgView.img];
    }
   
}

- (void)setRemindDate:(NSString *)remindDate
{
    if (!remindDate) {
        _remind = @"false";
        return;
    }
    _remind = @"true";
    _remindDate = @"30";
}

- (void)setLocalStr:(NSString *)localStr
{
    if (!localStr) {
        return;        
    }
    if (![localStr rangeOfString:@"国外"].location == 0) {
        NSArray *splitArr = [localStr componentsSeparatedByString:@" "];
        _province = splitArr[0];
        if ([splitArr count] == 2) {
            _city = splitArr[0];
            _address = splitArr[1];
        }else{
            _city = splitArr[1];
            _address  = splitArr[2];
        }
        return;
    }
    _address = @"";
}

- (void)setAddress:(NSString *)address
{
    if (!address) {
        return;
    }
    if (!_address) {
        _address = address;
        return;
    }
    _address = [NSString stringWithFormat:@"%@ %@",_address,address];
}

@end
