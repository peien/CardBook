//
//  KHHClientCellLNPCC.h
//  CardBook
//
//  Created by 孙铭 on 8/8/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCheckbox.h"

@interface KHHClientCellLNPCC : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *logoView;
@property (strong, nonatomic) IBOutlet UIButton *logoBtn;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *positionLabel;
@property (nonatomic, weak) IBOutlet UILabel *companyLabel;
@property (nonatomic, strong) SMCheckbox *checkbox;
@end
