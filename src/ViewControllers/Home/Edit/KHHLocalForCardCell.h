//
//  KHHLocalForCardCell.h
//  CardBook
//
//  Created by CJK on 13-1-13.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KHHLocalForCardCell : UITableViewCell

@property (nonatomic,strong)NSString *headStr;
@property (nonatomic,strong)NSString *locationStr;
@property (nonatomic,strong)UITextField *field;
@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)void(^localTip)();
@end
