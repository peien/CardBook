//
//  KHHAddressCell.h
//  CardBook
//
//  Created by 王国辉 on 12-9-22.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KHHAddressCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *bigAdress;
@property (strong, nonatomic) IBOutlet UITextField *detailAdress;
@property (strong, nonatomic) IBOutlet UILabel     *name;

@end
