//
//  EmployManageViewCell.h
//  CardBook
//
//  Created by 王国辉 on 12-8-10.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmployManageViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *icomImage;
@property (strong, nonatomic) IBOutlet UIImageView *locationImage;
@property (strong, nonatomic) IBOutlet UILabel     *positionLab;
@property (strong, nonatomic) IBOutlet UILabel     *numLab;
@property (strong, nonatomic) IBOutlet UILabel     *locationLab;
@end
