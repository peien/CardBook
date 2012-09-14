//
//  EditCardPersonCell.h
//  CardBook
//
//  Created by 王国辉 on 12-8-14.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditCardPersonCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iconImg;
@property (strong, nonatomic) IBOutlet UITextField *nameValue;
@property (strong, nonatomic) IBOutlet UITextField *jobValue;
@end
