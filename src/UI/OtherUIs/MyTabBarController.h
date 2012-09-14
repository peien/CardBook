//
//  MyTabBarController.h
//  91kge
//
//  Created by ge k on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTabBarController : UITabBarController
{
    int count;
}
@property (nonatomic,strong) UIView *tabBarView;
-(id)initWithNum:(int)num;
@end
