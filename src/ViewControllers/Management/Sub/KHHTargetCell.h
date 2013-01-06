//
//  KHHTargetCell.h
//  CardBook
//
//  Created by CJK on 13-1-4.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KHHTargetCell : UITableViewCell

@property (nonatomic,strong)NSString *headStr;
@property (nonatomic,strong)NSString *placeStr;
@property (nonatomic,strong)UITextField *field;

- (void)registResponder;

@end