//
//  UIViewController+Navigation.m
//  CardBook
//
//  Created by 孙铭 on 12-9-13.
//  Copyright (c) 2012年 KingHanHong. All rights reserved.
//

#import "UIViewController+Navigation.h"

@implementation UIViewController (Navigation)
- (void)pushViewControllerClass:(Class)vcClass animated:(BOOL)animated {
    [self.navigationController pushViewController:[[vcClass alloc] initWithNibName:nil bundle:nil]
                                         animated:animated];
}
@end
