//
//  KHHClientCellLNPC.h
//  CardBook
//
//  Created by 孙铭 on 8/8/12.
//  Copyright (c) 2012 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KHHClientCellLNPC : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *logoView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *positionLabel;
@property (nonatomic, weak) IBOutlet UILabel *companyLabel;
@property (nonatomic, assign) bool           isSelected;
@end
