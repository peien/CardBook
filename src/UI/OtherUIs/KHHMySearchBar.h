//
//  KHHMySearchBar.h
//  CardBook
//
//  Created by 王国辉 on 12-8-23.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol KHHMySearchBarDelegate<NSObject>
- (void)KHHMySearchBarBtnClick:(NSInteger)tag;
@end
@interface KHHMySearchBar : UISearchBar
@property (assign, nonatomic) id<KHHMySearchBarDelegate>delegateKHH;
@property (assign, nonatomic) bool isSimple;
@property (strong, nonatomic) UIButton *takePhoto;
- (id)initWithFrame:(CGRect)frame simple:(BOOL)sim;
@end
