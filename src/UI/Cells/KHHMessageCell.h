//
//  KHHMessageCell.h
//  CardBook
//
//  Created by 王国辉 on 12-8-30.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KHHMessageCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *subTitleLab;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;
@property (strong, nonatomic) IBOutlet UILabel *contentLab;
@property (strong, nonatomic) IBOutlet UIImageView *messageImage;
@end
