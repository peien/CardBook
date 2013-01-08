//
//  KHHImageCell.h
//  CardBook
//
//  Created by CJK on 13-1-5.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KHHImgViewInCell.h"

@interface KHHImageCell : UITableViewCell

@property (nonatomic,strong)NSString *headStr;
@property (nonatomic,strong)UIButton *imageBtn;
@property (nonatomic,strong)NSArray *imgArr;
@end
