//
//  KHHMemoCell.h
//  CardBook
//
//  Created by CJK on 13-1-6.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KHHMemoCellDelegate <NSObject>

@optional
- (void)selectPicker:(NSIndexPath *)indexPath;

@end

@interface KHHMemoCell : UITableViewCell

@property(nonatomic,strong) NSString *butTitle;
@property(nonatomic,strong) NSString *headStr;
@property(nonatomic,strong) NSIndexPath *indexpath;
@property(nonatomic,strong) id<KHHMemoCellDelegate> pickerDelegate;


@end
