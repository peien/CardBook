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

/*!
 更新当前位置信息: 
 更新成功与否通过 notification KHHLocationUpdateSucceeded 和 KHHLocationUpdateFailed 返回。
 调用前注册监听这两个notification。
 在notification的处理方法里取消监听。
 */
- (void)updateLocation;
@end
