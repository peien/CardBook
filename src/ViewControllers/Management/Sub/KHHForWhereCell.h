//
//  KHHForWhereCell.h
//  CardBook
//
//  Created by CJK on 13-1-8.
//  Copyright (c) 2013年 Kinghanhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KHHForWhereCell : UITableViewCell

@property(nonatomic,strong)NSString *locStrPro;
@property(nonatomic,assign)void(^justReload)();
@property(nonatomic,strong)UIImageView *rotaView;
@end
