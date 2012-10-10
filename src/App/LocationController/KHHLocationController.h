//
//  KHHLocationController.h
//  CardBook
//
//  Created by Sun Ming on 12-10-10.
//  Copyright (c) 2012年 Kinghanhong. All rights reserved.
//

#import "SMObject.h"

@interface KHHLocationController : SMObject
+ (id)sharedController;
- (void)refreshCurrentLocation;//更新当前位置信息
@end
